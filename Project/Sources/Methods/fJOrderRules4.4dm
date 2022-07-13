//%attributes = {"publishedWeb":true}
//fJOrderRules4
//  3/1/95
//•042696  MLB   make 'Revised Aware"
//•1/19/00  mlb  more leanient, ditch the array
// • mel (11/4/04, 11:11:24) must be in RoleOperations to leave WIP, can't get to WIP without being Released
//complete and close from other place

C_BOOLEAN:C305($0; $authorized)
//TRACE
C_TEXT:C284($1; $2; $oldStatus; $newStatus)  //old status/new status
$0:=True:C214
$oldStatus:=$1
$newStatus:=$2
Case of 
	: ($oldStatus="")
		
	: ($oldStatus="Opened")  //open
		Case of 
			: ($newStatus="Planned")
			: ($newStatus="Revised")
			: ($newStatus="Released")
				//: ($newStatus="WIP")
				//: ($newStatus="Complete")
				//: ($newStatus="Closed")
			: ($newStatus="Hold")
			: ($newStatus="Kill")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus)
				$0:=False:C215
		End case 
		
	: ($oldStatus="Planned")  //planned
		Case of 
			: ($newStatus="Planned")
			: ($newStatus="Revised")
			: ($newStatus="Released")
				//: ($newStatus="WIP")
				//: ($newStatus="Complete")
				//: ($newStatus="Closed")
			: ($newStatus="Hold")
			: ($newStatus="Kill")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus)
				$0:=False:C215
		End case 
		
	: ($oldStatus="Revised")  //revised`•042696  MLB 
		Case of 
			: ($newStatus="Revised")
			: ($newStatus="Planned")
			: ($newStatus="Released")
				//: ($newStatus="WIP")
				//: ($newStatus="Complete")
				//: ($newStatus="Closed")
			: ($newStatus="Hold")
			: ($newStatus="Kill")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus)
				$0:=False:C215
		End case 
		
	: ($oldStatus="Released")  //revised`•042696  MLB 
		Case of 
			: ($newStatus="Revised")
			: ($newStatus="Planned")
			: ($newStatus="Released")
			: ($newStatus="WIP")
				//: ($newStatus="Complete")
				//: ($newStatus="Closed")
			: ($newStatus="Hold")
			: ($newStatus="Kill")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus)
				$0:=False:C215
		End case 
		
	: ($oldStatus="WIP")  //in process
		$authorized:=User in group:C338(Current user:C182; "RoleOperations")
		Case of 
			: ($newStatus="Revised") & $authorized
				ALERT:C41("Remember to Warn Production of possible changes.")
			: ($newStatus="WIP")
			: ($newStatus="Complete") & $authorized
			: ($newStatus="Closed") & $authorized
			: ($newStatus="Hold") & $authorized
				ALERT:C41("Notify Production to Hold.")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus+" unless in RoleOperations")
				$0:=False:C215
		End case 
		
	: ($oldStatus="Complete")  //complete
		Case of 
				//: ($newStatus="WIP")
			: ($newStatus="Complete")
				//: ($newStatus="Closed")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus+" Use button on JobMasterLog.")
				$0:=False:C215
		End case 
		
	: ($oldStatus="Closed")  //closed
		Case of 
			: ($newStatus="Closed")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus+" Use button on Modify Actual form.")
				$0:=False:C215
		End case 
		
	: (Position:C15("Hold"; $oldStatus)#0)  //hold
		Case of 
			: ($newStatus="Planned")
			: ($newStatus="Revised")
				//: ($newStatus="Released")
				//: ($newStatus="WIP")
			: ($newStatus="Hold")
			: ($newStatus="Kill")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus)
				$0:=False:C215
		End case 
		
	: ($oldStatus="Kill")
		Case of 
			: ($newStatus="Kill")
			Else 
				BEEP:C151
				ALERT:C41("Can't go from "+$oldStatus+" to "+$newStatus+" You must recreate the job.")
				$0:=False:C215
		End case 
		
	Else 
		BEEP:C151
		ALERT:C41("What the #@!! does "+$oldStatus+" mean? See (P)fJOrderRules4."+Char:C90(13)+"Append "+$oldStatus+" to choice list 'J_OrderStatus'.")
		$0:=False:C215
End case 
//