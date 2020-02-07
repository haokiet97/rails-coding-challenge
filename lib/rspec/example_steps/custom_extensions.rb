# Just a little bit of extra syntactic sugar for the acceptance testing DSL.
# Let's call these examples 'Scenarios', instead of 'Steps'. I just like that better.
RSpec::Core::ExampleGroup.define_example_method :Scenario, :with_steps => true