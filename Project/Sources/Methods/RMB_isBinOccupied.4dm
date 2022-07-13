//%attributes = {}
// Method: RMB_isBinOccupied (bin) -> boolean
// ----------------------------------------------------
// by: mel: 09/08/05, 15:26:29
// ----------------------------------------------------
// Description:
// test if a bin has something in it before a move to that location is executed
// ----------------------------------------------------

C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_LONGINT:C283($numFGL)

$0:=False:C215  //assume empty

If (Position:C15("FG:"; $1)>0)
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numFGL)
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2=$1)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If ($numFGL>0)
		$0:=True:C214
	End if 
End if 