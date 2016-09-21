class Knight < Piece
  include Stepable

  def symbol
    @color == :white ? "\u2658".encode('utf-8') : "\u265E".encode('utf-8')
  end

  def get_diffs
    result = []

    (-2..2).each do |x_add|
      next if x_add == 0
      (-2..2).each do |y_add|
        next if y_add == 0
        next if x_add.abs == y_add.abs
        result << [x_add, y_add]
      end
    end
    result
  end


end
