//%attributes = {}
//Method:  Tgsn_Save(tpipedInvoice)
//Description:  This method will save the information sent to Tungsten

ARRAY TEXT:C222($at; 0)
ARRAY LONGINT:C221($an; 0)

ALL RECORDS:C47([edi_Outbox:155])

DISTINCT VALUES:C339([edi_Outbox:155]Com_AccountName:7; $at)
DISTINCT VALUES:C339([edi_Outbox:155]SentTimeStamp:4; $an)

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPipedInvoice)
	
	$tPipedInvoice:=$1
	
End if   //Done Initialize

CREATE RECORD:C68([edi_Outbox:155])

[edi_Outbox:155]ID:1:=Sequence number:C244([edi_Outbox:155])
[edi_Outbox:155]CrossReference:6:="Tungsten"+CorektSpace+String:C10(Current date:C33(*))
[edi_Outbox:155]Com_AccountName:7:="P&GTungsten"

[edi_Outbox:155]ContentText:10:=$tPipedInvoice
TEXT TO BLOB:C554($tPipedInvoice; [edi_Outbox:155]Content:3)
[edi_Outbox:155]Subject:5:=TgsnoColumn.SupplierPartNum+CorektSpace+CorektDash+CorektSpace+TgsnoColumn.SupplierPartDescr
[edi_Outbox:155]Path:2:=Tgsn_FilenameT
[edi_Outbox:155]PO_Number:8:=OB Get:C1224(TgsnoColumn; "PO Number")
[edi_Outbox:155]OrderID:9:=TgsnoColumn.InvoiceNumber
[edi_Outbox:155]SentTimeStamp:4:=-1

SAVE RECORD:C53([edi_Outbox:155])

REDUCE SELECTION:C351([edi_Outbox:155]; 0)