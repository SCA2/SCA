
var order = new Object();			// object to store order in
var root  = new Object();  			// selection criteria
var on    = true;
var off   = false;
var cntr    = 0;					// items in object
var shpr    = 0;					// what to charge for shipping;
var stxt    = "UPS Ground";  		// shipping text
var tfull=0;						// full price accumulator
var	tdsc=0;							// discount price accumulator
var tdif=0;							// total price difference
var tapp=0;							// total number of discounts applied
var	twgt=0;  						// total weight
var oldtfull=0;						// last full price
var oldtdsc=0;						// last discount price
var oldtwgt=0;						// last total weight

var	tCH02KFcombo=0;					// total CH02 kit combos
var tCH02KAcombo=0;					// total CH02 assembled combos
var tPC01CHcombo=0;					// total PC01 assembled combos
var tCHKF_WHcombo=0;				// total CH02KF/WH01KA combos

var tT15KFcombo=0;					// total T15 complete kit combos
var tA12bcombo=0;					// total A12b complete kit combos

var tA12KFSPCombo=0;				// total A12 subpanel combos
var tC84KFSPCombo=0;				// total C84 subpanel combos
var tJ99KFSPCombo=0;				// total J99 subpanel combos
var tN72KFSPCombo=0;				// total N72 subpanel combos
var tT15KFSPCombo=0;				// total T15 subpanel combos
var tD11KFSPCombo=0;				// total D11 subpanel combos
var tB16KFSPCombo=0;				// total B16 subpanel combos

var tA12KASPCombo=0;				// total A12 subpanel combos
var tC84KASPCombo=0;				// total C84 subpanel combos
var tJ99KASPCombo=0;				// total J99 subpanel combos
var tN72KASPCombo=0;				// total N72 subpanel combos
var tT15KASPCombo=0;				// total T15 subpanel combos
var tD11KASPCombo=0;				// total D11 subpanel combos
var tB16KASPCombo=0;				// total B16 subpanel combos

root.shp  = on;    	// shipping selection line
root.tax  = off;    // tax selection line
// place for user-specific options
root.xx_can  = ""; // place for PayPal cancel return path
root.xx_cur  = "USD";// enter default currency code (or null)
root.xx_id   = "sales@seventhcircleaudio.com";  // PayPal ID
root.xx_img  = ""; // image URL
root.xx_lc   = ""; // enter default country code (or null)
root.xx_ret  = ""; // place for PayPal return path
root.xx_sty  = ""; // place for PayPal page style
root.xx_xtra = "&rm=0"; // place for other PayPal commands

function Dollar (val) {     // force to valid dollar amount
	var str,pos,rnd=0,neg=0;
  
	if (val < 0) {
    val = -val;
		neg = 1;
  }
  if (val < .995) rnd = 1;  // for old Netscape browsers
  str = escape (val*1.0 + 0.005001 + rnd);  // float, round, escape
  pos = str.indexOf (".");  // should be one, but OK if not
  if (pos > 0) str = str.substring (rnd, pos + 3);
  if (neg == 1) str = "-" + str;
	if (str == ".00") str = "0" + str;
  return str;               // return valid string
}


function CalcTotals () { 	// calculate totals
	var i,d,q;
	q = 0.0;
	d = "";
	oldtfull=tfull;
	oldtdsc=tdsc;
	oldtwgt=twgt;
	tfull=0,tdsc=0,twgt=0;	// clear some totals
	for (i in order) { 			// calc totals we might use
		q = order[i].qty * 1.0;
		tfull = tfull + order[i].full * q;
		q = order[i].dsc * 1.0;
		tdsc = tdsc + order[i].disc * q;
		q = order[i].qty * 1.0 + order[i].dsc * 1.0;
		twgt = twgt + order[i].wgt * q;
	}
	twgt = Math.ceil(twgt);
}


function NewTotals(){ // returns true if totals have changed
	if(oldtfull != tfull) return true;
	if(oldtdsc != tdsc) return true;
	if(oldtwgt != twgt) return true;
	return false;
}


