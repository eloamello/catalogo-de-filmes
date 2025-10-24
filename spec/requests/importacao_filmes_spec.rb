require 'rails_helper'

RSpec.describe "ImportacaoFilmes", type: :request do
  let(:usuario) { create(:usuario) }
  let(:arquivo) { fixture_file_upload(Rails.root.join("spec/fixtures/filmes.csv"), "text/csv") }
  let!(:importacao) { create(:importacao_filme, usuario: usuario, arquivo: arquivo, status: :concluido) }

  describe "GET /importacao_filmes" do
    it "lista as importações do usuário logado" do
      sign_in usuario
      get importacao_filmes_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(importacao.id.to_s)
      expect(response.body).to include("Concluído")
    end

    it "redireciona se não estiver logado" do
      get importacao_filmes_path
      expect(response).to redirect_to(new_usuario_session_path)
      expect(response).to have_http_status(:found)
    end
  end
end
