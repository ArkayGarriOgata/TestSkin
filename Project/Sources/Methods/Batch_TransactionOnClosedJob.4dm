//%attributes = {}
// ---------------------------------------------------- 
// Method: Batch_TransactionOnClosedJob
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 11/08/07, 10:34:47
// ----------------------------------------------------
// Modified by: Mel Bohince (4/1/16) don't warn about auto issues


C_DATE:C307($1; $date)
C_LONGINT:C283($xfer; $found)
ARRAY LONGINT:C221($aRecNum; 0)
ARRAY TEXT:C222($aJobform; 0)
C_TEXT:C284($email_body)

$email_body:=""

If (Count parameters:C259=0)
	$date:=Date:C102(Request:C163("What day?"; String:C10(Current date:C33); "Check"; "Cancel"))
Else 
	$date:=$1
End if 

READ ONLY:C145([Job_Forms:42])

READ ONLY:C145([Raw_Materials_Transactions:23])
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3=$date; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1#"Auto@"; *)  // Modified by: Mel Bohince (4/1/16) don't warn about auto issues
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]; $aRecNum; [Raw_Materials_Transactions:23]JobForm:12; $aJobform)
SORT ARRAY:C229($aJobform; $aRecNum; >)

//SET QUERY DESTINATION(Into variable ;$found)
For ($xfer; 1; Size of array:C274($aJobform))
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$aJobform{$xfer}; *)
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ClosedDate:11<=$date; *)
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ClosedDate:11#!00-00-00!)
	If (Records in selection:C76([Job_Forms:42])>0)
		GOTO RECORD:C242([Raw_Materials_Transactions:23]; $aRecNum{$xfer})
		$email_body:=$email_body+$aJobform{$xfer}+" "+String:C10([Job_Forms:42]ClosedDate:11; Internal date short:K1:7)+": ("+String:C10([Raw_Materials_Transactions:23]Qty:6*-1)+") "+[Raw_Materials_Transactions:23]Commodity_Key:22+"=>"+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" ["+[Raw_Materials_Transactions:23]ReferenceNo:14+"]{"+[Raw_Materials_Transactions:23]ModWho:18+"}"+Char:C90(13)
	End if 
End for 
//SET QUERY DESTINATION(Into current selection )

If (Length:C16($email_body)>0)  //send an email
	$email_body:="Issues to 'Closed' Jobs on "+String:C10($date)+Char:C90(13)+"JOBFORM  CLOSED_ON   "+"(QTY)      COMM_KEY=>RM_CODE   [REF_NUM]{WHO} "+Char:C90(13)+$email_body
	distributionList:=Batch_GetDistributionList(""; "ACCTG")
	EMAIL_Sender("Batch_TransactionOnClosedJob_"+fYYMMDD($date; 4); ""; $email_body; distributionList)
End if 