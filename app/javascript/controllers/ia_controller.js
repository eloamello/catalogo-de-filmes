import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
    async buscar() {
        const botao = event.currentTarget
        const textoOriginal = botao.innerHTML
        const errorText = botao.dataset.errorSearchByAi

        botao.disabled = true
        botao.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Buscando...'

        const titulo = document.querySelector("#filme_titulo").value

        try {
            const response = await fetch("/filmes/buscar_por_ia", {
                method: "POST",
                headers: {
                    "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
                    "Accept": "text/vnd.turbo-stream.html, application/json",
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ titulo: titulo })
            })

            if (response.ok && response.headers.get("Content-Type")?.includes("text/vnd.turbo-stream.html")) {
                const html = await response.text()
                Turbo.renderStreamMessage(html)
            } else if (!response.ok) {
                const data = await response.json()
                Swal.fire({
                    icon: "warning",
                    title: "Ops!",
                    text: data.alerta,
                    confirmButtonColor: "#3085d6"
                })
            }

        } catch (error) {
            Swal.fire({
                icon: "error",
                title: "Erro",
                text: errorText,
                confirmButtonColor: "#d33"
            })
        } finally {
            botao.disabled = false
            botao.innerHTML = textoOriginal
        }
    }
}