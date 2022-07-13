// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 4/16/02  15:35
// ----------------------------------------------------
// Object Method: [Job_Forms_Master_Schedule].SetDate_dio.Variable1
// ----------------------------------------------------

SetObjectProperties("seq@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/13/13)
$jobSequence:=(sJobForm+"."+String:C10(i1; "000"))
If (i1>0)
	If (Length:C16(sJobForm)=8)
		READ WRITE:C146([ProductionSchedules:110])  //
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$jobSequence)
		If (Records in selection:C76([ProductionSchedules:110])=1)
			If (fLockNLoad(->[ProductionSchedules:110]))
				SetObjectProperties("seq@"; -><>NULL; True:C214)
				Lvalue2:=Num:C11([ProductionSchedules:110]PlatesReady:18#!00-00-00!)
				Lvalue7:=Num:C11([ProductionSchedules:110]CyrelsReady:19#!00-00-00!)
				Lvalue3:=Num:C11([ProductionSchedules:110]InkReady:20#!00-00-00!)
				Lvalue5:=Num:C11([ProductionSchedules:110]StampingDies:28#!00-00-00!)
				Lvalue14:=Num:C11([ProductionSchedules:110]Leaf:30#!00-00-00!)
				Lvalue15:=Num:C11([ProductionSchedules:110]EmbossingDies:29#!00-00-00!)
				Lvalue22:=Num:C11([ProductionSchedules:110]NormalizedPDF:82#!00-00-00!)
				Lvalue21:=Num:C11([ProductionSchedules:110]FemaleStripperBoard:26#!00-00-00!)
				Lvalue20:=Num:C11([ProductionSchedules:110]JobLockedUp:27#!00-00-00!)
				
				Lvalue23:=Num:C11([ProductionSchedules:110]InHouse:32#!00-00-00!)
				Lvalue24:=Num:C11([ProductionSchedules:110]ToolingSent:39#!00-00-00!)
				Lvalue25:=Num:C11([ProductionSchedules:110]StandardsSent:40#!00-00-00!)
				
				Lvalue13:=Num:C11([ProductionSchedules:110]DateFilmStampingRcd:43#!00-00-00!)
				Lvalue16:=Num:C11([ProductionSchedules:110]DateFilmEmbossRcd:44#!00-00-00!)
				Lvalue17:=Num:C11([ProductionSchedules:110]DateCountersRecd:41#!00-00-00!)
				Lvalue18:=Num:C11([ProductionSchedules:110]DateDieBoardRecd:45#!00-00-00!)
				Lvalue19:=Num:C11([ProductionSchedules:110]DateBlankerRecd:42#!00-00-00!)
				Lvalue26:=Num:C11([ProductionSchedules:110]DateDieFilesReady:46#!00-00-00!)
				
				Lvalue27:=Num:C11([ProductionSchedules:110]DateLatisealed:47#!00-00-00!)
				Lvalue28:=Num:C11([ProductionSchedules:110]DateWindowsCut:48#!00-00-00!)
				Lvalue29:=Num:C11([ProductionSchedules:110]DateAdhesiveOK:49#!00-00-00!)
				Lvalue30:=Num:C11([ProductionSchedules:110]DateLaminateOK:50#!00-00-00!)
				
				Lvalue33:=Num:C11([ProductionSchedules:110]PreSheetedStock:81#!00-00-00!)
				
				sReq:=[ProductionSchedules:110]RequisitionNum:33
				sPO:=[ProductionSchedules:110]PurchaseOrder:34
				iSheetsSent:=[ProductionSchedules:110]WIPsentSheets:35
				iSkidsSent:=[ProductionSchedules:110]WIPsentSkids:36
				iSheetsRet:=[ProductionSchedules:110]WIPreturnedSheets:37
				iSkidsRet:=[ProductionSchedules:110]WIPreturnedSkids:38
				SetObjectProperties("seqField@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
				
				JML_SetDateColors
				
			Else 
				ALERT:C41("Job sequence record "+$jobSequence+"is locked.")
			End if 
			
		Else 
			ALERT:C41("Job sequence record "+$jobSequence+" was not found.")
		End if 
	End if 
	
Else   //no sequence provided
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
End if 