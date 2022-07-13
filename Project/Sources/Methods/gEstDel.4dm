//%attributes = {"publishedWeb":true}
//gEstDel: Deletion for file [ESTIMATE]  see also x_exportest, x_importEstObj, 
//& doPurgeEstimate
//•062895  MLB  UPR 1507

READ WRITE:C146([Estimates:17])
READ WRITE:C146([Estimates_PSpecs:57])
READ WRITE:C146([Work_Orders:37])
READ WRITE:C146([Estimates_Carton_Specs:19])
READ WRITE:C146([Estimates_Differentials:38])
READ WRITE:C146([Estimates_DifferentialsForms:47])
READ WRITE:C146([Estimates_Materials:29])
READ WRITE:C146([Estimates_Machines:20])
READ WRITE:C146([Estimates_FormCartons:48])

QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]EstimateNo:3=[Estimates:17]EstimateNo:1)
If (Records in selection:C76([Customers_Orders:40])>0)
	ALERT:C41("This estimate is used in a Customer's order "+String:C10([Customers_Orders:40]OrderNumber:1)+", delete the order first.")
Else 
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]EstimateNo:47=[Estimates:17]EstimateNo:1)
	If (Records in selection:C76([Jobs:15])>0)
		ALERT:C41("This estimate is used in a job's form "+[Job_Forms:42]JobFormID:5+", delete the form first.")
	Else 
		BEEP:C151
		BEEP:C151
		BEEP:C151
		fDelete:=False:C215
		CONFIRM:C162("Are you sure you want to DELETE this record and its supporting records.")
		If (OK=1) & (fLockNLoad(->[Estimates:17]))
			app_Log_Usage("log"; "Delete Record"; "[Estimates] "+[Estimates:17]EstimateNo:1)
			RELATE MANY:C262([Estimates:17]EstimateNo:1)
			
			RELATE MANY SELECTION:C340([Estimates_DifferentialsForms:47]DiffId:1)
			RELATE MANY SELECTION:C340([Estimates_FormCartons:48]DiffFormID:2)
			RELATE MANY SELECTION:C340([Estimates_Machines:20]DiffFormID:1)
			RELATE MANY SELECTION:C340([Estimates_Materials:29]DiffFormID:1)
			
			DELETE SELECTION:C66([Estimates_PSpecs:57])
			DELETE SELECTION:C66([Estimates_Carton_Specs:19])
			DELETE SELECTION:C66([Estimates_Differentials:38])
			DELETE SELECTION:C66([Estimates_DifferentialsForms:47])
			DELETE SELECTION:C66([Estimates_Materials:29])
			DELETE SELECTION:C66([Estimates_Machines:20])
			DELETE SELECTION:C66([Estimates_FormCartons:48])
			
			DELETE RECORD:C58([Estimates:17])
			CANCEL:C270
		End if 
	End if 
End if 