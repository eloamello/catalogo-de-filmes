class FilmesController < ApplicationController
  before_action :set_filme, only: %i[ show edit update destroy ]
  before_action :authenticate_usuario!, except: [ :index, :show ]
  before_action :authorize_usuario!, only: [ :edit, :update, :destroy ]

  def index
    filmes = Filme.all

    categoria_ids = Array(params.dig(:q, :categorias_id_in)).reject(&:blank?)
    filmes = filmes.por_categorias(categoria_ids) if categoria_ids.any?

    q_params = params[:q] ? params[:q].except(:categorias_id_in) : {}
    @q = filmes.ransack(q_params)

    @filmes = @q.result(distinct: true)
                .order(ano: :desc, titulo: :asc)
                .paginate(page: params[:page], per_page: 6)

    @categorias = Categoria.joins(:filmes).distinct.select(:id, :nome).order(:nome)
    @diretores  = Filme.distinct.pluck(:diretor)
    @anos       = Filme.distinct.pluck(:ano)
  end

  def show
  end

  def new
    @filme = Filme.new
  end

  def edit
  end

  def create
    @filme = current_usuario.filmes.build(filme_params.except(:tags))

    tags_string = filme_params[:tags]
    if tags_string.present?
      tags_array = tags_string.split(" ").map(&:strip).reject(&:blank?)

      tags_array.each do |tag_nome|
        @filme.tags.build(nome: tag_nome)
      end
    end

    respond_to do |format|
      if @filme.save
        format.html { redirect_to @filme, notice: "Filme was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    update_params = filme_params.except(:tags)

    @filme.tags = filme_params[:tags].split(" ").map(&:strip).reject(&:blank?).each do |tag_nome|
      @filme.tags.build(nome: tag_nome)
    end

    respond_to do |format|
      if @filme.update(update_params)
        format.html { redirect_to @filme, notice: "Filme was successfully updated.", status: :see_other }
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
      params.require(:filme).permit(:titulo, :sinopse, :ano, :duracao, :diretor, :poster, :tags, categoria_ids: [])
    end
end
