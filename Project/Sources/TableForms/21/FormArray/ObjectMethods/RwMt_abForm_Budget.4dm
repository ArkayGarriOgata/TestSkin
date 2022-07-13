//asJFBudget: Job and Form Number Script
//• 5/22/98 cs aded code to display status & whether issues had been done by Closo
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=asJFBudget{asJFBudget})
uClrBudgetArray
sStatus:=[Job_Forms:42]Status:6

RELATE ONE:C42([Job_Forms:42]JobNo:2)
sCustName:=[Jobs:15]CustomerName:5

If ([Job_Forms:42]IssuingComplete:51)
	sIssued:="Issuing Done on Closeout"
	Core_ObjectSetColor(->sIssued; -(2*(256*11)))
Else 
	sIssued:=""
	Core_ObjectSetColor(->sIssued; -0)
End if 

If ([Job_Forms:42]Status:6="Closed") & (Not:C34(User in group:C338(Current user:C182; "WorkInProcess")))
	ALERT:C41("This Jobform "+[Job_Forms:42]JobFormID:5+" has been closed - You may not issue against this"+" Jobform."+Char:C90(13)+"Check with Accounting to complete this issue.")
	uClrBudgetArray
	gClrRMFields
	sStatus:=""  //• 5/22/98 cs 
	cbComplete:=0
	GOTO OBJECT:C206(sPoNum)
Else 
	gSrchBudget
End if 
//EOS