function set() {
	var result = {};

	for (var i = 0; i < arguments.length; i++)
	result[arguments[i]] = true;

	return result;
}
  
  
function CheckDiscs () { // check for discount combos
	var i, j, d, q;
	var notAlphaNum = /[^A-Z,0-9,-]/i;
	
	q = 0.0;
	d = "";
	
	var	tMKF=0;							// total modules, kits
	var tMKA=0;							// total modules, assembled
	var	tA12=0;							// total A12s
	var	tA12b=0;						// total A12bs
	var	tC84=0;							// total C84s
	var	tJ99=0;							// total J99s
	var	tJ99b=0;						// total J99bs
	var	tN72=0;							// total N72s
	var tT15=0;							// total T15s
	var	tD11=0;							// total D11s
	var	tB16=0;							// total B16s
	
	var tA12KF=0;						// total A12s
	var tC84KF=0;						// total C84s
	var tJ99KF=0;						// total J99s
	var tN72KF=0;						// total N72s
	var tT15KF=0;						// total T15s
	var tD11KF=0;						// total D11s
	var tB16KF=0;						// total B16s

	var tA12KA=0;						// total A12s
	var tA12BKA=0;						// total A12Bs
	var tC84KA=0;						// total C84s
	var tJ99KA=0;						// total J99s
	var tJ99BKA=0;						// total J99Bs
	var tN72KA=0;						// total N72s
	var tT15KA=0;						// total T15s
	var tD11KA=0;						// total D11s
	var tB16KA=0;						// total B16s

	var	tA12SP=0;						// total A12 subpanels
	var	tC84SP=0;						// total C84 subpanels
	var	tJ99SP=0;						// total J99 subpanels
	var	tN72SP=0;						// total N72 subpanels
	var tT15SP=0;						// total T15 subpanels
	var	tD11SP=0;						// total D11 subpanels
	var	tB16SP=0;						// total B16 subpanels
	
	var tA12KFNoSP=0;					// total A12 without subpanel
	var tC84KFNoSP=0;					// total C84 without subpanel
	var tJ99KFNoSP=0;					// total J99 without subpanel
	var tN72KFNoSP=0;					// total N72 without subpanel
	var tT15KFNoSP=0;					// total T15 without subpanel

	var tA12KANoSP=0;					// total A12 without subpanel
	var tC84KANoSP=0;					// total C84 without subpanel
	var tJ99KANoSP=0;					// total J99 without subpanel
	var tN72KANoSP=0;					// total N72 without subpanel
	var tT15KANoSP=0;					// total T15 without subpanel

	var	tSC10=0;						// total SC10s
	var	tSC25=0;						// total SC25s
	var	tSC99=0;						// total SC99s
	
	var tCH02KF=0;						// total CH02KFs
	var tPS03=0;						// total PS03s
	var tWH01=0;						// total WH01s
	
	var tPC01CH=0;						// total PC01CHs

	tCH02KFcombo=0;						// total complete kits
	tCH02KAcombo=0;						// total complete kits
	tPC01CHcombo=0;						// total PC01 kit combos
	tCHKF_WHcombo=0;					// total CH02KF/WH01KA combos
	tT15KFcombo=0;						// total T15 complete kit combos
	tA12bcombo=0;						// total A12b complete kit combos
	
	tA12KFSPCombo=0;					// total A12 subpanel combos
	tC84KFSPCombo=0;					// total C84 subpanel combos
	tJ99KFSPCombo=0;					// total J99 subpanel combos
	tN72KFSPCombo=0;					// total N72 subpanel combos
	tT15KFSPCombo=0;					// total T15 subpanel combos
	tD11KFSPCombo=0;					// total D11 subpanel combos
	tB16KFSPCombo=0;					// total B16 subpanel combos
		
	tA12KASPCombo=0;					// total A12 subpanel combos
	tC84KASPCombo=0;					// total C84 subpanel combos
	tJ99KASPCombo=0;					// total J99 subpanel combos
	tN72KASPCombo=0;					// total N72 subpanel combos
	tT15KASPCombo=0;					// total T15 subpanel combos
	tD11KASPCombo=0;					// total D11 subpanel combos
	tB16KASPCombo=0;					// total B16 subpanel combos
		
	tA12SC10Combo=0;					// total A12/SC10 combos
	tA12SC25Combo=0;					// total A12/SC25 combos
	tJ99SC99Combo=0;					// total J99/SC99 combos
	
	for (i in order) { 					// calc totals we might use
		q = order[i].qty * 1.0 + order[i].dsc * 1.0;
		if (q > 0) {
			d = order[i].des;
			j = d.search(notAlphaNum);
			if (j > 0) d = d.substring(0, j);
//			alert("d="+d);
			if (d == "A12KF") tA12KF += q;
			if (d == "C84KF") tC84KF += q;
			if (d == "J99KF") tJ99KF += q;
			if (d == "N72KF") tN72KF += q;
			if (d == "T15KF") tT15KF += q;
			if (d == "D11KF") tD11KF += q;
			if (d == "B16KF") tB16KF += q;
			if (d == "A12KA") tA12KA += q;
			if (d == "A12BKA") tA12BKA += q;
			if (d == "C84KA") tC84KA += q;
			if (d == "J99KA") tJ99KA += q;
			if (d == "J99BKA") tJ99BKA += q;
			if (d == "N72KA") tN72KA += q;
			if (d == "T15KA") tT15KA += q;
			if (d == "D11KA") tD11KA += q;
			if (d == "B16KA") tB16KA += q;
			if (d == "CH02SP-A12") tA12SP += q;
			if (d == "CH02SP-C84") tC84SP += q;
			if (d == "CH02SP-J99") tJ99SP += q;
			if (d == "CH02SP-N72") tN72SP += q;
			if (d == "CH02SP-T15") tT15SP += q;
			if (d == "CH02SP-D11") tD11SP += q;
			if (d == "CH02SP-B16") tB16SP += q;
			if (d == "SC10KA") tSC10 = tSC10 + q;
			if (d == "SC25KA") tSC25 = tSC25 + q;
			if (d == "SC99KA") tSC99 = tSC99 + q;
			if (d == "PS03KA") tPS03 += q;
			if (d == "CH02KF") tCH02KF += q;
			if (d == "WH01KA") tWH01 += q;
			if (d == "PC01-CH") tPC01CH += q;
		}
	}
	
	tMKF = 	tA12KF + tC84KF + tJ99KF + tN72KF + tT15KF + tB16KF;
	tMKA = 	tA12KA + tA12BKA + tC84KA + tJ99KA + tJ99BKA + tN72KA + tT15KA + tB16KA;

	sPackingCost = 0;
	if (tCH02KF > 0){ // big box
		sShipToLength = "24";
		sShipToWidth = "12";
		sShipToHeight = "6";
		sPackingCost = sBigBox * 1.0;
	}
	else if (((tMKF + tMKA) > 2) || (tPC01CH > 2)){ // medium box
		sShipToLength = "14";
		sShipToWidth = "10";
		sShipToHeight = "10";
		sPackingCost = sMedBox * 1.0;
	}
	else{
		sShipToLength = "12";
		sShipToWidth = "9";
		sShipToHeight = "6";
		sPackingCost = sSmallBox * 1.0;
	}

	if (tA12KF > 0) {tA12KFSPCombo = Math.min(tA12KF, tA12SP); tA12KFNoSP = tA12KF - tA12KFSPCombo;} // number of A12 SP combos
	if (tC84KF > 0) {tC84KFSPCombo = Math.min(tC84KF, tC84SP); tC84KFNoSP = tC84KF - tC84KFSPCombo;} // number of C84 combos
	if (tJ99KF > 0) {tJ99KFSPCombo = Math.min(tJ99KF, tJ99SP); tJ99KFNoSP = tJ99KF - tJ99KFSPCombo;} // number of J99 combos
	if (tN72KF > 0) {tN72KFSPCombo = Math.min(tN72KF, tN72SP); tN72KFNoSP = tN72KF - tN72KFSPCombo;} // number of N72 combos
	if (tT15KF > 0) {tT15KFSPCombo = Math.min(tT15KF, tT15SP); tT15KFNoSP = tT15KF - tT15KFSPCombo;} // number of T15 combos
	if (tD11KF > 0) {tD11KFSPCombo = Math.min(tD11KF, tD11SP); tD11KFNoSP = tD11KF - tD11KFSPCombo;} // number of D11 combos
	if (tB16KF > 0) {tB16KFSPCombo = Math.min(tB16KF, tB16SP); tB16KFNoSP = tB16KF - tB16KFSPCombo;} // number of B16 combos

	tA12KA = tA12KA + tA12BKA;
	tJ99KA = tJ99KA + tJ99BKA;
	if (tA12KA > 0) {tA12KASPCombo = Math.min(tA12KA, tA12SP); tA12KANoSP = tA12KA - tA12KASPCombo;} // number of A12 SP combos
	if (tC84KA > 0) {tC84KASPCombo = Math.min(tC84KA, tC84SP); tC84KANoSP = tC84KA - tC84KASPCombo;} // number of C84 combos
	if (tJ99KA > 0) {tJ99KASPCombo = Math.min(tJ99KA, tJ99SP); tJ99KANoSP = tJ99KA - tJ99KASPCombo;} // number of J99 combos
	if (tN72KA > 0) {tN72KASPCombo = Math.min(tN72KA, tN72SP); tN72KANoSP = tN72KA - tN72KASPCombo;} // number of N72 combos
	if (tT15KA > 0) {tT15KASPCombo = Math.min(tT15KA, tT15SP); tT15KANoSP = tT15KA - tT15KASPCombo;} // number of T15 combos
	if (tD11KA > 0) {tD11KASPCombo = Math.min(tD11KA, tD11SP); tD11KANoSP = tD11KA - tD11KASPCombo;} // number of D11 combos
	if (tB16KA > 0) {tB16KASPCombo = Math.min(tB16KA, tB16SP); tB16KANoSP = tB16KA - tB16KASPCombo;} // number of B16 combos

//	alert("tA12="+tA12+'\n'+"tA12SP="+tA12SP+'\n'+"tA12BKA="+tA12BKA+'\n'+"tA12NoSP="+tA12NoSP+'\n'+"tPC01CH="+tPC01CH);

	if (tCH02KF > 0)
		tCH02KFcombo = Math.min(tCH02KF, (tA12KFSPCombo + tC84KFSPCombo + tJ99KFSPCombo + tN72KFSPCombo + tT15KFSPCombo + tB16KFSPCombo + 
		tA12KASPCombo + tC84KASPCombo + tJ99KASPCombo + tN72KASPCombo + tT15KASPCombo + tB16KASPCombo));		// find number of CH02 combos			
	
	if (tCH02KFcombo > 0)
		if(tA12KASPCombo + tC84KASPCombo + tJ99KASPCombo + tN72KASPCombo + tT15KASPCombo + tD11KASPCombo + tB16KASPCombo > 0)
			document.getElementById("CH02-IN").disabled=false;
		else
			document.getElementById("CH02-IN").disabled=true;
	else
		document.getElementById("CH02-IN").disabled=true;


	if (tPC01CH > 0)
		tPC01CHcombo = Math.min(tPC01CH, (tA12KFNoSP + tC84KFNoSP + tJ99KFNoSP + tN72KFNoSP + tT15KFNoSP + tA12KANoSP + tC84KANoSP + tJ99KANoSP + tN72KANoSP + tT15KANoSP));	// find number of complete kits
	
	if(tPC01CHcombo > 0)
		if (tA12KANoSP + tC84KANoSP + tJ99KANoSP + tN72KANoSP + tT15KANoSP > 0)
			document.getElementById("PC01-IN").disabled=false;
		else
			document.getElementById("PC01-IN").disabled=true;
	else
		document.getElementById("PC01-IN").disabled=true;

	tA12 = tA12KF + tA12KA - tA12BKA;
	tJ99 = tJ99KF + tJ99KA - tJ99BKA;

	if (tA12 > 0 && tSC10 > 0) { // at least 1 A12/SC10 combo
		tA12SC10Combo = Math.min(tA12, tSC10); // number of A12 combos
	}
	
	if (tA12 > 0 && tSC25 > 0) { // at least 1 A12/SC25 combo
		tA12SC25Combo = Math.min((tA12 - tA12SC10Combo), tSC25); // number of A12 combos
	}
	
	if (tJ99 > 0 && tSC99 > 1) { // at least 1 J99/SC99 combo
		tJ99SC99Combo = Math.min((2*tJ99), (Math.floor(tSC99/2)*2)); // number of J99 combos
	}
	
	if (tCH02KF > 0 && tWH01 > 0) { // at least 1 CH02/WH01 combo
		tCHKF_WHcombo = Math.min(tCH02KF, tWH01); // number of CH02KF/WH01 combos
	}
}


