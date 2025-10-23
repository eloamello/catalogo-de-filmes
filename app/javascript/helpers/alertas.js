import Toastify from "toastify-js"

const showFlashes = () => {
    const flashContainer = document.getElementById("toast-flash-data")
    if (!flashContainer) return

    const flashes = JSON.parse(flashContainer.textContent)
    const colors = {
        notice: "#28a745",
        alert: "#ffc107",
        error: "#dc3545"
    }

    Object.entries(flashes).forEach(([type, message]) => {
        Toastify({
            text: message,
            duration: 3000,
            close: true,
            style: {
                background: colors[type] || "#333",
                color: "#fff",
                borderRadius: "6px",
                fontWeight: "600"
            }
        }).showToast()
    })
}

document.addEventListener("turbo:load", showFlashes)
document.addEventListener("DOMContentLoaded", showFlashes)