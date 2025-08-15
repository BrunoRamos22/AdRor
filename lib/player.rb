# /lib/player.rb
require 'gosu'

class Player
  attr_accessor :x, :y, :width, :height

  def initialize(window, game_area_x, game_area_y, game_area_width, game_area_height, width_from_upgrade)
    @window = window
    @width = width_from_upgrade
    @height = 10
    
    # Define a posição inicial no centro da área de jogo
    @x = game_area_x + (game_area_width / 2) - (@width / 2)
    @y = game_area_y + game_area_height - 30
  end

  def draw
    # Desenha o retângulo que representa o jogador
    Gosu.draw_rect(@x, @y, @width, @height, Gosu::Color::WHITE, ZOrder::PLAYER)
  end

  def increase_width(amount)
    # Método para aumentar a largura da base, útil para upgrades
    @width += amount
  end
end