function ApplyDiscs (item, num) { // Apply discounts
	var d, i=0, j=0, f=0, d=0, app=0;
	var notAlphaNum = /[^A-Z,0-9,-]/i;
	
	if (num > 0) { // apply discounts
		for (i in order) {
			d = order[i].des;
			j = d.search(notAlphaNum);
			if (j > 0) d = d.substring(0, j);		// strip off +S, +L, +H
			if (d == item) {
				if (order[i].qty > 0) {
					app = Math.min(num, order[i].qty);
//					alert ("Item = " + item + '\n' + "Num = " + num + '\n' + "App = " + app);
					order[i].qty = order[i].qty - app;
					order[i].dsc = order[i].dsc + app;
					f	= order[i].qty * order[i].full + order[i].dsc * order[i].full;
					d = order[i].qty * order[i].full + order[i].dsc * order[i].disc;
					tdif += (f - d) * 1.0;
//					alert ("Full = " + f + '\n' + "Disc = " + d + '\n' + "Diff = " + tdif);
				}
			}
		}
	}
	return app;
}


function ClearDiscs () { // Clear discounts
	var d,i,qty=0;
	tdif=0;
	tapp=0;
	for (i in order) {
		d = order[i].des;
		if (d) {
			if (order[i].dsc > 0) {
				qty = order[i].dsc * 1.0;
				order[i].qty = order[i].qty + qty;
				order[i].dsc = 0;
			}
	  }	
	}
}


