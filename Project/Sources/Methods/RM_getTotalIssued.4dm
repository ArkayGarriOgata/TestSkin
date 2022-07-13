//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 07/30/09, 15:51:37
// ----------------------------------------------------
// Method: RM_getTotalIssued(jobform;rmcode)->qty issued
// Description
// return the total qty rm issued to a form
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($2)
C_LONGINT:C283($0)

READ ONLY:C145([Raw_Materials_Transactions:23])

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$1; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=$2; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="issue")
Case of 
	: (Records in selection:C76([Raw_Materials_Transactions:23])=1)
		$0:=[Raw_Materials_Transactions:23]Qty:6*-1
	: (Records in selection:C76([Raw_Materials_Transactions:23])>1)
		$0:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)*-1
	Else 
		$0:=0
End case 