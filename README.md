# ------------------------ GEO GAMES ---------------------
by: Bruno Ramos

## Propósito do Projeto

O objetivo do jogo é ensinar sobre as formas geométricas, da mais simplificada "o ponto" ou "dot" à mais complexa. Por isso passamos pelos minigames "dot", "line", "triangle", "Square", etc.

## Requisitos Técnicos Obrigatórios

Este projeto foi desenvolvido para atender aos seguintes requisitos técnicos:

### 1. DSL (Domain-Specific Language)

Foi implementada uma DSL simples para a criação e configuração dos upgrades do jogo. O arquivo `upgrades.rb` utiliza essa DSL para definir de forma declarativa as melhorias disponíveis, seus custos e efeitos. Isso torna a adição de novos upgrades intuitiva e limpa.

### 2. Enumerable / Lazy Evaluation

A classe `DotMinigame` faz uso de `Enumerator::Lazy` para gerar as bolinhas que caem na tela. Isso garante que as bolinhas sejam criadas de forma "preguiçosa", ou seja, apenas quando são necessárias, otimizando o consumo de memória e o desempenho do sistema, especialmente se a lógica de geração de bolinhas fosse mais complexa.

### 3. Concorrência e Paralelismo

O `DotMinigame` roda em uma `Thread` separada. Isso permite que sua lógica de jogo (geração de bolinhas, movimento e pontuação) seja executada de forma concorrente com o loop principal da aplicação. O jogador pode estar no `LineMinigame` ou na tela principal, e o `DotMinigame` continuará funcionando em segundo plano, acumulando pontos de forma automática.

### 4. Organização e Composição

O código é estruturado em classes e módulos com responsabilidades bem definidas, utilizando o conceito de composição para integrar as funcionalidades. A classe `GameWindow` gerencia o estado do jogo e os diferentes minigames, enquanto o `UpgradesManager` lida com toda a lógica de upgrades. Os minigames (`DotMinigame`, `LineMinigame`) são classes independentes que podem ser adicionadas ou removidas sem impactar a arquitetura principal.

## Instalação e Execução

Certifique-se de ter o Ruby e o Bundler instalados.

1.  Clone o repositório.
2.  Navegue até o diretório do projeto.
3.  Instale as gems necessárias com o Bundler (bundle install).
4.  Execute o jogo a partir do diretório raiz (ruby main.rb).

## Como Jogar

* **Tela Inicial:** Clique nas miniaturas de jogo à esquerda para alternar entre os minigames.
* **DotMinigame:** Mova o mouse horizontalmente para controlar a plataforma e coletar as bolinhas que caem. Este jogo continuará gerando pontos passivamente, mesmo quando você estiver em outro minigame.
* **LineMinigame:** Clique nas bolinhas na ordem correta (numerada) para conectá-las com uma linha. Ao completar a sequência, você ganha pontos.
* **Upgrades:** Use os pontos acumulados para comprar upgrades no painel à direita, melhorando as habilidades do seu personagem em ambos os jogos.
* **Sair:** Pressione `ESC` para sair do minigame atual e retornar à tela principal. Pressione `ESC` novamente na tela principal para fechar o jogo.

## Próximas implementações

* Melhorar a GUI
* Criar mais jogos
* Criar um sistema de save
* Implementar o sistema de "rebirth" pra quando o jogo for zerado, poder recomeçar com algum tipo de buff
* Colocar sons
* Aceito sugestões
