//(S) [CUST_CUST_ADDR]Input'[CUST_ADDRESS]State
//. Modified by Garri Ogata to assure valid state abbreviation

Case of   //Verify state
		
	: ([Addresses:30]Country:9#"US")
	: (Core_State_VerifyB(->[Addresses:30]State:7; True:C214))
		
	Else   //
		
		C_OBJECT:C1216($oAlert)
		$oAlert:=New object:C1471()
		$oAlert.tMessage:="Please enter a valid US state."
		
		Core_Dialog_Alert($oAlert)
		
End case   //Done verify state

//***OLD
//If (Length([Addresses]State)=2)
//[Addresses]State:=Uppercase([Addresses]State)
//End if 

//****other
//If (([Addresses]Country="US")
//$usStateAbbreviationsAllowed:="AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR "
//$abbreviationEntered:=Uppercase(Substring([Addresses]State;1;2))
//If ((Position($abbreviationEntered;$usStateAbbreviationsAllowed)>0))
//[Addresses]State:=$abbreviationEntered
//Else 
//uConfirm ("Valid US state abbreviations are "+$usStateAbbreviationsAllowed;"Try again";"Lookup")
//If (ok=0)
//OPEN URL("https://about.usps.com/who-we-are/postal-history/state-abbreviations.htm")
//End if 
//[Addresses]State:=""
//GOTO OBJECT([Addresses]State)
//End if 
//End if 


