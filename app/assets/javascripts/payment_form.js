$(function() {
  $('#new_payment').submit(function(event) {
    var expiration = $.payment.cardExpiryVal($('.cc-exp').val());
    Stripe.card.createToken({
        number: $('.cc-num').val(),
        cvc: $('.cc-cvc').val(),
        exp_month: (expiration.month || 0),
        exp_year: (expiration.year || 0)
    }, stripeResponseHandler);

    $('#new_payment input[type=submit]').attr('disabled', true);
    $('#new_payment input[type=submit]').val("Processing...");

    return false;
  });

  function stripeResponseHandler(status, response) {
    var $form = $('#new_payment');

    if (response.error) {
      $form.find('.payment-errors').text(response.error.message);
      $('#new_payment input[type=submit]').attr('disabled', false);
      $('#new_payment input[type=submit]').val("Failed");
    } else {
      var token = response.id;
      $form.append($('<input type="hidden" name="stripeToken" />').val(token));
      $form.get(0).submit();
    }
  }

  // Stripe card validations
  $('input.cc-num').payment('formatCardNumber');
  $('input.cc-cvc').payment('formatCardCVC');
  $('input.cc-exp').payment('formatCardExpiry');
});