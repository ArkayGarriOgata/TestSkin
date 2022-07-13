Case of 
	: (Form event code:C388=On Load:K2:1)
		READ ONLY:C145([Customers_Projects:9])
		If (Not:C34(User in group:C338(Current user:C182; "RoleOperations")))
			OBJECT SET ENABLED:C1123(bDelete; False:C215)
			OBJECT SET ENABLED:C1123(bSave; False:C215)
			OBJECT SET ENABLED:C1123(bSaveBlock; False:C215)
		End if 
		[ProductionSchedules_BlockTimes:136]ModDate:8:=4D_Current_date
		[ProductionSchedules_BlockTimes:136]ModWho:7:=<>zResp
		JML_BlockTimeInitStandards
		JML_BlockTimeInitProcessVars
		C_LONGINT:C283($offset; $row; $secondsLag; $adjustedStart; $secondsDuration)
		C_POINTER:C301($ptrChkBox; $ptrCC; $ptrRate; $ptrHrs; $ptrLag)
		
		If (Is new record:C668([ProductionSchedules_BlockTimes:136]))
			If (Length:C16(<>pjtId)=5)  //set by Pjt_setReferId
				QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=<>pjtId)
				[ProductionSchedules_BlockTimes:136]BlockId:1:=app_GetPrimaryKey  //app_AutoIncrement (->[ProductionSchedules_BlockTimes])  `;"00000")
				[ProductionSchedules_BlockTimes:136]ProjectNumber:2:=<>pjtId
				<>pjtId:=""
				//set the operations, r1 -  r39 to zero
				For ($row; 1; 9)
					$ptrChkBox:=Get pointer:C304("rb"+String:C10($row))
					$ptrChkBox->:=0
					$ptrCC:=Get pointer:C304("r"+String:C10($row))
					$ptrCC->:=0
					$ptrRate:=Get pointer:C304("r1"+String:C10($row))
					$ptrRate->:=0
					$ptrHrs:=Get pointer:C304("r2"+String:C10($row))
					$ptrHrs->:=0
					$ptrLag:=Get pointer:C304("r3"+String:C10($row))
					$ptrLag->:=0
				End for 
				
			Else 
				BEEP:C151
				ALERT:C41("Use the 'Issue Runs' button on the Project Control Center"; "Cancel")
				CANCEL:C270
			End if 
			
		Else   //existing block, reload variables
			JML_BlockTimeRestoreSettings
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		Case of 
			: (bSave=1)
				JML_BlockTimeSaveSettings
			: (bSaveBlock=1)
				JML_BlockTimeSaveSettings
				JML_BlockTimeMakeBlocks
		End case 
		//make blocks
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
