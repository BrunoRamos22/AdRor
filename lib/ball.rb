# lib/ball.rb
require 'gosu'

class Ball
  attr_reader :x, :y, :radius, :value, :color

  def initialize(window, x, y, radius, speed, value, color)
    @window = window
    @x = x
    @y = y
    @radius = radius
    @speed = speed
    @value = value
    @color = color
  end

  def update
    @y += @speed
  end

  def draw
    Gosu.draw_rect(@x - @radius, @y - @radius, @radius * 2, @radius * 2, @color, ZOrder::BALLS)
  end

  def off_screen?(bottom_boundary)
    @y > bottom_boundary + @radius
  end
end