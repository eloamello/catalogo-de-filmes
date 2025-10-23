class FilmeIaService
  def initialize(titulo)
    @titulo = titulo
  end

  def buscar_dados
    chat = RubyLLM.chat(model: "gemini-2.5-flash")
    resposta = chat.ask(prompt)
    JSON.parse(resposta.content)
  rescue JSON::ParserError, StandardError => e
    raise "Erro ao buscar dados do filme: #{e.message}"
  end

  private

  def prompt
    <<~PROMPT
      Quero os dados do filme com título exato '#{@titulo}'.
      Responda APENAS O JSON com as chaves: titulo, sinopse, ano, duracao (em minutos) e diretor,
      sem formatar a resposta em markdown. Eu utilizarei a resposta para parsear o JSON.
    PROMPT
  end
end