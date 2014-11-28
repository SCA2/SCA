<?php
// PHP Proxy for UPS rate services. 

// https://www.ups.com/ups.app/xml/Rate?	// normal URL
// https://wwwcie.ups.com/ups.app/xml/Rate	// test URL

//$logfile = '../cart/upslog.txt';
//$handle = fopen($logfile, 'w');
//fwrite($handle, "UPS Proxy Log\r\n");

define ('HOSTNAME', 'https://www.ups.com/');

// Get the REST call path from the AJAX application
// Is it a POST or a GET?
$path = ($_POST['ups_path']) ? $_POST['ups_path'] : $_GET['ups_path'];
$url = HOSTNAME.$path;
//fwrite($handle, "url=".$url."\r\n");

// Open the Curl session
$ch = curl_init($url);
$header[] = "Content-type: text/xml";

if ($_POST['xml']) {
//	fwrite($handle, "_post=".$_POST."\r\n");
//	fwrite($handle, "_post['xml']=".$_POST['xml']."\r\n");

	$postvars = $_POST['xml'];
//	fwrite($handle, "postvars1=".$postvars."\r\n");
	$postvars = stripslashes($postvars);
//	fwrite($handle, "postvars2=".$postvars."\r\n");

	curl_setopt ($ch, CURLOPT_POST, true);
	curl_setopt ($ch, CURLOPT_POSTFIELDS, $postvars);
}

// Don't return HTTP headers. Do return the contents of the call
curl_setopt($ch, CURLOPT_HEADER, false);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_TIMEOUT, 120);
curl_setopt($ch, CURLOPT_FAILONERROR, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
 
// Make the call
$xml = curl_exec($ch);
//fwrite($handle, "xml=".$xml."\r\n");

// The web service returns XML. Set the Content-Type appropriately
header("Content-Type: text/xml");

//echo $xml;
echo stripslashes($xml);
curl_close($ch);
//fclose($handle);

?>
