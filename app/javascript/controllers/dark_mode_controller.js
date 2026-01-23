import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    this.updateTheme()
  }

  toggle() {
    if (document.documentElement.classList.contains('dark')) {
      localStorage.theme = 'light'
      document.documentElement.classList.remove('dark')
    } else {
      localStorage.theme = 'dark'
      document.documentElement.classList.add('dark')
    }
    this.updateIcon()
  }

  updateTheme() {
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
    this.updateIcon()
  }

  updateIcon() {
    if (this.hasIconTarget) {
      this.iconTarget.textContent = document.documentElement.classList.contains('dark') ? 'light_mode' : 'dark_mode'
    }
  }
}
