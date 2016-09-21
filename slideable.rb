module Slideable
  def moves
    move_dirs
  end

  private
  def move_dirs
    directions = []
    directions += horizontal_dirs if self.directions.include?(:horizontal)
    directions += diagonal_dirs if self.directions.include?(:diagonal)

    moves = []
    directions.each do |dir|
      moves.concat(grow_unblocked_moves_in_dir(dir))
    end
    moves
  end

  def horizontal_dirs
    [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end

  def diagonal_dirs
    [[1, 1], [-1, -1], [-1, 1], [1, -1]]
  end

  def grow_unblocked_moves_in_dir(dir)
    moves = []
    dx, dy = dir
    next_pos = @pos
    loop do
      next_pos = [next_pos[0] + dx, next_pos[1] + dy]
      break if !@board.in_bounds?(next_pos) || blocked?(next_pos)
      moves << next_pos
    end
    moves << next_pos if @board.in_bounds?(next_pos) &&
      @board[next_pos].enemy?(self.color)
    moves
  end

  def blocked?(pos)
    return false if @board[pos].empty?
    true
  end
end
