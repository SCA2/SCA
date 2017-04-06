$(document).ready(function() {

  // Get the public key from the meta tag
  const stripe_pk = $('meta[name="stripe-public-key"]').attr('content');

  // Create a Stripe client
  var stripe = Stripe(stripe_pk);

  // Create an instance of Elements
  var elements = stripe.elements();

  // Custom styling (overrides CSS)
  var style = {
    base: {
      fontSmoothing: 'antialiased',
      '::placeholder': {
        color: '#aab7c4'
      }
    },
    invalid: {
      color: '#fa755a',
      iconColor: '#fa755a'
    }
  };

  const cardElement = document.getElementById('card-element');
  const errorElement = document.getElementById('card-errors');
  const form = document.getElementById('new_card_tokenizer');

  if(cardElement && errorElement && form) {

    var values = function() {
      var userPostalCode = cardElement.dataset.postcode || '90210';
      return({postalCode: userPostalCode});
    };

    // Create an instance of the card Element
    var card = elements.create('card', {hidePostalCode: true, value: values(), style: style});

    // Add an instance of the card Element into the `card-element` <div>
    card.mount('#card-element');

    // Handle real-time validation errors from the card Element.
    card.addEventListener('change', function(event) { displayError(event) });

    var displayError = function(event) {
      if (event.error) {
        errorElement.textContent = event.error.message;
      } else {
        errorElement.textContent = '';
      }
    };

    // Handle form submission
    form.addEventListener('submit', function(event) {
      event.preventDefault();

      stripe.createToken(card).then(function(result) {
        if (result.error) {
          // Inform the user if there was an error
          var errorElement = document.getElementById('card-errors');
          errorElement.textContent = result.error.message;
          console.log(result.error.message);
        } else {
          // Send the token to your server
          submitForm(result.token);
        }
      });
    });
  };

  var submitForm = function(stripe_token) {
    var hiddenInput = document.getElementById('card_tokenizer_stripe_token');
    hiddenInput.setAttribute('value', stripe_token.id);
    // alert('Submitting token: ' + stripe_token.id);
    form.submit();
  }

});
