//%attributes = {}
// _______
// Method: edi_SetOutboxEndOfLine   ( "pretty" or "raw") ->
// By: Mel Bohince @ 04/06/21, 12:32:28
// Description
// replace the segment markers with segment marker + CR
// dependent on EDI Std used
// ----------------------------------------------------
// Modified by: MelvinBohince (1/19/22) make sure $segDelimiter & $endOfLine are init'd

C_TEXT:C284($chgTo; $1; $0)
$chgTo:=$1
C_POINTER:C301($ediMsgContentText_p; $2)
$ediMsgContentText_p:=$2

Case of 
	: (Substring:C12($ediMsgContentText_p->; 1; 2)="UN")  //edifact
		$segDelimiter:="'"  //apostrophy
		$endOfLine:="'\r"  //apostrophy+cr
		
	: (Substring:C12($ediMsgContentText_p->; 1; 2)="IS")  //x12
		$segDelimiter:="~"  //tilde
		$endOfLine:="~\r"  //tilde+cr
	Else 
		// Modified by: MelvinBohince (1/19/22) 
		$segDelimiter:=""
		$endOfLine:=""
End case 

Case of 
	: ($chgTo="raw")
		$0:=Replace string:C233($ediMsgContentText_p->; $endOfLine; $segDelimiter)
		
	: ($chgTo="pretty")
		$0:=Replace string:C233($ediMsgContentText_p->; $segDelimiter; $endOfLine)
		
End case 
