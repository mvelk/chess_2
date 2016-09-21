require 'singleton'

class NullPiece
  include Singleton

  def moves
    []
  end

  def color
    nil
  end

  def to_s
    "  "
  end

  def empty?
    true
  end

  def enemy?(color)
    false
  end
end
