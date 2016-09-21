

class Piece
  attr_accessor :color, :pos, :board

  def initialize(color, pos, board = nil)
    @color = color
    @pos = pos
    @board = board
  end

  def to_s
    "#{symbol} "
  end

  def empty?
    false
  end

  def symbol
  end

  def valid_moves
    from_pos = @pos
    self.moves.select do |to_pos|
      a = @board.deep_dup
      a.move_piece!(from_pos, to_pos)
      !a.check?(@color)
    end
  end

  def enemy?(color)
    @color == color ? false : true
  end

  private
  def move_into_check?(to_pos)
  end

end
