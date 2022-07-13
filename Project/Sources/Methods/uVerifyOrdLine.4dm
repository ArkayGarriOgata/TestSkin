//%attributes = {"publishedWeb":true}
//Procedure: uVerifyOrdLine()  081495  MLB

C_TEXT:C284($OL; $release; $cpn)  //1/25/95
$OL:=<>Orderline
$release:=String:C10(<>Release)
$cpn:=<>CPN
<>CPN:=""
<>Release:=0
Open window:C153(250; 120; 600; 160; -722; "Verifing orderline "+$OL+" for release "+$release)

READ ONLY:C145([Customers_Order_Lines:41])  //uChgEstSTatus
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$OL)
If (Records in selection:C76([Customers_Order_Lines:41])=1)
	If ([Customers_Order_Lines:41]ProductCode:5#$cpn)
		BEEP:C151
		ALERT:C41("Product code doesn't match on Orderline "+$OL+" and release "+$release)
		<>Orderline:="REJECT"
	Else 
		<>Orderline:="SAVE"
	End if 
Else 
	BEEP:C151
	ALERT:C41("Could not find orderline "+$OL+" for linking to release "+$release+".")
	<>Orderline:="REJECT"
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Customers_Order_Lines:41])
	
Else 
	
	// you have read only mode line 12
	
	
End if   // END 4D Professional Services : January 2019 

CLOSE WINDOW:C154
//