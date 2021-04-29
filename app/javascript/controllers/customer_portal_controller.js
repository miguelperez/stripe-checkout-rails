import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [];
  static values = { stripeKey: String }

  connect(){
    this.stripe = Stripe(this.stripeKeyValue);
  }

  redirect(e){
    e.preventDefault();
    let that = this;
    const token = document.querySelector('[name=csrf-token]').getAttribute('content');

    fetch('/stripe/customer_portals', {
      redirect: 'follow',
      method: 'POST',
      headers: {
        "Content-type": "application/json; charset=UTF-8",
        'X-CSRF-Token': token
      }
    }).then(function(response) {
      return response.json()
    }).then(function(data) {
      window.location.href = data.url;
    }).catch(function(error) {
      console.error('Error:', error);
    });
  }
}