function MakeOrder (id) {  					// handle the 'add'
	var n, qty, name, full, disc, weight;
	var digits = /[0-9]/i;
  
	n = id.substring(id.search(digits));  				// get number part of ID
	qty = document.getElementById("qty" + n).value;		// get qty
	if (isNaN (qty)) {									// test entry
		alert (n + " is not a valid number!  Try again.");
		return;
	}
 
	name = document.getElementById("name" + n).value;
	full = document.getElementById("full" + n).value;
	disc = document.getElementById("disc" + n).value;
	weight = document.getElementById("wght" + n).value;
	document.getElementById("dlr" + n).value = Dollar (qty * full);
	document.getElementById("toz" + n).value = qty * weight;
	if (cntr == 0) order = new Object (); 	// zap object
	cntr = cntr + 1;												// bump counter so no zap next time
	order[id] = new Object ();							// (re)create entry
	order[id].des = name;										// description
	order[id].full = Dollar (full);					// full price
	order[id].disc = Dollar (disc);					// discount price
	order[id].qty = qty;										// full price quantity
	order[id].dsc = 0;											// discount quantity
	if (weight) 
		order[id].wgt = weight * 1.0;
	else 
		order[id].wgt = 0;
				
//	order.sort(SortOrder);
}


function SortOrder(a, b) {		// sort by size of discount
	var adisc, bdisc;
	
	adisc = a.full - a.disc;
	bdisc = b.full - b.disc;
	
	return (bdisc - adisc)
}


