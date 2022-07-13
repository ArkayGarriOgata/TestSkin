//%attributes = {}
// Method: JOB_CloseNotice () -> 
// ----------------------------------------------------
// by: mel: 06/23/05, 09:21:39
// ----------------------------------------------------
// Description:
// give notice when a completed job has passed thru CC & EX
// ----------------------------------------------------
// Modified by: Mel Bohince (12/11/15) add xc

C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)
C_LONGINT:C283($i; $numRecs; $trans; $scraps; $receipt; $netDiff)
C_BOOLEAN:C305($break)
C_TEXT:C284($r; $t)

$t:=Char:C90(9)
$r:=Char:C90(13)
xTitle:="Jobs Out of CC and XC"
xText:="The following jobforms have been marked as Complete and do not have any quantitie"+"s in CC, XC, or EX."+$r
$body:=xText
xText:=xText+"Jobform"+$t+"Customer"+$t+"Line"+$t+"Want"+$t+"Receipts"+$t+"Scraps"+$t+"Excess(Shortage)"+$r

READ ONLY:C145([Finished_Goods_Locations:35])
READ WRITE:C146([Job_Forms:42])
READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([Jobs:15])

QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6="Complete"; *)
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]NoticeGiven:67=0)

$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms:42])
If ($numRecs>0)
	uThermoInit($numRecs; "Updating Records")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="CC@"; *)
		QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="EX@"; *)
		QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)  // Modified by: Mel Bohince (12/11/15) add xc
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]JobForm:19=[Job_Forms:42]JobFormID:5)
		
		If (Records in selection:C76([Finished_Goods_Locations:35])=0)
			RELATE ONE:C42([Job_Forms:42]JobNo:2)
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=[Job_Forms:42]JobFormID:5)
			SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionType:2; $aType; [Finished_Goods_Transactions:33]Qty:6; $aQty)
			$scraps:=0
			$receipt:=0
			For ($trans; 1; Size of array:C274($aType))
				Case of 
					: ($aType{$trans}="Receipt")
						$receipt:=$receipt+$aQty{$trans}
					: ($aType{$trans}="Scrap")
						$scraps:=$scraps+$aQty{$trans}
				End case 
			End for 
			$netDiff:=($receipt-$scraps)-[Job_Forms:42]QtyWant:22
			xText:=xText+[Job_Forms:42]JobFormID:5+$t+[Jobs:15]CustomerName:5+$t+[Jobs:15]Line:3+$t+String:C10([Job_Forms:42]QtyWant:22)+$t+String:C10($receipt)+$t+String:C10($scraps)+$t+String:C10($netDiff)+$r
			[Job_Forms:42]NoticeGiven:67:=1
			SAVE RECORD:C53([Job_Forms:42])
		End if 
		
		NEXT RECORD:C51([Job_Forms:42])
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	docName:="CloseNotice"+fYYMMDD(4D_Current_date)+".xls"
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; xTitle+Char:C90(13)+Char:C90(13))
		SEND PACKET:C103($docRef; xText)
		SEND PACKET:C103($docRef; Char:C90(13)+Char:C90(13)+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		If (Count parameters:C259=0)
			$err:=util_Launch_External_App(docName)
		Else 
			EMAIL_Sender(xTitle; ""; $body+" Open attachment with Excel"; distributionList; docName)
			util_deleteDocument(docName)
		End if 
	End if 
End if 