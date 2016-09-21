
module Stepable
  def moves
    offsets = self.get_diffs

    moves = []
    x, y = @pos
    offsets.each do |offset|
      dx, dy = offset
      new_pos = [x + dx, y + dy]
      moves << new_pos if @board.in_bounds?(new_pos) &&
        (@board[new_pos].empty? || @board[new_pos].enemy?(@color))
    end
    moves
  end

end
