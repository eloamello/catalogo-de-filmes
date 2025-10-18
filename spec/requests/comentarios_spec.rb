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
      sign_in create(:usuario)
      filme = create(:filme)

      expect {
        post "/comentarios", params: { comentario: attributes_for(:comentario).merge(filme_id: filme.id) }
      }.to change { Comentario.count }.by(1)

      expect(response).to have_http_status(:found)
    end

    it "cria comentário com sucesso sem usuário" do
      filme = create(:filme)
      expect {
        post "/comentarios", params: { comentario: { filme_id: filme.id, nome_visitante: "Visitante", conteudo: "comentario do visitante" } }
      }.to change { Comentario.count }.by(1)

      expect(response).to have_http_status(:found)
    end

    it "retorna erro quando inválido" do
      sign_in create(:usuario)
      filme = create(:filme)
      post "/comentarios", params: { comentario: { filme_id: filme.id, nome_visitante:"", conteudo:"" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "retorna erro quando deslogado e sem nome_visitante" do
      filme = create(:filme)
      expect {
        post "/comentarios", params: { comentario: { filme_id: filme.id, nome_visitante: "", conteudo: "comentario do visitante" } }
      }.to change { Comentario.count }.by(0)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /comentarios/:id" do
    it "atualiza comentario do usuario com sucesso" do
      comentario = create(:comentario)
      sign_in comentario.usuario
      patch "/comentarios/#{comentario.id}", params: {
        comentario: {
          filme_id: comentario.filme.id,
          nome_visitante: "Novo nome",
          conteudo: "Novo conteudo"
        }
      }
      expect(response).to have_http_status(:see_other)
      expect(comentario.reload.conteudo).to eq("Novo conteudo")
    end

    it "retorna erro quando inválido" do
      comentario = create(:comentario)
      sign_in comentario.usuario

      patch "/comentarios/#{comentario.id}", params: {
        comentario: {
          filme_id: comentario.filme.id,
          nome_visitante: "Novo nome",
          conteudo: ""
        }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "redireciona quando deslogado" do
      comentario = create(:comentario)

      patch "/comentarios/#{comentario.id}", params: {
        comentario: {
          filme_id: comentario.filme.id,
          nome_visitante: "Novo nome",
          conteudo: "conteudo"
        }
      }

      expect(response).to redirect_to(new_usuario_session_path)
      expect(response).to have_http_status(:found)
    end

    it "retorna erro se usuario não é dono do comentario" do
      comentario = create(:comentario)
      sign_in create(:usuario)

      patch "/comentarios/#{comentario.id}", params: {
        comentario: {
          filme_id: comentario.filme.id,
          nome_visitante: "Novo nome",
          conteudo: "conteudo"
        }
      }

      expect(flash[:alert]).to eq("Você não pode alterar este comentário.")
      expect(comentario.reload.conteudo).to eq("Aquele que controla a especiaria, controla o universo.")
      expect(response).to have_http_status(:found)
    end
  end

  describe "DELETE /comentarios/:id" do
    it "remove um comentario com sucesso" do
      comentario = create(:comentario)
      sign_in comentario.usuario
      delete "/comentarios/#{comentario.id}"
      expect(response).to have_http_status(:see_other)
    end

    it "redireciona quando deslogado" do
      comentario = create(:comentario)
      delete "/comentarios/#{comentario.id}"
      expect(response).to redirect_to(new_usuario_session_path)
      expect(response).to have_http_status(:found)
    end

    it "retorna erro se usuario não é dono do comentario" do
      comentario = create(:comentario)
      sign_in create(:usuario)
      delete "/comentarios/#{comentario.id}"
      expect(flash[:alert]).to eq("Você não pode alterar este comentário.")
      expect(comentario.reload.conteudo).to eq("Aquele que controla a especiaria, controla o universo.")
      expect(response).to have_http_status(:found)
    end
  end
end
