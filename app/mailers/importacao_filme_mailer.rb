class ImportacaoFilmeMailer < ApplicationMailer
  def importacao_finalizada
    @usuario = params[:usuario]
    @importacao_filme = params[:importacao_filme]

    mail(
      to: @usuario.email,
      subject: "Sua importação foi finalizada!"
    )
  end
end
