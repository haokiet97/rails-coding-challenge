class Note < ActiveRecord::Base

  # ========
  # = Data =
  # ========

  serialize :data, Hash

  # ================
  # = Associations =
  # ================

  # belongs_to :contact
  # validates_presence_of :contact

  belongs_to :subject, :polymorphic => true
  validates :subject, :presence => true

  after_create :update_contact_timestamp

  def update_contact_timestamp
    if subject_type == "Person"
      subject.update_attribute :last_note_at, created_at
    end
  end

  # ======================
  # = Rendering Markdown =
  # ======================

  def render (base_heading_level = 1)
    if text.present?
      heading_marker = '#' * (base_heading_level - 1)
      transposed_text = text.gsub(/^(#+)/, "\\1" + heading_marker)
      RDiscount.new(transposed_text, :filter_html, :no_image, :safelink, :no_pseudo_protocols).to_html
    else
      ""
    end
  end

  # ==================
  # = Activity Types =
  # ==================

  def is_session_reminder?
    activity_type == "notification"
  end

  def is_notification_email?
    activity_type == "notification"
  end

  def is_questionnaire_responses?
    activity_type == "questionnaire_responses"
  end

  # ======================
  # = Associated Records =
  # ======================

  def session
    Session.find(data[:session_id]) rescue nil
  end

  # ============
  # = Generate =
  # ============

  def self.log_notification! (contact, content)
    log_activity! contact, content, "notification"
  end

  def self.log_questionnaire_responses! (contact, content)
    log_activity! contact, content, "questionnaire_responses"
  end

  def self.log_activity! (contact, content_or_data, type)
    Note.create! do |n|
      n.subject = contact
      n.tenant = contact.tenant
      n.activity_type = type
      n.text = content_or_data if content_or_data.is_a? String
      n.data = content_or_data if content_or_data.is_a? Hash
    end
  end

end
