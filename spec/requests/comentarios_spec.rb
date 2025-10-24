require 'rails_helper'

RSpec.describe "Comentarios", type: :request do
  describe "POST /filmes/:filme_id/comentarios" do
    it "cria um comentario com sucesso" do
      sign_in create(:usuario)
      filme = create(:filme)

      expect {
        post "/filmes/#{filme.id}/comentarios", params: { comentario: attributes_for(:comentario) }
      }.to change { Comentario.count }.by(1)

      expect(response).to have_http_status(:found)
    end

    it "cria comentário com sucesso sem usuário" do
      filme = create(:filme)

      expect {
        post "/filmes/#{filme.id}/comentarios", params: { comentario: { nome_visitante: "Visitante", conteudo: "comentario do visitante" } }
      }.to change { Comentario.count }.by(1)

      expect(response).to have_http_status(:found)
    end

    it "retorna erro quando inválido" do
      sign_in create(:usuario)
      filme = create(:filme)

      post "/filmes/#{filme.id}/comentarios", params: { comentario: { nome_visitante: "", conteudo: "" } }

      expect(flash[:alert]).to eq("Não foi possível enviar seu comentário.")

      expect(response).to have_http_status(:found)
    end

    it "retorna erro quando deslogado e sem nome_visitante" do
      filme = create(:filme)

      expect {
        post "/filmes/#{filme.id}/comentarios", params: { comentario: { nome_visitante: "", conteudo: "comentario do visitante" } }
      }.not_to change { Comentario.count }

      expect(flash[:alert]).to eq("Não foi possível enviar seu comentário.")

      expect(response).to have_http_status(:found)
    end
  end
end