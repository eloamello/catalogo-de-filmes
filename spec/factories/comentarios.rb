FactoryBot.define do
  factory :comentario do
    filme
    usuario
    nome_visitante { "Muad Dib" }
    conteudo { "Aquele que controla a especiaria, controla o universo." }
  end
end
