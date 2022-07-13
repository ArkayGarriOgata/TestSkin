//%attributes = {"publishedWeb":true}
//PM: PS_Tile() -> 
//@author mlb - 4/16/02  15:18
// • mel (6/18/04, 12:04:24) use PS_pid_mgr 
// Modified by: MelvinBohince (1/25/22) update press#'s and chg coordinates

C_LONGINT:C283($left; $top; $right; $bottom; $screenNumber; $menuScreen; $presScheduleFormWidth; $presScheduleFormHeight; $leftCenterEdge; $leftEdge)
C_TEXT:C284($justifyHorizontally; $justifyVerically)

//layout size to be tiled
$border:=10
$menuHeight:=60

//determing which screen to put on
$menuScreen:=Menu bar screen:C441

$screenNumbers:=Count screens:C437  //maybe give option someday
If ($screenNumbers=2)
	//find the origin to use based on dimensions
	SCREEN COORDINATES:C438($left; $top; $right; $bottom; 1)
	$screenWidth:=$right-$left
	$screenHeight:=$bottom-$top
	$dim:=String:C10($screenWidth)+"w x "+String:C10($screenHeight)+"h"
	
	SCREEN COORDINATES:C438($left2; $top2; $right2; $bottom2; 2)
	$screenWidth2:=$right2-$left2
	$screenHeight2:=$bottom2-$top2
	$dim2:=String:C10($screenWidth2)+"w x "+String:C10($screenHeight2)+"h"
	$msg:="Use which screen?\r"
	$msg:=$msg+"1) "+$dim+" or\r"
	$msg:=$msg+"2) "+$dim2
	
	uConfirm($msg; "1"; "2")
	If (ok=1)
		$displayScreen:=1
	Else 
		$displayScreen:=2
	End if 
	SCREEN COORDINATES:C438($left; $top; $right; $bottom; $displayScreen)
	
Else 
	$displayScreen:=$menuScreen
	//find the origin to use
	SCREEN COORDINATES:C438($left; $top; $right; $bottom; $displayScreen)
End if 


$top:=$top+$menuHeight
$middle:=30
$rightDock:=50

$justifyHorizontally:="right"  // |left, not implemented
$justifyVerically:="top"  // |bottom, not implemented

$screenWidth:=$right-$left
$screenHeight:=$bottom-$top

$presScheduleFormWidth:=1050
$presScheduleFormHeight:=590

If ($screenWidth<(2*$presScheduleFormWidth))
	$presScheduleFormWidth:=($screenWidth-50)/2
End if 

If ($screenHeight<(2*$presScheduleFormHeight))
	$presScheduleFormHeight:=($screenHeight-50)/2
End if 

If ($justifyHorizontally="right") | (True:C214)
	$leftEdge:=$right-$rightDock-(2*$presScheduleFormWidth)  //a big resolution can make this offscreen
	$leftCenterEdge:=$border+$leftEdge+$presScheduleFormWidth
End if 

//position press windows if they are open, 2 x 6 grid posible, assuming all 4 presses open, if not, you got some gaps
If (PS_pid_mgr("win"; "418")=0)
	PS_Show418
End if 

If (PS_pid_mgr("win"; "419")=0)
	PS_Show419
End if 

If (PS_pid_mgr("win"; "420")=0)
	PS_Show420
End if 

If (PS_pid_mgr("win"; "421")=0)
	PS_Show421
End if 

If (PS_pid_mgr("win"; "420")#0)
	SET WINDOW RECT:C444($leftEdge; $top; $leftEdge+$presScheduleFormWidth; $presScheduleFormHeight; PS_pid_mgr("win"; "420"))  //top left 
End if 

If (PS_pid_mgr("win"; "421")#0)
	SET WINDOW RECT:C444($leftEdge; $middle+$presScheduleFormHeight; $leftEdge+$presScheduleFormWidth; 2*$presScheduleFormHeight; PS_pid_mgr("win"; "421"))  //middle left
End if 

If (PS_pid_mgr("win"; "418")#0)
	SET WINDOW RECT:C444($leftCenterEdge; $top; $leftCenterEdge+$presScheduleFormWidth; $presScheduleFormHeight; PS_pid_mgr("win"; "418"))  //top right 
End if 

If (PS_pid_mgr("win"; "419")#0)
	SET WINDOW RECT:C444($leftCenterEdge; $middle+$presScheduleFormHeight; $leftCenterEdge+$presScheduleFormWidth; 2*$presScheduleFormHeight; PS_pid_mgr("win"; "419"))  //middle right 
End if 

//If (PS_pid_mgr ("win";"429")#0)
//SET WINDOW RECT($leftEdge;$middle+(2*$presScheduleFormHeight);$leftEdge+$presScheduleFormWidth;(3*$presScheduleFormHeight);PS_pid_mgr ("win";"429"))  //bottom left
//End if 

//If (PS_pid_mgr ("win";"ALL")#0)
//SET WINDOW RECT($leftCenterEdge;$middle+(2*$presScheduleFormHeight);$leftCenterEdge+$presScheduleFormWidth;(3*$presScheduleFormHeight);PS_pid_mgr ("win";"ALL"))  //bottom right
//End if 
