# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('select#order_addresses_attributes_0_country').change (event) ->
    select_wrapper = $('#order_state_code_wrapper_billing')
    country_code = $(this).val()
    url = "/orders/subregion_options?parent_region=#{country_code}&address_type=billing&select_name=order[addresses_attributes][0]"
    select_wrapper.parent('.input').load(url)

  $('select#order_addresses_attributes_1_country').change (event) ->
    select_wrapper = $('#order_state_code_wrapper_shipping')
    country_code = $(this).val()
    url = "/orders/subregion_options?parent_region=#{country_code}&address_type=shipping&select_name=order[addresses_attributes][1]"
    select_wrapper.parent('.input').load(url)

$ ->
    country_code = $('select#order_addresses_attributes_0_country').val();
    url = "/orders/subregion_options?parent_region=#{country_code}&address_type=billing&select_name=order[addresses_attributes][0]"
    $('#order_state_code_wrapper_billing').parent('.input').load(url)

    country_code = $('select#order_addresses_attributes_1_country').val();
    url = "/orders/subregion_options?parent_region=#{country_code}&address_type=shipping&select_name=order[addresses_attributes][1]"
    $('#order_state_code_wrapper_shipping').parent('.input').load(url)
