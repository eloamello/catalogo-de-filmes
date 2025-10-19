class ComentariosController < ApplicationController
  before_action :set_comentario, only: %i[ show edit update destroy ]
  before_action :authenticate_usuario!, except: [ :index, :show, :new, :create ]
  before_action :authorize_usuario!, only: [ :edit, :update, :destroy ]

  def index
    @comentarios = Comentario.order(created_at: :desc)
  end

  def show
  end

  def new
    @comentario = Comentario.new
  end

  def edit
  end

  def create
    @comentario = Comentario.new(comentario_params)
    @comentario.usuario = current_usuario if usuario_signed_in?

    respond_to do |format|
      if @comentario.save
        format.html { redirect_to @comentario, notice: "Comentario was successfully created." }
        format.json { render :show, status: :created, location: @comentario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comentario.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comentario.update(comentario_params)
        format.html { redirect_to @comentario, notice: "Comentario was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @comentario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comentario.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comentario.destroy!

    respond_to do |format|
      format.html { redirect_to comentarios_path, notice: "Comentario was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def authorize_usuario!
      redirect_to comentarios_path, alert: "Você não pode alterar este comentário." unless @comentario.usuario == current_usuario
    end

    def set_comentario
      @comentario = Comentario.find(params.expect(:id))
    end

    def comentario_params
      params.require(:comentario).permit(:nome_visitante, :conteudo)
    end
end
