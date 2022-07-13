//© 2015 Footprints Inc. All Rights Reserved.
//Method: Object Method: AdvancedScheduler.List Box - Created `v1.0.0-PJK (12/17/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
C_LONGINT:C283($xlCol; $xlRow)
C_LONGINT:C283($xlLeft; $xlTop; $xlRight; $xlBottom)
C_LONGINT:C283($xlObLeft; $xlObTop; $xlObRight; $xlObBottom)

If (Form event code:C388=On Double Clicked:K2:5)
	LISTBOX GET CELL POSITION:C971(lbJobs; $xlCol; $xlRow)
	Case of 
		: ($xlRow<=0)  // No row selected
		: ($xlCol=1)  // Clicked on the Job Line
			
		: ($xlCol=2)  // Clicked on the Form Line
			$ttText:=sttJobFormID{$xlRow}
			$ttJobFormID:=GetNextField(->$ttText; ",")
			READ WRITE:C146([Job_Forms_Master_Schedule:67])
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$ttJobFormID)
			If (MULOADREC(->[Job_Forms_Master_Schedule:67]; False:C215))
				
				$ttText:=sttJobFormID{$xlRow}
				$ttPrefix:=GetNextField(->$ttText; "HRD: ")
				$ttHRDDate:=GetNextField(->$ttText; ")")
				$dDate:=Date:C102(Request:C163("Enter the HRD"; $ttHRDDate))
				If (OK=1)
					[Job_Forms_Master_Schedule:67]MAD:21:=$dDate
					JML_SetItemsHRD
					SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
					sttJobFormID{$xlRow}:=$ttPrefix+"HRD: "+String:C10([Job_Forms_Master_Schedule:67]MAD:21; System date short:K1:1)+")"
					
				End if 
			Else 
				ALERT:C41("The Job Master record is currently in use by another user or process and cannot be modified at this time.")
			End if 
			UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
			
		Else   // $xlCol > 2 is the operations
			
	End case 
End if 


