//%attributes = {"publishedWeb":true}
//(P)gSrchJobForm
//• 5/22/98 cs added display of status & whether Job Form has run through Closeout

uClrBudgetArray

sStatus:=""  //• 5/22/98 cs 
cbComplete:=0
//ALL RECORDS([JobForm])
If (Length:C16(sPONum)<=5)
	lPONum:=Num:C11(sPONum)
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=lPONum)
	SET QUERY LIMIT:C395(0)
	If (Records in selection:C76([Jobs:15])>0)  //job found 
		sCustName:=[Jobs:15]CustomerName:5
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=lPONum)
		SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; asJFBudget)
		SORT ARRAY:C229(asJFBudget)
		
	Else 
		uConfirm("Job Number is Invalid."; "Try Again"; "Help")
		sCustName:=sPONum+" is invalid"
		GOTO OBJECT:C206(sPONum)
	End if 
	
Else 
	ARRAY TEXT:C222(asJFBudget; 0)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sPONum)
	If (Records in selection:C76([Job_Forms:42])>0)  //job foundsStatus:=[Job_Forms]Status 
		RELATE ONE:C42([Job_Forms:42]JobNo:2)
		sCustName:=[Jobs:15]CustomerName:5
		
		If ([Job_Forms:42]IssuingComplete:51)
			
			sIssued:="Issuing Done on Closeout"
			
			OBJECT SET RGB COLORS:C628(sIssued; 16777215; 16711680)
			
		Else 
			
			sIssued:=CorektBlank
			
			OBJECT SET RGB COLORS:C628(sIssued; 16777215; 16777215)
			
		End if 
		
		If ([Job_Forms:42]Status:6="Closed") & (Not:C34(User in group:C338(Current user:C182; "WorkInProcess")))
			ALERT:C41("This Jobform "+[Job_Forms:42]JobFormID:5+" has been closed - You may not issue against this"+" Jobform."+Char:C90(13)+"Check with Accounting to complete this issue.")
			sStatus:=""  //• 5/22/98 cs 
			cbComplete:=0
			GOTO OBJECT:C206(sPoNum)
			gClrRMFields
		Else 
			gSrchBudget
		End if 
		
	Else 
		uConfirm("Job Form is Invalid."; "Try Again"; "Help")
		sCustName:=sPONum+" is invalid"
		GOTO OBJECT:C206(sPONum)
	End if 
End if 