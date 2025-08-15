# /lib/minigames/line_minigame.rb
require 'gosu'

class LineMinigame
  attr_accessor :score
  
  def initialize(window)
    @window = window
    @score = 0
    
    @game_area_x = 150
    @game_area_y = 0
    @game_area_width = @window.width - 150 - 250
    @game_area_height = @window.height
    
    @points = []
    @lines = []
    @current_point_index = 0
    
    @points_to_spawn = 5
    generate_new_sequence
  end

  def update
    # A lógica de atualização para este minigame é mínima, já que a interação
    # principal é através do clique do mouse.
  end

  def draw
    # Fundo da área do minigame
    Gosu.draw_rect(@game_area_x, @game_area_y, @game_area_width, @game_area_height, Gosu::Color::BLACK, ZOrder::BACKGROUND)
    
    # Desenha as linhas já conectadas
    @lines.each do |line|
      Gosu.draw_line(
        line[:x1], line[:y1], Gosu::Color::WHITE,
        line[:x2], line[:y2], Gosu::Color::WHITE,
        ZOrder::BALLS
      )
    end
    
    # Desenha os pontos
    @points.each_with_index do |point, index|
      color = (index == @current_point_index) ? Gosu::Color::YELLOW : Gosu::Color::WHITE
      Gosu.draw_rect(point[:x] - 5, point[:y] - 5, 10, 10, color, ZOrder::BALLS)
      @window.font.draw_text(index + 1, point[:x] + 10, point[:y] - 10, ZOrder::UI, 1, 1, Gosu::Color::WHITE)
    end
  end

  def button_down(id)
    if id == Gosu::MS_LEFT
      click_x = @window.mouse_x
      click_y = @window.mouse_y
      
      if click_x.between?(@game_area_x, @game_area_x + @game_area_width) && click_y.between?(@game_area_y, @game_area_y + @game_area_height)
        handle_click(click_x, click_y)
      end
    end
  end

  def handle_click(mouse_x, mouse_y)
    if @current_point_index < @points.size
      current_target = @points[@current_point_index]
      
      # Verifica se o clique está perto do ponto alvo
      if Gosu.distance(mouse_x, mouse_y, current_target[:x], current_target[:y]) < 20
        # Ponto clicado corretamente
        if @current_point_index > 0
          prev_point = @points[@current_point_index - 1]
          @lines << {
            x1: prev_point[:x], y1: prev_point[:y],
            x2: current_target[:x], y2: current_target[:y]
          }
        end
        
        @current_point_index += 1
        
        # Sequência completa, ganha pontos e reinicia
        if @current_point_index == @points.size
          @score += 100
          @window.upgrade_points += 100
          generate_new_sequence
        end
      end
    end
  end

  private

  def generate_new_sequence
    @points.clear
    @lines.clear
    @current_point_index = 0
    
    @points_to_spawn.times do
      x = rand(@game_area_x + 20..@game_area_x + @game_area_width - 20)
      y = rand(@game_area_y + 20..@game_area_y + @game_area_height - 20)
      @points << { x: x, y: y }
    end
  end
end