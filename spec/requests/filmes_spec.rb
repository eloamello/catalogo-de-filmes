require 'rails_helper'

RSpec.describe "Filmes", type: :request do

  describe "GET /filmes" do
    it "retorna uma lista de filmes" do
      filme = create(:filme)
      create(:filme, usuario: filme.usuario, titulo: "A Lista de Schindler", sinopse: "sinopse teste", ano: 1993, duracao: 195, diretor: "Steven Spielberg")
      create(:filme, usuario: filme.usuario, titulo: "Um Sonho de Liberdade", sinopse: "sinopse teste", ano: 1995, duracao: 142, diretor: "Frank Darabont")

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
      sign_in create(:usuario)

      expect {
        post "/filmes", params: { filme: attributes_for(:filme) }
      }.to change(Filme, :count).by(1)

      expect(response).to have_http_status(:found)
    end

    it "retorna erro quando inválido" do
      sign_in create(:usuario)
      post "/filmes", params: { filme: { titulo: "", sinopse: "", ano: 1998, duracao: 115, diretor: "Frank Darabont" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "redireciona se usuario deslogado" do
      post "/filmes", params: { filme: { titulo: "", sinopse: "", ano: 1998, duracao: 115, diretor: "Frank Darabont" } }
      expect(response).to redirect_to(new_usuario_session_path)
      expect(response).to have_http_status(:found)
    end
  end

  describe "PATCH /filmes/:id" do
    it "atualiza um filme com sucesso" do
      filme = create(:filme)
      sign_in filme.usuario

      patch "/filmes/#{filme.id}", params: {
        filme: {
          titulo: "Novo Título",
          sinopse: filme.sinopse,
          ano: filme.ano,
          duracao: filme.duracao,
          diretor: filme.diretor
        }
      }
      expect(response).to have_http_status(:found)
      expect(filme.reload.titulo).to eq("Novo Título")
    end

    it "retorna erro quando inválido" do
      filme = create(:filme)
      sign_in filme.usuario

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

    it "retorna erro se usuario não cadastrou o filme" do
      filme = create(:filme)
      sign_in create(:usuario)

      patch "/filmes/#{filme.id}", params: {
        filme: {
          titulo: "Novo Título",
          sinopse: filme.sinopse,
          ano: filme.ano,
          duracao: filme.duracao,
          diretor: filme.diretor
        }
      }

      expect(flash[:alert]).to eq("Você não pode alterar este filme.")
      expect(filme.reload.titulo).to eq("O Poderoso Chefão")
      expect(response).to have_http_status(:found)
    end
  end

  describe "DELETE /filmes/:id" do
    it "remove um filme com sucesso" do
      filme = create(:filme)
      sign_in filme.usuario

      delete "/filmes/#{filme.id}"
      expect(response).to have_http_status(:found)
    end

    it "redireciona quando deslogado" do
      filme = create(:filme)
      delete "/filmes/#{filme.id}"
      expect(response).to redirect_to(new_usuario_session_path)
      expect(response).to have_http_status(:found)
    end

    it "retorna erro se usuario não cadastrou o filme" do
      filme = create(:filme)
      sign_in create(:usuario)
      delete "/filmes/#{filme.id}"
      expect(flash[:alert]).to eq("Você não pode apagar este filme.")
      expect(filme.reload.titulo).to eq("O Poderoso Chefão")
      expect(response).to have_http_status(:found)
    end
  end

  describe "POST /filmes/importar" do
    let(:usuario) { create(:usuario) }

    before { sign_in usuario }

    it "inicia a importação com arquivo enviado" do
      arquivo = fixture_file_upload('filmes.csv', 'text/csv')

      allow(ImportarFilmesJob).to receive(:perform_async)

      expect {
        post importacao_filmes_path, params: { arquivo: arquivo }
      }.to change { ImportacaoFilme.count }.by(1)

      expect(response).to redirect_to(importacao_filmes_path)
      expect(flash[:notice]).to eq("Importação de filmes iniciada com sucesso.")
    end


    it "retorna alerta quando não envia arquivo" do
      post importacao_filmes_path
      expect(response).to redirect_to(filmes_path)
      expect(flash[:alert]).to eq("Nenhum arquivo enviado para importação.")
    end
  end

  describe "POST /filmes/buscar_por_ia" do
    let(:usuario) { create(:usuario) }

    before { sign_in usuario }

    it "renderiza o partial com dados retornados da IA" do
      fake_dados = {
        titulo: "Filme IA",
        sinopse: "Sinopse gerada",
        ano: 2023,
        duracao: 120,
        diretor: "Diretor IA"
      }
      allow_any_instance_of(FilmeIaService).to receive(:buscar_dados).and_return(fake_dados)

      post buscar_por_ia_filmes_path, params: { titulo: "Algum Filme" }

      expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
      expect(response.body).to include("Filme IA")
    end

    it "renderiza o partial vazio quando serviço IA retorna nil" do
      allow_any_instance_of(FilmeIaService).to receive(:buscar_dados).and_return(nil)

      post buscar_por_ia_filmes_path, params: { titulo: "Filme Inexistente" }

      expect(response.body).to include("form_filme") # o id do form atualizado
    end
  end

end
