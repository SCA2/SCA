// ==============Global Configuration=============

var sMarkupFactor = 1.03
var sPackingCost = 0;
var sSmallBox = 1.0;
var sMedBox = 1.0;
var sBigBox = 3.0;

var sDisplayErrors = true;
// ============End Global Configuration===========



// =====================UPS=======================
var sUPSAccessLicenseNumber = "DC1022E5FAC7AD60";
var sUPSUserID = "tpryan";
var sUPSPassword = "ups1138";
var sUPSAccount = "Y7V283";

//production url = "https://www.ups.com/ups.app/xml/Rate?"
//test url = "https://wwwcie.ups.com/ups.app/xml/Rate"

var sUPSproxy = "http://www.seventhcircleaudio.com/cart/upsproxy.php";

// The web services request minus the domain name
var sUPSpath = "ups.app/xml/Rate?";	// normal path
//var sUPSpath = "ups.app/xml/Rate";	// test path

var sUPSurl = sUPSproxy + "?ups_path=" + sUPSpath;

var sUPSheader = "application/x-www-form-urlencoded";
var sUPSTimer = 0;

// 	Pickup Types
//  01 - daily pickup
//	03 - customer counter
//  06 - a one time pickup 
//	07 - on call air
//	11 - suggested retail rates
//  19 - dropped off at a UPS Letter Center

var sUPSPickupType = "03";

//	UPS Customer Classifications
//	01 - wholesale
//	03 - occasional
//	04 - retail

var sUPSCustomerClass = "03";

var sShipFromCompany = "Seventh Circle Audio";
var sShipFromAddr1 = "1234 47th Ave";
var sShipFromAddr2 = "Suite 9";
var sShipFromCity = "Oakland";
var sShipFromState = "CA";
var sShipFromZip = "94601";
var sShipFromCountry = "US";
var sShipFromPhone = "(510) 436-4559";
var sShipFromFAX = "(510) 436-4559";

var sShipToCountry = "US";
var sShipToZip = "";
var sShipToLength = "24";
var sShipToWidth = "12";
var sShipToHeight = "6";


// ===============================================


