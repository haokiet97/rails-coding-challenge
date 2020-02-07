module ApplicationHelper
  def title (text)
    content_for(:title) do
      [text, "Satori"].compact.join(" — ")
    end
  end

  def section_nav_partial
    controller.section_nav_partial
  end

  def present (object, klass = nil)
    klass     ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def present_array (array, klass)
    array.map { |e| klass.new(e, self) }.each do |presenter|
      yield presenter if block_given?
    end
  end

  def avatar_url (contact, size = 80, default = 'mm')
    Avatar.url_for(contact, size, default)
  end

  def new_record_button (label, path, options = {})
    classes = ["btn btn-primary btn-new-record", options[:class]].join(" ")
    %{<a href="#{path}" class="#{classes}"><span class="plus">+</span>#{label}</a>}.html_safe
  end

  def qualified_controller_name
    controller.class.name.underscore.sub(/_controller$/, '')
  end

  def identified_controller_name
    qualified_controller_name.gsub(/\//, '-')
  end

  def section_controller_classes
    section_name = qualified_controller_name.sub(/\/.*$/, '')
    action_name  = controller.action_name
    "section-#{section_name} action-#{action_name}"
  end

  def section_stylesheet (version = "")
    section_name = qualified_controller_name.sub(/\/.*$/, '')
    if version.present?
      "sections/#{section_name}/#{section_name}.css?#{version}"
    else
      "sections/#{section_name}/#{section_name}"
    end
  end
end
