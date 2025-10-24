class FilmesController < ApplicationController
  before_action :set_filme, only: %i[ show edit update destroy ]
  before_action :authenticate_usuario!, except: [ :index, :show ]
  before_action :authorize_usuario!, only: [ :edit, :update, :destroy ]

  def index
    @q = Filme.ransack(params[:q])
    @filmes = @q.result(distinct: true)
                .order(ano: :desc, titulo: :asc)
                .paginate(page: params[:page], per_page: 6)

    @categorias = Categoria.joins(:filmes).distinct.select(:id, :nome).order(:nome)
    @diretores = Filme.distinct.pluck(:diretor).compact.sort
    @anos = Filme.distinct.pluck(:ano).compact.sort.reverse
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
        format.html { redirect_to @filme, notice: "Filme criado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @filme.update(filme_params)
        format.html { redirect_to @filme, notice: "Filme atualizado com sucesso.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @filme.destroy!

    respond_to do |format|
      format.html { redirect_to filmes_path, notice: "Filme was successfully destroyed.", status: :see_other }
    end
  end

  def importar
    arquivo = params[:arquivo]
    return redirect_to filmes_path, alert: "Nenhum arquivo enviado." if arquivo.nil?

    @importacao_filme = current_usuario.importacao_filmes.build(arquivo: arquivo)
    if @importacao_filme.save
      ImportarFilmesJob.perform_async(@importacao_filme.id)
      redirect_to importacao_filmes_path, notice: "Importação iniciada!"
    else
      redirect_to filmes_path, alert: @importacao_filme.errors.full_messages.join(", ")
    end
  end

  def buscar_por_ia
    titulo = params[:titulo]

    dados = FilmeIaService.new(titulo).buscar_dados

    @filme = dados ? Filme.new(dados) : Filme.new

    render turbo_stream: turbo_stream.update(
      "form_filme",
      partial: "filmes/form",
      locals: { filme: @filme }
    )
  end

  private
    def authorize_usuario!
      redirect_to filmes_path, alert: "Você não pode alterar este filme." unless @filme.usuario == current_usuario
    end

    def set_filme
      @filme = Filme.find(params.expect(:id))
    end

    def filme_params
      params.require(:filme).permit(:titulo, :sinopse, :ano, :duracao, :diretor, :poster, :tags_texto, categoria_ids: [])
    end
end
