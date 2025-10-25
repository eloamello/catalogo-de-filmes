import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
    async buscar(event) {
        const botao = event.currentTarget
        const textoOriginal = botao.innerHTML
        const errorText = botao.dataset.errorSearchByAi

        botao.disabled = true
        botao.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>'

        const titulo = document.querySelector("#filme_titulo").value

        try {
            const response = await fetch("/filmes/buscar_por_ia", {
                method: "POST",
                headers: {
                    "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ titulo: titulo })
            })

            if (response.ok) {
                const data = await response.json()
                if (data.filme) {
                    Object.keys(data.filme).forEach(key => {
                        document.querySelector(`#filme_${key}`).value = data.filme[key] || ""
                    })
                }
            } else {
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