function GetSelect (id) {  // handle select list
	var n, s, name, fullPrice, discPrice, weight;
	var digits = /[0-9]/i;

	n = id.substring(id.search(digits)); 																				// get number part of ID
	if (s = document.getElementById("slct" + n).value) {												// get select string
		name = s.substring(0, s.indexOf(",")); 																		// get name
		s = s.substring(s.indexOf(",")+1);
		fullPrice = s.substring(0, s.indexOf(",")); 															// get full price
		s = s.substring(s.indexOf(",")+1);
		discPrice = s.substring(0, s.indexOf(",")); 															// get discount price
		weight = s.substring(s.indexOf(",")+1);																		// get weight
		document.getElementById("prc" + n).innerHTML = "<b>$"+fullPrice+"</b>";		// write full price to page
		document.getElementById("name" + n).value = name;													// save full price
		document.getElementById("full" + n).value = fullPrice;										// save full price
		document.getElementById("disc" + n).value = discPrice;										// save discount price
		document.getElementById("wght" + n).value = weight;												// save full price
		GetOrder ("id" + n);																											// click 'add'
	}
}


function GetOrder (id) {  // get all ordered items
	MakeOrder (id);
	ClearDiscs ();
	CheckDiscs ();
	ApplyDiscs ("PC01-CH", tPC01CHcombo);
	ApplyDiscs ("CH02KF", tCH02KFcombo);
	ApplyDiscs ("SC10KA", tA12SC10Combo);
	ApplyDiscs ("SC25KA", tA12SC25Combo);
	ApplyDiscs ("SC99KA", tJ99SC99Combo);
	
	ApplyDiscs ("CH02SP-A12", tA12KFSPCombo);
	ApplyDiscs ("CH02SP-C84", tC84KFSPCombo);
	ApplyDiscs ("CH02SP-J99", tJ99KFSPCombo);
	ApplyDiscs ("CH02SP-N72", tN72KFSPCombo);
	ApplyDiscs ("CH02SP-T15", tT15KFSPCombo);
	ApplyDiscs ("CH02SP-D11", tD11KFSPCombo);
	ApplyDiscs ("CH02SP-B16", tB16KFSPCombo);

	ApplyDiscs ("CH02SP-A12", tA12KASPCombo);
	ApplyDiscs ("CH02SP-C84", tC84KASPCombo);
	ApplyDiscs ("CH02SP-J99", tJ99KASPCombo);
	ApplyDiscs ("CH02SP-N72", tN72KASPCombo);
	ApplyDiscs ("CH02SP-T15", tT15KASPCombo);
	ApplyDiscs ("CH02SP-D11", tD11KASPCombo);
	ApplyDiscs ("CH02SP-B16", tB16KASPCombo);

	CalcTotals ();
	ResetDropdown();
	EnableCheckout();
//		shpr = 0;
	DispTots ();
}


