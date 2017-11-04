class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update]


  # GET /todos
  def index
    @todos = Todo.all
    json_response(@todos)
  end

  # GET /todos/:id
  def show
    json_response(@todo)
  end

  #POST /todos
  def create
    @todo = Todo.create!(todo_params)
    json_response(@todo, :created)
  end

  #PUT /todos
  def update
    #Todo what should be corerct error message if record to be updated is not found
    @todo.update(todo_params)
    head :no_content
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.permit(:title,:created_by)
  end

  end
