require "io/console"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @current_piece = nil
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  def handle_key(key)
    case key
    when :return, :space
      highlighted_piece = @board[@cursor_pos]
      unless highlighted_piece.is_a?(NullPiece) || highlighted_piece.enemy?(highlighted_piece.color)
        @current_piece = highlighted_piece
        return nil
      end
      possible_moves = nil
      unless @current_piece.nil? || @current_piece.is_a?(NullPiece)
        possible_moves = @current_piece.valid_moves
      end

      if possible_moves.include?(@cursor_pos)
        return [@current_piece.pos, @cursor_pos]
      else
        @current_piece = nil
      end
    when :left, :right, :up, :down
      update_pos(MOVES[key])
    when :ctrl_c
      Process.exit(0)
    end
    nil
  end

  def update_pos(diff)
    x = @cursor_pos[0] + diff[0]
    y = @cursor_pos[1] + diff[1]
    @cursor_pos = [x, y] if @board.in_bounds?([x, y])
  end

end
