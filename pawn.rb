class Pawn < Piece

  def symbol
    @color == :white ? "\u2659".encode('utf-8') : "\u265F".encode('utf-8')
  end

  def moves
    x, y = @pos
    capture_moves(x, y) + forward_moves(x, y)
  end

  def forward_moves(x, y)
    forward_moves = []
    forward_steps.each do |offset|
      dx, dy = offset
      forward_move = [x + dx, y + dy]
      forward_moves << forward_move if @board[forward_move].empty?
    end
    forward_moves
  end

  def capture_moves(x, y)
    capture_moves = []
    side_attacks.each do |offset|
      dx, dy = offset
      attack_move = [x + dx, y + dy]

      if attack_move.all? { |coord| coord.between?(0, 7) } &&
        @board[attack_move].enemy?(@color)
        capture_moves << attack_move
      end
    end
    capture_moves
  end

  protected
  def at_start_row?
    return true if @color == :white && @pos[0] == 6
    return true if @color == :black && @pos[0] == 1
    false
  end

  def forward_dir
    @color == :black ? 1 : -1
  end

  def forward_steps
    return [[forward_dir * 2, 0], [forward_dir, 0]] if at_start_row?
    [[forward_dir, 0]]
  end

  def side_attacks
    [[forward_dir, 1], [forward_dir, -1]]
  end

end
