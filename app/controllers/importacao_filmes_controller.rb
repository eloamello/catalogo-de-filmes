class ImportacaoFilmesController < ApplicationController
  before_action :authenticate_usuario!

  def index
    @importacoes = current_usuario.importacao_filmes.order(created_at: :desc)
  end

  def show
    @importacao = current_usuario.importacao_filmes.find(params[:id])
  end
end