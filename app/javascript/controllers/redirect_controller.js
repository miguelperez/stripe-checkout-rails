import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['link'];
  static values = { url: String}

  connect(){
    this.linkTarget.href = this.urlValue;
  }
}
