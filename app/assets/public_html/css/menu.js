
function WriteHeader(path2nav) {
/*	var path2nav="../";*/
	document.write(
	"<div class=\"header\">" +
	"<img class=\"title_1\" src=\"" + path2nav + "images/title3.gif\">" +
	"<img class=\"logo_1\" src=\"" + path2nav + "images/logo4.gif\">" + 
	
	"<div class=\"spacer\">&nbsp;</div>" +
	"<div class=\"navmenu\">" +
		"<ul id=\"nav\">" +
			"<li class=\"top\"><a href=\"" + path2nav + "index.htm\">Home</a></li>" +

			"<li class=\"top\"><a href=\"" + path2nav + "products.htm\">Products</a>" +
				"<ul class=\"sub\">" +
					"<li><a href=\"" + path2nav + "products.htm#modules\" class=\"parent\">Modules</a>" +
						"<ul>" +
							"<li><a href=\"" + path2nav + "A12/a12_about.htm\" class=\"parent\">A12 Mic Pre</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "A12/a12_about.htm\">About the A12</a></li>" +
									"<li><a href=\"" + path2nav + "A12/a12_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "A12/A12R17/docs/a12_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "A12/A12R17/docs/a12_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "A12/A12R17/docs/a12_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
							"<li><a href=\"" + path2nav + "A12B/a12b_about.htm\" class=\"parent\">A12b Mic Pre</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "A12B/a12b_about.htm\">About the A12b</a></li>" +
									"<li><a href=\"" + path2nav + "A12B/a12b_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "A12B/A12BR11/docs/a12b_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "A12B/A12BR11/docs/a12b_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "A12B/A12BR11/docs/a12b_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
							"<li><a href=\"" + path2nav + "C84/c84_about.htm\" class=\"parent\">C84 Mic Pre</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "C84/c84_about.htm\">About the C84</a></li>" +
									"<li><a href=\"" + path2nav + "C84/c84_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "C84/C84R20/docs/c84_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "C84/C84R20/docs/c84_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "C84/C84R20/docs/c84_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
							"<li><a href=\"" + path2nav + "J99/j99_about.htm\" class=\"parent\">J99 Mic Pre</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "J99/j99_about.htm\">About the J99</a></li>" +
									"<li><a href=\"" + path2nav + "J99/j99_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "J99/J99R36/docs/j99_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "J99/J99R36/docs/j99_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "J99/J99R36/docs/j99_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
							"<li><a href=\"" + path2nav + "J99B/j99b_about.htm\" class=\"parent\">J99b Mic Pre</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "J99B/j99b_about.htm\">About the J99b</a></li>" +
									"<li><a href=\"" + path2nav + "J99B/j99b_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "J99B/J99BR11/docs/j99b_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "J99B/J99BR11/docs/j99b_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "J99B/J99BR11/docs/j99b_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
							"<li><a href=\"" + path2nav + "N72/n72_about.htm\" class=\"parent\">N72 Mic Pre</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "N72/n72_about.htm\">About the N72</a></li>" +
									"<li><a href=\"" + path2nav + "N72/n72_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "N72/N72R32/docs/n72_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "N72/N72R32/docs/n72_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "N72/N72R32/docs/n72_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
							"<li><a href=\"" + path2nav + "T15/t15_about.htm\" class=\"parent\">T15 Mic Pre</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "T15/t15_about.htm\">About the T15</a></li>" +
									"<li><a href=\"" + path2nav + "T15/t15_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "T15/T15R14/docs/t15_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "T15/T15R14/docs/t15_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "T15/T15R14/docs/t15_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
							"<li><a href=\"" + path2nav + "B16/b16_about.htm\" class=\"parent\">B16 Compressor</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "B16/b16_about.htm\">About the B16</a></li>" +
									"<li><a href=\"" + path2nav + "B16/b16_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "B16/B16R12/docs/b16_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "B16/B16R12/docs/b16_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "B16/B16R12/docs/b16_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
							"<li><a href=\"" + path2nav + "D11/d11_about.htm\" class=\"parent\">D11 Direct Input</a>" +
								"<ul>" +
									"<li><a href=\"" + path2nav + "D11/d11_about.htm\">About the D11</a></li>" +
									"<li><a href=\"" + path2nav + "D11/d11_specs.htm\">Specifications</a></li>" +
									"<li><a href=\"" + path2nav + "D11/D11R12/docs/d11_bom.pdf\">Bill of Materials</a></li>" +
									"<li><a href=\"" + path2nav + "D11/D11R12/docs/d11_sch.pdf\">Schematics</a></li>" +
									"<li><a href=\"" + path2nav + "D11/D11R12/docs/d11_asmbly.pdf\">Assembly Instructions</a></li>" +
								"</ul>" +
							"</li>" +
						"</ul>" +
					"</li>" +
					"<li><a href=\"" + path2nav + "products.htm#opamps\" class=\"parent\">Discrete Op-Amps</a>" +
						"<ul>" +
							"<li><a href=\"" + path2nav + "OpAmps/sc10_about.htm\">SC10 Op-Amp</a></li>" +
							"<li><a href=\"" + path2nav + "OpAmps/sc25_about.htm\">SC25 Op-Amp</a></li>" +
							"<li><a href=\"" + path2nav + "OpAmps/sc99_about.htm\">SC99 Op-Amp</a></li>" +
						"</ul>" +
					"</li>" +
					"<li><a href=\"" + path2nav + "products.htm#power\" class=\"parent\">OneShot Chassis</a>" +
						"<ul>" +
							"<li><a href=\"" + path2nav + "PC01/pc01_about.htm\">About the OneShot</a></li>" +
							"<li><a href=\"" + path2nav + "PC01/pc01_specs.htm\">Specifications</a></li>" +
							"<li><a href=\"" + path2nav + "PC01/docs/pc01_bom.pdf\">Bill of Materials</a></li>" +
							"<li><a href=\"" + path2nav + "PC01/docs/pc01_asmbly.pdf\">Assembly Instructions</a></li>" +
						"</ul>" +
					"</li>" +
					"<li><a href=\"" + path2nav + "products.htm#power\" class=\"parent\">CH02 Chassis</a>" +
						"<ul>" +
							"<li><a href=\"" + path2nav + "CH02/ch02_about.htm\">About the CH02</a></li>" +
							"<li><a href=\"" + path2nav + "CH02/ch02_specs.htm\">Specifications</a></li>" +
							"<li><a href=\"" + path2nav + "CH02/docs/ch02_bom.pdf\">Bill of Materials</a></li>" +
							"<li><a href=\"" + path2nav + "CH02/docs/ch02_asmbly.pdf\">Assembly Instructions</a></li>" +
						"</ul>" +
					"</li>" +
					"<li><a href=\"" + path2nav + "products.htm#power\" class=\"parent\">PS03 Power Supply</a>" +
						"<ul>" +
							"<li><a href=\"" + path2nav + "PS0X/PS03/ps03_about.htm\">About the PS03</a></li>" +
							"<li><a href=\"" + path2nav + "PS0X/PS03/ps03_specs.htm\">Specifications</a></li>" +
							"<li><a href=\"" + path2nav + "PS0X/PS03/docs/ps03_bom.pdf\">Bill of Materials</a></li>" +
							"<li><a href=\"" + path2nav + "PS0X/PS03/docs/ps03_sch.pdf\">Schematics</a></li>" +
						"</ul>" +
					"</li>" +
					"<li><a href=\"" + path2nav + "products.htm#power\" class=\"parent\">WH01 Harness</a>" +
						"<ul>" +
							"<li><a href=\"" + path2nav + "WH01/wh01_about.htm\">About the WH01</a></li>" +
							"<li><a href=\"" + path2nav + "WH01/wh01_specs.htm\">Specifications</a></li>" +
							"<li><a href=\"" + path2nav + "WH01/docs/wh01_bom.pdf\">Bill of Materials</a></li>" +
							"<li><a href=\"" + path2nav + "WH01/docs/wh01_sch.pdf\">Schematics</a></li>" +
						"</ul>" +
					"</li>" +
				"</ul>" +
			"</li>" +
		
			"<li class=\"top\"><a href=\"" + path2nav + "mainfaq.htm\">FAQ</a></li>" +
		
			"<li class=\"top\"><a href=\"" + path2nav + "msgboard.htm\">Forums</a></li>" +

			"<li class=\"top\"><a href=\"" + path2nav + "reviews.htm\">Reviews</a></li>" +
		
			"<li class=\"top\"><a href=\"#\">Support</a>" +
				"<ul class=\"sub\">" +
					"<li><a href=\"" + path2nav + "asmtips.htm\">Assembly Tips</a></li>" +
					"<li><a href=\"" + path2nav + "trouble.htm\">Troubleshooting</a></li>" +
					"<li><a href=\"" + path2nav + "repairs.htm\">Repairs</a></li>" +
					"<li><a href=\"" + path2nav + "links.htm\">Resources</a></li>" +
					"<li><a href=\"" + path2nav + "contact.htm\">Contact Us</a></li>" +
				"</ul>" +
			"</li>" +
		
			"<li class=\"top\"><a href=\"" + path2nav + "cart/cart.htm\">Order</a>" +
				"<ul class=\"sub\">" +
					"<li><a href=\"" + path2nav + "cart/cart.htm\">Shopping Cart</a></li>" +
					"<li><a href=\"" + path2nav + "instructions.htm\">Ordering Instructions</a></li>" +
					"<li><a href=\"" + path2nav + "terms.htm\">Terms of Sale</a></li>" +
				"</ul>" +
			"</li>" +
		"</ul>" +
	"</div>" +
"</div>"
)}
