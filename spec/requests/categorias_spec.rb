require 'rails_helper'

RSpec.describe "Categorias", type: :request do
  let(:usuario) { create(:usuario) }
  let(:categoria) { create(:categoria, nome: "Drama") }

  describe "GET /categorias" do
    it "retorna a lista de categorias" do
      sign_in usuario
      categoria
      get categorias_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Drama")
    end
  end

  describe "GET /categorias/new" do
    it "retorna a página de nova categoria" do
      sign_in usuario
      get new_categoria_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /categorias" do
    it "cria uma nova categoria" do
      sign_in usuario
      expect {
        post categorias_path, params: { categoria: { nome: "Comédia" } }
      }.to change(Categoria, :count).by(1)
      expect(response).to redirect_to(categorias_path)
    end

    it "não cria duplicada se já existir" do
      sign_in usuario
      categoria
      expect {
        post categorias_path, params: { categoria: { nome: "Drama" } }
      }.not_to change(Categoria, :count)
      expect(response).to redirect_to(categorias_path)
    end
  end

  describe "GET /categorias/:id/edit" do
    it "retorna a página de edição" do
      sign_in usuario
      get edit_categoria_path(categoria)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /categorias/:id" do
    it "atualiza uma categoria com sucesso" do
      sign_in usuario
      patch categoria_path(categoria), params: { categoria: { nome: "Suspense" } }
      expect(response).to redirect_to(categorias_path)
      expect(categoria.reload.nome).to eq("Suspense")
    end

    it "retorna erro quando inválido" do
      sign_in usuario
      patch categoria_path(categoria), params: { categoria: { nome: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /categorias/:id" do
    it "remove uma categoria" do
      sign_in usuario
      categoria
      expect {
        delete categoria_path(categoria)
      }.to change(Categoria, :count).by(-1)
      expect(response).to redirect_to(categorias_path)
    end
  end
end
