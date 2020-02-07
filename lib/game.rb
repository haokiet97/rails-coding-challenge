class RefactoringGame

  # ------------------------------ REFACTORING START ------------------------------

  def was_correctly_answered
    if @in_penalty_box[@current_player]
      if @is_getting_out_of_penalty_box
        puts "#{@players[@current_player]} got out of penalty box"
        puts 'Answer was correct!!!!'
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."
        winner          = did_player_win()
        @current_player += 1
        @current_player = 0 if @current_player == @players.length
        puts "Player is now #{@players[@current_player]}"
        winner
      else
        puts "#{@players[@current_player]} stays in penalty box"
        @current_player += 1
        @current_player = 0 if @current_player == @players.length
        puts "Player is now #{@players[@current_player]}"
        true
      end
    else
      puts "Answer was correct!!!!"
      @purses[@current_player] += 1
      puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."
      winner          = did_player_win
      @current_player += 1
      @current_player = 0 if @current_player == @players.length
      puts "Player is now #{@players[@current_player]}"
      return winner
    end
  end

  private

  def did_player_win
    !(@purses[@current_player] == 6)
  end

# ------------------------------ REFACTORING END ------------------------------

  public

  def initialize seed = nil
    srand(seed) if seed
    @players                       = %w[Alice Bob Cecil]
    @purses                        = @players.map { rand(3) + 2 }
    @in_penalty_box                = @players.map { rand(2) == 0 }
    @current_player                = rand(@players.count)
    @is_getting_out_of_penalty_box = @in_penalty_box[@current_player] && rand(2) == 0
  end
end

# Copyright © 2012 Michal Taszycki
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
