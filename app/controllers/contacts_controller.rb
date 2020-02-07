class ContactsController < ApplicationController

  # set_tab :contacts
  set_section_nav "contacts/section_nav"

  # include Concerns::UpcomingSessionsContext

  before_filter :fetch_recently_viewed_contacts, :except => [:show, :schedule]

  before_filter :set_has_contacts, :assign_ransack_filter, :assign_tags

  protected

  def fetch_recently_viewed_contacts
    @recently_viewed = Contact.recently_accessed
  end

  def set_has_contacts
    @has_contacts = Contact.count > 0
  end

  def assign_contact
    @contact = Contact.find(params[:id]).tap { |c| c.bump }
  end

  def assign_ransack_filter
    @search = Contact.alphabetical.ransack(params[:q])
  end

  def assign_tags
    @tags            = RocketTag::Tag.order(:name)
    @tags_by_initial = @tags.chunk { |t| t.name.first.upcase }.to_a
  end

  public

  # GET /contacts
  # GET /contacts.xml
  def index
    respond_to do |format|
      format.html do
        @segment_title = "All Contacts"
        assign_paginated_results_for @search.result(distinct: true)
        render_contacts_html
      end
      format.json { send_contacts_as_json }
      format.csv { send_contacts_as_csv }
    end
  end

  def send_contacts_as_csv
    send_data CsvExporter.export(Contact.alphabetical),
       filename: "#{current_tenant.sitename}_contacts.csv"
  end

  def send_contacts_as_json
    send_data JsonExporter.export(Contact.alphabetical.includes(:notes)),
       filename: "#{current_tenant.sitename}_contacts.json"
  end

  # ========
  # = Tags =
  # ========

  def tag
    @segment_title = "Tagged with #{params[:tag]}"
    assign_paginated_results_for Contact.tagged_with params[:tag]
    render_contacts_html
  end

  # ============
  # = Segments =
  # ============

  def current_clients
    assign_paginated_results_for Contact.current_clients
    @segment_title = "Current Clients"
    render_contacts_html
  end

  def former_clients
    assign_paginated_results_for Contact.former_clients
    @segment_title = "Former Clients"
    render_contacts_html
  end

  def prospects
    assign_paginated_results_for Contact.prospects
    @segment_title = "Prospects"
    render_contacts_html
  end

  def no_notes
    assign_paginated_results_for Contact.no_notes_for_30_days
    @segment_title = "No Notes for 30 Days"
    render_contacts_html
  end

  # ===================
  # = Show with Notes =
  # ===================

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    assign_contact
    @contact.bump
    @summary          = ContactSummary.new(@contact)
    @new_note         = Note.new
    @new_note.subject = @contact
    @recently_viewed  = Contact.recently_accessed

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @contact }
    end
  end

  # =====================
  # = Creating Contacts =
  # =====================

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    assign_contact
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = Contact.new(params[:contact].except(:id, :type))

    respond_to do |format|
      if @contact.save
        format.html { redirect_to(contact_path(@contact), :notice => 'Contact was successfully created.') }
        format.xml { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    assign_contact

    respond_to do |format|
      params[:contact][:tags] = [] if params[:contact][:tags] == ""

      # There should be a better solution to sanitising this input than
      # removing the dangerous params here. But I need to do this because
      # if I don't I get protected attribute exceptions blowing up my tests.

      if @contact.update_attributes(params[:contact].except(:id, :type))
        format.html { redirect_to(contact_path(@contact), :notice => 'Contact was successfully updated.') }
        format.xml { head :ok }
        format.json { render json: @contact.tags, root: false }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    assign_contact
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml { head :ok }
    end
  end

  protected

  def assign_paginated_results_for (scope)
    @contacts = paginated_results(scope)
  end

  def paginated_results (scope)
    scope.paginate(page: params[:page], per_page: 10)
  end

  def render_contacts_html
    render @has_contacts ? 'index' : 'blank_slate'
  end

end
