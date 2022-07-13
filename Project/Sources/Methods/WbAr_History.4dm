//%attributes = {}
//Method: WbAr_History(tWebArea)
//Description:  This method will bring up a popup menu of the history.

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tWebArea)
	
	C_LONGINT:C283($nHistoryMenu)
	
	C_TEXT:C284($tURL)
	
	$tWebArea:=$1
	
	$tURL:=CorektBlank
	
End if   //Done initialize

$HistoryMenu:=WA Create URL history menu:C1049(*; $tWebArea; WA previous URLs:K62:1)

$tURL:=Dynamic pop up menu:C1006($HistoryMenu)

If ($tURL#CorektBlank)
	
	WA OPEN URL:C1020(*; $tWebArea; $tURL)
	
End if 

RELEASE MENU:C978($HistoryMenu)
