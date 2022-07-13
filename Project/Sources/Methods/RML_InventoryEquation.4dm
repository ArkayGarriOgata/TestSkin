//%attributes = {}
// -------
// Method: RML_InventoryEquation   ( ) ->
// By: Mel Bohince @ 06/04/18, 16:23:13
// Description
// method to see if transaction add up to perpetual
// ----------------------------------------------------
C_LONGINT:C283($0)
$0:=0
C_TEXT:C284($1; $msg)
If (Count parameters:C259=0)
	$msg:="init"
Else 
	$msg:=$1
End if 

Case of 
	: ($msg="init")
		READ WRITE:C146([Raw_Materials_Locations:25])
		ALL RECORDS:C47([Raw_Materials_Locations:25])
		$0:=Records in selection:C76([Raw_Materials_Locations:25])
		APPLY TO SELECTION:C70([Raw_Materials_Locations:25]; RML_InventoryEquation("freeze"))
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
			
			UNLOAD RECORD:C212([Raw_Materials_Locations:25])
			REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
			
		Else 
			
			REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
			
		End if   // END 4D Professional Services : January 2019 
		
	: ($msg="freeze")
		[Raw_Materials_Locations:25]LastCycleCount:7:=[Raw_Materials_Locations:25]QtyOH:9
		[Raw_Materials_Locations:25]LastCycleDate:8:=Current date:C33
		
	: ($msg="calc")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Raw_Materials_Locations:25]POItemKey:19; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3>[Raw_Materials_Locations:25]LastCycleDate:8)
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			$0:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
		Else   //no change, just rtn perpetual
			$0:=0
		End if 
		
	: ($msg="test")
		$calcTransaction:=RML_InventoryEquation("calc")
		If ([Raw_Materials_Locations:25]QtyOH:9=([Raw_Materials_Locations:25]LastCycleCount:7+$calcTransaction))
			$0:=1
		Else   //in error
			$0:=0
		End if 
End case 
