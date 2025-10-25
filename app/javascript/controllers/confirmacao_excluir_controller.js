import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
    ask(event) {
        const button = event.currentTarget
        const url = button.dataset.url

        Swal.fire({
            title: button.dataset.i18nTitle,
            text: button.dataset.i18nText,
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: button.dataset.i18nConfirm,
            cancelButtonText: button.dataset.i18nCancel,
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement("form")
                form.action = url
                form.method = "post"
                form.innerHTML = `
        <input type="hidden" name="_method" value="delete">
        <input type="hidden" name="authenticity_token" value="${document.querySelector('meta[name=csrf-token]').content}">
      `
                document.body.appendChild(form)
                form.submit()
            }
        })
    }
}
