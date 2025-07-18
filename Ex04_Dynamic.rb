require 'thread'
require_relative 'Ex04_Threads' 

class DynamicThreadPool
  DEFAULT_MIN_THREADS = 2
  DEFAULT_MAX_THREADS = 10

  def initialize(min_threads: DEFAULT_MIN_THREADS, max_threads: DEFAULT_MAX_THREADS, queue_class: PriorityQueue)
    raise ArgumentError, "min_threads must be >= 1" if min_threads < 1
    raise ArgumentError, "max_threads must be >= min_threads" if max_threads < min_threads

    @min_threads = min_threads
    @max_threads = max_threads
    @queue = queue_class.new
    @threads = []
    @mutex = Mutex.new
    @shutdown = false
    @worker_condition = ConditionVariable.new

    start_initial_threads
  end

  def schedule(priority = :medium, &block)
    raise ArgumentError, "Block must be provided" unless block_given?
    raise "ThreadPool is shutting down" if @shutdown

    @queue.enqueue(priority, block)
    ensure_thread
    @worker_condition.signal # Sinaliza uma thread para pegar o trabalho
  end

  def shutdown
    @mutex.synchronize do
      @shutdown = true
      @worker_condition.broadcast # Acorda todas as threads
    end
    @threads.each(&:join) # Aguarda as threads terminarem
  end

  private

  def start_initial_threads
    @min_threads.times { create_worker }
  end

  def ensure_thread
    @mutex.synchronize do
      if @threads.size < @max_threads
        create_worker
      end
    end
  end

  def create_worker
    thread = Thread.new do
      loop do
        task = nil
        @mutex.synchronize do
          break if @shutdown

          task = @queue.dequeue
          if task.nil?
            @worker_condition.wait(@mutex) unless @shutdown
          end
        end

        break if @shutdown # Sai do loop se o pool estiver desligando

        begin
          task.call if task
        rescue => e
          puts "Erro ao executar tarefa: #{e.message}"
          puts e.backtrace.join("\n")
        end
      end
    end
    @threads << thread
    thread.abort_on_exception = true # Importante para evitar threads "zumbis"
  end
end
