class CategoriasController < ApplicationController
  before_action :set_categoria, only: [:edit, :update, :destroy]
  before_action :authenticate_usuario!

  def index
    @categorias = Categoria.order(nome: :asc)
  end

  def show
  end

  def new
    @categoria = Categoria.new
  end

  def edit
  end

  def create
    @categoria = Categoria.find_or_create_by(nome: categoria_params[:nome].strip)

    if @categoria.persisted?
      redirect to categorias_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content, alert: t(".failure")
    end
  end

  def update
    if @categoria.update(categoria_params)
      redirect_to categorias_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content, alert: t(".failure")
    end
  end

  def destroy
    @categoria.destroy
    redirect_to categorias_path, notice: t(".success")
  end

  private

    def set_categoria
      @categoria = Categoria.find(params.expect(:id))
    end

    def categoria_params
      params.require(:categoria).permit(:nome)
    end
end
