import TomSelect from "tom-select";

["turbo:load", "turbo:render", "turbo:frame-render"].forEach(eventName => {
    document.addEventListener(eventName, () => {
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
    })
})