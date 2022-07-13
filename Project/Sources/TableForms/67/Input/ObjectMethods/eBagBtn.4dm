//OM: bEBag() -> 
// -------
// -------
// -------
// Method: [zz_control].PressSchedule.eBagBtn   ( ) ->
//@author mlb - 1/29/02  14:53
// Modified by: Mel Bohince (10/13/17) add the sequence to pre-select tab
If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	<>jobform:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
	<>jobformseq:=[ProductionSchedules:110]JobSequence:8  // Modified by: Mel Bohince (10/13/17) add the sequence to pre-select tab
	eBag_UI
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 