$(document).on('change', '#bom_creator_product', function () {
  var valueSelected = $(this).find('option:selected').val();
  var url = $('#bom_creator_url').val();
  $.ajax({
      url: url,
      type: 'GET',
      data: { "product_id": valueSelected },
      dataType: "json",
      success: function(result) {
        var options = $('#bom_creator_option');
        options.empty();
        for (var i = 0; i < result.length; i++) {                 
          options.append("<option value=" + result[i].id + ">" + result[i].model + "</option>");    
        }
      }
    })
});

$(document).on('change', '#bom_importer_product', function () {
  var valueSelected = $(this).find('option:selected').val();
  var url = $('#bom_importer_url').val();
  $.ajax({
      url: url,
      type: 'GET',
      data: { "product_id": valueSelected },
      dataType: "json",
      success: function(result) {
        var options = $('#bom_importer_option');
        options.empty();
        for (var i = 0; i < result.length; i++) {                 
          options.append("<option value=" + result[i].id + ">" + result[i].model + "</option>");    
        }
      }
    })
});
