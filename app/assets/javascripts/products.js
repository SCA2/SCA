// $(document).on('load', this, function () {
// 	$('.update-button').remove();
// });

$(document).on('change', '.select-option', function () {
	var optionSelected = $(this).find('option:selected');
	var valueSelected = optionSelected.val();
	var textSelected = optionSelected.text();
//		alert(textSelected + ' selected');
	$(this).parent('form').submit();
});
