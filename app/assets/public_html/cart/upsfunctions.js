
var oXMLHTTP = null;
var oUPSXML = null;


function IE(v) {
  var r = RegExp('msie' + (!isNaN(v) ? ('\\s' + v) : ''), 'i');
  return r.test(navigator.userAgent);
}

	
if( document.implementation.hasFeature("XPath", "3.0")){
    if( typeof XMLDocument == "undefined" ){ XMLDocument = Document; }
	XMLDocument.prototype.selectNodes = function(cXPathString, xNode){
    if( !xNode ) { xNode = this; }
        var oNSResolver = this.createNSResolver(this.documentElement)
        var aItems = this.evaluate(cXPathString, xNode, oNSResolver, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null)
        var aResult = [];
        for( var i = 0; i < aItems.snapshotLength; i++){aResult[i] =  aItems.snapshotItem(i);    }
        return aResult;
    }
    XMLDocument.prototype.selectSingleNode = function(cXPathString, xNode){
        if( !xNode ) { xNode = this; }
        var xItems = this.selectNodes(cXPathString, xNode);
        if( xItems.length > 0 ){return xItems[0];    }
        else{return null;   }
    }
    Element.prototype.selectNodes = function(cXPathString){
        if(this.ownerDocument.selectNodes){ return this.ownerDocument.selectNodes(cXPathString, this);}
        else{throw "For XML Elements Only";}
    }
    Element.prototype.selectSingleNode = function(cXPathString){
        if(this.ownerDocument.selectSingleNode){return this.ownerDocument.selectSingleNode(cXPathString, this); }
        else{throw "For XML Elements Only";}
    }
}


function formatCurrency(strValue)
{
	strValue = strValue.toString().replace(/\$|\,/g,'');
	dblValue = parseFloat(strValue);

	blnSign = (dblValue == (dblValue = Math.abs(dblValue)));
	dblValue = Math.floor(dblValue*100+0.50000000001);
	intCents = dblValue%100;
	strCents = intCents.toString();
	dblValue = Math.floor(dblValue/100).toString();
	if(intCents<10)
		strCents = "0" + strCents;
	for (var i = 0; i < Math.floor((dblValue.length-(1+i))/3); i++)
		dblValue = dblValue.substring(0,dblValue.length-(4*i+3))+','+
		dblValue.substring(dblValue.length-(4*i+3));
	return (((blnSign)?'':'-') + '$' + dblValue + '.' + strCents);
}


function GetUPSXMLRate(sShipToWeight, sShipToZip, sShipToCountry){

	if (window.XMLHttpRequest) {	// Mozilla
		try {
			oXMLHTTP=new XMLHttpRequest();
		}
		catch (err) {
			alert("Sorry, can't create XML object - "+err); // show error
			return false;
		}
	}
	else if (window.ActiveXObject) {	// IE
		try {
		  oXMLHTTP=new ActiveXObject("Microsoft.XMLHTTP");
		} 
		catch (err) {
			alert("Sorry, can't create XML object - "+err); // show error
			return false;
		}
	}
	else {
		alert ("Sorry, UPS rates only available with XMLHttpRequest-capable browsers");
		return false;
	}
	
	sUPSTimer = setTimeout("onTimeout();", 15000);
	var txt="<input name='GetRates' type='button' value='Getting Rates...' disabled='true' />"
	document.getElementById('RateDropdown').innerHTML=txt;
	var sUPSXML = BuildUPSXML(sShipToWeight, sShipToZip, sShipToCountry);
//	try {
//		oXMLHTTP.responseType = 'msxml-document';
//	}
//	catch (err){}

	try {
		oXMLHTTP.open("POST", sUPSurl, true);
		oXMLHTTP.setRequestHeader("Content-Type", sUPSheader);
		oXMLHTTP.onreadystatechange=onResponse;
		oXMLHTTP.send("xml="+sUPSXML);
	} 
	catch (err) {
		alert("Error (1): "+err);
		ResetDropdown();
		clearTimeout(sUPSTimer);
		return false;
	}
}


function checkReadyState(obj){
//	alert("ReadyState: "+obj.readyState+"\n"+"Status: "+obj.status);
  if(obj.readyState == 4) {
    if(obj.status == 200) {
      return true
		}
		else if(obj.status == 404) {
			alert("Requested file not found");
			return false
		}
		else {
			alert("Error (2)\n"+"ReadyState: "+obj.readyState+"\n"+"Status: "+obj.statusText);
			return false
	  }
	}
	return false
}


function onTimeout() {
	alert("UPS Not Responding");
	ResetDropdown();
}


