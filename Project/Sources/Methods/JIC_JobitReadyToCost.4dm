//%attributes = {"publishedWeb":true}
//PM:  JIC_JobitReadyToCostobit)->boolaen  072002  mlb
//rtn true if jmi actQty>0

C_BOOLEAN:C305($0)
C_LONGINT:C283($produced)

CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "holdJMIs")  //make no assumptions, leave no tracks
//$numJMI:=qryJMI ($1)`is a non-evasive seqry
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$1)
If (Records in selection:C76([Job_Forms_Items:44])>0)
	$produced:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
	$0:=($produced>0)
Else 
	$0:=False:C215
End if 

USE NAMED SELECTION:C332("holdJMIs")