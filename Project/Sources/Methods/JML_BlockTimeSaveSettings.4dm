//%attributes = {}
// Method: JML_BlockTimeSaveSettings () -> 
// ----------------------------------------------------
// by: mel: 01/28/05, 09:36:16
// ----------------------------------------------------
// Description:
// Save settings to disk
//Updates:
// • mel (1/28/05, 15:48:40) make iTimes a field
// ----------------------------------------------------

C_LONGINT:C283($row)
C_POINTER:C301($ptrChkBox; $ptrCC; $ptrRate; $ptrHrs; $ptrLag)

SET BLOB SIZE:C606([ProductionSchedules_BlockTimes:136]Settings:3; 0)
VARIABLE TO BLOB:C532(iSheets; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(iUp; [ProductionSchedules_BlockTimes:136]Settings:3; *)

VARIABLE TO BLOB:C532(dDateBegin; [ProductionSchedules_BlockTimes:136]Settings:3; *)
//VARIABLE TO BLOB(iTimes;[BlockTime]Settings;*)

VARIABLE TO BLOB:C532(sRMcode; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(sOutline; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(xText; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(iDays; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(sComment; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(sDieNumber; [ProductionSchedules_BlockTimes:136]Settings:3; *)
//get th operations
For ($row; 1; 9)
	$ptrChkBox:=Get pointer:C304("cb"+String:C10($row))
	$ptrCC:=Get pointer:C304("r"+String:C10($row))
	$ptrRate:=Get pointer:C304("r1"+String:C10($row))
	$ptrHrs:=Get pointer:C304("r2"+String:C10($row))
	$ptrLag:=Get pointer:C304("r3"+String:C10($row))
	VARIABLE TO BLOB:C532($ptrChkBox->; [ProductionSchedules_BlockTimes:136]Settings:3; *)
	VARIABLE TO BLOB:C532($ptrCC->; [ProductionSchedules_BlockTimes:136]Settings:3; *)
	VARIABLE TO BLOB:C532($ptrRate->; [ProductionSchedules_BlockTimes:136]Settings:3; *)
	VARIABLE TO BLOB:C532($ptrHrs->; [ProductionSchedules_BlockTimes:136]Settings:3; *)
	VARIABLE TO BLOB:C532($ptrLag->; [ProductionSchedules_BlockTimes:136]Settings:3; *)
End for 
//get the frequency
For ($row; 1; 6)
	$ptrChkBox:=Get pointer:C304("rb"+String:C10($row))
	VARIABLE TO BLOB:C532($ptrChkBox->; [ProductionSchedules_BlockTimes:136]Settings:3; *)
End for 
//things that were added later
VARIABLE TO BLOB:C532(b1; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(b2; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(iHRDweeks; [ProductionSchedules_BlockTimes:136]Settings:3; *)
VARIABLE TO BLOB:C532(iNumJobs; [ProductionSchedules_BlockTimes:136]Settings:3; *)