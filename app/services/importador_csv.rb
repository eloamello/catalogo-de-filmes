require "csv"

class ImportadorCsv
  def self.ler_e_validar(arquivo_attached)
    csv_text = arquivo_attached.download.force_encoding("utf-8")

    csv = CSV.parse(csv_text, headers: true, col_sep: ",")

    headers_validos = ["titulo", "sinopse", "ano", "duracao", "diretor"]
    csv_headers_normalizados = csv.headers.map { |h| h.strip.downcase }

    raise "CSV inválido" unless (headers_validos - csv_headers_normalizados).empty?

    csv.map(&:to_h)
  end
end