//%attributes = {}
// Method: RM_merge () -> 
// ----------------------------------------------------
// by: mel: 06/06/05, 08:54:27
// ----------------------------------------------------
// Description:
// reattach related records to another rm and delete this one
// ----------------------------------------------------

C_LONGINT:C283($hit)
C_TEXT:C284($newCode; $oldCode)

READ WRITE:C146([Raw_Materials_Allocations:58])
READ WRITE:C146([Raw_Materials_Components:60])
READ WRITE:C146([Raw_Materials_Locations:25])
READ WRITE:C146([Raw_Materials_Transactions:23])
READ WRITE:C146([Purchase_Orders_Items:12])
READ WRITE:C146([Job_Forms_Materials:55])
READ WRITE:C146([Process_Specs_Materials:56])
READ WRITE:C146([Finished_Goods_PackingSpecs:91])

$oldCode:=[Raw_Materials:21]Raw_Matl_Code:1
$newCode:=Request:C163("Merge related records with which RM_Code?")

If (OK=1)
	SET QUERY DESTINATION:C396(Into variable:K19:4; $hit)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$newCode)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($hit=1)
		$count:=RMRenameLoc($oldCode)
		RMReNameWork(->[Raw_Materials_Locations:25]Raw_Matl_Code:1; ->[Raw_Materials_Locations:25]ModDate:21; ->[Raw_Materials_Locations:25]ModWho:22; "Bins"; $newCode)
		RMReNameWork(->[Raw_Materials_Transactions:23]Raw_Matl_Code:1; ->[Raw_Materials_Transactions:23]ModDate:17; ->[Raw_Materials_Transactions:23]ModWho:18; "Xfer"; $newCode)
		RMReNameWork(->[Estimates_Materials:29]Raw_Matl_Code:4; ->[Estimates_Materials:29]ModDate:22; ->[Estimates_Materials:29]ModWho:21; "Est"; $newCode)
		RMReNameWork(->[Raw_Materials_Allocations:58]Raw_Matl_Code:1; ->[Raw_Materials_Allocations:58]ModDate:8; ->[Raw_Materials_Allocations:58]ModWho:9; "Alloc"; $newCode)
		RMReNameWork(->[Job_Forms_Materials:55]Raw_Matl_Code:7; ->[Job_Forms_Materials:55]ModDate:10; ->[Job_Forms_Materials:55]ModWho:11; "Job"; $newCode)
		RMReNameWork(->[Process_Specs_Materials:56]Raw_Matl_Code:13; ->[Process_Specs_Materials:56]ModDate:11; ->[Process_Specs_Materials:56]ModWho:10; "Pspec"; $newCode)
		RMReNameWork(->[Purchase_Orders_Items:12]Raw_Matl_Code:15; ->[Purchase_Orders_Items:12]ModDate:19; ->[Purchase_Orders_Items:12]ModWho:20; "Items"; $newCode)
		RMReNameWork(->[Finished_Goods_PackingSpecs:91]RM_Code:36; ->[Finished_Goods_PackingSpecs:91]ModDate:37; ->[Finished_Goods_PackingSpecs:91]ModWho:38; "PakSpec"; $newCode)
		
		DELETE RECORD:C58([Raw_Materials:21])
		CANCEL:C270
		
	Else 
		BEEP:C151
		ALERT:C41($rm+" was not found.")
	End if 
End if 