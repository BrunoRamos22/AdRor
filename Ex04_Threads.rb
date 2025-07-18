require 'thread'

class PriorityQueue
  PRIORITIES = [:high, :medium, :low].freeze

  def initialize
    @queues = PRIORITIES.map { |priority| [priority, Queue.new] }.to_h
    @mutex = Mutex.new
    @not_empty_condition = ConditionVariable.new
  end

  def enqueue(priority, task)
    raise ArgumentError, "Invalid priority: #{priority}" unless PRIORITIES.include?(priority)

    @mutex.synchronize do
      @queues[priority].push(task)
      @not_empty_condition.signal # Sinaliza que uma nova tarefa foi adicionada
    end
  end

  def dequeue
    task = nil
    @mutex.synchronize do
      loop do
        PRIORITIES.each do |priority|
          if !@queues[priority].empty?
            task = @queues[priority].pop
            break # Sai do loop de prioridades assim que encontrar uma tarefa
          end
        end
        break if task # Sai do loop principal se uma tarefa foi encontrada

        @not_empty_condition.wait(@mutex) # Aguarda por sinal de novas tarefas
      end
    end
    task
  end

  def empty?
    @mutex.synchronize do
      PRIORITIES.all? { |priority| @queues[priority].empty? }
    end
  end
end
