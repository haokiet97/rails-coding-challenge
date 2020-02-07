# Game Refactoring

## Instructions

1. Examine the code of the class `RefactoringGame` in `game.rb`.
2. See what it does by running `ruby main.rb`. 
3. Record the characterisation tests by running `ruby main.rb --record`.
4. Make the code beautiful. You are allowed to modify only the code between markers `REFACTORING START` / `REFACTORING END` in `game.rb`.
5. Check your code is correct by running `ruby main.rb --test` — the tests must pass!
6. When your code is ready, make a Pull Request.

## Hits

1. Don't worry about making the code perfect. Just take the first steps towards a better design.

```
 Usage:
  ruby main.rb [-h|--help|help]       - shows help screen.
  ruby main.rb [-c|--clean|clean]     - clean recorded results of simulation.
  ruby main.rb [-r|--record|record]   - records 5000 results of simulation.
  ruby main.rb [-t|--test|test]       - tests against 5000 recorded results of simulation.
  ruby main.rb <ANY_NUMBER>           - shows result of simulation initialized with <ANY_NUMBER>.
  ruby main.rb                        - shows result of random simulation.
```