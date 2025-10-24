puts "Limpando banco de dados..."
Comentario.destroy_all
Filme.destroy_all
Categoria.destroy_all
Tag.destroy_all
ImportacaoFilme.destroy_all
Usuario.destroy_all

puts "Criando usuários..."
admin = Usuario.create!(
  nome: "Admin",
  email: "admin@gmail.com",
  password: "senha123",
  password_confirmation: "senha123",
  funcao: :administrador
)

usuarios = [
  Usuario.create!(
    nome: "Eloá Mello",
    email: "eloa@gmail.com",
    password: "senha123",
    password_confirmation: "senha123",
    funcao: :administrador
  ),
  Usuario.create!(
    nome: "Maria Oliveira",
    email: "maria@gmail.com",
    password: "senha123",
    password_confirmation: "senha123",
    funcao: :usuario
  ),
  Usuario.create!(
    nome: "Carlos Mendes",
    email: "carlos@gmail.com",
    password: "senha123",
    password_confirmation: "senha123",
    funcao: :usuario
  )
]

puts "#{Usuario.count} usuários criados!"

puts "Criando categorias..."
categorias = {
  acao: Categoria.create!(nome: "Ação"),
  drama: Categoria.create!(nome: "Drama"),
  comedia: Categoria.create!(nome: "Comédia"),
  ficcao: Categoria.create!(nome: "Ficção Científica"),
  terror: Categoria.create!(nome: "Terror"),
  suspense: Categoria.create!(nome: "Suspense"),
  romance: Categoria.create!(nome: "Romance"),
  animacao: Categoria.create!(nome: "Animação"),
  aventura: Categoria.create!(nome: "Aventura"),
  crime: Categoria.create!(nome: "Crime")
}

puts "#{Categoria.count} categorias criadas!"

puts "Criando filmes..."

