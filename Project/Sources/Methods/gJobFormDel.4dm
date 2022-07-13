//%attributes = {"publishedWeb":true}
//(P) gDelJob 

fDelBud:=False:C215
fDelItem:=False:C215
fDelAct:=False:C215
BEEP:C151
uConfirm("Are you sure you want to DELETE this record!"; "Delete"; "Cancel")
If (OK=1)
	fDelBud:=False:C215
	fDelItem:=False:C215
	fDelAct:=False:C215
	RELATE MANY:C262([Job_Forms:42])
	RELATE MANY:C262([Job_Forms_Machines:43])
	If ((Records in selection:C76([Job_Forms_Machines:43])>0) | (Records in selection:C76([Job_Forms_Materials:55])>0))
		CONFIRM:C162("Budgets exist for this record.  Delete anyway?")
		If (OK=1)
			fDelBud:=True:C214
		Else 
			fDelete:=False:C215
		End if 
	End if 
	If ((Records in selection:C76([Job_Forms_Items:44])>0))
		CONFIRM:C162("Items exist for this record.  Delete anyway?")
		If (OK=1)
			fDelItem:=True:C214
		Else 
			fDelete:=False:C215
		End if 
	End if 
	If (fDelete=False:C215)
		//ALERT("Job cannot be deleted.  Items, Budgets, and Actuals must be deleted first
		ALERT:C41("Job cannot be deleted.  Items and Budgets must be deleted first.")
	End if 
	//If((Records in selection([MachineTicket])>0)|(Records in selection([Material_Job
	If ((Records in selection:C76([Job_Forms_Machine_Tickets:61])>0) | (Records in selection:C76([Raw_Materials_Transactions:23])>0))
		ALERT:C41("Job cannot be deleted.  Actuals exist for this Job.")
		//CONFIRM("Actuals exist for this record.  Delete anyway?")
		//If (OK=1)
		//fDelAct:=True
		//Else 
		fDelete:=False:C215
		//End if 
	End if 
	If (fDelete)
		If (fDelBud=True:C214)
			DELETE SELECTION:C66([Job_Forms_Machines:43])
			DELETE SELECTION:C66([Job_Forms_Materials:55])
		End if 
		If (fDelItem=True:C214)
			RELATE MANY:C262([Job_Forms_Items:44])
			DELETE SELECTION:C66([Job_Forms_Items:44])
		End if 
		If (fDelAct=True:C214)
			DELETE SELECTION:C66([Job_Forms_Machine_Tickets:61])
			DELETE SELECTION:C66([Job_Forms_Materials:55])
		End if 
		//DELETE RECORD(zDefFilePtr»)
		DELETE RECORD:C58([Job_Forms:42])
	End if 
	//gEnableAdHoc 
	CANCEL:C270
End if 