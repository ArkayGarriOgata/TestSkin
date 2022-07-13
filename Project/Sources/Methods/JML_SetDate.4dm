//%attributes = {"publishedWeb":true}
//PM: JML_SetDate() -> 
//@author mlb - 4/18/01  09:56
//• mlb - 8/14/02  10:39 add some more
// Modified by: MelvinBohince (2/3/22) ignore preState of JML, always go readonly

C_LONGINT:C283($x; $y; $state)
C_TEXT:C284(sJobForm)
C_LONGINT:C283(i1; Lvalue1; Lvalue2; Lvalue3; Lvalue4; Lvalue5; Lvalue6; $2; $preCondition2; i2)
C_LONGINT:C283(Lvalue7; Lvalue8; Lvalue9; Lvalue10; Lvalue11; Lvalue12)
C_LONGINT:C283(Lvalue13; Lvalue14; Lvalue15; Lvalue16; Lvalue17; Lvalue18; Lvalue19; Lvalue20; Lvalue21; Lvalue22)
C_LONGINT:C283(Lvalue23; Lvalue24; Lvalue25; Lvalue26; Lvalue27; Lvalue28; Lvalue29; Lvalue30)
C_DATE:C307($now; $not)
C_TEXT:C284($preCondition; $1)

GET MOUSE:C468($x; $y; $state; *)

$preCondition:=sJobForm
$preCondition2:=i1
$preState:=util_getReadWriteState(->[Job_Forms_Master_Schedule:67])
$preState2:=util_getReadWriteState(->[ProductionSchedules:110])
//If ($preState) | ($preState2)  // Modified by: Mel Bohince (7/14/15) 
//ALERT("Production schedule is in read-only state, dates won't be saved, check your login.")
//End if 
CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "holdForPriority")
CUT NAMED SELECTION:C334([ProductionSchedules:110]; "holdForPlates")

Case of 
	: (Count parameters:C259=1)
		sJobForm:=$1
		i1:=0
	: (Count parameters:C259=2)
		sJobForm:=$1
		i1:=$2
	Else 
		sJobForm:=""
		i1:=0
End case 
<>JobForm:=sJobForm
READ WRITE:C146([Job_Forms_Master_Schedule:67])
READ WRITE:C146([ProductionSchedules:110])  // Modified by: Mark Zinke (11/8/12)

//utl_LogfileServer (<>zResp;"SET-A-DATE--"+sJobForm)

//$winRef:=Open form window([JobMasterLog];"SetDate_dio";5;$x-50;$y-300)
$winRef:=Open form window:C675([Job_Forms_Master_Schedule:67]; "SetDate_dio"; 5)
DIALOG:C40([Job_Forms_Master_Schedule:67]; "SetDate_dio")
CLOSE WINDOW:C154($winRef)

sJobForm:=$preCondition
i1:=$preCondition2
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
	UNLOAD RECORD:C212([ProductionSchedules:110])
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
Else 
	
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
End if   // END 4D Professional Services : January 2019 

If ($preState) | (True:C214)  // Modified by: MelvinBohince (2/3/22) 
	READ ONLY:C145([Job_Forms_Master_Schedule:67])
End if 
If ($preState2)
	READ ONLY:C145([ProductionSchedules:110])
End if 

USE NAMED SELECTION:C332("holdForPriority")
USE NAMED SELECTION:C332("holdForPlates")