function onResponse(){
	clearTimeout(sUPSTimer);
	if(checkReadyState(oXMLHTTP)) {
//		alert(oXMLHTTP.responseText);
		if (document.implementation && document.implementation.createDocument){	// Mozilla
			try {
				oUPSXML=document.implementation.createDocument("","",null);
				oUPSXML=oXMLHTTP.responseXML;
			}
			catch (err) {
				alert("Sorry, error getting UPS response. - "+err); // show error
				ResetDropdown();
				return false;
			}
		}
		else if (window.ActiveXObject) {	// IE
			try {
				oUPSXML=new ActiveXObject("Microsoft.XMLDOM");
				oUPSXML.async=false;
				oUPSXML.load(oXMLHTTP.responseXML);
			}
			catch (err){
				alert("Sorry, error getting UPS response. - "+err); // show error
				ResetDropdown();
				return false;
			}
		}
		else {
			alert("Sorry, your browser can't handle this script");
		}
	}
	else
		return false;

	if(!UPSErrors(oUPSXML)) {
		//Create A Nodelist of All The RatedShipments;
		var rateList = oUPSXML.getElementsByTagName('RatedShipment');
		if(rateList.length > 0){
			var txt="<select id=UPSDropdown selectedIndex=0 onchange='OnRateSelect();'>"
			for(i=0; i < (rateList.length - 1); i++){
				var s = null;
				var r = 0;
				s = rateList.item(i).selectSingleNode("Service/Code").childNodes[0].nodeValue;
				s = GetFriendlyUPSName(s) + " - ";
				r = rateList.item(i).selectSingleNode("TotalCharges/MonetaryValue").childNodes[0].nodeValue;
				r = r * sMarkupFactor * 1.0 + sPackingCost * 1.0;
				r = formatCurrency(r);
				s = s + r;
				txt = txt + "<option>" + s + "</option>"
			}
		}
		txt = txt + "</select>"
		document.getElementById('RateDropdown').innerHTML=txt;
		OnRateSelect();
	}
	else {	//Returned with errors
		ResetDropdown();
		return false;
	}
}


function GetFriendlyUPSName(vCode){
	switch(vCode){
		case "01": return ("UPS Next Day Air");
		case "02": return ("UPS 2nd Day Air");
		case "03": return ("UPS Ground");
		case "07": return ("UPS Worldwide Express");
		case "08": return ("UPS Worldwide Expedited");
		case "11": return ("UPS Standard");
		case "12": return ("UPS 3 Day Select");
		case "13": return ("UPS Next Day Air Saver");
		case "14": return ("UPS Next Day Air Early A.M.");
		case "54": return ("UPS Worldwide Express Plus");
		case "59": return ("UPS 2nd Day Air A.M.");
		case "65": return ("UPS Saver");
	}
}


function UPSErrors(oUPSXML) {
	if(oUPSXML) {	// exists?
		if(oUPSXML.getElementsByTagName('ResponseStatusCode').length > 0) { // got a response status code
			if(oUPSXML.getElementsByTagName('ResponseStatusCode')[0].childNodes[0].nodeValue == 0) {	// failed
				var errnum = oUPSXML.getElementsByTagName('Error').length; 	
				if(errnum > 0){	// got errors
					var txt="";
					for(i=0; i < errnum; i++){
						txt=txt+"Error Severity - "+oUPSXML.getElementsByTagName('ErrorSeverity')[i].childNodes[0].nodeValue+"\n";
						txt=txt+"Error Code - "+oUPSXML.getElementsByTagName('ErrorCode')[i].childNodes[0].nodeValue+"\n";
						txt=txt+"Error - "+oUPSXML.getElementsByTagName('ErrorDescription')[i].childNodes[0].nodeValue+"\n";
						txt=txt+"\n"
						alert(txt);
					}
				}
				return(true);
			}
		}
	}
	return(false);
}
	