filmes_data = [
  {
    titulo: "A Origem",
    sinopse: "Dom Cobb é um ladrão especializado em extrair segredos do subconsciente durante o sono. Quando recebe a chance de ter sua vida de volta, ele precisa fazer o impossível: realizar uma 'inception', plantar uma ideia na mente de alguém.",
    ano: 2010,
    duracao: 148,
    diretor: "Christopher Nolan",
    categorias: [categorias[:acao], categorias[:ficcao], categorias[:suspense]],
    tags: "sonhos realidade subconsiente thriller"
  },
  {
    titulo: "O Poderoso Chefão",
    sinopse: "A família Corleone é uma das mais poderosas famílias do crime organizado em Nova York. Quando o patriarca tenta se afastar dos negócios, seu filho mais novo é forçado a assumir o comando.",
    ano: 1972,
    duracao: 175,
    diretor: "Francis Ford Coppola",
    categorias: [categorias[:drama], categorias[:crime]],
    tags: "máfia familia poder traição"
  },
  {
    titulo: "Pulp Fiction",
    sinopse: "Histórias entrelaçadas de criminosos, boxeadores e gangsters em Los Angeles. Um clássico que revolucionou o cinema com sua narrativa não-linear e diálogos memoráveis.",
    ano: 1994,
    duracao: 154,
    diretor: "Quentin Tarantino",
    categorias: [categorias[:crime], categorias[:drama]],
    tags: "cultmovie nonlinear gangster violence"
  },
  {
    titulo: "Parasita",
    sinopse: "A família Kim, muito pobre, se infiltra na vida da família Park, extremamente rica. O que começa como uma farsa se transforma em uma história sobre desigualdade social e suas consequências.",
    ano: 2019,
    duracao: 132,
    diretor: "Bong Joon-ho",
    categorias: [categorias[:drama], categorias[:suspense]],
    tags: "desigualdade classsocial coreia thriller"
  },
  {
    titulo: "Interestelar",
    sinopse: "Com a Terra se tornando inabitável, um grupo de exploradores viaja através de um buraco de minhoca em busca de um novo lar para a humanidade.",
    ano: 2014,
    duracao: 169,
    diretor: "Christopher Nolan",
    categorias: [categorias[:ficcao], categorias[:drama], categorias[:aventura]],
    tags: "espaço tempo buraconegro ciência"
  },
  {
    titulo: "Coringa",
    sinopse: "Arthur Fleck é um comediante fracassado que, após uma série de eventos traumáticos, se transforma no icônico vilão Coringa em uma Gotham City decadente.",
    ano: 2019,
    duracao: 122,
    diretor: "Todd Phillips",
    categorias: [categorias[:drama], categorias[:crime], categorias[:suspense]],
    tags: "psicológico sociedade vilão gotham"
  },
  {
    titulo: "Toy Story",
    sinopse: "Quando um novo brinquedo chega ao quarto de Andy, Woody precisa lidar com o ciúme e descobrir o verdadeiro significado de ser um brinquedo.",
    ano: 1995,
    duracao: 81,
    diretor: "John Lasseter",
    categorias: [categorias[:animacao], categorias[:aventura], categorias[:comedia]],
    tags: "brinquedos pixar infancia amizade"
  },
  {
    titulo: "O Iluminado",
    sinopse: "Jack Torrance aceita um emprego como zelador de inverno em um hotel isolado nas montanhas. Aos poucos, a solidão e forças sobrenaturais o levam à loucura.",
    ano: 1980,
    duracao: 146,
    diretor: "Stanley Kubrick",
    categorias: [categorias[:terror], categorias[:suspense]],
    tags: "hotel loucura sobrenatural horror"
  },
  {
    titulo: "La La Land",
    sinopse: "Mia, uma aspirante a atriz, e Sebastian, um pianista de jazz, se apaixonam enquanto perseguem seus sonhos em Los Angeles. Um musical sobre amor e ambição.",
    ano: 2016,
    duracao: 128,
    diretor: "Damien Chazelle",
    categorias: [categorias[:romance], categorias[:drama]],
    tags: "musical jazz sonhos losangeles"
  },
  {
    titulo: "Matrix",
    sinopse: "Neo descobre que a realidade é uma simulação criada por máquinas inteligentes. Ele se junta a um grupo de rebeldes para libertar a humanidade.",
    ano: 1999,
    duracao: 136,
    diretor: "Lana Wachowski, Lilly Wachowski",
    categorias: [categorias[:ficcao], categorias[:acao]],
    tags: "realidadevirtual hacker rebeldia matrix"
  },
  {
    titulo: "Clube da Luta",
    sinopse: "Um funcionário de escritório insone forma um clube de luta clandestino com um vendedor de sabonetes carismático. As coisas saem do controle rapidamente.",
    ano: 1999,
    duracao: 139,
    diretor: "David Fincher",
    categorias: [categorias[:drama], categorias[:suspense]],
    tags: "anarchismo sociedade identidade twist"
  },
  {
    titulo: "Cidade de Deus",
    sinopse: "A história de crianças e adolescentes crescendo em uma das favelas mais perigosas do Rio de Janeiro, mostrando como o crime organizado se desenvolve ao longo de décadas.",
    ano: 2002,
    duracao: 130,
    diretor: "Fernando Meirelles",
    categorias: [categorias[:crime], categorias[:drama]],
    tags: "favela riodejaneiro violencia brasil"
  },
  {
    titulo: "Divertida Mente",
    sinopse: "Dentro da mente de Riley, cinco emoções - Alegria, Tristeza, Medo, Raiva e Nojinho - trabalham juntas para guiá-la através da vida.",
    ano: 2015,
    duracao: 95,
    diretor: "Pete Docter",
    categorias: [categorias[:animacao], categorias[:aventura], categorias[:comedia]],
    tags: "emoções infancia psicologia pixar"
  },
  {
    titulo: "Vingadores: Ultimato",
    sinopse: "Após Thanos eliminar metade da vida no universo, os Vingadores sobreviventes se reúnem para uma última missão de reverter seus atos.",
    ano: 2019,
    duracao: 181,
    diretor: "Anthony Russo, Joe Russo",
    categorias: [categorias[:acao], categorias[:ficcao], categorias[:aventura]],
    tags: "marvel superherois thanos viagemdotempo"
  },
  {
    titulo: "O Silêncio dos Inocentes",
    sinopse: "A agente do FBI Clarice Starling busca a ajuda do psicopata encarcerado Dr. Hannibal Lecter para capturar outro serial killer.",
    ano: 1991,
    duracao: 118,
    diretor: "Jonathan Demme",
    categorias: [categorias[:suspense], categorias[:crime], categorias[:terror]],
    tags: "serialkiller fbi psicopata thriller"
  }
]

