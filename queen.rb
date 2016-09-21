class Queen < Piece
  include Slideable
  def symbol
    @color == :white ? "\u2655".encode('utf-8') : "\u265B".encode('utf-8')
  end

  def directions
    [:diagonal, :horizontal]
  end
end
