import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['yearly', 'monthly', 'prices', 'monthlyPrices', 'yearlyPrices', 'price'];
  static values = { prices: Object, subscribeUrl: String, stripeKey: String }

  connect(){
    this.stripe = Stripe(this.stripeKeyValue);
    this.yearlyTarget.click();
    console.log('a')
  }

  changePrice(e){
    let value = document.querySelector('[name=atendees]:checked').value;
    this.priceTarget.innerHTML = parseInt(value)/100;
  }

  checkIfUnchecked(){
    setTimeout(function(){
      document.querySelector('[name=atendees]').click();
    }, 100)
  }

  yearly(e){
    e.preventDefault()
    e.target.classList.add('selected')
    this.monthlyTarget.classList.remove('selected')
    this.pricesTarget.innerHTML = this.yearlyPricesTarget.content.firstElementChild.cloneNode(true).innerHTML
    this.checkIfUnchecked();
  }

  monthly(e){
    e.preventDefault()
    e.target.classList.add('selected')
    this.yearlyTarget.classList.remove('selected')
    this.pricesTarget.innerHTML = this.monthlyPricesTarget.content.firstElementChild.cloneNode(true).innerHTML
    this.checkIfUnchecked();
  }

  selectedProductAndPrice(){
    let selectedPrice = document.querySelector('[name=atendees]:checked');
    return {
      product_id: selectedPrice.dataset.productId,
      price_id: selectedPrice.dataset.priceId
    }
  }

  subscribe(e){
    let that = this;
    const token = document.querySelector('[name=csrf-token]').getAttribute('content');
    fetch(this.subscribeUrlValue, {
      redirect: 'follow',
      method: 'POST',
      body: JSON.stringify(this.selectedProductAndPrice()),
      headers: {
        "Content-type": "application/json; charset=UTF-8",
        'X-CSRF-Token': token
      }
    })
      .then(response => response.json() )
      .then(function(data) {
        console.log(data)
        // Call Stripe.js method to redirect to the new Checkout page
        that.stripe
          .redirectToCheckout({
            sessionId: data.id
          })
      });
  }

  processResponse(data){
    console.log(data)
    // if(data.supported === true){
    //   this.supported();
    // }else{
    //   this.notSupported();
    // }
  }
}
