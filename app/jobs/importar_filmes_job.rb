class ImportarFilmesJob
  include Sidekiq::Job

  def perform(importacao_filme_id)
    importacao_filme = ImportacaoFilme.find(importacao_filme_id)
    usuario = importacao_filme.usuario
    begin
      filmes_array = ImportadorCsv.ler_e_validar(importacao_filme.arquivo)

      filmes_array.each do |linha|
        usuario.filmes.create!(
          titulo: linha["titulo"],
          sinopse: linha["sinopse"],
          ano: linha["ano"],
          duracao: linha["duracao"],
          diretor: linha["diretor"]
        )
      end

      importacao_filme.update(status: :concluido)
      importacao_filme.arquivo.purge_later

      ImportacaoFilmeMailer.with(usuario: usuario, importacao_filme: importacao_filme)
                           .importacao_finalizada
                           .deliver_later
    rescue StandardError => e
      importacao_filme.update(status: :erro)
      Rails.logger.error e
    end
  end
end