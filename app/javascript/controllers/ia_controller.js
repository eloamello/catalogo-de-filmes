import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    async buscar() {
        const botao = event.currentTarget
        const textoOriginal = botao.innerHTML

        botao.disabled = true
        botao.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Buscando...'

        try {
            const response = await fetch("/filmes/buscar_por_ia", {
                method: "POST",
                headers: {
                    "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
                    "Accept": "text/vnd.turbo-stream.html"
                }
            })

            const html = await response.text()
            Turbo.renderStreamMessage(html)
        } catch (error) {
            alert('Erro ao buscar dados do filme. Tente novamente.')
        } finally {
            botao.disabled = false
            botao.innerHTML = textoOriginal
        }
    }
}