import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "url" ]

  copyToClipboard() {
    const textField = this.urlTarget
    textField.select()
    try {
      const succeeded = document.execCommand("copy")
      if (succeeded) {
        alert("Copied!")
      } else {
        throw new Error("Failed to copy to clipboard")
      }
    } catch (e) {
      console.error("Error copying to clipboard:", e)
      alert("Failed to copy to clipboard. Please try again.")
    } finally {
      document.getSelection().removeAllRanges()
    }
  }
}