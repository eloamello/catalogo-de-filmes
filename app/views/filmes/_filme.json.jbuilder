json.extract! filme, :id, :titulo, :sinopse, :ano, :duracao, :diretor, :created_at, :updated_at
json.url filme_url(filme, format: :json)
