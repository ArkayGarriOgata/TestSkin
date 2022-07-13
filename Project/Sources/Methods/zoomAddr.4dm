//%attributes = {"publishedWeb":true}
//(P) zoomAddr
C_LONGINT:C283($1; $temp)
C_POINTER:C301($2; $3)  // ptrs to foreign key and text var
$temp:=iMode
iMode:=$1
If ($temp<=2)
	iMode:=2
Else 
	iMode:=3
End if 
fromZoom:=True:C214
READ WRITE:C146([Addresses:30])
Case of 
	: ($1=3)  //via [Estimate]Input_bZoomBill
		//RELATE ONE([CustAddressLink]CustAddrID)
		//$thisOne:=Record number([Addresses])
		CUT NAMED SELECTION:C334([Customers_Addresses:31]; "Billtos")  //have to juggle the address link file
		CUT NAMED SELECTION:C334([Work_Orders:37]; "Shiptos")
		MODIFY RECORD:C57([Addresses:30]; *)
		USE NAMED SELECTION:C332("Billtos")
		USE NAMED SELECTION:C332("Shiptos")
		// GOTO RECORD([Addresses];$thisOne)
		[Estimates:17]z_Bill_To_ID:5:=[Addresses:30]ID:1
		Text2:=fGetAddressText
		
	: ($1=4)  //via [CustomerOrder][OrderLine][ReleaseSchedule].Input_bZoomBill{2}
		If (Count parameters:C259=3)
			QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$2->)
			MODIFY RECORD:C57([Addresses:30]; *)
			$2->:=[Addresses:30]ID:1
			$3->:=fGetAddressText
		Else 
			BEEP:C151
			ALERT:C41("Parameter error in (P)zoomAddr(4;nnnnn;»text)")
		End if 
		//: ($1=1)
		// ADD RECORD([Addresses];*)
		//: ($1=2)
		// RELATE ONE([CustAddressLink]CustAddrID)
		//  MODIFY RECORD([Addresses];*)
		
	Else 
		BEEP:C151
		ALERT:C41("That option is no longer available in (P)zoomAddr")
End case 
//READ ONLY([CUST_ADDRESS])
//UNLOAD RECORD([CUST_ADDRESS])
iMode:=$temp
fromZoom:=False:C215
//