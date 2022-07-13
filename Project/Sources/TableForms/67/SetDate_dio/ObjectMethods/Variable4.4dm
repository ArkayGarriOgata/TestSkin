// ----------------------------------------------------
// User name (OS): MLB
// Date: 4/29/06
// ----------------------------------------------------
// Object Method: [Job_Forms_Master_Schedule].SetDate_dio.Variable4
// SetObjectProperties, Mark Zinke (5/17/13)
// ----------------------------------------------------
// Modified by: MelvinBohince (2/3/22) switch to fLockNLoad( )

C_BOOLEAN:C305(jobHasBeenReleased)

jobHasBeenReleased:=False:C215

SetObjectProperties("notReleasedText"; -><>NULL; True:C214)
SetObjectProperties("job@"; -><>NULL; False:C215)

If (Length:C16(sJobForm)>=7)
	If (Length:C16(sJobForm)=7)
		sJobForm:=Insert string:C231(sJobForm; "."; 6)
	End if 
	
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=sJobForm)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
		If (fLockNLoad(->[Job_Forms_Master_Schedule:67]))  //(Not(Locked([Job_Forms_Master_Schedule])))
			
			//mlb 4/29/06
			jobHasBeenReleased:=False:C215
			CUT NAMED SELECTION:C334([Job_Forms:42]; "testingJob")
			$isReadOnly:=Read only state:C362([Job_Forms:42])
			If (Not:C34($isReadOnly))
				READ ONLY:C145([Job_Forms:42])
			End if 
			
			SET QUERY LIMIT:C395(1)
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sJobForm)
			If ([Job_Forms:42]Status:6="Released") | ([Job_Forms:42]Status:6="wip")
				jobHasBeenReleased:=True:C214
				SetObjectProperties("notReleasedText"; -><>NULL; False:C215)
			End if 
			SET QUERY LIMIT:C395(0)
			
			If (Not:C34($isReadOnly))
				READ WRITE:C146([Job_Forms:42])
			End if 
			USE NAMED SELECTION:C332("testingJob")
			//If (fLockNLoad (->[ProductionSchedules]))
			//If (fLockNLoad (->[Job_Forms_Master_Schedule]))
			Lvalue1:=Num:C11([Job_Forms_Master_Schedule:67]DateStockRecd:17#!00-00-00!)
			Lvalue4:=Num:C11([Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)
			Lvalue6:=Num:C11([Job_Forms_Master_Schedule:67]GlueReady:28#!00-00-00!)
			Lvalue8:=Num:C11([Job_Forms_Master_Schedule:67]DateBagReceived:48#!00-00-00!)
			Lvalue9:=Num:C11([Job_Forms_Master_Schedule:67]DateBagApproved:49#!00-00-00!)
			Lvalue10:=Num:C11([Job_Forms_Master_Schedule:67]DateStockSheeted:47#!00-00-00!)
			Lvalue11:=Num:C11([Job_Forms_Master_Schedule:67]DateBagReturned:52#!00-00-00!)
			Lvalue12:=Num:C11([Job_Forms_Master_Schedule:67]DateWIPreceived:53#!00-00-00!)
			Lvalue31:=Num:C11([Job_Forms_Master_Schedule:67]StockStaged:66)
			SetObjectProperties("job@"; -><>NULL; True:C214)
			JML_SetDateColors
			//
			//Else 
			//BEEP
			//ALERT("Job Form "+sJobForm+" was in use";"Try later")
			//sJobForm:=""
			//GOTO OBJECT(sJobForm)
			//End if 
			//
			//Else 
			//BEEP
			//ALERT("Job Sequence "+[ProductionSchedules]JobSequence+" is locked.";"Try later")
			//sJobForm:=""
			//GOTO OBJECT(sJobForm)
			//End if 
		Else 
			ALERT:C41("Job Form "+sJobForm+" was in use"; "Try later")
			zwStatusMsg("Nope"; "Job Form "+sJobForm+" was locked")  //;"Try again")
			REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
			sJobForm:=""
			GOTO OBJECT:C206(sJobForm)
		End if 
		
	Else 
		BEEP:C151
		zwStatusMsg("Nope"; "Job Form "+sJobForm+" was not found")  //;"Try again")
		sJobForm:=""
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		GOTO OBJECT:C206(sJobForm)
	End if 
	
Else 
	BEEP:C151
	zwStatusMsg("Yo"; "Enter Job Form like 12345.12")
	sJobForm:=""
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	READ ONLY:C145([Job_Forms_Master_Schedule:67])
	
	GOTO OBJECT:C206(sJobForm)
End if 