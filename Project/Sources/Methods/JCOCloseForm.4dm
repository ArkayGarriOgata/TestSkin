//%attributes = {"publishedWeb":true}
//(p) JCOCloseForm
//mark Jobform as closed
//7/31/98 cs created
//•090398  MLB  set the closed date
//•120398  MLB  offer to retain prior close date
//•051999  mlb  don't present msg, messes up batching, just leave the old date

If (fLockNLoad(->[Job_Forms:42]))
	[Job_Forms:42]Status:6:="Closed"
	If ([Job_Forms:42]ClosedDate:11=!00-00-00!)
		[Job_Forms:42]ClosedDate:11:=4D_Current_date  //•090398  MLB   
	End if 
	
	If ([Job_Forms:42]Completed:18=!00-00-00!)  //•2/23/00  mlb  
		[Job_Forms:42]Completed:18:=4D_Current_date
	End if 
	
	[Job_Forms:42]ModDate:7:=4D_Current_date
	[Job_Forms:42]ModWho:8:=<>zResp
	SAVE RECORD:C53([Job_Forms:42])
	
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms:42]JobFormID:5)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		If (fLockNLoad(->[Job_Forms_Master_Schedule:67]))
			If ([Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)  //•2/23/00  mlb  
				[Job_Forms_Master_Schedule:67]DateComplete:15:=4D_Current_date
				SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
			End if 
		Else 
			utl_Logfile("JobCloseOut.Log"; [Job_Forms:42]JobFormID:5+" JCOCloseForm frustrated by JML")
		End if 
	End if 
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	
Else 
	utl_Logfile("JobCloseOut.Log"; [Job_Forms:42]JobFormID:5+" JCOCloseForm frustrated by JF")
End if 