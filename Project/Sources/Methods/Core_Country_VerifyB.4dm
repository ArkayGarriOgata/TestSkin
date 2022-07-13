//%attributes = {}
//Method:  Core_Country_VerifyB(ptCountry{;bReturnAbbreviation})=>bVerify
//Desctiption: This method will abbreviate country codes 
C_COLLECTION:C1488($cCountryAbbreviationFull)

$cCountryAbbreviationFull:=New collection:C1472()

$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AD"; "tFull"; "Andorra"))
$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AO"; "tFull"; "Angola"))
$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AI"; "tFull"; "Anguilla"))
$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AQ"; "tFull"; "Antarctica"))
$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AG"; "tFull"; "Antigua and Barbuda"))
$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AR"; "tFull"; "Argentina"))
$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AM"; "tFull"; "Armenia"))
$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AW"; "tFull"; "Aruba"))
$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AU"; "tFull"; "Australia"))


If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $ptCountry)
	C_BOOLEAN:C305($2; $bReturnAbbreviation)
	C_BOOLEAN:C305($0; $bVerify)
	C_COLLECTION:C1488($cCountryAbbreviationFull)
	
	ARRAY TEXT:C222($atStripCharacter; 0)
	ARRAY TEXT:C222($atFrontBack; 0)
	
	$bReturnAbbreviation:=False:C215
	
	If (Count parameters:C259>=1)
		$ptCountry:=$1
		If (Count parameters:C259>=2)
			$bReturnAbbreviation:=$2
		End if 
	End if 
	
	$bVerify:=True:C214
	
	APPEND TO ARRAY:C911($atStripCharacter; CorektPeriod)
	APPEND TO ARRAY:C911($atStripCharacter; CorektLeftParen)
	APPEND TO ARRAY:C911($atStripCharacter; CorektRightParen)
	APPEND TO ARRAY:C911($atStripCharacter; CorektCR)
	APPEND TO ARRAY:C911($atStripCharacter; Char:C90(Tab:K15:37))
	APPEND TO ARRAY:C911($atStripCharacter; CorektComma)
	APPEND TO ARRAY:C911($atStripCharacter; "0")
	APPEND TO ARRAY:C911($atStripCharacter; "1")
	APPEND TO ARRAY:C911($atStripCharacter; "2")
	APPEND TO ARRAY:C911($atStripCharacter; "3")
	APPEND TO ARRAY:C911($atStripCharacter; "4")
	APPEND TO ARRAY:C911($atStripCharacter; "5")
	APPEND TO ARRAY:C911($atStripCharacter; "6")
	APPEND TO ARRAY:C911($atStripCharacter; "7")
	APPEND TO ARRAY:C911($atStripCharacter; "8")
	APPEND TO ARRAY:C911($atStripCharacter; "9")
	
	APPEND TO ARRAY:C911($atFrontBack; CorektSpace)
	
	If (True:C214)  //Country
		
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AF"; "tFull"; "Afghanistan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AL"; "tFull"; "Albania"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "DZ"; "tFull"; "Algeria"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AS"; "tFull"; "American Samoa"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AD"; "tFull"; "Andorra"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AO"; "tFull"; "Angola"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AI"; "tFull"; "Anguilla"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AQ"; "tFull"; "Antarctica"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AG"; "tFull"; "Antigua and Barbuda"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AR"; "tFull"; "Argentina"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AM"; "tFull"; "Armenia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AW"; "tFull"; "Aruba"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AU"; "tFull"; "Australia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AT"; "tFull"; "Austria"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AZ"; "tFull"; "Azerbaijan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BS"; "tFull"; "Bahamas(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BH"; "tFull"; "Bahrain"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BD"; "tFull"; "Bangladesh"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BB"; "tFull"; "Barbados"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BY"; "tFull"; "Belarus"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BE"; "tFull"; "Belgium"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BZ"; "tFull"; "Belize"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BJ"; "tFull"; "Benin"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BM"; "tFull"; "Bermuda"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BT"; "tFull"; "Bhutan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BO"; "tFull"; "Bolivia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BQ"; "tFull"; "Bonaire, Sint Eustatius and Saba"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BA"; "tFull"; "Bosnia and Herzegovina"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BW"; "tFull"; "Botswana"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BV"; "tFull"; "Bouvet Island"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BR"; "tFull"; "Brazil"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IO"; "tFull"; "British Indian Ocean Territory(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BN"; "tFull"; "Brunei Darussalam"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BG"; "tFull"; "Bulgaria"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BF"; "tFull"; "Burkina Faso"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BI"; "tFull"; "Burundi"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CV"; "tFull"; "Cabo Verde"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KH"; "tFull"; "Cambodia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CM"; "tFull"; "Cameroon"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CA"; "tFull"; "Canada"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KY"; "tFull"; "Cayman Islands"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CF"; "tFull"; "Central African Republic(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TD"; "tFull"; "Chad"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CL"; "tFull"; "Chile"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CN"; "tFull"; "China"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CX"; "tFull"; "Christmas Island"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CC"; "tFull"; "Cocos(Keeling)Islands(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CO"; "tFull"; "Colombia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KM"; "tFull"; "Comoros(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CD"; "tFull"; "Congo(the Democratic Republic of the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CG"; "tFull"; "Congo(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CK"; "tFull"; "Cook Islands(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CR"; "tFull"; "Costa Rica"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "HR"; "tFull"; "Croatia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CU"; "tFull"; "Cuba"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CW"; "tFull"; "Curaçao"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CY"; "tFull"; "Cyprus"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CZ"; "tFull"; "Czechia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CI"; "tFull"; "Côte d'Ivoire"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "DK"; "tFull"; "Denmark"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "DJ"; "tFull"; "Djibouti"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "DM"; "tFull"; "Dominica"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "DO"; "tFull"; "Dominican Republic(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "EC"; "tFull"; "Ecuador"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "EG"; "tFull"; "Egypt"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SV"; "tFull"; "El Salvador"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GQ"; "tFull"; "Equatorial Guinea"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ER"; "tFull"; "Eritrea"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "EE"; "tFull"; "Estonia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SZ"; "tFull"; "Eswatini"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ET"; "tFull"; "Ethiopia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "FK"; "tFull"; "Falkland Islands(the)[Malvinas]"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "FO"; "tFull"; "Faroe Islands(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "FJ"; "tFull"; "Fiji"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "FI"; "tFull"; "Finland"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "FR"; "tFull"; "France"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GF"; "tFull"; "French Guiana"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PF"; "tFull"; "French Polynesia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TF"; "tFull"; "French Southern Territories(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GA"; "tFull"; "Gabon"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GM"; "tFull"; "Gambia(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GE"; "tFull"; "Georgia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "DE"; "tFull"; "Germany"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GH"; "tFull"; "Ghana"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GI"; "tFull"; "Gibraltar"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GR"; "tFull"; "Greece"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GL"; "tFull"; "Greenland"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GD"; "tFull"; "Grenada"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GP"; "tFull"; "Guadeloupe"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GU"; "tFull"; "Guam"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GT"; "tFull"; "Guatemala"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GG"; "tFull"; "Guernsey"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GN"; "tFull"; "Guinea"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GW"; "tFull"; "Guinea-Bissau"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GY"; "tFull"; "Guyana"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "HT"; "tFull"; "Haiti"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "HM"; "tFull"; "Heard Island and McDonald Islands"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "VA"; "tFull"; "Holy See(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "HN"; "tFull"; "Honduras"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "HK"; "tFull"; "Hong Kong"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "HU"; "tFull"; "Hungary"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IS"; "tFull"; "Iceland"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IN"; "tFull"; "India"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ID"; "tFull"; "Indonesia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IR"; "tFull"; "Iran(Islamic Republic of)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IQ"; "tFull"; "Iraq"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IE"; "tFull"; "Ireland"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IM"; "tFull"; "Isle of Man"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IL"; "tFull"; "Israel"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "IT"; "tFull"; "Italy"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "JM"; "tFull"; "Jamaica"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "JP"; "tFull"; "Japan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "JE"; "tFull"; "Jersey"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "JO"; "tFull"; "Jordan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KZ"; "tFull"; "Kazakhstan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KE"; "tFull"; "Kenya"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KI"; "tFull"; "Kiribati"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KP"; "tFull"; "Korea(the Democratic People's Republic of)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KR"; "tFull"; "Korea(the Republic of)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KW"; "tFull"; "Kuwait"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KG"; "tFull"; "Kyrgyzstan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LA"; "tFull"; "Lao People's Democratic Republic(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LV"; "tFull"; "Latvia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LB"; "tFull"; "Lebanon"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LS"; "tFull"; "Lesotho"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LR"; "tFull"; "Liberia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LY"; "tFull"; "Libya"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LI"; "tFull"; "Liechtenstein"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LT"; "tFull"; "Lithuania"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LU"; "tFull"; "Luxembourg"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MO"; "tFull"; "Macao"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MG"; "tFull"; "Madagascar"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MW"; "tFull"; "Malawi"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MY"; "tFull"; "Malaysia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MV"; "tFull"; "Maldives"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ML"; "tFull"; "Mali"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MT"; "tFull"; "Malta"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MH"; "tFull"; "Marshall Islands(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MQ"; "tFull"; "Martinique"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MR"; "tFull"; "Mauritania"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MU"; "tFull"; "Mauritius"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "YT"; "tFull"; "Mayotte"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MX"; "tFull"; "Mexico"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "FM"; "tFull"; "Micronesia(Federated States of)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MD"; "tFull"; "Moldova(the Republic of)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MC"; "tFull"; "Monaco"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MN"; "tFull"; "Mongolia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ME"; "tFull"; "Montenegro"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MS"; "tFull"; "Montserrat"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MA"; "tFull"; "Morocco"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MZ"; "tFull"; "Mozambique"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MM"; "tFull"; "Myanmar"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NA"; "tFull"; "Namibia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NR"; "tFull"; "Nauru"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NP"; "tFull"; "Nepal"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NL"; "tFull"; "Netherlands(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NC"; "tFull"; "New Caledonia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NZ"; "tFull"; "New Zealand"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NI"; "tFull"; "Nicaragua"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NE"; "tFull"; "Niger(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NG"; "tFull"; "Nigeria"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NU"; "tFull"; "Niue"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NF"; "tFull"; "Norfolk Island"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MP"; "tFull"; "Northern Mariana Islands(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "NO"; "tFull"; "Norway"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "OM"; "tFull"; "Oman"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PK"; "tFull"; "Pakistan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PW"; "tFull"; "Palau"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PS"; "tFull"; "Palestine, State of"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PA"; "tFull"; "Panama"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PG"; "tFull"; "Papua New Guinea"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PY"; "tFull"; "Paraguay"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PE"; "tFull"; "Peru"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PH"; "tFull"; "Philippines(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PN"; "tFull"; "Pitcairn"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PL"; "tFull"; "Poland"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PT"; "tFull"; "Portugal"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PR"; "tFull"; "Puerto Rico"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "QA"; "tFull"; "Qatar"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MK"; "tFull"; "Republic of North Macedonia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "RO"; "tFull"; "Romania"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "RU"; "tFull"; "Russian Federation(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "RW"; "tFull"; "Rwanda"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "RE"; "tFull"; "Réunion"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "BL"; "tFull"; "Saint Barthélemy"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SH"; "tFull"; "Saint Helena, Ascension and Tristan da Cunha"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "KN"; "tFull"; "Saint Kitts and Nevis"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LC"; "tFull"; "Saint Lucia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "MF"; "tFull"; "Saint Martin(French part)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "PM"; "tFull"; "Saint Pierre and Miquelon"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "VC"; "tFull"; "Saint Vincent and the Grenadines"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "WS"; "tFull"; "Samoa"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SM"; "tFull"; "San Marino"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ST"; "tFull"; "Sao Tome and Principe"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SA"; "tFull"; "Saudi Arabia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SN"; "tFull"; "Senegal"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "RS"; "tFull"; "Serbia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SC"; "tFull"; "Seychelles"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SL"; "tFull"; "Sierra Leone"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SG"; "tFull"; "Singapore"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SX"; "tFull"; "Sint Maarten(Dutch part)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SK"; "tFull"; "Slovakia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SI"; "tFull"; "Slovenia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SB"; "tFull"; "Solomon Islands"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SO"; "tFull"; "Somalia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ZA"; "tFull"; "South Africa"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GS"; "tFull"; "South Georgia and the South Sandwich Islands"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SS"; "tFull"; "South Sudan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ES"; "tFull"; "Spain"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "LK"; "tFull"; "Sri Lanka"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SD"; "tFull"; "Sudan(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SR"; "tFull"; "Suriname"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SJ"; "tFull"; "Svalbard and Jan Mayen"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SE"; "tFull"; "Sweden"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "CH"; "tFull"; "Switzerland"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "SY"; "tFull"; "Syrian Arab Republic"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TW"; "tFull"; "Taiwan(Province of China)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TJ"; "tFull"; "Tajikistan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TZ"; "tFull"; "Tanzania, United Republic of"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TH"; "tFull"; "Thailand"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TL"; "tFull"; "Timor-Leste"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TG"; "tFull"; "Togo"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TK"; "tFull"; "Tokelau"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TO"; "tFull"; "Tonga"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TT"; "tFull"; "Trinidad and Tobago"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TN"; "tFull"; "Tunisia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TR"; "tFull"; "Turkey"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TM"; "tFull"; "Turkmenistan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TC"; "tFull"; "Turks and Caicos Islands(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "TV"; "tFull"; "Tuvalu"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "UG"; "tFull"; "Uganda"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "UA"; "tFull"; "Ukraine"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AE"; "tFull"; "United Arab Emirates(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "GB"; "tFull"; "United Kingdom of Great Britain and Northern Ireland(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "UM"; "tFull"; "United States Minor Outlying Islands(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "US"; "tFull"; "United States of America(the)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "UY"; "tFull"; "Uruguay"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "UZ"; "tFull"; "Uzbekistan"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "VU"; "tFull"; "Vanuatu"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "VE"; "tFull"; "Venezuela(Bolivarian Republic of)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "VN"; "tFull"; "Viet Nam"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "VG"; "tFull"; "Virgin Islands(British)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "VI"; "tFull"; "Virgin Islands(U.S.)"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "WF"; "tFull"; "Wallis and Futuna"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "EH"; "tFull"; "Western Sahara"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "YE"; "tFull"; "Yemen"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ZM"; "tFull"; "Zambia"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "ZW"; "tFull"; "Zimbabwe"))
		$cCountryAbbreviationFull.push(New object:C1471("tAbbreviation"; "AX"; "tFull"; "Åland Islands"))
		
	End if   //Done country
	
End if   //Done inititialize

$ptCountry->:=Core_Text_RemoveGremlinsT($ptCountry->)
$ptCountry->:=Core_Text_RemoveT($ptCountry->; ->$atStripCharacter)
$ptCountry->:=Core_Text_RemoveT($ptCountry->; ->$atFrontBack; 3)

$nAbbreviation:=$cCountryAbbreviationFull.findIndex("Core_Country_Abbreviation"; $ptCountry->)
$nFull:=$cCountryAbbreviationFull.findIndex("Core_Country_Full"; $ptCountry->)

Case of   //Verify
		
	: ($nAbbreviation>=0)  //Abbreviation good
		
		$ptCountry->:=Uppercase:C13($ptCountry->)
		
	: ($nFull>=0)  //Full good
		
		If ($bReturnAbbreviation)
			
			$ptCountry->:=$cCountryAbbreviationFull[$nFull].tAbbreviation
			
		End if 
		
	Else   //Failed
		
		$bVerify:=False:C215
		
End case   //Done verify

$0:=$bVerify