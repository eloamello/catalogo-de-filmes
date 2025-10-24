FactoryBot.define do
  factory :importacao_filme do
    usuario
    status { :em_andamento }
    after(:build) do |importacao|
      importacao.arquivo.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/filmes.csv")),
        filename: 'filmes.csv',
        content_type: 'text/csv'
      )
    end
  end
end
