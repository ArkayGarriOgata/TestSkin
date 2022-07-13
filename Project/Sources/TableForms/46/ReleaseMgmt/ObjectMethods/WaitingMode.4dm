// ----------------------------------------------------
// Method: [Customers_ReleaseSchedules].ReleaseMgmt.WaitingMode   ( ) ->
// By: Mel Bohince @ 02/18/16, 10:21:12
// Description
// 
// ----------------------------------------------------


If (WaitingModeButtonText="Waiting Mode")
	COPY NAMED SELECTION:C331([Customers_ReleaseSchedules:46]; "preModeSelection")
	
	$choice:=Lowercase:C14(uYesNoCancel("Which RFM's do you want to see?"; "Waiting"; "Received"; "Required"))
	If (Read only state:C362([Customers_ReleaseSchedules:46]))
		$numFound:=ELC_RFM($choice)
	Else 
		$numFound:=ELC_RFM($choice; 1)
	End if 
	
	WaitingModeButtonText:="Restore Search"
	SET WINDOW TITLE:C213(String:C10($numFound)+" ELC Releases Waiting for Mode [RFM]")
	
Else 
	USE NAMED SELECTION:C332("preModeSelection")
	WaitingModeButtonText:="Waiting Mode"
	CLEAR NAMED SELECTION:C333("preModeSelection")
	SET WINDOW TITLE:C213(String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" "+windowPhrase)
End if 

ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]Shipto:10; >)
SetObjectProperties("WaitingMode"; -><>NULL; True:C214; WaitingModeButtonText)  // Modified by: Mark Zinke (5/15/13) fixed by mlb on 9/23/15
