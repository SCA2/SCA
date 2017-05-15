$(document).on('click', '#print_slip', function () {

  var mywindow = window.open('', 'PRINT', 'height=400,width=600');
  var stylesheet = document.getElementById('print_slip').dataset.css;

  mywindow.document.write('<html><head>');
  mywindow.document.write(stylesheet);
  mywindow.document.write('</head><body >');
  mywindow.document.write(document.getElementById('print_area').innerHTML);
  mywindow.document.write('</body></html>');

  mywindow.document.close(); // necessary for IE >= 10
  mywindow.focus(); // necessary for IE >= 10*/

  return true;
});
