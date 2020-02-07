class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    Class.new do

    end.new
  end

  def section_nav_partial
    @@section_nav ||= {}
    @@section_nav[controller_path] ||= "scheduling/section_nav"
  end

  def self.set_section_nav (path_to_partial)
    @@section_nav ||= {}
    @@section_nav[controller_path] = path_to_partial
  end
end