function SendCart () {  // send the cart to PayPal
	var winpar = "width=800,height=600,scrollbars," +
	             "location,resizable,status";
	var strn   = "https://www.paypal.com/cgi-bin/webscr?cmd=_cart" +
	             "&upload=1" +
	             "&business=" + root.xx_id + root.xx_xtra;
	var i, j=0, des;

  if (root.xx_cur.length > 0)
    strn = strn + "&currency_code=" + root.xx_cur;
  if (root.xx_lc.length > 0)
    strn = strn + "&lc=" + root.xx_lc;
  if (root.xx_can.length > 0)
    strn = strn + "&cancel_return=" + root.xx_can;
  if (root.xx_ret.length > 0)
    strn = strn + "&return=" + root.xx_ret;
  if (root.xx_sty.length > 0)
    strn = strn + "&page_style=" + root.xx_sty;
  if (root.xx_img.length > 0)
    strn = strn + "&image_url=" + root.xx_img;
		
  for (i in order) {  															// send all valid data
    if (order[i].qty > 0) {													// add full price items
      j = j + 1;
      des = order[i].des;
      if (j == 1) {  																// put in descriptions for 1st item
        des = des + ", " + stxt;
      }
      strn = strn + "&item_name_"    + j + "=" + escape (des) +
										"&quantity_"     + j + "=" + order[i].qty +
                   	"&amount_"       + j + "=" + order[i].full;
		}
				
		if (order[i].dsc > 0) {	// add discounted items
			j = j + 1;
			des = order[i].des;
			if (j == 1) {  // put in descriptions for 1st item
			  des = des + ", " + stxt;
			}
			strn = strn + "&item_name_"    + j + "=" + escape (des) +
										"&quantity_"     + j + "=" + order[i].dsc +
	                  "&amount_"       + j + "=" + order[i].disc;
		}
  } 

	if (shpr > 0) {  // there is some shipping activity
     strn = strn + "&shipping_" + j + "=" + Dollar (shpr);
//		alert ("shpr = " + shpr + '\n' + "j = " + j);
 	}

	if (EnableCheckout()) 
		window.open (strn, "paypal", winpar);
//		alert(strn);
	else {
		alert("Can't send cart, totals are not correct!");
		return false;
	}
}


function SendUPS(){
	var sShipToWgt = document.getElementById("totwgt").value;
	var sShipToZip = document.getElementById("ZipCode").value;
	
	//	validate zip
	if (isNaN(sShipToZip) || sShipToZip.length != 5){
		 alert("ZIP code must be 5 digits!");
		 return false;
	}
	//	validate wgt
	if (isNaN(sShipToWgt) || sShipToWgt < 1 || sShipToWgt > 100){
		alert("Weight must be between 1 and 100");
		return false;
	}
	//	validate country
	if (sShipToCountry != "US"){
		 alert("Cart only accepts US addresses at this time");
		 return false;
	}

	GetUPSXMLRate(sShipToWgt, sShipToZip, sShipToCountry);
	return true;
}


