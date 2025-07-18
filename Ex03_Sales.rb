# Objetivo:
# Implemente uma classe SalesReport que recebe uma lista de vendas no formato abaixo:
# sales = [
# { product: "Notebook", category: "Eletrônicos", amount: 3000 },
# { product: "Celular", category: "Eletrônicos", amount: 1500 },
# { product: "Cadeira", category: "Móveis", amount: 500 },
# { product: "Mesa", category: "Móveis", amount: 1200 },
# { product: "Headphone", category: "Eletrônicos", amount: 300 },
# { product: "Armário", category: "Móveis", amount: 800 }
# ]
    class SalesReport
  include Enumerable

  def initialize(sales)
    @sales = sales
  end

  def each(&block)
    @sales.each(&block)
  end

  def total_by_category
    @sales.each_with_object(Hash.new(0)) do |sale, totals|
      totals[sale[:category]] += sale[:amount]
    end
  end

  def top_sales(n)
    @sales.sort_by { |sale| -sale[:amount] }.take(n)
  end

  def grouped_by_category
    @sales.group_by { |sale| sale[:category] }
  end

  def above_average_sales
    average = @sales.map { |sale| sale[:amount] }.sum / @sales.size.to_f
    @sales.select { |sale| sale[:amount] > average }
  end

  # Métodos para formatar a saída
  def format_total_by_category
    total_by_category.inspect
  end

  def format_top_sales(n)
    top_sales(n).inspect
  end

  def format_grouped_by_category
    grouped_by_category.inspect
  end

  def format_above_average_sales
    above_average_sales.inspect
  end
end

# Exemplo de uso:
sales = [
  { product: "Notebook", category: "Eletrônicos", amount: 3000 },
  { product: "Celular", category: "Eletrônicos", amount: 1500 },
  { product: "Cadeira", category: "Móveis", amount: 500 },
  { product: "Mesa", category: "Móveis", amount: 1200 },
  { product: "Headphone", category: "Eletrônicos", amount: 300 },
  { product: "Armário", category: "Móveis", amount: 800 }
]

report = SalesReport.new(sales)

puts "Total por categoria: #{report.format_total_by_category}"
puts "Top 2 vendas: #{report.format_top_sales(2)}"
puts "Vendas agrupadas por categoria: #{report.format_grouped_by_category}"
puts "Vendas acima da média: #{report.format_above_average_sales}"

# Exemplo de uso do Enumerable (iterando sobre as vendas)
puts "\nIterando sobre as vendas:"
report.each do |sale|
  puts sale.inspect
end
