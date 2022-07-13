// Method: Trigger on [edi_Outbox]   ( ) ->
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/21/06, 19:45:11
// ----------------------------------------------------
// Description
// dup the blob as text for display and edit purposes
//
// Modified by: Mel Bohince (4/6/21) treat edifact and x12 differently using edi_SetOutboxEndOfLine
// Modified by: MelvinBohince (1/20/22) don't format text if blob is empty

C_LONGINT:C283($0; $dbevent)
$0:=0
C_TEXT:C284($ContentText)

$dbevent:=Trigger event:C369
Case of 
	: ($dbevent=On Saving New Record Event:K3:1) | ($dbevent=On Saving Existing Record Event:K3:2)
		
		If (BLOB size:C605([edi_Outbox:155]Content:3)>0)  // Modified by: MelvinBohince (1/20/22) 
			$ContentText:=BLOB to text:C555([edi_Outbox:155]Content:3; Mac text without length:K22:10)  //reload it, content is a blob without CR's so we stay honest
			[edi_Outbox:155]ContentText:10:=edi_SetOutboxEndOfLine("pretty"; ->$ContentText)  //reformat it
		End if 
		
		
End case 
