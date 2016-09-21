class Board
  attr_accessor :rows

  def initialize
    @rows = Array.new(8) { Array.new(8) }
    make_starting_grid
  end

  def [](pos)
    x, y = pos
    @rows[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @rows[x][y] = piece
  end

  def move_piece(color, from_pos, to_pos)
  end

  def move_piece!(from_pos, to_pos)
    raise ArgumentError.new "You can't move a piece that's not on the board!" unless from_pos.all? { |coordinate| coordinate.between?(0,7) }
    raise ArgumentError.new "No piece to move!" if self[from_pos].empty?
    raise ArgumentError.new "You can't move off the board!" unless to_pos.all? { |coordinate| coordinate.between?(0,7) }

    moved_piece = self[from_pos]

    # update the board
    self[to_pos] = moved_piece
    self[from_pos] = NullPiece.instance
    # update the piece
    self[to_pos].pos = to_pos
  end

  def checkmate?(color)
    pieces = collect_pieces(color)
    moves = []
    pieces.each do |piece|
      piece.moves.each do |move|
        moves << [piece.pos, move]
      end
    end
    moves.each do |move|
      from_pos, to_pos = move
      a = self.deep_dup
      a.move_piece!(from_pos, to_pos)
      return false unless check?(color)
    end
    true
  end

  def collect_pieces(color)
    pieces = []
    @rows.each do |row|
      row.each { |piece| pieces << piece if piece.color == color }
    end
    pieces
  end

  def check?(color)
    enemy_color = color == :white ? :black : :white
    threatened_squares = []

    enemy_pieces = collect_pieces(enemy_color)
    enemy_pieces.each do |enemy_piece|
      if enemy_piece.is_a?(Pawn)
        x, y = enemy_piece.pos
        threatened_squares += enemy_piece.capture_moves(x, y)
      else
        threatened_squares += enemy_piece.moves
      end
    end

    threatened_squares
    king_pos = find_king(color)
    threatened_squares.include?(king_pos)
  end

  def in_bounds?(pos)
    x, y = pos
    return false unless x.between?(0, 7) && y.between?(0, 7)
    true
  end

  def make_starting_grid

    # place pawns
    [1, 6].each do |row_num|
      color = row_num == 1 ? :black : :white
      (0..7).each do |col_num|
        self[[row_num, col_num]] = Pawn.new(color, [row_num, col_num], self)
      end
    end

    # place pieces
    [0, 7].each do |row_num|
      color = row_num.zero? ? :black : :white
      # place rooks
      [0, 7].each do |col_num|
        self[[row_num, col_num]] = Rook.new(color, [row_num, col_num], self)
      end
      # place knights
      [1, 6].each do |col_num|
        self[[row_num, col_num]] = Knight.new(color, [row_num, col_num], self)
      end
      # place bishops
      [2, 5].each do |col_num|
        self[[row_num, col_num]] = Bishop.new(color, [row_num, col_num], self)
      end
      # place queens
      self[[row_num, 3]] = Queen.new(color, [row_num, 3], self)
      # place kings
      self[[row_num, 4]] = King.new(color, [row_num, 4], self)
    end

    # place null pieces
    (2..5).each do |row_num|
      (0..7).each do |col_num|
        self[[row_num, col_num]] = NullPiece.instance
      end
    end
  end

  def find_king(color)
    @rows.each_with_index do |row, m|
      row.each_with_index do |piece, n|
        return [m, n] if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def deep_dup
    # color, pos, board = nil

    dd_board = Board.new
    @rows.each_with_index do |row, idx1|
      row.each_with_index do |piece, idx2|
        if piece.is_a?(NullPiece)
          dd_board[[idx1, idx2]] = NullPiece.instance
        else
          dd_board[[idx1, idx2]] = piece.class.new(piece.color, piece.pos, dd_board)
        end
      end
    end
    dd_board
  end

end
