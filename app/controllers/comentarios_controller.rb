class ComentariosController < ApplicationController
  before_action :set_filme

  def create
    @comentario = @filme.comentarios.new(comentario_params)
    @comentario.usuario = current_usuario if usuario_signed_in?

    if @comentario.save
      redirect_to @filme, notice: "Comentário enviado com sucesso."
    else
      redirect_to @filme, alert: "Não foi possível enviar seu comentário."
    end
  end

  private
  def set_filme
    @filme = Filme.find(params[:filme_id])
  end

  def comentario_params
    params.require(:comentario).permit(:nome_visitante, :conteudo)
  end
end
