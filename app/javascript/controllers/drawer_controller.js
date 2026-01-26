import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "backdrop", "content"]

  open(event) {
    event.preventDefault()
    const url = event.currentTarget.dataset.drawerUrlValue

    // Show backdrop
    this.backdropTarget.classList.remove("opacity-0", "pointer-events-none")

    // Slide panel in
    this.panelTarget.classList.remove("translate-x-full")
    this.panelTarget.classList.add("translate-x-0")

    // Fetch content
    this.loadContent(url)
  }

  close() {
    // Slide panel out
    this.panelTarget.classList.remove("translate-x-0")
    this.panelTarget.classList.add("translate-x-full")

    // Hide backdrop
    this.backdropTarget.classList.add("opacity-0", "pointer-events-none")
  }

  async loadContent(url) {
    try {
      this.contentTarget.innerHTML = `
        <div class="flex h-full items-center justify-center text-white">
           <i class="bi bi-arrow-clockwise animate-spin text-3xl"></i>
        </div>
      `

      const response = await fetch(url, {
        headers: { "X-Requested-With": "XMLHttpRequest" }
      })

      if (!response.ok) throw new Error("Failed to load content")

      const html = await response.text()
      this.contentTarget.innerHTML = html

    } catch (error) {
      console.error(error)
      this.contentTarget.innerHTML = `
        <div class="p-6 text-center text-red-400">
           <i class="bi bi-exclamation-triangle text-2xl mb-2 block"></i>
           Error al cargar los detalles.
        </div>
      `
    }
  }
}
