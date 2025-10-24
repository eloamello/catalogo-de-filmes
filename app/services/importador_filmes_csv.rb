require "csv"

class ImportadorFilmesCsv
  def self.ler_e_validar(arquivo_attached)
    csv_text = arquivo_attached.download.force_encoding("utf-8")
    csv = CSV.parse(csv_text, headers: true, col_sep: ",")

    headers_validos = %w[titulo sinopse ano duracao diretor]
    csv_headers_normalizados = csv.headers.map { |h| h.strip.downcase }

    raise "CSV inválido" unless (headers_validos - csv_headers_normalizados).empty?

    csv.map do |row|
      row.to_h.transform_keys { |k| k.strip.downcase }
    end
  end
end