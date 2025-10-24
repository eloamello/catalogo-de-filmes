require 'rails_helper'

RSpec.describe ImportarFilmesJob, type: :job do
  let(:usuario) { create(:usuario) }
  let(:importacao_filme) { create(:importacao_filme, usuario: usuario) }

  describe '#perform' do
    context 'quando a importação é bem-sucedida' do
      it 'importa os filmes e finaliza corretamente' do
        expect {
          described_class.new.perform(importacao_filme.id)
        }.to change { usuario.filmes.count }.by(2)

        importacao_filme.reload
        expect(importacao_filme.status).to eq('concluido')

        filme = usuario.filmes.find_by(titulo: 'O Poderoso Chefão')
        expect(filme).to be_present
        expect(filme.diretor).to eq('Francis Ford Coppola')
      end
    end

    context 'quando ocorre um erro' do
      before do
        allow(ImportadorFilmesCsv).to receive(:ler_e_validar).and_raise(StandardError.new('CSV inválido'))
      end

      it 'marca a importação como erro' do
        expect {
          described_class.new.perform(importacao_filme.id)
        }.not_to change { usuario.filmes.count }

        importacao_filme.reload
        expect(importacao_filme.status).to eq('erro')
      end
    end

    context 'quando a importação não existe' do
      it 'levanta erro' do
        expect {
          described_class.new.perform(999999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end