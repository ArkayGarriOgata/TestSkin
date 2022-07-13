//%attributes = {"executedOnServer":true}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/16/15, 13:57:35
// ----------------------------------------------------
// Method: Adv_JobSchedulerLoadOnServer
// Description
// 
//
// Parameters
// ----------------------------------------------------
//$1=->BLOB
//$2=->array holding the ->sttJobFormSeq values


C_PICTURE:C286($iPict; $iPictGoTo)
C_LONGINT:C283($i; $xlRecs)
C_DATE:C307($dHRD; $dStartDate; $dEndDate)
C_POINTER:C301($1; $2)
C_TIME:C306($hStartTime; $hEndTime)

SET BLOB SIZE:C606($1->; 0)


$ttPath:=Get 4D folder:C485(Current resources folder:K5:16)+"popupicon.png"
READ PICTURE FILE:C678($ttPath; $iPict)
$ttPath:=Get 4D folder:C485(Current resources folder:K5:16)+"gotoicon.png"
READ PICTURE FILE:C678($ttPath; $iPictGoTo)


If (Count parameters:C259>1)
	ARRAY TEXT:C222($sttValues; 0)
	COPY ARRAY:C226($2->; $sttValues)
	
	If (Size of array:C274($sttValues)=0)  // Since we are NOT reloading the screen, the array is blank, load all scheduled items
		ALL RECORDS:C47([ProductionSchedules:110])
		ARRAY TEXT:C222($sttJobFormSeq; 0)
		SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $sttJobFormSeq)
		
		QUERY WITH ARRAY:C644([Job_Forms_Machines:43]JobSequence:8; $sttJobFormSeq)
		
	Else 
		QUERY WITH ARRAY:C644([Job_Forms_Machines:43]JobSequence:8; $sttValues)
	End if 
	
Else 
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]MAD:21=!00-00-00!)
	
	RELATE ONE SELECTION:C349([Job_Forms_Master_Schedule:67]; [Job_Forms:42])  // Get Job Forms
	RELATE MANY SELECTION:C340([Job_Forms_Machines:43]JobForm:1)
End if 

Adv_JobSchedulerArrays("Init")
ARRAY TEXT:C222($sttJobFormDesc; 0)
ARRAY LONGINT:C221($sxlJobNumber; 0)
ARRAY TEXT:C222($sttJobCust; 0)
ARRAY TEXT:C222($sttJobCustLine; 0)
ARRAY DATE:C224($sdNeedDate; 0)
ARRAY TEXT:C222($sttProcessSpec; 0)
ARRAY TEXT:C222($sttCustLine; 0)

SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)

SELECTION TO ARRAY:C260([Job_Forms_Machines:43]JobSequence:8; sttJobFormSeq; [Cost_Centers:27]ID:1; sttJobMachineID; [Cost_Centers:27]Description:3; sttJobMachine; [Job_Forms_Machines:43]Planned_Qty:10; sxrJobQty; [Jobs:15]CustomerName:5; $sttJobCust; [Jobs:15]Line:3; $sttJobCustLine; [Job_Forms:42]JobNo:2; $sxlJobNumber; [Job_Forms:42]NeedDate:1; $sdNeedDate; [Job_Forms:42]ProcessSpec:46; $sttProcessSpec; [Job_Forms:42]CustomerLine:62; $sttCustLine; [Job_Forms:42]JobFormID:5; sttJobFormID; [Job_Forms:42]ProcessSpec:46; sttJobType; [Job_Forms:42]CustomerLine:62; sttJobTypeDesc)


SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
$xlRecs:=Size of array:C274($sxlJobNumber)
ARRAY TEXT:C222(sttJobNum; $xlRecs)

ARRAY TEXT:C222(sttJobCompletedOn; $xlRecs)
ARRAY PICTURE:C279(siSelectMachine; $xlRecs)
ARRAY PICTURE:C279(siGoToMachine; $xlRecs)

ARRAY TEXT:C222(sttJobOnMachineID; $xlRecs)
ARRAY TEXT:C222(sttJobOnMachine; $xlRecs)

ARRAY PICTURE:C279(siJobGraph; $xlRecs)



For ($i; 1; $xlRecs)
	sttJobNum{$i}:=String:C10($sxlJobNumber{$i})+" - "+$sttJobCust{$i}
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=sttJobFormID{$i})
	$dHRD:=[Job_Forms_Master_Schedule:67]MAD:21
	UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
	
	sttJobFormID{$i}:=sttJobFormID{$i}+", Needed by "+String:C10($sdNeedDate{$i}; System date short:K1:1)+", for "+$sttProcessSpec{$i}+", "+$sttCustLine{$i}+"  ( HRD: "+String:C10($dHRD; System date short:K1:1)+" )"
	siSelectMachine{$i}:=$iPict
	
	sttJobMachine{$i}:=sttJobMachineID{$i}+"-"+sttJobMachine{$i}
	
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=sttJobFormSeq{$i})
	$dStartDate:=[ProductionSchedules:110]StartDate:4
	$hStartTime:=[ProductionSchedules:110]StartTime:5
	
	$dEndDate:=[ProductionSchedules:110]EndDate:6
	$hEndTime:=[ProductionSchedules:110]EndTime:7
	
	
	sttJobOnMachineID{$i}:=[ProductionSchedules:110]CostCenter:1
	sttJobOnMachine{$i}:=sttJobOnMachineID{$i}+"-"+[ProductionSchedules:110]Name:2
	If (sttJobOnMachineID{$i}#"")
		siGoToMachine{$i}:=$iPictGoTo
	Else 
		siGoToMachine{$i}:=siGoToMachine{$i}*0
	End if 
	
	
	If (Records in selection:C76([ProductionSchedules:110])=0)  // NOT SCHEDULED
		$dStartDate:=!1900-01-01!
		$hStartTime:=?00:00:00?
		$dEndDate:=!1900-01-01!
		$hEndTime:=?00:00:00?
		
	End if 
	
	sttJobCompletedOn{$i}:=String:C10([ProductionSchedules:110]StartDate:4; System date short:K1:1)+" @ "+String:C10([ProductionSchedules:110]StartTime:5; System time short:K7:9)
	
	siJobGraph{$i}:=BuildDateDot(200; $dStartDate; $hStartTime; $dEndDate; $hEndTime; 4D_Current_date; 4D_Current_date+30)
	
	UNLOAD RECORD:C212([ProductionSchedules:110])
End for 



Adv_JobSchedulerArrays("ArraysToBLOB"; $1)
