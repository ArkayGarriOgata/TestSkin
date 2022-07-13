//%attributes = {"publishedWeb":true}
//PM: PS_moveToOtherPlant(oldCompanyId;newCompanyID) -> 
//@author mlb - 4/8/03  17:09
// • mel (11/20/03, 11:26:12) clear out a few more things
// Modified by: Mel Bohince (3/5/13) disable, only mfg at one plant currently, and could be causing inadvertant date losses

If (False:C215)  //Modified by: Mel Bohince (3/5/13) disable
	//If ($1#$2)  //clear some red/green
	//[ProductionSchedules]PlatesReady:=!00/00/0000!
	//[ProductionSchedules]CyrelsReady:=!00/00/0000!
	//[ProductionSchedules]InkReady:=!00/00/0000!
	//[ProductionSchedules]ScreenFilm:=!00/00/0000!
	//[ProductionSchedules]StampingDies:=!00/00/0000!
	//[ProductionSchedules]EmbossingDies:=!00/00/0000!
	//[ProductionSchedules]Leaf:=!00/00/0000!
	//[ProductionSchedules]JobLockedUp:=!00/00/0000!
	//[ProductionSchedules]FemaleStripperBoard:=!00/00/0000!
	//  // • mel (11/20/03, 11:26:12) clear out a few more things
	
	//READ WRITE([Job_Forms_Master_Schedule])
	//QUERY([Job_Forms_Master_Schedule];[Job_Forms_Master_Schedule]JobForm=(Substring([ProductionSchedules]JobSequence;1;8)))
	//  //[JobMasterLog]DateBagReturned:=!00/00/00!
	
	//  //[JobMasterLog]DateWIPreceived:=!00/00/00!
	
	//[Job_Forms_Master_Schedule]DateCountersRecd:=!00/00/0000!
	//[Job_Forms_Master_Schedule]DateBlankerRecd:=!00/00/0000!
	//  //[JobMasterLog]DateFilmStampingRecd:=!00/00/00!
	
	//  //[JobMasterLog]DateFilmEmbossingRecd:=!00/00/00!
	
	//[Job_Forms_Master_Schedule]DateDieBoardRecd:=!00/00/0000!
	//SAVE RECORD([Job_Forms_Master_Schedule])
	//REDUCE SELECTION([Job_Forms_Master_Schedule];0)
	
	//End if 
End if 