# Name:     MainNavTabBuilder
# Purpose:  Customise rendering of a tab on the main navigation bar to include the anchor tag for the selected tab.
# Changes:  Never!

class MainNavTabBuilder < TabsOnRails::Tabs::TabsBuilder
  def tab_for (tab, name, options, item_options = {})
    active_tab_class_name  = @options[:active_class] || "current"
    classes_for_active_tab = item_options[:class].to_s.split(" ").push(active_tab_class_name).join(" ")
    item_options[:class]   = classes_for_active_tab if current_tab?(tab)
    content                = @context.link_to(name, options)
    @context.content_tag(:li, content, item_options)
  end
end
