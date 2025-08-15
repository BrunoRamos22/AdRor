# /lib/minigames/dot_minigame.rb
require 'gosu'
require_relative '../player'
require_relative '../ball'

class DotMinigame
  attr_reader :player, :balls
  attr_accessor :score
  
  def initialize(window)
    @window = window
    @score = 0

    # Definir a área de jogo do minigame
    @game_area_x = 150
    @game_area_y = 0
    @game_area_width = @window.width - 150 - 250
    @game_area_height = @window.height
    
    player_width = @window.upgrades_manager.get_value(:player_width)
    @player = Player.new(@window, @game_area_x, @game_area_y, @game_area_width, @game_area_height, player_width)
    @balls = []
    
    @ball_generator = spawn_balls
    @is_running = true
  end

  def run_in_thread
    @thread = Thread.new do
      while @is_running
        ball_quantity_upgrade_value = @window.upgrades_manager.get_value(:ball_quantity)

        if @balls.count < ball_quantity_upgrade_value
          @balls << @ball_generator.next
        end

        @balls.each do |ball|
          ball.update
          
          if ball.y + ball.radius > @player.y && ball.x > @player.x && ball.x < @player.x + @player.width
            @score += ball.value
            @window.upgrade_points += ball.value
            @balls.delete(ball)
          elsif ball.off_screen?(@game_area_y + @game_area_height)
            @balls.delete(ball)
          end
        end
        
        sleep(0.01)
      end
    end
  end
  
  def stop_thread
    @is_running = false
    @thread.join
  end

  def update_mouse_position
    @player.width = @window.upgrades_manager.get_value(:player_width)

    new_x = @window.mouse_x - (@player.width / 2)
    min_x = @game_area_x
    max_x = @game_area_x + @game_area_width - @player.width
    @player.x = [max_x, [min_x, new_x].max].min
  end
  
  def draw
    Gosu.draw_rect(@game_area_x, @game_area_y, @game_area_width, @game_area_height, Gosu::Color::BLACK, ZOrder::BACKGROUND)
    
    @player.draw
    @balls.each(&:draw)
  end

  def spawn_balls
    Enumerator.new do |yielder|
      loop do
        x = rand(@game_area_x..@game_area_x + @game_area_width)
        y = @game_area_y
        radius = rand(10..20)
        ball_speed = @window.upgrades_manager.get_value(:ball_speed) + rand(1..3)
        
        color, value = get_ball_attributes
        
        yielder.yield Ball.new(@window, x, y, radius, ball_speed, value, color)
      end
    end.lazy
  end

  def get_ball_attributes
    base_value = @window.upgrades_manager.get_value(:ball_value)
    
    if rand < 0.2
      color = Gosu::Color.argb(0xff_ff0000)
      value = base_value * 5
    else
      color = Gosu::Color::WHITE
      value = base_value
    end
    [color, value]
  end
end