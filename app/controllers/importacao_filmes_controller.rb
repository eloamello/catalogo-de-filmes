class ImportacaoFilmesController < ApplicationController
  before_action :authenticate_usuario!

  def index
    @importacoes = current_usuario.importacao_filmes.order(created_at: :desc)
  end

  def create
    arquivo = params[:arquivo]
    return redirect_to filmes_path, alert: t(".no_file") if arquivo.nil?

    @importacao_filme = current_usuario.importacao_filmes.build(arquivo: arquivo)
    if @importacao_filme.save
      ImportarFilmesJob.perform_async(@importacao_filme.id)
      redirect_to importacao_filmes_path, notice: t(".success")
    else
      redirect_to filmes_path, alert: t(".failure")
    end
  end
end
