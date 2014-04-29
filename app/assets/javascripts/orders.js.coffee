# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("[id*='addresses_attributes'][id*='country']").change (event) ->
    country_code = $(this).val()
    target = '[addresses_attributes]'
    target_index = $(this).attr('name').indexOf(target) + target.length + 1
    index = $(this).attr('name').charAt(target_index)
    url = "/addresses/subregion_options?parent_region=#{country_code}&select_name=[addresses_attributes][" + index + "]"
    select_wrapper = $("[id*='addresses_attributes'][id*=" + index + "][id*='state_code']")
    select_wrapper.parent('.input').load(url)

$ ->
    country_code = $("[id*='addresses_attributes'][id*='0'][id*='country']").val();
    url = "/addresses/subregion_options?parent_region=#{country_code}&select_name=user[addresses_attributes][0]"
    $("[id*='addresses_attributes'][id*='0'][id*='state_code']").parent('.input').load(url)

$ ->
    country_code = $("[id*='addresses_attributes'][id*='1'][id*='country']").val();
    url = "/addresses/subregion_options?parent_region=#{country_code}&select_name=user[addresses_attributes][1]"
    $("[id*='addresses_attributes'][id*='1'][id*='state_code']").parent('.input').load(url)

