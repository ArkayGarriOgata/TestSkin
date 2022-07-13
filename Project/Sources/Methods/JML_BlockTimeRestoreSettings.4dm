//%attributes = {}
// Method: JML_BlockTimeRestoreSettings () -> 
// ----------------------------------------------------
// by: mel: 01/28/05, 15:23:04
// ----------------------------------------------------
// Description:
// reload the form to prior settings
//Updates:
// • mel (1/28/05, 15:48:40) make iTimes a field
// ----------------------------------------------------

C_LONGINT:C283($offset; $row)
C_POINTER:C301($ptrChkBox; $ptrCC; $ptrRate; $ptrHrs; $ptrLag)

QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[ProductionSchedules_BlockTimes:136]ProjectNumber:2)
$offset:=0
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; iSheets; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; iUp; $offset)

BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; dDateBegin; $offset)
//BLOB TO VARIABLE([BlockTime]Settings;iTimes;$offset)

BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; sRMcode; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; sOutline; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; xText; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; iDays; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; sComment; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; sDieNumber; $offset)
//set the operations
For ($row; 1; 9)
	$ptrChkBox:=Get pointer:C304("cb"+String:C10($row))
	$ptrCC:=Get pointer:C304("r"+String:C10($row))
	$ptrRate:=Get pointer:C304("r1"+String:C10($row))
	$ptrHrs:=Get pointer:C304("r2"+String:C10($row))
	$ptrLag:=Get pointer:C304("r3"+String:C10($row))
	BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; $ptrChkBox->; $offset)
	BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; $ptrCC->; $offset)
	BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; $ptrRate->; $offset)
	BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; $ptrHrs->; $offset)
	BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; $ptrLag->; $offset)
End for 
//set the frequency
For ($row; 1; 6)
	$ptrChkBox:=Get pointer:C304("rb"+String:C10($row))
	BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; $ptrChkBox->; $offset)
End for 
//things that were added later
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; b1; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; b2; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; iHRDweeks; $offset)
BLOB TO VARIABLE:C533([ProductionSchedules_BlockTimes:136]Settings:3; iNumJobs; $offset)