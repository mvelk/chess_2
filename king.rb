
class King < Piece
  include Stepable

  def initialize(color, pos, board)
    @has_moved = false
    super
  end

  def symbol
    @color == :white ? "\u2654".encode('utf-8') : "\u265A".encode('utf-8')
  end

  def get_diffs
    result = []

    (-1..1).each do |x_add|
      (-1..1).each do |y_add|
        next if x_add == 0 && y_add == 0
        result << [x_add, y_add]
      end
    end
    result
  end

end
