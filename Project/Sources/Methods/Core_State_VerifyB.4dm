//%attributes = {}
//Method:  Core_State_VerifyB(ptState{;bReturnAbbreviation})=>bVerify
//Desctiption: This method will abbreviate for US states

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $ptState)
	C_BOOLEAN:C305($2; $bReturnAbbreviation)
	C_BOOLEAN:C305($0; $bVerify)
	C_COLLECTION:C1488($cStateAbbreviationFull)
	
	ARRAY TEXT:C222($atStripCharacter; 0)
	ARRAY TEXT:C222($atFrontBack; 0)
	
	$bReturnAbbreviation:=False:C215
	
	If (Count parameters:C259>=1)
		$ptState:=$1
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
	
	If (True:C214)  //State Abbreviation
		
		$cStateAbbreviationFull:=New collection:C1472()
		
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "AA"; "tFull"; "Armed Forces America"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "AE"; "tFull"; "Armed Forces"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "AK"; "tFull"; "Alaska"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "AL"; "tFull"; "Alabama"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "AP"; "tFull"; "Armed Forces Pacific"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "AR"; "tFull"; "Arkansas"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "AZ"; "tFull"; "Arizona"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "CA"; "tFull"; "California"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "CO"; "tFull"; "Colorado"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "CT"; "tFull"; "Connecticut"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "DC"; "tFull"; "Washington DC"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "DE"; "tFull"; "Delaware"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "FL"; "tFull"; "Florida"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "GA"; "tFull"; "Georgia"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "GU"; "tFull"; "Guam"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "HI"; "tFull"; "Hawaii"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "IA"; "tFull"; "Iowa"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "ID"; "tFull"; "Idaho"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "IL"; "tFull"; "Illinois"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "IN"; "tFull"; "Indiana"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "KS"; "tFull"; "Kansas"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "KY"; "tFull"; "Kentucky"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "LA"; "tFull"; "Louisiana"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "MA"; "tFull"; "Massachusetts"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "MD"; "tFull"; "Maryland"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "ME"; "tFull"; "Maine"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "MI"; "tFull"; "Michigan"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "MN"; "tFull"; "Minnesota"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "MO"; "tFull"; "Missouri"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "MS"; "tFull"; "Mississippi"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "MT"; "tFull"; "Montana"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "NC"; "tFull"; "North Carolina"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "ND"; "tFull"; "North Dakota"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "NE"; "tFull"; "Nebraska"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "NH"; "tFull"; "New Hampshire"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "NJ"; "tFull"; "New Jersey"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "NM"; "tFull"; "New Mexico"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "NV"; "tFull"; "Nevada"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "NY"; "tFull"; "New York"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "OH"; "tFull"; "Ohio"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "OK"; "tFull"; "Oklahoma"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "OR"; "tFull"; "Oregon"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "PA"; "tFull"; "Pennsylvania"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "PR"; "tFull"; "Puerto Rico"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "RI"; "tFull"; "Rhode Island"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "SC"; "tFull"; "South Carolina"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "SD"; "tFull"; "South Dakota"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "TN"; "tFull"; "Tennessee"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "TX"; "tFull"; "Texas"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "UT"; "tFull"; "Utah"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "VA"; "tFull"; "Virginia"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "VI"; "tFull"; "Virgin Islands"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "VT"; "tFull"; "Vermont"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "WA"; "tFull"; "Washington"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "WI"; "tFull"; "Wisconsin"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "WV"; "tFull"; "West Virginia"))
		$cStateAbbreviationFull.push(New object:C1471("tAbbreviation"; "WY"; "tFull"; "Wyoming"))
		
	End if   //Done state abbreviation
	
End if   //Done inititialize

$ptState->:=Core_Text_RemoveGremlinsT($ptState->)
$ptState->:=Core_Text_RemoveT($ptState->; ->$atStripCharacter)
$ptState->:=Core_Text_RemoveT($ptState->; ->$atFrontBack; 3)

$nAbbreviation:=$cStateAbbreviationFull.findIndex("Core_State_Abbreviation"; $ptState->)
$nFull:=$cStateAbbreviationFull.findIndex("Core_State_Full"; $ptState->)

Case of   //Verify
		
	: ($nAbbreviation>=0)  //Abbreviation good
		
		$ptState->:=Uppercase:C13($ptState->)
		
	: ($nFull>=0)  //Full good
		
		If ($bReturnAbbreviation)
			
			$ptState->:=$cStateAbbreviationFull[$nFull].tAbbreviation
			
		End if 
		
	Else   //Failed
		
		$bVerify:=False:C215
		
End case   //Done verify

$0:=$bVerify