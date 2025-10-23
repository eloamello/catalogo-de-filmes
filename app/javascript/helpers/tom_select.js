import TomSelect from "tom-select";

document.addEventListener("turbo:load", () => {
    document.querySelectorAll(".tom-select").forEach((el) => {
        if (!el.classList.contains("ts-loaded")) {
            new TomSelect(el, {
                plugins: ["remove_button"],
                create: false,
                persist: false
            });

            el.classList.add("ts-loaded");
        }
    });
});
