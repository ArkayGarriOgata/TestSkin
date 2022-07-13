// ----------------------------------------------------
// Object Method: [Job_Forms_Master_Schedule].SetDate_dio.Variable3
// SetObjectProperties, Mark Zinke (5/17/13)
// ----------------------------------------------------
// Modified by: MelvinBohince (2/3/22) READ ONLY([Job_Forms_Master_Schedule]) on exit

If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	$now:=4D_Current_date
	$not:=!00-00-00!
	
	If (Lvalue8=1)
		If ([Job_Forms_Master_Schedule:67]DateBagReceived:48=!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateBagReceived:48:=$now
		End if 
	Else 
		If ([Job_Forms_Master_Schedule:67]DateBagReceived:48#!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateBagReceived:48:=$not
		End if 
	End if 
	
	If (Lvalue9=1)
		If ([Job_Forms_Master_Schedule:67]DateBagApproved:49=!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateBagApproved:49:=$now
		End if 
	Else 
		If ([Job_Forms_Master_Schedule:67]DateBagApproved:49#!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateBagApproved:49:=$not
		End if 
	End if 
	
	If (Lvalue1=1)
		If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateStockRecd:17:=$now
		End if 
	Else 
		If ([Job_Forms_Master_Schedule:67]DateStockRecd:17#!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateStockRecd:17:=$not
		End if 
	End if 
	
	If (Lvalue31=1)
		[Job_Forms_Master_Schedule:67]StockStaged:66:=True:C214
	Else 
		[Job_Forms_Master_Schedule:67]StockStaged:66:=False:C215
	End if 
	
	If (Lvalue10=1)
		If ([Job_Forms_Master_Schedule:67]DateStockSheeted:47=!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateStockSheeted:47:=$now
			If (JOB_isValidForm([Job_Forms_Master_Schedule:67]JobForm:4))
				READ WRITE:C146([ProductionSchedules:110])
				QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=([Job_Forms_Master_Schedule:67]JobForm:4+"@"))
				$numPS:=PS_qrySheetingOnly("*")
				Case of 
					: ($numPS>14)
						BEEP:C151
						ALERT:C41("Too many Schedule Records found, remove them manually.")
					: ($numPS>0)
						BEEP:C151
						CONFIRM:C162("Remove this job from the Sheeter Schedule?")
						If (ok=1)
							DELETE SELECTION:C66([ProductionSchedules:110])
						End if 
				End case 
				REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
				READ ONLY:C145([ProductionSchedules:110])
			End if   //got job 
		End if 
	Else 
		If ([Job_Forms_Master_Schedule:67]DateStockSheeted:47#!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateStockSheeted:47:=$not
		End if 
	End if 
	
	If (Lvalue4=1)
		If ([Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
			[Job_Forms_Master_Schedule:67]Printed:32:=$now
			If (JOB_isValidForm([Job_Forms_Master_Schedule:67]JobForm:4))
				READ WRITE:C146([ProductionSchedules:110])
				QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=([Job_Forms_Master_Schedule:67]JobForm:4+"@"))
				$numPS:=PS_qryPrintingOnly("*")
				Case of 
					: ($numPS>14)
						BEEP:C151
						ALERT:C41("Too many Schedule Records found, remove them manually.")
					: ($numPS>0)
						BEEP:C151
						CONFIRM:C162("Remove this job from the Press Schedule?")
						If (ok=1)
							DELETE SELECTION:C66([ProductionSchedules:110])
						End if 
				End case 
				REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
				READ ONLY:C145([ProductionSchedules:110])
			End if   //got job
		End if 
	Else 
		If ([Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)
			[Job_Forms_Master_Schedule:67]Printed:32:=$not
		End if 
	End if 
	
	If (Lvalue6=1)
		If ([Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!)
			[Job_Forms_Master_Schedule:67]GlueReady:28:=$now
		End if 
	Else 
		If ([Job_Forms_Master_Schedule:67]GlueReady:28#!00-00-00!)
			[Job_Forms_Master_Schedule:67]GlueReady:28:=$not
		End if 
	End if 
	
	If (Lvalue11=1)
		If ([Job_Forms_Master_Schedule:67]DateBagReturned:52=!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateBagReturned:52:=$now
		End if 
	Else 
		If ([Job_Forms_Master_Schedule:67]DateBagReturned:52#!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateBagReturned:52:=$not
		End if 
	End if 
	
	If (Lvalue12=1)
		If ([Job_Forms_Master_Schedule:67]DateWIPreceived:53=!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateWIPreceived:53:=$now
		End if 
	Else 
		If ([Job_Forms_Master_Schedule:67]DateWIPreceived:53#!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateWIPreceived:53:=$not
		End if 
	End if 
	
	SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
	
	PF_UpdateJobProperty([Job_Forms_Master_Schedule:67]JobForm:4; True:C214)
	
	UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
	
	If (Records in selection:C76([ProductionSchedules:110])=1)
		If (fLockNLoad(->[ProductionSchedules:110]))
			//Lvalue33
			If (Lvalue33=1)  // Modified by: Mel Bohince (11/19/19) 
				If ([ProductionSchedules:110]PreSheetedStock:81=!00-00-00!)
					[ProductionSchedules:110]PreSheetedStock:81:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]PreSheetedStock:81#!00-00-00!)
					[ProductionSchedules:110]PreSheetedStock:81:=$not
				End if 
			End if 
			
			If (Lvalue2=1)
				If ([ProductionSchedules:110]PlatesReady:18=!00-00-00!)
					[ProductionSchedules:110]PlatesReady:18:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]PlatesReady:18#!00-00-00!)
					[ProductionSchedules:110]PlatesReady:18:=$not
				End if 
			End if 
			
			If (Lvalue7=1)
				If ([ProductionSchedules:110]CyrelsReady:19=!00-00-00!)
					[ProductionSchedules:110]CyrelsReady:19:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]CyrelsReady:19#!00-00-00!)
					[ProductionSchedules:110]CyrelsReady:19:=$not
				End if 
			End if 
			
			If (Lvalue3=1)
				If ([ProductionSchedules:110]InkReady:20=!00-00-00!)
					[ProductionSchedules:110]InkReady:20:=$now
					//PF_UpdateTaskProperty ([ProductionSchedules]JobSequence;[ProductionSchedules]CostCenter;0;"Ink";"Yes")
				End if 
			Else 
				If ([ProductionSchedules:110]InkReady:20#!00-00-00!)
					[ProductionSchedules:110]InkReady:20:=$not
				End if 
			End if 
			
			If (Lvalue22=1)  // Modified by: Mel Bohince (11/19/19) was screen film
				If ([ProductionSchedules:110]NormalizedPDF:82=!00-00-00!)
					[ProductionSchedules:110]NormalizedPDF:82:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]NormalizedPDF:82#!00-00-00!)
					[ProductionSchedules:110]NormalizedPDF:82:=$not
				End if 
			End if 
			
			If (Lvalue5=1)
				If ([ProductionSchedules:110]StampingDies:28=!00-00-00!)
					[ProductionSchedules:110]StampingDies:28:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]StampingDies:28#!00-00-00!)
					[ProductionSchedules:110]StampingDies:28:=$not
				End if 
			End if 
			
			If (Lvalue15=1)
				If ([ProductionSchedules:110]EmbossingDies:29=!00-00-00!)
					[ProductionSchedules:110]EmbossingDies:29:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]EmbossingDies:29#!00-00-00!)
					[ProductionSchedules:110]EmbossingDies:29:=$not
				End if 
			End if 
			
			If (Lvalue14=1)
				If ([ProductionSchedules:110]Leaf:30=!00-00-00!)
					[ProductionSchedules:110]Leaf:30:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]Leaf:30#!00-00-00!)
					[ProductionSchedules:110]Leaf:30:=$not
				End if 
			End if 
			
			If (Lvalue20=1)
				If ([ProductionSchedules:110]JobLockedUp:27=!00-00-00!)
					[ProductionSchedules:110]JobLockedUp:27:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]JobLockedUp:27#!00-00-00!)
					[ProductionSchedules:110]JobLockedUp:27:=$not
				End if 
			End if 
			
			If (Lvalue21=1)
				If ([ProductionSchedules:110]FemaleStripperBoard:26=!00-00-00!)
					[ProductionSchedules:110]FemaleStripperBoard:26:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]FemaleStripperBoard:26#!00-00-00!)
					[ProductionSchedules:110]FemaleStripperBoard:26:=$not
				End if 
			End if 
			
			If (Lvalue23=1)
				If ([ProductionSchedules:110]InHouse:32=!00-00-00!)
					[ProductionSchedules:110]InHouse:32:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]InHouse:32#!00-00-00!)
					[ProductionSchedules:110]InHouse:32:=$not
				End if 
			End if 
			
			If (Lvalue24=1)
				If ([ProductionSchedules:110]ToolingSent:39=!00-00-00!)
					[ProductionSchedules:110]ToolingSent:39:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]ToolingSent:39#!00-00-00!)
					[ProductionSchedules:110]ToolingSent:39:=$not
				End if 
			End if 
			
			If (Lvalue25=1)
				If ([ProductionSchedules:110]StandardsSent:40=!00-00-00!)
					[ProductionSchedules:110]StandardsSent:40:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]StandardsSent:40#!00-00-00!)
					[ProductionSchedules:110]StandardsSent:40:=$not
				End if 
			End if 
			
			If (Lvalue13=1)
				If ([ProductionSchedules:110]DateFilmStampingRcd:43=!00-00-00!)
					[ProductionSchedules:110]DateFilmStampingRcd:43:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateFilmStampingRcd:43#!00-00-00!)
					[ProductionSchedules:110]DateFilmStampingRcd:43:=$not
				End if 
			End if 
			
			If (Lvalue16=1)
				If ([ProductionSchedules:110]DateFilmEmbossRcd:44=!00-00-00!)
					[ProductionSchedules:110]DateFilmEmbossRcd:44:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateFilmEmbossRcd:44#!00-00-00!)
					[ProductionSchedules:110]DateFilmEmbossRcd:44:=$not
				End if 
			End if 
			
			If (Lvalue17=1)
				If ([ProductionSchedules:110]DateCountersRecd:41=!00-00-00!)
					[ProductionSchedules:110]DateCountersRecd:41:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateCountersRecd:41#!00-00-00!)
					[ProductionSchedules:110]DateCountersRecd:41:=$not
				End if 
			End if 
			
			If (Lvalue18=1)
				If ([ProductionSchedules:110]DateDieBoardRecd:45=!00-00-00!)
					[ProductionSchedules:110]DateDieBoardRecd:45:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateDieBoardRecd:45#!00-00-00!)
					[ProductionSchedules:110]DateDieBoardRecd:45:=$not
				End if 
			End if 
			
			If (Lvalue19=1)
				If ([ProductionSchedules:110]DateBlankerRecd:42=!00-00-00!)
					[ProductionSchedules:110]DateBlankerRecd:42:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateBlankerRecd:42#!00-00-00!)
					[ProductionSchedules:110]DateBlankerRecd:42:=$not
				End if 
			End if 
			
			If (Lvalue26=1)
				If ([ProductionSchedules:110]DateDieFilesReady:46=!00-00-00!)
					[ProductionSchedules:110]DateDieFilesReady:46:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateDieFilesReady:46#!00-00-00!)
					[ProductionSchedules:110]DateDieFilesReady:46:=$not
				End if 
			End if 
			
			[ProductionSchedules:110]RequisitionNum:33:=sReq
			[ProductionSchedules:110]PurchaseOrder:34:=sPO
			[ProductionSchedules:110]WIPsentSheets:35:=iSheetsSent
			[ProductionSchedules:110]WIPsentSkids:36:=iSkidsSent
			[ProductionSchedules:110]WIPreturnedSheets:37:=iSheetsRet
			[ProductionSchedules:110]WIPreturnedSkids:38:=iSkidsRet
			
			If (Lvalue27=1)
				If ([ProductionSchedules:110]DateLatisealed:47=!00-00-00!)
					[ProductionSchedules:110]DateLatisealed:47:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateLatisealed:47#!00-00-00!)
					[ProductionSchedules:110]DateLatisealed:47:=$not
				End if 
			End if 
			
			If (Lvalue28=1)
				If ([ProductionSchedules:110]DateWindowsCut:48=!00-00-00!)
					[ProductionSchedules:110]DateWindowsCut:48:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateWindowsCut:48#!00-00-00!)
					[ProductionSchedules:110]DateWindowsCut:48:=$not
				End if 
			End if 
			
			If (Lvalue29=1)
				If ([ProductionSchedules:110]DateAdhesiveOK:49=!00-00-00!)
					[ProductionSchedules:110]DateAdhesiveOK:49:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateAdhesiveOK:49#!00-00-00!)
					[ProductionSchedules:110]DateAdhesiveOK:49:=$not
				End if 
			End if 
			
			If (Lvalue30=1)
				If ([ProductionSchedules:110]DateLaminateOK:50=!00-00-00!)
					[ProductionSchedules:110]DateLaminateOK:50:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateLaminateOK:50#!00-00-00!)
					[ProductionSchedules:110]DateLaminateOK:50:=$not
				End if 
			End if 
			
			If (Lvalue32=1)
				If ([ProductionSchedules:110]DateDyluxChecked:75=!00-00-00!)
					[ProductionSchedules:110]DateDyluxChecked:75:=$now
				End if 
			Else 
				If ([ProductionSchedules:110]DateDyluxChecked:75#!00-00-00!)
					[ProductionSchedules:110]DateDyluxChecked:75:=$not
				End if 
			End if 
			
			SAVE RECORD:C53([ProductionSchedules:110])
			
			PF_UpdateSet_A_DateProperties([ProductionSchedules:110]JobSequence:8; [ProductionSchedules:110]CostCenter:1; 0)
			UNLOAD RECORD:C212([ProductionSchedules:110])
			
			$err:=Shuttle_Register("milestone"; sJobForm)
			
			
			
		Else   // Modified by: Mel Bohince (7/14/15) 
			ALERT:C41("Job sequence record is locked.")
		End if   //pressSchd
		
	Else   // Modified by: Mel Bohince (7/14/15) 
		If (i1>0)
			ALERT:C41("Job sequence record was not found.")
		End if 
	End if   //pressSchd
	
	zwStatusMsg(sJobForm; "Dates set")
	sJobForm:=""
	i1:=0
	Lvalue1:=0
	Lvalue2:=0
	Lvalue3:=0
	Lvalue4:=0
	Lvalue5:=0
	Lvalue6:=0
	Lvalue7:=0
	Lvalue8:=0
	Lvalue9:=0
	Lvalue10:=0
	Lvalue11:=0
	Lvalue12:=0
	Lvalue13:=0
	Lvalue14:=0
	Lvalue15:=0
	Lvalue16:=0
	Lvalue17:=0
	Lvalue18:=0
	Lvalue19:=0
	Lvalue20:=0
	Lvalue21:=0
	Lvalue22:=0
	// • mel (8/12/04, 11:00:46)
	Lvalue23:=0
	Lvalue24:=0
	Lvalue25:=0
	Lvalue26:=0
	Lvalue27:=0  // • mel (12/1/04, 15:32:08)
	Lvalue28:=0
	Lvalue29:=0
	Lvalue30:=0
	Lvalue31:=0
	Lvalue32:=0
	Lvalue33:=0
	
	sReq:=""
	sPO:=""
	iSheetsSent:=0
	iSkidsSent:=0
	iSheetsRet:=0
	iSkidsRet:=0
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
End if   //jml

READ ONLY:C145([Job_Forms_Master_Schedule:67])  // Modified by: MelvinBohince (2/3/22) READ ONLY([Job_Forms_Master_Schedule]) on exit

GOTO OBJECT:C206(sJobForm)
SetObjectProperties("job@"; -><>NULL; False:C215)
SetObjectProperties("seq@"; -><>NULL; False:C215)