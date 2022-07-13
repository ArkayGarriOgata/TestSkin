C_TEXT:C284($ttResult; $ttStart; $ttEnd)
C_BOOLEAN:C305($fAllDay)
C_OBJECT:C1216(obResult)
Case of 
	: (Form event code:C388=On URL Filtering:K2:49)
		//$ttURL:=WA Get last filtered URL(eaGant)
		//$ttURL:=FilteredURLParse ($ttURL)
		//Case of 
		//: ($ttURL="TaskUpdateFields_gantt")
		//Gantt_UpdateTask (->eaGant)
		
		
		//: ($ttURL="TaskRemove_gantt")
		//Gantt_RemoveTask (->eaGant)
		
		
		//: ($ttURL="TaskEdit_gantt")
		//  //Gantt_EditTask (->eaGant)
		
		//: ($ttURL="TaskSelect_gantt")
		//Gantt_SelectTask (->eaGant)
		
		//: ($ttURL="TaskDeselect_gantt")
		//Gantt_DeselectTask (->eaGant)
		
		//: ($ttURL="LinkAdd_gantt")
		//Gantt_AddLink (->eaGant)
		
		//: ($ttURL="LinkRemove_gantt")
		//Gantt_RemoveLink (->eaGant)
		
		//End case 
		
	: (Form event code:C388=On End URL Loading:K2:47)
		WA EXECUTE JAVASCRIPT FUNCTION:C1043(eaCal; "setView"; $ttResult; "month")
		
		WA EXECUTE JAVASCRIPT FUNCTION:C1043(eaCal; "gotoToday"; $ttResult)
		//setView
		//agendaWeek
		
		//getCalDetail
		
		// 2015-11-25T11:01:57-05:00
		
		
		//v5.3.5-CYH (12/2/15) removed, this will get called when the calendar loads via javascript:   GanttCal_LoadTasks (->eaGant)
		//
		
End case 

