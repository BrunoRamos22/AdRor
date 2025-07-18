# Objetivo:
# Criar uma classe Vector2 que receba dois parâmetros (X e Y) e permita a multiplicação desse Vector2 por objetos do tipo Numeric e Vector2.
class Vector2
  attr_reader :x, :y

  def initialize(x, y)
    @x = x.to_f
    @y = y.to_f
  end

  def *(other)
    if other.is_a?(Numeric)
      Vector2.new(@x * other, @y * other)
    elsif other.is_a?(Vector2)
      @x * other.x + @y * other.y
    else
      raise ArgumentError, "Can't multiply Vector2 by #{other.class}"
    end
  end

  def coerce(other)
    [self, other]
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

# Testes
v = Vector2.new(3, 4)
puts v * 2       # Output: (6.0, 8.0)
puts v * 2.5     # Output: (7.5, 10.0)
puts v * v       # Output: 25.0
puts 2 * v       # Output: (6.0, 8.0)
puts 2.5 * v     # Output: (7.5, 10.0)
