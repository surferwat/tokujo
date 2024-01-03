import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image"]

  download() {
    const pngData = this.imageTarget.src;

    if (pngData) {
      const downloadLink = document.createElement("a")
      downloadLink.href = pngData
      downloadLink.download = "sales_qr_code.png"

      document.body.appendChild(downloadLink)

      setTimeout(() => {
        downloadLink.click()
        document.body.removeChild(downloadLink)
      }, 0);
    } else {
      console.error("PNG data not found.")
      alert("Image download failed. Please try again.")
    }
  }
}