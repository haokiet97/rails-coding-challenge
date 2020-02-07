require_relative "lib/runner"
require_relative "lib/game"

case ARGV[0].to_s.downcase
when "-h", "--help", "help"
  puts "Usage:"
  puts "  ruby #{__FILE__} [-h|--help|help]       - shows help screen."
  puts "  ruby #{__FILE__} [-c|--clean|clean]     - clean recorded results of simulation."
  puts "  ruby #{__FILE__} [-r|--record|record]   - records #{SIMULATIONS_COUNT} results of simulation."
  puts "  ruby #{__FILE__} [-t|--test|test]       - tests against #{SIMULATIONS_COUNT} recorded results of simulation."
  puts "  ruby #{__FILE__} <ANY_NUMBER>           - shows result of simulation initialized with <ANY_NUMBER>."
  puts "  ruby #{__FILE__}                        - shows result of random simulation."
when "-c", "--clean", "clean"
  clean_fixtures
when "-r", "--record", "record"
  record_fixtures
when "-t", "--test", "test"
  test_output
when /\d(.\d+)?/
  run_simulation ARGV[0].to_f
else
  run_simulation
end