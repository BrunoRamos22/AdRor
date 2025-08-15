# /lib/upgrades_manager.rb
require_relative 'upgrades_dsl'

class UpgradesManager
  def initialize(window)
    @window = window
    @upgrades = UpgradesDsl.load('upgrades.rb')
    @current_values = {}
    
    @upgrades.each do |key, definition|
      @current_values[key] = definition.initial_value_get
    end
  end

  def get_value(key)
    @current_values[key]
  end

  def draw
    upgrades_x = @window.width - 250
    upgrades_y = 70
    
    @upgrades.each do |key, definition|
      upgrade_description = definition.description_get
      upgrade_cost = definition.cost_get
      current_value = get_value(key)
      
      button_text = "#{upgrade_description}\nCusto: #{upgrade_cost}\nValor Atual: #{current_value}"
      
      Gosu.draw_rect(upgrades_x + 10, upgrades_y, 230, 60, Gosu::Color::GRAY, ZOrder::UI)
      
      @window.font.draw_text(button_text, upgrades_x + 20, upgrades_y + 10, ZOrder::UI, 1, 1, Gosu::Color::WHITE)
      
      upgrades_y += 70
    end
  end
  
  def handle_click(mouse_x, mouse_y)
    upgrades_x = @window.width - 250
    upgrades_y_start = 70
    button_height = 60
    
    @upgrades.each_with_index do |(key, definition), index|
      button_y = upgrades_y_start + (index * 70)
      
      if mouse_x.between?(upgrades_x + 10, upgrades_x + 240) && mouse_y.between?(button_y, button_y + button_height)
        buy_upgrade(key)
        break
      end
    end
  end

  def buy_upgrade(upgrade_key)
    definition = @upgrades[upgrade_key]
    if @window.upgrade_points >= definition.cost_get
      new_value = definition.effect_get.call(@current_values[upgrade_key])
      
      # Lógica de correção para o limite de upgrade
      limit = definition.limit_get
      limit_ok = (limit == :max_panel) || (new_value <= limit)
      
      if limit_ok
        @current_values[upgrade_key] = new_value
      else
        puts "Limite do upgrade alcançado."
        return false
      end
      
      @window.upgrade_points -= definition.cost_get
      puts "Upgrade '#{definition.description_get}' comprado! Novo valor: #{@current_values[upgrade_key]}"
      return true
    end
    false
  end
end