//%attributes = {"publishedWeb":true}
//PM:  RM_onHandRpt  4/25/00  mlb
//report the rm inventory
// • mel (4/15/04, 15:14:01) add sheetingvendor location
// Modified by: Mel Bohince (6/6/17) add consignment column and print settings for pdf choice

If (Count parameters:C259=0)
	C_LONGINT:C283(rbAll; rbArkay; rbRoanoke)
	
	DIALOG:C40([Raw_Materials_Locations:25]; "onHandSearch")
	$continue:=(ok=1)
	ERASE WINDOW:C160
	Case of 
		: (rbArkay=1)
			binLocation:="H@"
		: (rbRoanoke=1)
			binLocation:="R@"
		: (rbVistaWH=1)
			binLocation:="V@"
		: (rbOutside=1)
			binLocation:="S@"
		Else 
			binLocation:="@"
	End case 
Else 
	sCommKey:=$1
	binLocation:=$2
	$continue:=True:C214
End if 

If ($continue)
	READ ONLY:C145([Raw_Materials_Transactions:23])  // used in reporrt's script poitemkey
	READ ONLY:C145([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Warehouse:29=binLocation; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Commodity_Key:12=sCommKey)
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Commodity_Key:12; >; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >; [Raw_Materials_Locations:25]Warehouse:29; >; [Raw_Materials_Locations:25]POItemKey:19; >)
		BREAK LEVEL:C302(3)
		ACCUMULATE:C303([Raw_Materials_Locations:25]QtyOH:9; [Raw_Materials_Locations:25]ConsignmentQty:26; extendedCost; rOnHand; rOHPrice; rOnConsign)
		FORM SET OUTPUT:C54([Raw_Materials_Locations:25]; "OnHandReport")
		util_PAGE_SETUP(->[Raw_Materials_Locations:25]; "OnHandReport")
		If (Length:C16(<>pdfFileName)=0)
			<>pdfFileName:="OnHandByCommodity.pdf"
		End if 
		
		PDF_setUp(<>pdfFileName)
		If (Count parameters:C259=0)
			PRINT SETTINGS:C106
		End if 
		
		PRINT SELECTION:C60([Raw_Materials_Locations:25]; *)
		
		FORM SET OUTPUT:C54([Raw_Materials_Locations:25]; "List")
	Else 
		If (Count parameters:C259=0)
			BEEP:C151
			ALERT:C41("No bins for location = "+binLocation+" and Commodity Key = "+sCommKey)
		End if 
	End if 
	
End if 