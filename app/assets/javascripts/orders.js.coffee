# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("[id*='addresses_attributes'][id*='country']").change (event) ->
    country_code = $(this).val()
    target = '[addresses_attributes]'
    target_index = $(this).attr('name').indexOf(target) + target.length + 1
    index = $(this).attr('name').charAt(target_index)
    url = "/addresses/subregion_options?parent_region=#{country_code}&select_name=order[addresses_attributes][" + index + "]"
    select_wrapper = $("[id*='addresses_attributes'][id*=" + index + "][id*='state_code']")
    select_wrapper.parent('.input').load(url)

$ ->
    subregion = $("[id*='addresses_attributes'][id*='0'][id*='state_code']")
    if subregion.prop("id")
      if subregion.prop("innerHTML").search("Please") != -1
        select = $("[id*='addresses_attributes'][id*='0'][id*='country']")
        if select.prop("name")
          country_code = select.val()
          select_name = select.prop("name").replace("[country]", "")
          url = "/addresses/subregion_options?parent_region=#{country_code}&select_name=#{select_name}"
          $("[id*='addresses_attributes'][id*='0'][id*='state_code']").parent('.input').load(url)

$ ->
    subregion = $("[id*='addresses_attributes'][id*='1'][id*='state_code']")
    if subregion.prop("id")
      if subregion.prop("innerHTML").search("Please") != -1
        select = $("[id*='addresses_attributes'][id*='1'][id*='country']")
        if select.prop("name")
          country_code = select.val()
          select_name = select.prop("name").replace("[country]", "")
          url = "/addresses/subregion_options?parent_region=#{country_code}&select_name=#{select_name}"
          $("[id*='addresses_attributes'][id*='1'][id*='state_code']").parent('.input').load(url)

