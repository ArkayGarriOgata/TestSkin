//%attributes = {}
// -------
// Method: RMX_PlatesPost   ( ) ->
// By: Mel Bohince @ 06/01/17, 16:21:24
// Description
// create rm xaction and relieve plate inventory
// ----------------------------------------------------
//use as
//RMX_postPlates ($pltRecNum;"OKWBD000")// if from Plate Use btn or if apply formula:
//RMX_postPlates (0;"OO8L7000")
//RMX_postPlates (0;"OKWBD000")

// Modified by: Mel Bohince (12/6/17) save rec number in rmx record, so it can be modified later
// Modified by: Mel Bohince (2/9/18) don't treat PH77144 as a consignment item
// Modified by: Mel Bohince (11/14/18) chg to 09u7r000 and 07q1f000
// Modified by: Mel Bohince (1/14/19) next 3 lines got accidentally deleted
// Modified by: Mel Bohince (9/6/19) change to data based control
// Modified by: Mel Bohince (1/8/20) correct PO on transaction if more that 1 po involved
// Modified by: Mel Bohince (1/25/20) do 04@ not 04-Plates
READ ONLY:C145([Job_PlatingMaterialUsage:175])
READ ONLY:C145([Raw_Materials:21])
READ WRITE:C146([Raw_Materials_Locations:25])

C_LONGINT:C283($recNum; $1; $platesUsed)
$recNum:=$1
C_TEXT:C284($2; $rmCode; $usedBy)
//$rmCode:=$2// Modified by: Mel Bohince (9/6/19) change to data based control
$usedBy:=$2

If ($recNum>0)
	GOTO RECORD:C242([Job_PlatingMaterialUsage:175]; $recNum)
Else 
	//must be an apply formula
End if 

Case of 
	: ($usedBy="XL")  //"OKWBD000")"07q1f000"
		$platesUsed:=[Job_PlatingMaterialUsage:175]M2O:8+[Job_PlatingMaterialUsage:175]M2R:9
		
	: ($usedBy="Large")
		$platesUsed:=[Job_PlatingMaterialUsage:175]M3O:10+[Job_PlatingMaterialUsage:175]M3R:11
		
	: ($usedBy="Cyrel")
		$platesUsed:=[Job_PlatingMaterialUsage:175]M5O:14+[Job_PlatingMaterialUsage:175]M5R:15
		
	Else   // Modified by: Mel Bohince (9/6/19) change to data based control
		$platesUsed:=0
End case 

If ($platesUsed>0)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2="04@"; *)
	QUERY:C277([Raw_Materials:21];  & ; [Raw_Materials:21]UsedBy:52=$usedBy)
	If (Records in selection:C76([Raw_Materials:21])>0)
		$rmCode:=[Raw_Materials:21]Raw_Matl_Code:1
	Else 
		$rmCode:="not-found"
	End if 
	
	
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]QtyOH:9>0; *)  // Added by: Mel Bohince (4/15/19) 
	QUERY:C277([Raw_Materials_Locations:25];  | ; [Raw_Materials_Locations:25]ConsignmentQty:26>0; *)  // Added by: Mel Bohince (4/15/19) 
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$rmCode)
	
	ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >)  //fifo
	
	//loop thru bin records consuming in fifo manor, create transactions sas you go
	//$platesUsed decremented as you go
	
	C_POINTER:C301($ptr_Bin)  // Modified by: Mel Bohince (2/9/18) don't treat PH77144 as a consignment item
	
	While ($platesUsed>0) & (Not:C34(End selection:C36([Raw_Materials_Locations:25])))
		//  //do the consumption
		If ($rmCode="PH77144")  // Modified by: Mel Bohince (2/9/18) don't treat PH77144 as a consignment item
			$ptr_Bin:=->[Raw_Materials_Locations:25]QtyOH:9
		Else 
			$ptr_Bin:=->[Raw_Materials_Locations:25]ConsignmentQty:26
		End if 
		
		$qtyRemaining:=$ptr_Bin->  //get the current contents of the bin
		If ($qtyRemaining>=$platesUsed)  //at least enough
			$ptr_Bin->:=$ptr_Bin->-$platesUsed  //relieve the bin
			RMX_PlatesPostTransaction("init"; $rmCode; $platesUsed; $usedBy)
			$platesUsed:=0  //we're done, break out of the loop, bin may have more for later
			
		Else   //finish off that po
			$platesUsed:=$platesUsed-$ptr_Bin->  //reduce the amount to be issued by the entire contents of the bin
			RMX_PlatesPostTransaction("init"; $rmCode; $qtyRemaining; $usedBy)
			$ptr_Bin->:=0  //set the bin as empty, can be deleted later
		End if 
		
		SAVE RECORD:C53([Raw_Materials_Locations:25])
		
		NEXT RECORD:C51([Raw_Materials_Locations:25])
	End while 
	
	If ($platesUsed>0)
		ALERT:C41("More "+$rmCode+" used that was on hand"; "Dang")
	End if 
	
	UNLOAD RECORD:C212([Raw_Materials:21])
	UNLOAD RECORD:C212([Job_PlatingMaterialUsage:175])
	UNLOAD RECORD:C212([Raw_Materials_Locations:25])
	
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]QtyOH:9=0; *)  // Added by: Mel Bohince (4/15/19) 
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]ConsignmentQty:26=0; *)  // Added by: Mel Bohince (4/15/19) 
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$rmCode)
	util_DeleteSelection(->[Raw_Materials_Locations:25])
	
End if 





