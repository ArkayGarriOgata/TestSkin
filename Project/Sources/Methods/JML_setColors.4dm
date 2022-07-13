//%attributes = {"publishedWeb":true}
//PM: JML_setColors() -> 
//@author mlb - 4/18/01  14:39
// Modified by: MelvinBohince (6/2/22) dump Core_ObjectSetColor to fix colors


//colorize the customer name
C_OBJECT:C1216($oNameColor)
$oNameColor:=Cust_Name_ColorO([Job_Forms_Master_Schedule:67]Customer:2)
OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]Customer:2; $oNameColor.nForeground; $oNameColor.nBackground)

//set some attention grabbing colors for jobtypes, late things etc
$blackForeground:="rgb(0,0,0)"
$redForeground:="rgb(251,60,46)"
$darkRedForeground:="rgb(183,33,29)"
$pinkForeground:="rgb(250,56,92)"
$orangeForeground:="rgb(250,138,49)"
$hiliteYellow:="rgb(255, 255, 0)"  //yellow highligter, use in background only
$hiliteGo:="rgb(0, 128, 0)"  // green
$hiliteNoGo:="rgb(255, 0, 0)"  //red
$white:="rgb(255, 255, 255)"  //white

//colors on output form
If (Length:C16([Job_Forms_Master_Schedule:67]RepeatJob:27)>0)
	OBJECT SET FONT STYLE:C166([Job_Forms_Master_Schedule:67]JobType:31; Underline:K14:4)
Else 
	OBJECT SET FONT STYLE:C166([Job_Forms_Master_Schedule:67]JobType:31; Plain:K14:1)
End if 

Case of 
	: ([Job_Forms_Master_Schedule:67]JobType:31="2@")
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]JobType:31; $darkRedForeground; Background color none:K23:10)
	: ([Job_Forms_Master_Schedule:67]JobType:31="4@")
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]JobType:31; $redForeground; Background color none:K23:10)
	: ([Job_Forms_Master_Schedule:67]JobType:31="5@")
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]JobType:31; $orangeForeground; Background color none:K23:10)
	: ([Job_Forms_Master_Schedule:67]JobType:31="6@")
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]JobType:31; $pinkForeground; Background color none:K23:10)
	Else 
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]JobType:31; $blackForeground; Background color none:K23:10)
End case 

If ([Job_Forms_Master_Schedule:67]DateFinalArtApproved:12=!00-00-00!)
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateFinalArtApproved:12; $hiliteNoGo; $hiliteYellow)
Else 
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateFinalArtApproved:12; $hiliteGo; $white)
End if 

If ([Job_Forms_Master_Schedule:67]DateFinalToolApproved:18=!00-00-00!)
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateFinalToolApproved:18; $hiliteNoGo; $hiliteYellow)
Else 
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateFinalToolApproved:18; $hiliteGo; $white)
End if 

If ([Job_Forms_Master_Schedule:67]GateWayDeadLine:42#!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]DateClosingMet:23<=[Job_Forms_Master_Schedule:67]GateWayDeadLine:42)
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateClosingMet:23; $blackForeground; Background color none:K23:10)
	Else 
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateClosingMet:23; $hiliteNoGo; $hiliteYellow)
	End if 
	
Else 
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateClosingMet:23; $blackForeground; Background color none:K23:10)
End if 

If ([Job_Forms_Master_Schedule:67]FirstReleaseDat:13#!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]FirstReleaseDat:13<4D_Current_date)  //scheduled late
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]FirstReleaseDat:13; $hiliteNoGo; Background color none:K23:10)
	Else 
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]FirstReleaseDat:13; $blackForeground; Background color none:K23:10)
	End if 
	
	If ([Job_Forms_Master_Schedule:67]MAD:21<=[Job_Forms_Master_Schedule:67]FirstReleaseDat:13)  //scheduled late
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]MAD:21; $blackForeground; Background color none:K23:10)
	Else 
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]MAD:21; $hiliteNoGo; $hiliteYellow)
	End if 
	
Else 
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]MAD:21; $blackForeground; Background color none:K23:10)
End if 

If ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]PressDate:25<=[Job_Forms_Master_Schedule:67]MAD:21)  //printing late
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]PressDate:25; $blackForeground; Background color none:K23:10)
	Else 
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]PressDate:25; $hiliteNoGo; $hiliteYellow)
	End if 
	
Else 
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]MAD:21; $blackForeground; Background color none:K23:10)
End if 

//colors on input form
If ([Job_Forms_Master_Schedule:67]DateStockDue:16#!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]DateStockRecd:17<=[Job_Forms_Master_Schedule:67]DateStockDue:16)  //printing late
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateStockDue:16; $blackForeground; Background color none:K23:10)
	Else 
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateStockDue:16; $hiliteNoGo; $hiliteYellow)
	End if 
	
Else 
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]DateStockDue:16; $blackForeground; Background color none:K23:10)
End if 

If ([Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]MAD:21>[Job_Forms_Master_Schedule:67]PlannerReleased:14)  //released on time
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]PlannerReleased:14; $blackForeground; Background color none:K23:10)
	Else 
		OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]PlannerReleased:14; $hiliteNoGo; $hiliteYellow)
	End if 
	
Else 
	OBJECT SET RGB COLORS:C628([Job_Forms_Master_Schedule:67]MAD:21; $blackForeground; Background color none:K23:10)
End if 

Case of 
	: (Position:C15("hold"; tHold)>0)
		$forground:=$redForeground
		
	: (Position:C15("kill"; tHold)>0)
		$forground:=$redForeground
		
	: (Position:C15("WIP"; tHold)>0)
		$forground:=$hiliteGo
		
	Else 
		$forground:=$blackForeground  //the tHold will be blank if not hold,kill,or wip
End case 

OBJECT SET RGB COLORS:C628(tHold; $forground; Background color none:K23:10)
