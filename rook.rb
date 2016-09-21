
class Rook < Piece
  include Slideable
  def initialize(color, pos, board)
    @has_moved = false
    super
  end

  def symbol
    @color == :white ? "\u2656".encode('utf-8') : "\u265C".encode('utf-8')
  end

  def directions
    [:horizontal]
  end
end
