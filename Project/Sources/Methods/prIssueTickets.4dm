//%attributes = {"publishedWeb":true}
//(p)prIssueTickets
//do needed setuo for new pallett
//• 8/13/98 cs created

If (Current user:C182="Designer") | (User in group:C338(Current user:C182; "WorkInProcess"))
	uSpawnPalette("IssTicketPallet"; "$IssueTIcket Palette")
Else 
	uNotAuthorized
End if 