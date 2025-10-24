require "rails_helper"

RSpec.describe ImportadorFilmesCsv do
  let(:csv_valido) do
    <<~CSV
      titulo,sinopse,ano,duracao,diretor
      O Poderoso Chefão,Um clássico do cinema,1972,175,Francis Ford Coppola
      Pulp Fiction,História de mafiosos,1994,154,Quentin Tarantino
    CSV
  end

  let(:csv_invalido) do
    <<~CSV
      nome,sinopse,ano,duracao,diretor
      O Poderoso Chefão,Um clássico do cinema,1972,175,Francis Ford Coppola
    CSV
  end

  describe ".ler_e_validar" do
    it "retorna um array de hashes para um CSV válido" do
      arquivo_mock = double("ArquivoAttached", download: csv_valido)
      resultado = described_class.ler_e_validar(arquivo_mock)

      expect(resultado).to be_an(Array)
      expect(resultado.size).to eq(2)
      expect(resultado.first["titulo"]).to eq("O Poderoso Chefão")
    end

    it "levanta erro se o CSV tiver headers inválidos" do
      arquivo_mock = double("ArquivoAttached", download: csv_invalido)

      expect {
        described_class.ler_e_validar(arquivo_mock)
      }.to raise_error("CSV inválido")
    end

    it "trata headers com espaços e capitalização" do
      csv_espaco = <<~CSV
        Titulo , Sinopse , Ano , Duracao , Diretor
        O Poderoso Chefão,Um clássico do cinema,1972,175,Francis Ford Coppola
      CSV

      arquivo_mock = double("ArquivoAttached", download: csv_espaco)
      resultado = described_class.ler_e_validar(arquivo_mock)

      expect(resultado.first["titulo"]).to eq("O Poderoso Chefão")
    end
  end
end
