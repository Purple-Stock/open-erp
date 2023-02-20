import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    $(this.element).select2()
  }

  disconnect() {
    $(this.element).select2("destroy")
  }

}
