# ===================================================== #
#    Environment
# ===================================================== #

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# ===================================================== #
#    Approval Spec DSL
# ===================================================== #

# require 'rspec/core/extensions/approvals/dsl/verify'
# require 'rspec/core/extensions/approvals/dsl/verify_mail'
# require 'rspec/core/extensions/approvals/dsl/verify_db'
# require 'rspec/core/extensions/approvals/dsl/verify_controller_action'

# ===================================================== #
#    Interaction Spec DSL
# ===================================================== #

# require 'rspec/core/extensions/fast_context'
# require 'rspec/core/extensions/interactions/dsl'
# require 'rspec/core/extensions/interactions/controller_extensions'
# require 'rspec/core/extensions/interactions/runner'
# require 'rspec/core/extensions/interactions/interaction_report'
# require 'rspec/core/extensions/interactions/matchers'
# require 'rspec/core/extensions/interactions/configuration'

# ===================================================== #
#    Feature Spec DSL
# ===================================================== #

require 'rspec/example_steps'
require 'rspec/example_steps/custom_extensions'

# ===================================================== #
#    Drivers
# ===================================================== #

require 'capybara/rspec'
require 'capybara/rails'
# require 'capybara/poltergeist'
require 'webmock/rspec'

# We need to disable WebMock here by default, so it is disabled before
# zeus forks the server process. We enable it on a per-spec basis
# (see rspec config, below).

WebMock.disable!

# ===================================================== #
#    Lib
# ===================================================== #

# require 'satori/exceptions'
# require 'interactions/interaction'
# require 'interactions/role'

# ===================================================== #
#    Shared Examples
# ===================================================== #

# require 'support/shared_examples/shared_examples_for_a_person'
# require 'support/shared_examples/shared_examples_for_multipart_email'
# require 'support/shared_examples/shared_examples_for_notifications'
# require 'support/shared_examples/shared_examples_for_contact_selector'
# require 'support/shared_examples/shared_examples_for_encrypted_passwords'
# require 'support/shared_examples/shared_examples_for_contact_view'

# ===================================================== #
#    Helpers
# ===================================================== #

# require 'support/helpers/authentication_spec_helper'
# require 'support/helpers/booking_spec_helper'
# require 'support/helpers/email_spec_helper'
# require 'support/helpers/wait_for_ajax'
# require 'support/helpers/normalize_attributes'

# ===================================================== #
#    Pages
# ===================================================== #

# require 'support/pages/pages'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.fail_fast = false

  # Should is good.
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }
  config.mock_with(:rspec) { |c| c.syntax = [:should, :expect] }

  # Mocking framework.
  config.mock_with :rspec

  # Turn off transactions because DatabaseCleaner will manage this for us.
  config.use_transactional_fixtures = false

  # ============
  # = Database =
  # ============

  config.before(:suite) do
    # Make sure we start with a clean slate.
    DatabaseCleaner.clean_with :truncation
    # Transactions for speed.
    DatabaseCleaner.strategy = :transaction
  end

  # Always set up at the beginning and clean up at the end..
  config.before(:all) { setup_example }
  config.after(:all) { cleanup_example }

  # Setup and cleanup for each example.
  config.around(:each) do |spec|
    WebMock.enable!
    setup_example
    spec.run
    cleanup_example
    WebMock.disable!
  end

  def setup_example
    setup_environment_before_example
    setup_database_before_example
  end

  def cleanup_example
    cleanup_database_after_example
    cleanup_environment_after_example
  end

  def setup_database_before_example
    DatabaseCleaner.start
  end

  def cleanup_database_after_example
    DatabaseCleaner.clean
    # see https://github.com/bmabey/database_cleaner/issues/99
    begin
      ActiveRecord::Base.connection.send(:rollback_transaction_records, true)
    rescue
    end
  end

  def reset_factory_girl_sequences
    FactoryGirl.sequences.each do |s|
      s.instance_eval { @value = FactoryGirl::Sequence::EnumeratorAdapter.new(1) }
    end
  end

  def setup_environment_before_example
    Timecop.return
    # Make sure we're running specs in a consistent timezone.
    # I'm not sure how this gets changed, but ommitting this
    # causes tests to fail when running a complete suite.
    # Some tests are sensitive to the current timezone.
    # UTC is the default used on the server, so should typically
    # be used for testing. However, the code should really be
    # TZ agnostic, so we should try changing this to various
    # zones and seeing if that causes failures.
    Time.zone                     = "UTC"
    ActionMailer::Base.deliveries = []
  end

  def cleanup_environment_after_example
    setup_environment_before_example
  end

  config.include FactoryGirl::Syntax::Methods

  # ===================================================== #
  #    Controller Specs...
  # ===================================================== #

  config.include Rails.application.routes.url_helpers, type: :controller

end

def use_driver (driver)
  Capybara.current_driver = driver
  yield
ensure
  Capybara.use_default_driver
end

# require "spec_helper_tools"