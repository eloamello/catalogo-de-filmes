class FilmesController < ApplicationController
  before_action :set_filme, only: %i[ show edit update destroy ]
  before_action :authenticate_usuario!, except: [:index, :show]
  before_action :authorize_usuario!, only: [:edit, :update, :destroy]

  def index
    @filmes = Filme.order(ano: :desc, titulo: :asc).paginate(page: params[:page], per_page: 6)
  end

  def show
  end

  def new
    @filme = Filme.new
  end

  def edit
  end

  def create
    @filme = current_usuario.filmes.build(filme_params)

    respond_to do |format|
      if @filme.save
        format.html { redirect_to @filme, notice: "Filme was successfully created." }
        format.json { render :show, status: :created, location: @filme }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @filme.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @filme.update(filme_params)
        format.html { redirect_to @filme, notice: "Filme was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @filme }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @filme.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @filme.destroy!

    respond_to do |format|
      format.html { redirect_to filmes_path, notice: "Filme was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def importar
    arquivo = params[:arquivo]
    return redirect_to filmes_path, alert: "Nenhum arquivo enviado." if arquivo.nil?

    @importacao_filme = current_usuario.importacao_filmes.build(arquivo: arquivo)
    if @importacao_filme.save
      ImportarFilmesJob.perform_async(@importacao_filme.id)
      redirect_to filmes_path, notice: "Importação iniciada!"
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @importacao_filme.errors, status: :unprocessable_entity }
    end
  end

  private
    def authorize_usuario!
      redirect_to filmes_path, alert: "Você não pode alterar este filme." unless @filme.usuario == current_usuario
    end

    def set_filme
      @filme = Filme.find(params.expect(:id))
    end

    def filme_params
      params.require(:filme).permit(:titulo, :sinopse, :ano, :duracao, :diretor, :poster)
    end
end
