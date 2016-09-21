require 'colorize'

class Display
  attr_accessor :cursor

  def initialize(cursor_pos, board)
    @cursor = Cursor.new(cursor_pos, board)
    @board = board
  end

  def move(new_pos)
  end

  def render
    system("clear")
    (0..7).each do |row|
      (0..7).each do |col|
        background = nil
        if (row + col).even?
          background = :light_yellow
        else
          background = :blue
        end

        foreground = nil
        if @cursor.cursor_pos == [row, col]
          foreground = :red
          background = :green
        else
          foreground = :black
        end

        print @board[[row, col]].to_s.colorize(:color => foreground, :background => background )

      end
      puts
    end
  end

end
