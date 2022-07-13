//%attributes = {"publishedWeb":true}
//(p) CartSpecOvrUndr
//• 5/23/97 cs  created upr 1857
//moved code from script in order type to here for cspeclikeFG
//• 7/15/97 cs replaced reference to a field
//•10/16/97 cs added one optional incomming parameter
//$1 (optional) string anything - flag do not post mesage regarding standard if no
//cust/ordertype found (called from a before phase

READ ONLY:C145([Customers:16])  //avoid locking the customer record

qryCustomer(->[Customers:16]ID:1; [Estimates_Carton_Specs:19]CustID:6)  //do so
//ALL SUBRECORDS([Customers]OverUnderRuns)
[Estimates_Carton_Specs:19]OverRun:47:=0
[Estimates_Carton_Specs:19]UnderRun:48:=0

If ([Estimates_Carton_Specs:19]OrderType:8#"") & (Records in selection:C76([Customers:16])>0)  //• 7/15/97 cs replaced above code Mel found ref to wrong field
	Case of 
		: (Position:C15("reg"; [Estimates_Carton_Specs:19]OrderType:8)>0)
			[Estimates_Carton_Specs:19]OverRun:47:=[Customers:16]Run_Over_Regular_Order:63
			[Estimates_Carton_Specs:19]UnderRun:48:=[Customers:16]Run_Under_Regular_Order:64
		: (Position:C15("promo"; [Estimates_Carton_Specs:19]OrderType:8)>0)
			[Estimates_Carton_Specs:19]OverRun:47:=[Customers:16]Run_Over_Promo_Order:65
			[Estimates_Carton_Specs:19]UnderRun:48:=[Customers:16]Run_Under_Promo_Order:66
	End case 
	
Else 
	If (Count parameters:C259=0)
		uConfirm("Use standard over/under run?"; "Yes 5%"; "No")
		If (OK=1)
			[Estimates_Carton_Specs:19]OverRun:47:=5
			[Estimates_Carton_Specs:19]UnderRun:48:=5
		End if 
	End if 
End if 