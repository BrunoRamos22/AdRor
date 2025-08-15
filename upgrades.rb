# upgrade 1: Quantidade de bolinhas caindo
upgrade :ball_quantity do
  description "Aumenta a quantidade de bolinhas que caem por vez."
  initial_value 1
  limit 200
  cost 50
  effect do |current_value|
    current_value + 1
  end
end

# upgrade 2: Velocidade de queda das bolinhas
upgrade :ball_speed do
  description "Aumenta a velocidade de queda das bolinhas."
  initial_value 2
  limit 10
  cost 75
  effect do |current_value|
    current_value + 0.5
  end
end

# upgrade 3: Valor das bolinhas (pontos)
upgrade :ball_value do
  description "Aumenta a pontuação obtida por cada bolinha."
  initial_value 1
  limit 10
  cost 100
  effect do |current_value|
    current_value + 1
  end
end

# upgrade 4: Tamanho da plataforma
upgrade :player_width do
  description "Aumenta o tamanho da plataforma para pegar mais bolinhas."
  initial_value 80 # Largura inicial da plataforma em pixels
  limit :max_panel
  cost 150
  effect do |current_value, minigame|
    # Aumenta a largura para caber mais uma bolinha de cada lado.
    # Assumimos que a bolinha de maior raio tem 20px de diâmetro.
    increase_amount = 20 * 2 # Diâmetro da bolinha
    current_value + increase_amount
  end
end