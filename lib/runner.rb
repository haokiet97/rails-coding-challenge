require 'fileutils'
module FixtureHandler
  def self.clear_fixtures
    FileUtils.rm_rf(fixtures_dir)
  end

  def self.create_fixture_dir
    FileUtils.mkdir(fixtures_dir)
  end

  def self.write_fixture index, text
    File.open(fixture_path(index), "w") do |file|
      file.write(text)
    end
  end

  def self.fixture_exists? index
    File.exists?(fixture_path(index))
  end

  def self.read_fixture index
    File.read(fixture_path(index))
  end

  def self.fixture_path index
    "#{fixtures_dir}/#{index}.txt"
  end

  def self.fixtures_dir
    "#{File.expand_path(File.dirname(__FILE__))}/fixtures"
  end
end

module StdOutToStringRedirector
  require 'stringio'
  def self.redirect_stdout_to_string
    sio = StringIO.new
    old_stdout, $stdout = $stdout, sio
    yield
    $stdout = old_stdout
    sio.string
  end
end

SIMULATIONS_COUNT = 5000
def run_simulation index = nil
  RefactoringGame.new(index).was_correctly_answered
end

def capture_simulation_output index
  StdOutToStringRedirector.redirect_stdout_to_string do
    run_simulation(index)
  end
end

def clean_fixtures
  FixtureHandler.clear_fixtures
end

def record_fixtures
  SIMULATIONS_COUNT.times do |index|
    raise "You need to clean recorded simulation results first!" if FixtureHandler.fixture_exists?(index)
  end
  FixtureHandler.create_fixture_dir
  SIMULATIONS_COUNT.times do |index|
    FixtureHandler.write_fixture(index, capture_simulation_output(index))
  end
rescue RuntimeError => e
  puts "ERROR!!!"
  puts e.message
end

require 'test/unit/assertions'
include Test::Unit::Assertions
def test_output
  SIMULATIONS_COUNT.times do |index|
    raise "You need to record simulation results first!" unless FixtureHandler.fixture_exists?(index)
    assert_equal(FixtureHandler.read_fixture(index), capture_simulation_output(index))
  end
  puts "OK."
rescue RuntimeError => e
  puts "ERROR!!!"
  puts e.message
end