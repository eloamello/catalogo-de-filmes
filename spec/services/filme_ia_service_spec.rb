require 'rails_helper'

RSpec.describe FilmeIaService do
  let(:titulo) { "O Poderoso Chefão" }
  let(:service) { described_class.new(titulo) }

  describe "#buscar_dados" do
    let(:json_resposta) do
      {
        "titulo" => "O Poderoso Chefão",
        "sinopse" => "Mafia story",
        "ano" => 1972,
        "duracao" => 175,
        "diretor" => "Francis Ford Coppola"
      }.to_json
    end

    it "retorna os dados do filme como hash" do
      chat_double = double("Chat", ask: double(content: json_resposta))
      allow(RubyLLM).to receive(:chat).and_return(chat_double)

      resultado = service.buscar_dados
      expect(resultado).to be_a(Hash)
      expect(resultado["titulo"]).to eq("O Poderoso Chefão")
      expect(resultado["ano"]).to eq(1972)
    end

    it "levanta erro se a resposta não for JSON válido" do
      chat_double = double("Chat", ask: double(content: "texto inválido"))
      allow(RubyLLM).to receive(:chat).and_return(chat_double)

      expect { service.buscar_dados }.to raise_error(RuntimeError, /Erro ao buscar dados do filme/)
    end

    it "chama o prompt corretamente" do
      chat_double = double("Chat", ask: double(content: json_resposta))
      allow(RubyLLM).to receive(:chat).and_return(chat_double)

      prompt = service.send(:prompt)
      expect(prompt).to include(titulo)
      expect(prompt).to include("JSON")
    end
  end
end