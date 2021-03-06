// Create a Stripe client
var stripe = Stripe(window.stripe_api_key);

// Create an instance of Elements
var elements = stripe.elements();

// Custom styling can be passed to options when creating an Element.
// (Note that this demo uses a wider set of styles than the guide below.)
var style = {
  base: {
    color: '#32325d',
    lineHeight: '18px',
    fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
    fontSmoothing: 'antialiased',
    fontSize: '16px',
    '::placeholder': {
      color: '#aab7c4'
    }
  },
  invalid: {
    color: '#fa755a',
    iconColor: '#fa755a'
  }
};

// Create an instance of the card Element
var card = elements.create('card', {style: style});

// Add an instance of the card Element into the `card-element` <div>
card.mount('#card-element');

// Handle real-time validation errors from the card Element.
card.addEventListener('change', function(event) {
  var displayError = document.getElementById('card-errors');
  if (event.error) {
    displayError.textContent = event.error.message;
  } else {
    displayError.textContent = '';
  }
});

// Handle form submission
var form = document.getElementById('payment-form');
form.addEventListener('submit', function(event) {
  event.preventDefault();

  stripe.createToken(card).then(function(result) {
    if (result.error) {
      // Inform the user if there was an error
      var errorElement = document.getElementById('card-errors');
      errorElement.textContent = result.error.message;
    } else {
      stripeTokenHandler(result.token);
    }
  });
});

var stripeTokenHandler = function(result){
  var headers = {
    'X-CSRF-Token': document.querySelectorAll('meta[name="csrf-token"]')[0].content,
    'Content-type': 'application/json'
  }

  var data = {
    payment: {
      vendor: result.card.brand,
      token: result.id,
      last_4: result.card.last4,
      card_type: result.type,
    }
  }

  fetch('/payments', {
    credentials: 'include',
    headers: headers,
    method: 'POST',
    body: JSON.stringify(data)
  })
    .then(res => { 
      res.json().then(json => {
        // render new card
        var form = document.getElementById('payment-form')
        form.outerHTML = '<p>' + result.card.brand + result.type + ' ending in ' + result.card.last4 + '</p>'
      }) 
    })
    .catch(err => { console.error(err) })
}
