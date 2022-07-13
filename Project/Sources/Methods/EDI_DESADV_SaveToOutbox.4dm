//%attributes = {}
// _______
// Method: EDI_DESADV_SaveToOutbox   ( ) ->
// By: Mel Bohince @ 02/06/20, 18:30:22
// Description
// 
// ----------------------------------------------------
C_TEXT:C284($1; $2; $3; $4; $5)
C_POINTER:C301($message; $6)
C_BLOB:C604($blobOrdRspl)
C_LONGINT:C283($0)

SET BLOB SIZE:C606($blobOrdRspl; 0)
$message:=$6
TEXT TO BLOB:C554($message->; $blobOrdRspl; UTF8 text without length:K22:17; *)  // Modified by: Mel Bohince (1/9/18) was: Mac text without length

C_BOOLEAN:C305($testing)
$testing:=(Current date:C33<!2020-07-06!)  //True until go-live day

CREATE RECORD:C68([edi_Outbox:155])
[edi_Outbox:155]ID:1:=Sequence number:C244([edi_Outbox:155])
[edi_Outbox:155]Path:2:=""
SET BLOB SIZE:C606([edi_Outbox:155]Content:3; 0)
[edi_Outbox:155]Com_AccountName:7:=$1  //$senders_id
If ($testing)
	[edi_Outbox:155]SentTimeStamp:4:=32  //so it doesn't get sent, Waiting ASN button on outbox listing will find
Else 
	[edi_Outbox:155]SentTimeStamp:4:=0
End if 
[edi_Outbox:155]Subject:5:="DESADV_"+$2  //$tActualICN
[edi_Outbox:155]PO_Number:8:=$3  //[Customers_ReleaseSchedules]CustomerRefer
[edi_Outbox:155]OrderID:9:=$4  //[Customers_ReleaseSchedules]OrderLine+"/BOL:"+String([Customers_ReleaseSchedules]B_O_L_number)
[edi_Outbox:155]Content:3:=$blobOrdRspl
[edi_Outbox:155]ContentText:10:=$message->
[edi_Outbox:155]CrossReference:6:=$5  //[Customers_Order_Lines]edi_ICN

zwStatusMsg("DESADV"; "PREPARED RELEASE "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1))

SAVE RECORD:C53([edi_Outbox:155])
$0:=[edi_Outbox:155]ID:1
REDUCE SELECTION:C351([edi_Outbox:155]; 0)