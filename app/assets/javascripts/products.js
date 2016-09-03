$(document).on('change', '.select-option', function () {
	var optionSelected = $(this).find('option:selected');
	var valueSelected = optionSelected.val();
	var textSelected = optionSelected.text();
//    alert(textSelected + ' selected');
  $(this).parent('form').submit();
});

$(document).on('change', '#product_category', function () {
  var textSelected = $(this).find('option:selected').text();
  var url = $('#product_category_url').val();
	// alert(textSelected + ' selected\n' + 'url:' + url);
  $.ajax({
    url: url,
    type: 'GET',
    data: { "category": textSelected },
    dataType: "json",
    success: function(result) {
      $('#product_category_sort_order').val(result);
    }
  })
});
