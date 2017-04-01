$(document).ready(function() {

  // Create a Stripe client
  const stripe_pk = $('meta[name="stripe-public-key"]').attr('content');
  var stripe = Stripe(stripe_pk);

  // Create an instance of Elements
  var elements = stripe.elements();

  // Custom styling can be passed to options when creating an Element.
  // (Note that this demo uses a wider set of styles than the guide below.)
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

  // Create an instance of the card Element
  let userPostalCode = document.getElementById('card-element')
  userPostalCode = userPostalCode ? userPostalCode.dataset.postcode : '90210';
  var card = elements.create('card', {value: {postalCode: userPostalCode}, style: style});

  // Add an instance of the card Element into the `card-element` <div>
  card.mount('#card-element');

  // Handle real-time validation errors from the card Element.
  var errorDisplayDiv = document.getElementById('card-errors');

  card.addEventListener('change', function(event) { displayError(event) });

  var displayError = function(event) {
    if (event.error) {
      errorDisplayDiv.textContent = event.error.message;
    } else {
      errorDisplayDiv.textContent = '';
    }
  };

  // Handle form submission
  var form = document.getElementById('new_card_validator');

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

  var submitForm = function(stripe_token) {
    let hiddenInput = document.getElementById('card_validator_stripe_token');
    hiddenInput.setAttribute('value', stripe_token.id);
    // alert('submitting token: ' + stripe_token.id);
    form.submit();
  }
});
