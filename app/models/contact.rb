require "fully_named"

class Contact < Person

  # ================
  # = Associations =
  # ================

  has_many     :notes, -> { order "created_at desc" }, dependent: :destroy, as: :subject

  # Tags!
  attr_taggable :tags
  # workaround for a bug in rocket_tag (rocket_tag breaks #reload by not returning self)
  alias :rocket_tag_reload :reload
  define_method(:reload) { rocket_tag_reload ; self }

  def tags_alphabetically
    tags_tags.order(:name).map(&:name)
  end

  def current_agreement
    active_agreements.where(:is_default => false).last
  end

  def active_agreements
    agreements.where(:status => "active")
  end

  def active_and_completed_agreements
    agreements.where("status = 'active' OR status = 'complete'")
  end

  def scheduled_invitations
    invitations.where(:status => "scheduled")
  end

  def entered_bookings
    bookings.where(:status => "entered")
  end

  # ========================
  # = Session Associations =
  # ========================

  has_many :sessions, foreign_key: "coachee_id"

  def scheduled_sessions
    sessions.
    where("start_time IS NOT NULL and end_time IS NOT NULL").
    where("cancelled_at IS NULL").
    where("start_time > ?", Time.now).
    order(:start_time)
  end

  def next_session
    scheduled_sessions.first
  end

  # ========================
  # = Invoice Associations =
  # ========================

  has_many     :invoices, through: :agreements

  def outstanding_invoices
    invoices.where("invoices.status" => [Billing::Invoice::SENT, Billing::Invoice::AUTHORIZED]).except(:order).order(:due_date)
  end

  def scheduled_invoices
    invoices.where(:status => Billing::Invoice::SCHEDULED).order("scheduled_for")
  end

  def sent_invoices
    invoices.where(:status => [Billing::Invoice::SENT, Billing::Invoice::PAID, Billing::Invoice::AUTHORIZED]).order([:issue_date, :number])
  end

  def payments
    agreements.map { |a| a.payments }.flatten
  end

  # ===========
  # = Queries =
  # ===========

  # Contacts in alphabetical order.

  def self.alphabetical
    order("first_name, last_name")
  end

  def self.current_clients
    joins(:agreements).
    where("agreements.status" => "active").
    where("agreements.billing_structure" => AgreementBillingStructure::PAID).
    group("people.id")
  end

  def self.former_clients
    joins(:agreements).
    where("agreements.status" => "complete").
    where("agreements.billing_structure" => AgreementBillingStructure::PAID).
    group("people.id")
  end

  # An active agreement indicates that the contact has a booking.
  # Prospects are folks who have recently booked a free sesion.
  # Maybe we should actually use the bookings instead of agreements?
  def self.prospects
    joins(:agreements).
    where("agreements.status" => "active").
    where("agreements.billing_structure" => AgreementBillingStructure::FREE).
    where("agreements.activated_at > ?", Time.now - 30.days)
  end

  def self.new_contacts
    where("created_at > ?", Time.now - 30.days)
  end

  def self.no_notes_for_30_days
    where("last_note_at < ? OR last_note_at IS NULL", Time.now - 30.days)
  end

  def self.for_email (email)
    where(:email => email).first
  end

  # Accounts having current invoices or recent payments.

  def self.active_accounts
    month_start = Time.now.beginning_of_month
    month_end = month_start + 1.month
    priority = ["overdue", "invoiced", "paid", "unbilled"]

    Contact.select("DISTINCT people.*").joins([
      "LEFT JOIN agreements ON agreements.coachee_id = people.id",
      "LEFT JOIN invoices ON invoices.agreement_id = agreements.id",
      "LEFT JOIN payments ON payments.invoice_id = invoices.id"
    ]).where([
      %{
        (invoices.status = 'scheduled' OR
        invoices.status = 'sent' OR
        (agreements.status = 'active' AND agreements.billing_structure != '#{AgreementBillingStructure::FREE}') OR
        (payment_date BETWEEN ? AND ?))
      }, month_start, month_end
    ]).sort_by { |a| priority.find_index(a.account_status) }

    # We use a series of expressions that will return false for
    # a matching record, and therefore order it before the others.

  end

  # ============
  # = Sessions =
  # ============

  def used_sessions
    []
  end

  def upcoming_sessions
    sessions.select { |s| s.start_time.present? && (Time.now..Time.now + 7.days).cover?(s.start_time) }
  end

  # ==================
  # = Initialization =
  # ==================

  after_initialize :set_defaults

  def set_defaults
    # This is an ugly way to do initialization. It would be nicer to juse use ||=
    # But there seems to be a Rails bug that is exposed by the .no_notes_for_30_days query.
    # And we get 'missing attribute' errors in this initialization block if we use that syntax.
    # This more verbose version seems to avoid that problem.
    write_attribute 'phone_1_label', "Mobile" if read_attribute('phone_1_label').nil?
    write_attribute 'phone_2_label', "Mobile" if read_attribute('phone_2_label').nil?
    write_attribute 'phone_3_label', "Mobile" if read_attribute('phone_3_label').nil?
    write_attribute 'account_status', "free" if read_attribute('account_status').nil?
  end

  # ==============
  # = Validation =
  # ==============

  # Enforcing this validation is causing errors in our booking / payment flow.
  # And I don't think it's even necessary. Simplest solution is simply to remove
  # the validation requirement.

  # These fields must be provided when the contact is updated,
  # only when there is a financial agreement. We need this information
  # to issue invoices.

  def self.billing_fields
    [
      :first_name,
      :last_name,
      :email
    ]
  end

  # billing_fields.each do |field|
  #   self.validates_presence_of field, :if => :has_financial_agreement
  # end

  def has_financial_agreement
    self.agreements.any? { |a| a.is_financial? }
  end

  def billing_info_complete? # deprecated?
    Contact.billing_fields.all? { |field| self[field].present? }
  end

  # ==============
  # = Engagement =
  # ==============

  def engagement_rating
    mailing_list_memberships.map(&:member_rating).max || 0
  end

  # =============
  # = Callbacks =
  # =============

  before_destroy :check_for_contexts

  private
  def check_for_contexts
    if agreements.count > 0
      errors.add(:base, "cannot delete contact while agreements exist")
      return false
    end
    if invitations.count > 0
      errors.add(:base, "cannot delete contact while invitations exist")
      return false
    end
    if bookings.count > 0
      errors.add(:base, "cannot delete contact while bookings exist")
      return false
    end
  end

  public

  # ==============
  # = Scheduling =
  # ==============

  def session_contexts
    active_and_completed_agreements.sort do |a, b|
      # Converting the date to an integer prevents an error
      # in the case where one date is nil.
      b.activated_at.to_i <=> a.activated_at.to_i
    end
  end

  # ===========
  # = Account =
  # ===========

  def primary_email
    email
  end

  def total_investment
    0
    # invoices.reject { |i| i.status == Billing::Invoice::DRAFT || i.status == Billing::Invoice::VOID }.inject(0) { |m, i| m + i.total }
  end

  def total_billed
    sent_invoices.inject(0) { |m, i| m + i.total }
  end

  def total_payments
    payments.inject(0) { |t, p| t + p.amount }
  end

  def next_billing_date
    scheduled_invoices.first.try(:scheduled_for)
  end

  def days_overdue
    (Date.today - outstanding_invoices.first.due_date.to_date).to_i
  end

  def account_balance
    outstanding_invoices.inject(0) { |sum, invoice| sum + invoice.total }
  end

  # Checks the account status and records it on the database column.
  # Should be called after invoices update their status.

  def update_account_status
    new_status = Billing::AccountStatus.new(self).calculate_account_status
    update_attribute :account_status, new_status
  end

  # ===================
  # = Contact Details =
  # ===================

  # Logic for updating the contact record with data supplied via a new booking.

  def add_contact_detail (type, value)
    self.first_name = value if type == :first_name unless has_name?(first_name)
    self.last_name = value if type == :last_name unless has_name?(last_name)
    self[next_blank_phone_field] = value if type == :phone unless has_phone_number?(value)
    self.skype = value if type == :skype
  end

  protected
  def next_blank_phone_field
    return :phone_1 unless phone_1.present?
    return :phone_2 unless phone_2.present?
    return :phone_3
  end

  def has_phone_number? (value)
    [phone_1, phone_2, phone_3].reject { |n| n.blank? }.include?(value)
  end

  def has_name? (value)
    value.present? && (value || "").strip.downcase != (email || "").strip.downcase
  end

  # =======
  # = URL =
  # =======

  public
  def to_param
    "#{self.id}-#{full_name.parameterize}"
  end

  # ==========
  # = Search =
  # ==========

  def self.search(term)
    if term.blank?
      []
    else
      # Concatenate first_name and last_name (deliniated by space)
      # and match the given search term to the START of any word therin.
      query = "(first_name || ' ' || last_name) ~* ?"
      pattern = "(^|[[:space:]]+)#{Regexp.escape(term)}"
      Contact.where([query, pattern])
    end
  end

  # Make the virtual full_name attribute accessible via ransack search forms.
  # Note that this version just matches the search term anywhere within the
  # concatenated first and last names. Which is not the same behaviour as the
  # version implemented in .search

  ransacker :full_name do |contact|
    # Build an Arel tree that concatenates the terms.
    # Equivelent to `first_name || ' ' || last_name`.
    infix = Arel::Nodes::InfixOperation
    infix.new('||',
    infix.new('||',
    contact.table[:first_name], ' '),
    contact.table[:last_name])
  end

  # ===============
  # = Exact Match =
  # ===============

  def self.exact (full_name)
    if full_name.blank?
      nil
    else
      query = "trim(both from (first_name || ' ' || last_name)) ILIKE ?"
      Contact.where([query, full_name.strip]).first
    end
  end

  # =====================
  # = Recently Accessed =
  # =====================

  def self.recently_accessed
    self.where("accessed_at IS NOT NULL").order("accessed_at DESC").limit(6)
  end

  def bump
    Contact.record_timestamps = false
    update_attribute "accessed_at", DateTime.now
    Contact.record_timestamps = true
  end

end
