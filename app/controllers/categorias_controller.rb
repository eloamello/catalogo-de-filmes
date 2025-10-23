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

    respond_to do |format|
      format.html { redirect_to categorias_path }
    end
  end

  def update
    respond_to do |format|
      if @categoria.update(categoria_params)
        format.html { redirect_to categorias_path, notice: "Categoria was successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @categoria.destroy!

    respond_to do |format|
      format.html { redirect_to categorias_path, notice: "Categoria was successfully destroyed.", status: :see_other }
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
