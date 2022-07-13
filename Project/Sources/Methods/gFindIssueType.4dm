//%attributes = {"publishedWeb":true}
//(P) gFindIssueType

C_LONGINT:C283($i)

If ([Raw_Materials_Transactions:23]Xfer_Type:2="")
	sIssueType:=""
Else 
	$i:=Find in array:C230(<>asIssueType; [Raw_Materials_Transactions:23]Xfer_Type:2)
	sIssueType:=<>asIssueDesc{$i}
End if 