//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/11/10, 13:52:03
// ----------------------------------------------------
// Method: Job_back_flush_components
// Description
// determine if materials included subcomponents (com 33)
// if so, backflush the fg inventory and issue it to the job
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($0; $2)
C_BOOLEAN:C305(<>USE_SUBCOMPONENT)

<>USE_SUBCOMPONENT:=True:C214

QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$1; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12="33@")
If (Records in selection:C76([Job_Forms_Materials:55])>0)  //backflush required
	ARRAY LONGINT:C221($aItemNumber; 0)
	ARRAY LONGINT:C221($aCartons_produced; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ItemNumber:7; $aItemNumber; [Job_Forms_Items:44]Qty_Actual:11; $aCartons_produced)
	
	$each_cost:=0
	//on each item, relieve fg inventory and add to the job
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Job_Forms_Materials:55])
	
	uThermoInit($numRecs; "Backflushing Component Items...")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		If (Size of array:C274($aCartons_produced)=1)
			$hit:=1
		Else 
			$hit:=Find in array:C230($aItemNumber; [Job_Forms_Materials:55]Real2:18)
		End if 
		If ($hit>-1)
			[Job_Forms_Materials:55]Actual_Qty:14:=$aCartons_produced{$hit}*[Job_Forms_Materials:55]Real1:17
		End if 
		//fifo out the qty leaving transactions in the wake
		[Job_Forms_Materials:55]Actual_Price:15:=Job_price_component([Job_Forms_Materials:55]Raw_Matl_Code:7; "inventoried"; [Job_Forms_Materials:55]Actual_Qty:14; [Job_Forms_Materials:55]JobForm:1)
		
		SAVE RECORD:C53([Job_Forms_Materials:55])
		NEXT RECORD:C51([Job_Forms_Materials:55])
		uThermoUpdate($i)
	End for 
	uThermoClose
	
Else   //not required
	$0:=0
End if 