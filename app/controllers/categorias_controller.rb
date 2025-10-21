class CategoriasController < ApplicationController
  before_action :authenticate_usuario!

  def index
    @categorias = Categoria.order(nome: :asc)
  end

  def show
  end

  def new
    @categoria = Categoria.new
  end

  def create
    @categoria = Categoria.find_or_create_by(nome: categoria_params[:nome].strip)

    respond_to do |format|
      format.html { redirect_to categorias_path }
    end
  end

  private

    def set_categoria
      @categoria = Categoria.find(params.expect(:id))
    end

    def categoria_params
      params.require(:categoria).permit(:nome)
    end
end
