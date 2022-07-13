//%attributes = {}
// _______
// Method: RIM_getLegacyLocationId   ( poi ) ->  uuid
// By: Mel Bohince @ 04/11/19, 08:45:27
// Description
// return the pk_key of the location record is only one is found
// ----------------------------------------------------
C_TEXT:C284($1; $0)
//so we can restore
ARRAY LONGINT:C221($_record_machines; 0)
LONGINT ARRAY FROM SELECTION:C647([Raw_Materials_Locations:25]; $_record_machines)

//only query if needed
If ([Raw_Materials_Locations:25]POItemKey:19#$1) | (Records in selection:C76([Raw_Materials_Locations:25])>1)
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=$1)
End if 

If (Records in selection:C76([Raw_Materials_Locations:25])=1)
	$0:=[Raw_Materials_Locations:25]pk_id:32
Else 
	$0:=""
End if 

//tidy up
CREATE SELECTION FROM ARRAY:C640([Raw_Materials_Locations:25]; $_record_machines)
