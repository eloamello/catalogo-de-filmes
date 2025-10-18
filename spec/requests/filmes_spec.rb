require 'rails_helper'

RSpec.describe "Filmes", type: :request do
  describe "GET /filmes" do
    it "retorna uma lista de filmes" do
      create_list(:filme, 1)
      create(:filme, titulo: "A Lista de Schindler", sinopse: "sinopse teste", ano: 1993, duracao: 195, diretor: "Steven Spielberg")
      create(:filme, titulo: "Um Sonho de Liberdade", sinopse: "sinopse teste", ano: 1995, duracao: 142, diretor: "Frank Darabont")

      get '/filmes'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("O Poderoso Chefão")
      expect(response.body).to include("A Lista de Schindler")
      expect(response.body).to include("Um Sonho de Liberdade")
    end
  end

  describe "GET /filmes/:id" do
    it "retorna um filme" do
      filme = create(:filme)
      get "/filmes/#{filme.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("O Poderoso Chefão")
    end
  end

  describe "POST /filmes" do
    it "cria um filme com sucesso" do
      post "/filmes", params: { filme: attributes_for(:filme) }
      expect(response).to have_http_status(:found)
    end

    it "retorna erro quando inválido" do
      post "/filmes", params: { filme: { titulo: "", sinopse: "", ano: 1998, duracao: 115, diretor: "Frank Darabont" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /filmes/:id" do
    it "atualiza um filme com sucesso" do
      filme = create(:filme)
      patch "/filmes/#{filme.id}", params: {
        filme: {
          titulo: "Novo Título",
          sinopse: filme.sinopse,
          ano: filme.ano,
          duracao: filme.duracao,
          diretor: filme.diretor
        }
      }
      expect(response).to have_http_status(:see_other)
      expect(filme.reload.titulo).to eq("Novo Título")
    end

    it "retorna erro quando inválido" do
      filme = create(:filme)
      patch "/filmes/#{filme.id}", params: {
        filme: {
          titulo: "",
          sinopse: filme.sinopse,
          ano: filme.ano,
          duracao: filme.duracao,
          diretor: filme.diretor
        }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /filmes/:id" do
    it "remove um filme com sucesso" do
      filme = create(:filme)
      delete "/filmes/#{filme.id}"
      expect(response).to have_http_status(:see_other)
    end
  end
end