filmes_criados = []
filmes_data.each do |filme_data|
  tags_texto = filme_data.delete(:tags)
  categorias_filme = filme_data.delete(:categorias)

  filme = Filme.create!(
    filme_data.merge(usuario: [admin, *usuarios].sample)
  )

  filme.categorias = categorias_filme
  filme.tags_texto = tags_texto
  filme.save!

  filmes_criados << filme
end

puts "#{Filme.count} filmes criados!"
puts "#{Tag.count} tags criadas!"

puts "Criando comentários..."

comentarios_templates = [
  "Filme absolutamente incrível! A direção é impecável e a história te prende do início ao fim.",
  "Não entendi o hype, achei bem mediano. Esperava mais.",
  "Um dos melhores filmes que já vi! Recomendo muito!",
  "A fotografia é linda, mas a história é um pouco arrastada.",
  "Obra-prima! Assisti três vezes e sempre descubro algo novo.",
  "Muito bom, mas o final me deixou confuso.",
  "Atuações fantásticas! O elenco está impecável.",
  "Interessante, mas não é para todos. Requer atenção.",
  "Chorei do início ao fim. Emocionante demais!",
  "Superestimado. Tem filmes muito melhores no mesmo gênero.",
  "A trilha sonora é perfeita! Casa perfeitamente com as cenas.",
  "Roteiro brilhante! Cada diálogo importa.",
  "Vi com a família e todos adoraram. Vale muito a pena!",
  "Decepcionante. Não chegou nem perto das expectativas.",
  "Simplesmente espetacular! Uma experiência cinematográfica única."
]

nomes_visitantes = [
  "Ana Paula", "Roberto Alves", "Fernanda Costa", "Lucas Pereira",
  "Juliana Mendes", "Pedro Henrique", "Carla Santos", "Bruno Lima",
  "Patricia Souza", "Ricardo Oliveira"
]

filmes_criados.each do |filme|
  usuarios.sample(rand(1..3)).each do |usuario|
    Comentario.create!(
      filme: filme,
      usuario: usuario,
      conteudo: comentarios_templates.sample
    )
  end

  rand(0..2).times do
    Comentario.create!(
      filme: filme,
      nome_visitante: nomes_visitantes.sample,
      conteudo: comentarios_templates.sample
    )
  end
end

puts "#{Comentario.count} comentários criados!"

puts "Criando importações de exemplo..."

ImportacaoFilme.create!(
  usuario: admin,
  status: :concluido
)

ImportacaoFilme.create!(
  usuario: usuarios.first,
  status: :em_andamento
)

puts "#{ImportacaoFilme.count} importações criadas!"

puts "\n" + "="*50
puts "Seed finalizado com sucesso!"
puts "="*50
puts " Resumo:"
puts "    Usuários: #{Usuario.count}"
puts "    Categorias: #{Categoria.count}"
puts "    Filmes: #{Filme.count}"
puts "    Tags: #{Tag.count}"
puts "    Comentários: #{Comentario.count}"
puts "    Importações: #{ImportacaoFilme.count}"
puts "\n Credenciais de acesso:"
puts "   Admin: admin@cinemadb.com / senha123"
puts "   User:  joao@email.com / senha123"
puts "="*50