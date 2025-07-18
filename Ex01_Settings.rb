# Objetivo: 
# Criar uma classe Settings que permita o registro e a leitura dinâmica de configurações, utilizando define_method, method_missing, respond_to_missing? e send.

class Settings
  def initialize
    @settings = {}
    @aliases = {}
    @readonly = {}
  end

  def add(key, value, alias_name = nil, readonly: false)
    key = key.to_sym
    @settings[key] = value
    @readonly[key] = readonly

    self.class.send(:define_method, key) do
      value
    end

    if alias_name
      alias_name = alias_name.to_sym
      @aliases[alias_name] = key
      self.class.send(:define_method, alias_name) do
        value
      end
    end
  end

  def method_missing(name, *args)
    name_sym = name.to_sym

    if name.to_s.end_with?('=')
      key = name.to_s.chomp('=').to_sym
      if @readonly[key]
        raise "Configuração '#{key}' é somente leitura."
      else
        @settings[key] = args.first
        self.class.send(:define_method, key) { args.first }
      end
      return
    end

    if @aliases.key?(name_sym)
      return @settings[@aliases[name_sym]]
    end

    if @settings.key?(name_sym)
      return @settings[name_sym]
    end

    raise NoMethodError, "Configuração '#{name}' não existe."
  end

  def respond_to_missing?(name, include_private = false)
    name_sym = name.to_sym
    name.to_s.end_with?('=') || @settings.key?(name_sym) || @aliases.key?(name_sym) || super
  end

  def all
    @settings.dup  # Retorna uma cópia para evitar modificações externas diretas
  end
end


# Exemplo de uso
settings = Settings.new

# Definindo configurações dinamicamente
settings.add(:timeout, 30)
settings.add(:mode, "production")
settings.add(:ily, "I.", readonly: true)
#settings.ily = "No, I don't"         # => Erro, esta configuração é só leitura!
settings.add(:environment, "production", :env) # Adicionando um alias

# Acessando configurações via método
puts settings.timeout       # => 30
puts settings.mode          # => "production"
puts settings.env           # => "production" (usando o alias)

# Tentando acessar configuração inexistente
begin
  puts settings.retry
rescue NoMethodError => e
  puts "Erro: #{e.message}" # => "Configuração 'retry' não existe."
end

# Checando se um método está disponível
puts settings.respond_to?(:timeout)  # => true
puts settings.respond_to?(:retry)    # => false
puts settings.respond_to?(:env)      # => true (devido ao alias)

puts settings.all  # => {:timeout=>30, :mode=>"production", :ily=>"I.", :environment=>"production"}
