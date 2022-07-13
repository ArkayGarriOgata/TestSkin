//%attributes = {"publishedWeb":true}
//PM:  RM_AllocationRemove  082402  mlb
//delete any allocations for the specified jobform

C_TEXT:C284($1)
C_LONGINT:C283($0)

READ WRITE:C146([Raw_Materials_Allocations:58])
If (Length:C16($1)>=5)
	QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=$1)
	$0:=Records in selection:C76([Raw_Materials_Allocations:58])
	util_DeleteSelection(->[Raw_Materials_Allocations:58]; "*")
End if 