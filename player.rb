
class Player
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end

  def get_move
    display = Display.new([0,0], @board)
    move = nil
    loop do
      display.render
      move = display.cursor.get_input
      break if move
    end
    move
  end

end
