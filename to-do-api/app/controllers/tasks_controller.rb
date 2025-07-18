class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.all
    @tasks = @tasks.by_status(params[:status]) if params[:status].present? && Task.statuses.key?(params[:status].to_sym)
    @tasks = @tasks.by_title(params[:title]) if params[:title].present?
    @tasks = @tasks.by_description(params[:description]) if params[:description].present?
    @tasks = @tasks.by_created_at(Date.parse(params[:created_at])) if params[:created_at].present? rescue nil # Lida com datas inválidas
    @tasks = @tasks.by_due_date(Date.parse(params[:due_date])) if params[:due_date].present? rescue nil # Lida com datas inválidas

    render json: @tasks
  end

  # GET /tasks/:id
  def show
    render json: @task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/:id
  def destroy
    # Apenas marca como "Cancelada", não remove o registro
    if @task.cancelled!
      render json: { message: "Task successfully cancelled." }, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end