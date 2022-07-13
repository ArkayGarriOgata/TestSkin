// _______
// Method: [Addresses].Input   ( ) ->
// _______
//Modified by Garri O defaulted country to US
// Modified by: MelvinBohince (1/20/22) do not save if US state is not valid

Case of 
	: (Form event code:C388=On Load:K2:1)
		//was beforeCadd: before phase processing for [CUST_ADDRESS]
		If (Is new record:C668([Addresses:30]))
			[Addresses:30]ID:1:=app_set_id_as_string(Table:C252(->[Addresses:30]))
			[Addresses:30]Country:9:="US"  //Modified by Garri O defaulted country to US
			
			Case of 
				: (sFile="CUSTOMER")
					[Customers_Addresses:31]CustAddrID:2:=[Addresses:30]ID:1
					SAVE RECORD:C53([Customers_Addresses:31])
				: (sFile="Addresses")
					RELATE MANY:C262([Addresses:30]ID:1)
			End case 
		Else 
			
			Case of 
				: ((sFile="Addresses") | (sFile="Estimate"))  //"CUST_ADDRESS")
					RELATE MANY:C262([Addresses:30]ID:1)
					ORDER BY:C49([Customers_Addresses:31]; [Customers_Addresses:31]AddressType:3; >; [Customers_Addresses:31]CustAddrID:2; >)
					UNLOAD RECORD:C212([Customers_Addresses:31])
					GOTO SELECTED RECORD:C245([Customers_Addresses:31]; 0)
					
			End case 
		End if 
		
	: (Form event code:C388=On Outside Call:K2:11)
		
		
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Addresses:30]ModDate:19; ->[Addresses:30]ModWho:20; ->[Addresses:30]zCount:18)
		
		If (Records in selection:C76([Customers:16])>0)
			UNLOAD RECORD:C212([Customers:16])  //upr 153
			READ WRITE:C146([Customers:16])
			LOAD RECORD:C52([Customers:16])
			
			[Customers:16]ModAddress:35:=4D_Current_date
			[Customers:16]ModFlag:37:=True:C214
			SAVE RECORD:C53([Customers:16])
		End if 
		//
		[Addresses:30]ModFlag:32:=False:C215
		If (Records in selection:C76([Customers_Addresses:31])>0)
			//*New way`•052799  mlb  UPR 236
			QUERY SELECTION:C341([Customers_Addresses:31]; [Customers_Addresses:31]AddressType:3="Bill to")
			$numFound:=Records in selection:C76([Customers_Addresses:31])
			If ($numFound>0)
				[Addresses:30]UpdateDynamics:35:=TSTimeStamp
				If (Length:C16([Addresses:30]DynamicsPrefix:36)=0)
					[Addresses:30]DynamicsPrefix:36:=Invoice_CustomerMapping
				End if 
				
			End if 
			
		Else 
			[Addresses:30]ModFlag:32:=False:C215
		End if 
		
		If ([Addresses:30]Country:9="US")  // Modified by: MelvinBohince (1/20/22) do not save if US state is not valid
			$usStateAbbreviationsAllowed:="AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR "
			$abbreviationEntered:=Uppercase:C13(Substring:C12([Addresses:30]State:7; 1; 2))
			If ((Position:C15($abbreviationEntered; $usStateAbbreviationsAllowed)>0))
				[Addresses:30]State:7:=$abbreviationEntered
			Else 
				uConfirm("Valid US state abbreviations are "+$usStateAbbreviationsAllowed; "Fix Later"; "Lookup")
				If (ok=0)
					OPEN URL:C673("https://about.usps.com/who-we-are/postal-history/state-abbreviations.htm")
				End if 
				[Addresses:30]State:7:=""
				ToDo_postTask(<>zResp; "Fix Address"; "Fix Address ID = "+[Addresses:30]ID:1+"'s State abbreviation"; ""; $today)
			End if 
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
End case 
//
//(S) [CUST_CUST_ADDR]Input'[CUST_ADDRESS]State
//. Modified by Garri Ogata to assure valid state abbreviation

