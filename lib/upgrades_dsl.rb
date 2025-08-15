# /lib/upgrades_dsl.rb

class UpgradeDefinition
  # Removendo todos os attr_reader para evitar a colisão de nomes
  # e definindo os métodos de leitura manualmente
  attr_reader :key

  def initialize(key)
    @key = key
  end

  # Métodos que a DSL usa para definir os atributos (setters)
  def cost(value)
    @cost = value
  end

  def description(text)
    @description = text
  end

  def initial_value(value)
    @initial_value = value
  end

  def limit(value)
    @limit = value
  end

  def effect(&block)
    @effect = block
  end

  # Métodos para ler os atributos (getters)
  def cost_get
    @cost
  end

  def description_get
    @description
  end

  def initial_value_get
    @initial_value
  end
  
  def limit_get
    @limit
  end
  
  def effect_get
    @effect
  end

end

class UpgradesDsl
  attr_reader :upgrades

  def initialize
    @upgrades = {}
  end

  def upgrade(key, &block)
    definition = UpgradeDefinition.new(key)
    definition.instance_eval(&block)
    @upgrades[key] = definition
  end

  def self.load(file_path)
    dsl = new
    dsl.instance_eval(File.read(file_path))
    dsl.upgrades
  end
end