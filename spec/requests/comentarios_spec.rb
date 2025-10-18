require 'rails_helper'

RSpec.describe "Comentarios", type: :request do
  describe "GET /comentarios" do
    it "retorna uma lista de comentarios" do
      create_list(:comentario, 1)
      create(:comentario, nome_visitante: "", conteudo: "comentario teste 1")
      create(:comentario, nome_visitante: "visitante", conteudo: "comentario teste 2")

      get '/comentarios'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("comentario teste 1")
      expect(response.body).to include("comentario teste 1")
      expect(response.body).to include("Muad Dib")
    end
  end

  describe "GET /comentarios/:id" do
    it "retorna um comentario" do
      comentario = create(:comentario)
      get "/comentarios/#{comentario.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Muad Dib")
    end
  end

  describe "POST /comentarios" do
    it "cria um comentario com sucesso" do
      filme = create(:filme)
      post "/comentarios", params: { comentario: attributes_for(:comentario).merge(filme_id: filme.id) }
      expect(response).to have_http_status(:found)
    end

    it "retorna erro quando inválido" do
      filme = create(:filme)
      post "/comentarios", params: { comentario: { filme_id: filme.id, nome_visitante:"", conteudo:"" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /comentarios/:id" do
    it "atualiza um comentario com sucesso" do
      comentario = create(:comentario)
      patch "/comentarios/#{comentario.id}", params: {
        comentario: {
          filme_id: comentario.filme.id,
          nome_visitante: "Novo nome",
          conteudo: "Novo conteudo",
        }
      }
      expect(response).to have_http_status(:see_other)
      expect(comentario.reload.conteudo).to eq("Novo conteudo")
    end

    it "retorna erro quando inválido" do
      comentario = create(:comentario)
      patch "/comentarios/#{comentario.id}", params: {
        comentario: {
          filme_id: comentario.filme.id,
          nome_visitante: "Novo nome",
          conteudo: "",
        }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /comentarios/:id" do
    it "remove um comentario com sucesso" do
      comentario = create(:comentario)
      delete "/comentarios/#{comentario.id}"
      expect(response).to have_http_status(:see_other)
    end
  end
end