function BuildUPSXML(sShipToWeight, sShipToZip, sShipToCountry){

	var sXML = "";
	
	sXML = sXML + "<?xml version='1.0'?>"
	sXML = sXML + "<AccessRequest xml:lang='en-US'>"
	sXML = sXML + "<AccessLicenseNumber>"+sUPSAccessLicenseNumber+"</AccessLicenseNumber>"
	sXML = sXML + "<UserId>"+sUPSUserID+"</UserId>"
	sXML = sXML + "<Password>"+sUPSPassword+"</Password>"
	sXML = sXML + "</AccessRequest>"
	
	sXML = sXML + "<?xml version='1.0'?>"
	sXML = sXML + "<RatingServiceSelectionRequest>"
	sXML = sXML + "<Request>"
	sXML = sXML + "<RequestAction>Rate</RequestAction>"
	sXML = sXML + "<RequestOption>Shop</RequestOption>"
	sXML = sXML + "<TransactionReference>"
	sXML = sXML + "<CustomerContext>Rating and Service</CustomerContext>"
	sXML = sXML + "<XpciVersion>1.0</XpciVersion>"
	sXML = sXML + "</TransactionReference>"
	sXML = sXML + "</Request>"
	sXML = sXML + "<PickupType>"
	sXML = sXML + "<Code>"+sUPSPickupType+"</Code>"
	sXML = sXML + "</PickupType>"
	sXML = sXML + "<CustomerClassification>"
	sXML = sXML + "<Code>"+sUPSCustomerClass+"</Code>"
	sXML = sXML + "</CustomerClassification>"
	sXML = sXML + "<Shipment>"
	sXML = sXML + "<Description>Rate Shopping - Domestic</Description>"
	sXML = sXML + "<Shipper>"
	sXML = sXML + "<Name>"+sShipFromCompany+"</Name>"
	sXML = sXML + "<PhoneNumber>"+sShipFromPhone+"</PhoneNumber>"
	sXML = sXML + "<FaxNumber>"+sShipFromFAX+"</FaxNumber>"
	sXML = sXML + "<ShipperNumber>"+sUPSAccount+"</ShipperNumber>"
	sXML = sXML + "<Address>"
	sXML = sXML + "<AddressLine1>"+sShipFromAddr1+"</AddressLine1>"
	sXML = sXML + "<AddressLine2>"+sShipFromAddr2+"</AddressLine2>"
	sXML = sXML + "<AddressLine3 />"
	sXML = sXML + "<City>"+sShipFromCity+"</City>"
	sXML = sXML + "<StateProvinceCode>"+sShipFromState+"</StateProvinceCode>"
	sXML = sXML + "<PostalCode>"+sShipFromZip+"</PostalCode>"
	sXML = sXML + "<CountryCode>"+sShipFromCountry+"</CountryCode>"
	sXML = sXML + "</Address>"
	sXML = sXML + "</Shipper>"
	sXML = sXML + "<ShipTo>"
	sXML = sXML + "<Address>"
	sXML = sXML + "<PostalCode>"+sShipToZip+"</PostalCode>"
	sXML = sXML + "<CountryCode>"+sShipToCountry+"</CountryCode>"
	sXML = sXML + "</Address>"
	sXML = sXML + "</ShipTo>"
	sXML = sXML + "<ShipFrom>"
	sXML = sXML + "<CompanyName>"+sShipFromCompany+"</CompanyName>"
	sXML = sXML + "<PhoneNumber>"+sShipFromPhone+"</PhoneNumber>"
	sXML = sXML + "<FaxNumber>"+sShipFromFAX+"</FaxNumber>"
	sXML = sXML + "<Address>"
	sXML = sXML + "<AddressLine1>"+sShipFromAddr1+"</AddressLine1>"
	sXML = sXML + "<AddressLine2>"+sShipFromAddr2+"</AddressLine2>"
	sXML = sXML + "<City>"+sShipFromCity+"</City>"
	sXML = sXML + "<StateProvinceCode>"+sShipFromState+"</StateProvinceCode>"
	sXML = sXML + "<PostalCode>"+sShipFromZip+"</PostalCode>"
	sXML = sXML + "<CountryCode>"+sShipFromCountry+"</CountryCode>"
	sXML = sXML + "</Address>"
	sXML = sXML + "</ShipFrom>"
	sXML = sXML + "<PaymentInformation>"
	sXML = sXML + "<Prepaid>"
	sXML = sXML + "<BillShipper><AccountNumber>"+sUPSAccount+"</AccountNumber></BillShipper>"
	sXML = sXML + "</Prepaid>"
	sXML = sXML + "</PaymentInformation>"
	sXML = sXML + "<Package>"
	sXML = sXML + "<PackagingType>"
	sXML = sXML + "<Code>02</Code>"
	sXML = sXML + "<Description>Customer Packaging</Description>"
	sXML = sXML + "</PackagingType>"
	sXML = sXML + "<Description>Rate</Description>"
	sXML = sXML + "<Dimensions>"
	sXML = sXML + "<Length>"+sShipToLength+"</Length>"
	sXML = sXML + "<Width>"+sShipToWidth+"</Width>"
	sXML = sXML + "<Height>"+sShipToHeight+"</Height>"
	sXML = sXML + "</Dimensions>"
	sXML = sXML + "<PackageWeight>"
	sXML = sXML + "<UnitOfMeasurement>"
	sXML = sXML + "<Code>LBS</Code>"
	sXML = sXML + "</UnitOfMeasurement>"
	sXML = sXML + "<Weight>"+sShipToWeight+"</Weight>"
	sXML = sXML + "</PackageWeight>"
	sXML = sXML + "</Package>"
	sXML = sXML + "<ShipmentServiceOptions/>"
	sXML = sXML + "</Shipment>"
	sXML = sXML + "</RatingServiceSelectionRequest>"

	return sXML;
}
