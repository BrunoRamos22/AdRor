# /lib/game_window.rb
require 'gosu'
require_relative 'upgrades_manager'
require_relative 'minigames/dot_minigame'
require_relative 'minigames/line_minigame'

module ZOrder
  BACKGROUND, BALLS, PLAYER, UI = *0..3
end

class GameWindow < Gosu::Window
  attr_accessor :score, :upgrade_points, :current_minigame, :upgrades_manager
  attr_reader :screen_state, :font 

  MAIN_SCREEN = :main_screen
  DOT_MINIGAME = :dot_minigame
  LINE_MINIGAME = :line_minigame

  def initialize
    super(1200, 800)
    self.caption = "Geo Minigames"
    
    @upgrade_points = 0
    @font = Gosu::Font.new(20)
    
    @upgrades_manager = UpgradesManager.new(self)
    
    @current_minigame = nil
    @screen_state = MAIN_SCREEN
    
    @dot_thumbnail_image = Gosu::Image.new("assets/images/dot_thumbnail.png")
    @line_thumbnail_image = Gosu::Image.new("assets/images/line_thumbnail.png")
  end

  def update
    if @screen_state == DOT_MINIGAME
      # O update do DotMinigame foi movido para a thread,
      # então só precisamos atualizar a posição do mouse na tela principal.
      @current_minigame.update_mouse_position
    elsif @screen_state == LINE_MINIGAME
      # Aqui chamaremos o update do minigame de ligar os pontos
      @current_minigame.update
    end
  end

  def draw
    if @screen_state == MAIN_SCREEN
      draw_main_layout
    elsif @screen_state == DOT_MINIGAME
      @current_minigame.draw
      draw_layout
      @font.draw_text("Minigame Score: #{@current_minigame.score}", 165, 5, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    elsif @screen_state == LINE_MINIGAME
      @current_minigame.draw
      draw_layout
    end
  end

  def draw_layout
    minigame_thumbnail_width = 150
    upgrades_panel_width = 250
    
    Gosu.draw_rect(0, 0, minigame_thumbnail_width, height, Gosu::Color.argb(0xff_333333), ZOrder::UI)
    
    dot_button_x = 0
    dot_button_y = 0
    if @dot_thumbnail_image
      @dot_thumbnail_image.draw(dot_button_x, dot_button_y, ZOrder::UI)
    else
      Gosu.draw_rect(dot_button_x, dot_button_y, minigame_thumbnail_width, 150, Gosu::Color.argb(0xff_555555), ZOrder::UI)
      @font.draw_text("Dot", 50, dot_button_y + 70, ZOrder::UI, 1, 1, Gosu::Color::RED)
    end
    
    line_button_x = 0
    line_button_y = 150
    if @line_thumbnail_image
      @line_thumbnail_image.draw(line_button_x, line_button_y, ZOrder::UI)
    else
      Gosu.draw_rect(line_button_x, line_button_y, minigame_thumbnail_width, 150, Gosu::Color.argb(0xff_555555), ZOrder::UI)
      @font.draw_text("Line", 50, line_button_y + 70, ZOrder::UI, 1, 1, Gosu::Color::RED)
    end
    
    upgrades_x = width - upgrades_panel_width
    Gosu.draw_rect(upgrades_x, 0, upgrades_panel_width, height, Gosu::Color.argb(0xff_333333), ZOrder::UI)
    @font.draw_text("Upgrades", upgrades_x + 10, 5, ZOrder::UI, 1, 1, Gosu::Color::WHITE)
    @font.draw_text("Upgrade Points: #{@upgrade_points}", upgrades_x + 10, 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    
    @upgrades_manager.draw
  end
  
  def draw_main_layout
    Gosu.draw_rect(0, 0, width, height, Gosu::Color::BLACK, ZOrder::BACKGROUND)
    draw_layout
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      if @screen_state != MAIN_SCREEN
        if @screen_state == DOT_MINIGAME
          @current_minigame.stop_thread
        end
        @current_minigame = nil
        @screen_state = MAIN_SCREEN
      else
        close
      end
    elsif id == Gosu::MS_LEFT
      dot_button_x = 0
      dot_button_y = 0
      dot_button_width = @dot_thumbnail_image ? @dot_thumbnail_image.width : 150
      dot_button_height = @dot_thumbnail_image ? @dot_thumbnail_image.height : 150
      
      line_button_x = 0
      line_button_y = 150
      line_button_width = @line_thumbnail_image ? @line_thumbnail_image.width : 150
      line_button_height = @line_thumbnail_image ? @line_thumbnail_image.height : 150

      if mouse_x.between?(dot_button_x, dot_button_x + dot_button_width) && mouse_y.between?(dot_button_y, dot_button_y + dot_button_height)
        switch_to_dot_minigame
      elsif mouse_x.between?(line_button_x, line_button_x + line_button_width) && mouse_y.between?(line_button_y, line_button_y + line_button_height)
        switch_to_line_minigame
      elsif @screen_state == DOT_MINIGAME
        @upgrades_manager.handle_click(mouse_x, mouse_y)
      elsif @screen_state == LINE_MINIGAME
        @current_minigame.button_down(id)
        @upgrades_manager.handle_click(mouse_x, mouse_y)
      end
    end
  end

  def switch_to_dot_minigame
    if @screen_state == DOT_MINIGAME
      return
    elsif @screen_state == LINE_MINIGAME
      # Nenhuma thread para parar ao sair do LineMinigame
    end
    
    @current_minigame = DotMinigame.new(self)
    @current_minigame.run_in_thread
    @screen_state = DOT_MINIGAME
  end
  
  def switch_to_line_minigame
    if @screen_state == LINE_MINIGAME
      return
    elsif @screen_state == DOT_MINIGAME
      # Não paramos a thread ao ir para o LineMinigame
    end
    
    @current_minigame = LineMinigame.new(self)
    @screen_state = LINE_MINIGAME
  end
end