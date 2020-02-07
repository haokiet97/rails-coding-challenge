module FullyNamed
  def full_name
    [self.first_name, self.last_name].reject { |e| e.blank? }.join(' ')
  end
end
