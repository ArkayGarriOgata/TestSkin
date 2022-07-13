//%attributes = {"publishedWeb":true}
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	C_TEXT:C284($1)  //uBuildAddrSelec
	C_POINTER:C301($2; $3; $cust; $billTo)
	If (Count parameters:C259=3)
		$cust:=$2
		$billTo:=$3
	Else 
		$cust:=->[Estimates:17]Cust_ID:2
		$billTo:=->[Estimates:17]z_Bill_To_ID:5
	End if 
	QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=$cust->; *)
	QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3=$1)
	RELATE ONE SELECTION:C349([Customers_Addresses:31]; [Addresses:30])
	If (Records in selection:C76([Addresses:30])>0)
		If ($billTo->="")
			FIRST RECORD:C50([Addresses:30])
			$billTo->:=[Addresses:30]ID:1
		Else 
			FIRST RECORD:C50([Addresses:30])
			While ((Not:C34(End selection:C36([Addresses:30]))) & ($billTo->#[Addresses:30]ID:1))
				NEXT RECORD:C51([Addresses:30])
			End while 
		End if 
		If ($1#"Ship to")
			Text2:=fGetAddressText
		Else 
			//Text23:=fGetAddressText 
			//Text24:=Text23
		End if 
	Else 
		$billTo->:=""
		Text2:="Bill to address not available."
	End if 
	
Else 
	//4D PS: we can optimize from ligne 11 to 13 just by using one query to obtain adress
	
	C_TEXT:C284($1)  //uBuildAddrSelec
	C_POINTER:C301($2; $3; $cust; $billTo)
	If (Count parameters:C259=3)
		$cust:=$2
		$billTo:=$3
	Else 
		$cust:=->[Estimates:17]Cust_ID:2
		$billTo:=->[Estimates:17]z_Bill_To_ID:5
	End if 
	QUERY:C277([Addresses:30]; [Customers_Addresses:31]CustID:1=$cust->; *)
	QUERY:C277([Addresses:30];  & ; [Customers_Addresses:31]AddressType:3=$1)
	If (Records in selection:C76([Addresses:30])>0)
		If ($billTo->="")
			$billTo->:=[Addresses:30]ID:1
		Else 
			// 4d replace while
			QUERY SELECTION:C341([Addresses:30]; [Addresses:30]ID:1=$billTo)
			
		End if 
		If ($1#"Ship to")
			Text2:=fGetAddressText
		End if 
	Else 
		$billTo->:=""
		Text2:="Bill to address not available."
	End if 
	
End if   // END 4D Professional Services : January 2019 First record

