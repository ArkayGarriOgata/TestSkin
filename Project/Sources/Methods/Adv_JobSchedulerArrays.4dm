//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/16/15, 13:46:56
// ----------------------------------------------------
// Method: Adv_JobSchedulerArrays
// Description
// Parameters
// ----------------------------------------------------
//$1=Message
//$2=Pointer, Depends on message
// sort added by: Mel Bohince (1/20/16) 

C_TEXT:C284($1; $ttPath)
C_POINTER:C301($2)
C_PICTURE:C286($iPict)
C_LONGINT:C283($xlOffset)
C_BLOB:C604($obData)
C_LONGINT:C283($xlRow)

Case of 
	: ($1="Init")
		ARRAY TEXT:C222(sttJobNum; 0)
		ARRAY REAL:C219(sxrJobQty; 0)
		ARRAY PICTURE:C279(siSelectMachine; 0)
		ARRAY PICTURE:C279(siGoToMachine; 0)
		ARRAY TEXT:C222(sttJobMachine; 0)
		ARRAY TEXT:C222(sttJobOnMachine; 0)
		ARRAY TEXT:C222(sttJobCompletedOn; 0)
		
		
		ARRAY TEXT:C222(sttJobOnMachineID; 0)
		ARRAY TEXT:C222(sttJobFormSeq; 0)
		ARRAY TEXT:C222(sttJobFormID; 0)
		ARRAY TEXT:C222(sttJobType; 0)
		ARRAY TEXT:C222(sttJobTypeDesc; 0)
		
		ARRAY PICTURE:C279(siJobGraph; 0)
		
	: ($1="Reload")
		//->sttJobFormSeq
		SHOW_MESSAGE("Init"; "Reloading items, please wait...")
		Adv_JobSchedulerLoadOnServer(->$obData; ->sttJobFormSeq)
		Adv_JobSchedulerArrays("Init")
		Adv_JobSchedulerArrays("BLOBToArrays"; ->$obData)
		SHOW_MESSAGE("Close")
		
		
	: ($1="LoadAllScheduled")
		SHOW_MESSAGE("Init"; "Loading all scheduled items, please wait...")
		Adv_JobSchedulerArrays("Init")  // Force sttJobFormSeq to be BLANK so it forces loading of all scheduled inside Adv_JobSchedulerLoadOnServer
		Adv_JobSchedulerLoadOnServer(->$obData; ->sttJobFormSeq)
		Adv_JobSchedulerArrays("BLOBToArrays"; ->$obData)
		SHOW_MESSAGE("Close")
		
	: ($1="LoadNeedHRD")
		SHOW_MESSAGE("Init"; "Loading items without HRD Date, please wait...")
		Adv_JobSchedulerArrays("Init")
		Adv_JobSchedulerLoadOnServer(->$obData)
		Adv_JobSchedulerArrays("BLOBToArrays"; ->$obData)
		SHOW_MESSAGE("Close")
		
	: ($1="Update")  //$2=->Row
		$xlRow:=$2->
		$ttPath:=Get 4D folder:C485(Current resources folder:K5:16)+"gotoicon.png"
		READ PICTURE FILE:C678($ttPath; $iPictGoTo)
		
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=sttJobFormSeq{$xlRow})
		sttJobOnMachineID{$xlRow}:=[ProductionSchedules:110]CostCenter:1
		sttJobOnMachine{$xlRow}:=sttJobOnMachineID{$xlRow}+"-"+[ProductionSchedules:110]Name:2
		sttJobCompletedOn{$xlRow}:=String:C10([ProductionSchedules:110]StartDate:4; System date short:K1:1)+" @ "+String:C10([ProductionSchedules:110]StartTime:5; System time short:K7:9)
		If (sttJobOnMachineID{$xlRow}#"")
			siGoToMachine{$xlRow}:=$iPictGoTo
		Else 
			siGoToMachine{$xlRow}:=siGoToMachine{$xlRow}*0
		End if 
		
		siJobGraph{$xlRow}:=BuildDateDot(200; [ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5; [ProductionSchedules:110]EndDate:6; [ProductionSchedules:110]EndTime:7; 4D_Current_date; 4D_Current_date+30)
		
		
		$ttText:=sttJobFormID{$xlRow}
		$ttJobFormID:=GetNextField(->$ttText; ",")
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$ttJobFormID)
		$dHRD:=[Job_Forms_Master_Schedule:67]MAD:21
		UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
		
		UNLOAD RECORD:C212([ProductionSchedules:110])
		
		
		
	: ($1="ArraysToBLOB")  //$2=->BLOB variable
		SET BLOB SIZE:C606($2->; 0)
		// sort added by: Mel Bohince (1/20/16) 
		SORT ARRAY:C229(sttJobFormSeq; sttJobNum; sttJobFormID; sttJobType; sttJobTypeDesc; sttJobCompletedOn; sttJobMachineID; sttJobMachine; sxrJobQty; siSelectMachine; siGoToMachine; sttJobOnMachine; sttJobOnMachineID; siJobGraph; >)
		
		VARIABLE TO BLOB:C532(sttJobFormSeq; $2->; *)
		VARIABLE TO BLOB:C532(sttJobNum; $2->; *)
		VARIABLE TO BLOB:C532(sttJobFormID; $2->; *)
		VARIABLE TO BLOB:C532(sttJobType; $2->; *)
		VARIABLE TO BLOB:C532(sttJobTypeDesc; $2->; *)
		
		VARIABLE TO BLOB:C532(sttJobCompletedOn; $2->; *)
		VARIABLE TO BLOB:C532(sttJobMachineID; $2->; *)
		VARIABLE TO BLOB:C532(sttJobMachine; $2->; *)
		VARIABLE TO BLOB:C532(sxrJobQty; $2->; *)
		
		VARIABLE TO BLOB:C532(siSelectMachine; $2->; *)
		VARIABLE TO BLOB:C532(siGoToMachine; $2->; *)
		
		VARIABLE TO BLOB:C532(sttJobOnMachine; $2->; *)
		VARIABLE TO BLOB:C532(sttJobOnMachineID; $2->; *)
		
		VARIABLE TO BLOB:C532(siJobGraph; $2->; *)
		
		
	: ($1="BLOBToArrays")  //$2=->BLOB variable
		Adv_JobSchedulerArrays("Init")
		$xlOffset:=0
		BLOB TO VARIABLE:C533($2->; sttJobFormSeq; $xlOffset)
		BLOB TO VARIABLE:C533($2->; sttJobNum; $xlOffset)
		BLOB TO VARIABLE:C533($2->; sttJobFormID; $xlOffset)
		BLOB TO VARIABLE:C533($2->; sttJobType; $xlOffset)
		BLOB TO VARIABLE:C533($2->; sttJobTypeDesc; $xlOffset)
		
		BLOB TO VARIABLE:C533($2->; sttJobCompletedOn; $xlOffset)
		BLOB TO VARIABLE:C533($2->; sttJobMachineID; $xlOffset)
		BLOB TO VARIABLE:C533($2->; sttJobMachine; $xlOffset)
		BLOB TO VARIABLE:C533($2->; sxrJobQty; $xlOffset)
		
		BLOB TO VARIABLE:C533($2->; siSelectMachine; $xlOffset)
		BLOB TO VARIABLE:C533($2->; siGoToMachine; $xlOffset)
		
		BLOB TO VARIABLE:C533($2->; sttJobOnMachine; $xlOffset)
		BLOB TO VARIABLE:C533($2->; sttJobOnMachineID; $xlOffset)
		
		BLOB TO VARIABLE:C533($2->; siJobGraph; $xlOffset)
		
End case 