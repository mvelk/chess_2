
require_relative 'manifest'

class Chess
  attr_accessor :players, :board

  def initialize
    @board = Board.new()
    @players = make_players
    play
  end

  def make_players
    @white = Player.new(:white, @board)
    @black = Player.new(:black, @board)
    [@white, @black]
  end

  def play
    display = Display.new([0,0], @board)

    until @board.checkmate?(@players[0].color)
      play_turn
      swap_turn!
    end
    # announce winner
  end

  def play_turn
    from_pos, to_pos = @players[0].get_move
    @board.move_piece!(from_pos, to_pos)
  end

  private
  def notify_players
  end

  def swap_turn!
    @players.rotate!
  end

end


if __FILE__ == $PROGRAM_NAME
  game = Chess.new()
  game.run
end
