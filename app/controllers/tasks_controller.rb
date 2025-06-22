class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @tasks = current_user.tasks.order(due_date: :asc)

    if params[:filter].present?
      case params[:filter]
      when "completed"
        @tasks = @tasks.where(status: "completed")
      when "pending"
        @tasks = @tasks.where(status: "pending")
      end
    end

    if params[:date].present?
      @tasks = @tasks.where("due_date = ?", params[:date])
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      flash.now[:alert] = "Please fill required fields."
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Task was successfully updated.'
    else
      flash.now[:alert] = "Please fill required fields."
      render :edit
    end
  end

  def show
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully deleted.'
  end

  private
    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :due_date, :status)
    end
end