function DispTots () {  // display totals on the page
  document.getElementById("sub").value = Dollar (tfull + tdsc);
  document.getElementById("totwgt").value = twgt;
  document.getElementById("shp").value = Dollar (shpr);
  document.getElementById("dsc").value = Dollar (tdif);
  document.getElementById("tot").value = Dollar (tfull + tdsc + shpr);
}


function OnRateSelect(){
	var d = document.getElementById('UPSDropdown');
	if(d) {
		var rateIndex = d.selectedIndex;
		var svcName = d.options[rateIndex].text;
		var rate = d.options[rateIndex].text;
		svcName = svcName.substring(0, svcName.indexOf("$") - 2);
		rate = rate.substring(rate.indexOf("$") + 1);
		shpr = rate * 1.0;
		stxt = svcName;
		DispTots();
		EnableCheckout();
	}
}


function EnableGetRates(){
	var d = document.getElementById("GetRates");
	if(d != null){
		if(ValidZip() && (twgt > 0))
			d.disabled=false;
		else
			d.disabled=true;
	}
}


function EnableCheckout(){
	var d = document.getElementById("terms");
	var e = document.getElementById("Checkout");
	var subtotal = tfull + tdsc;
	if(ValidZip() && (d.checked == true) && (subtotal > 0) && (shpr > 0) && (twgt > 0)) {
		e.disabled=false;
		return true;
	}
	else {
		e.disabled=true;
		return false;
	}
}


function ValidZip(){	//	validate zip
	var d = document.getElementById("ZipCode");
	if (isNaN(d.value) || d.value.length != 5)
		return false;
	else
		return true;
}


function OnZipChange(){
	var d = document.getElementById("ZipCode");

	if(ValidZip())
		sShipToZip = d.value;
	else
		sShipToZip = "";

	ResetDropdown();
	EnableCheckout();
	shpr = 0;
	DispTots();
}


function ResetDropdown(){
	var txt="<input name='GetRates' type= 'button' value= 'Get UPS Rates' onclick= 'SendUPS();' />"
	if(document.getElementById('RateDropdown')){
		document.getElementById('RateDropdown').innerHTML=txt;
		shpr = 0;
		DispTots();
		EnableCheckout();
	}
}


function Reset() { // reset objects
//	var d = document.orderf;

	order = null;
	cntr = 0;
	ClearDiscs ();
	CalcTotals ();
	ResetDropdown();
	EnableCheckout();
	document.getElementById("CH02-IN").disabled=true;;
	document.getElementById("PC01-IN").disabled=true;;
}


function wopen(url, name, w, h)
{
  // Fudge factors for window decoration space.
  w += 32;
  h += 96;
  wleft = (screen.width - w) / 2;
  wtop = (screen.height - h) / 2;
  // IE5 and other old browsers might allow a window that is
  // partially offscreen or wider than the screen. Fix that.
  // (Newer browsers fix this for us, but let's be thorough.)
  if (wleft < 0) {
    w = screen.width;
    wleft = 0;
  }
  if (wtop < 0) {
    h = screen.height;
    wtop = 0;
  }
  var win = window.open(url, name,
  'width=' + w + ', height=' + h + ', ' +
  'left=' + wleft + ', top=' + wtop + ', ' +
  'location=no, locationbar=no, personalbar=no, menubar=no, ' +
  'statusbar=no, navbar=no, toolbar=no, scrollbars=no, resizable=no');
  // Just in case width and height are ignored
  win.resizeTo(w, h);
  // Just in case left and top are ignored
  win.moveTo(wleft, wtop);
  win.focus();
}


function ShowPop(s, n) { // display popup
	var popup = null;
	
	if(n > 0) {
		if(s == 'A12') {
			wopen('A12_popup.htm', '', 500, 200);
		}
		else if(s == 'J99') {
			wopen('J99_popup.htm', '', 500, 200);
		}
		else if(s == 'Terms') {
			wopen('Terms_popup.htm', '', 700, 660);
		}
	}
}