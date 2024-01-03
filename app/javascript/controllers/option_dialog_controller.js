import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialogButton", "optionsDialog"]

  show() {
    this.toggleDialog(true)
  }

  hide() {
    this.toggleDialog(false)
  }

  toggleDialog(show) {
    const { dialogButton, optionsDialog } = this

    if (show) {
      dialogButton.classList.add("hidden")
      optionsDialog.classList.remove("hidden")
    } else {
      dialogButton.classList.remove("hidden")
      optionsDialog.classList.add("hidden")
    }
  }

  get dialogButton() {
    return this.dialogButtonTarget
  }

  get optionsDialog() {
    return this.optionsDialogTarget
  }
}
