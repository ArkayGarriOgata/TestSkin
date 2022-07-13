//%attributes = {}
// _______
// Method: edi_Outbox_SaveEdits   ( ) ->
// By: Mel Bohince @ 04/06/21, 14:48:46
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($ContentText)
$ContentText:=Form:C1466.editEntity.ContentText
$ContentText:=edi_SetOutboxEndOfLine("raw"; ->$ContentText)  //remove the line breaks that were to prettify, so the blob can be saved

//update the blob
Form:C1466.editEntity.SentTimeStamp:=edi_SetOutboxContent(Form:C1466.editEntity.ID; ->$ContentText; Form:C1466.editEntity.SentTimeStamp)  //will rtn 0 if successful, unchanged senttimestamp otherwise

Form:C1466.editEntity.reload()  //so save doesn't have a problem with the stamp

Form:C1466.editEntity:=Form:C1466.editEntity  // update the screen

