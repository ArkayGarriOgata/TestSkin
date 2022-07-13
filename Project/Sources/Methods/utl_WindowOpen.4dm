//%attributes = {"publishedWeb":true}
//PM:  utl_Windowe(height;width{
//                            ;type=4;title=pid name;close method="";position="C})
//• Created 2/10/00 cs as (m) utl_Open_Window
//•2/24/00  mlb  fuss with
//         valid: C - Center, UL - Upper Left, UR - Upper right, LR - Lower right
//         valid: LL - Lower Left, S - Stacked, UT - upper Third centered, 
//         valid: LT - Lower third centered
C_LONGINT:C283($0; $1; $2; $3; $Screen_Height; $Screen_Width; $LeftSide; $Top; $RightSide; $Bottom; $params)
C_LONGINT:C283($Height; $Width; $Window_Type; $Constrained_Height; $Constrained_Width)
C_TEXT:C284($Window_Title; $Close_Method; $Window_Position; $4; $5; $6)
C_TEXT:C284($Process_Name)
C_LONGINT:C283($Process_State; $Process_Time)
// for new installs -
<>Stacking_Offset:=20
//

$Screen_Height:=Screen height:C188
$Screen_Width:=Screen width:C187
$Height:=$1  //heigth of new winodw
$Width:=$2  //width of new window
$params:=Count parameters:C259
Case of   //determine the number of parameters passed, and assign to human readable locals
	: ($params=6)  //nothing defaulted
		$Window_Position:=$6
		$Close_Method:=$5
		$Window_Title:=$4
		$Window_Type:=$3
		
	: ($params=5)  //default window position is center
		$Window_Position:="C"
		$Close_Method:=$5
		$Window_Title:=$4
		$Window_Type:=$3
		
	: ($params=4)  //default window close routine - NONE ("")
		$Window_Position:="C"
		$Close_Method:=""
		$Window_Title:=$4
		$Window_Type:=$3
		
	: ($params=3)  //need to get a default window title (below), using process name
		$Window_Position:="C"
		$Close_Method:=""
		PROCESS PROPERTIES:C336(Current process:C322; $Process_Name; $Process_State; $Process_Time)
		$Window_Title:=$Process_Name
		$Window_Type:=$3
		
	Else   //everything default 
		$Window_Position:="C"
		$Close_Method:=""
		PROCESS PROPERTIES:C336(Current process:C322; $Process_Name; $Process_State; $Process_Time)
		$Window_Title:=$Process_Name
		$Window_Type:=4
End case 

//the call is for a centered window (determine if it should be window or screen
If ($Window_Position="C@") & (($Window_Type=4) | ($Window_Type=1) | (Abs:C99($Window_Type)>=700))  //center for dialogs
	$LeftSide:=0
	$RightSide:=0
	GET WINDOW RECT:C443($LeftSide; $Top; $RightSide; $Bottom)  //get the placement of the topmost window
	
	If ($Rightside<=0)  //no open, on screen, window
		$Window_Position:="CS"  //cwnter new window on screen
	Else   //center new winodw on open window
		$Window_Position:="CW"
	End if 
Else 
	$Window_Position:="CS"
End if 

Case of 
	: ($Window_Position="CS")  //Centered on Screen
		$Screen_Height:=$Screen_Height/2
		$Screen_Width:=$Screen_Width/2
		$LeftSide:=$Screen_Width-($Width/2)
		$Top:=$Screen_Height-($Height/2)
		
	: ($Window_Position="CW")  //Centered on Window
		GET WINDOW RECT:C443($LeftSide; $Top; $RightSide; $Bottom)  //get the placement of the topmost window
		$Constrained_Height:=($Bottom-$Top)/2
		$Constrained_Width:=($RightSide-$LeftSide)/2
		
		Case of 
			: (($LeftSide+$Width)>$Screen_Width)  //Adjustment placed new window off Right edge of screen, move it
				$LeftSide:=$Screen_Width-$Width-4  //the 4 is an absolute adjustment to insure all of window on screen
			: ($LeftSide<4) & (($RightSide-$LeftSide)<=$Width)  //this would place the window off the let of the screen
				$LeftSide:=4
			Else 
				$LeftSide:=$Constrained_Width-($Width/2)+$LeftSide
		End case 
		
		Case of 
			: (($Top+$Height)>$Screen_Height)  //adjustment placed new window off bottom of screen, move it
				$Top:=$Screen_Height-$Height-4  //the 4 is an absolute adjustment to insure all of window on screen
			: ($Top<43)  //this would place the top of the window under the menubar
				$Top:=43
			Else 
				$Top:=$Constrained_Height-($Height/2)+$Top
		End case 
		
	: ($Window_Position="S")  //Stacked
		GET WINDOW RECT:C443($LeftSide; $Top; $RightSide; $Bottom)  //get the placement of the topmost window
		
		//check to see that the new window will not either
		//A  -  open with title bar controls off screen (right side of window opening off 
		//B - open with title bar below bottom of screen
		If (($Width+<>Stacking_Offset+$LeftSide)>$Screen_Width) | (<>Stacking_Offset+$Top>($Screen_Height-20))
			$LeftSide:=20  //reset stacking to upper left
			$Top:=43
		Else 
			$LeftSide:=<>Stacking_Offset+$LeftSide  //add stacking offset to previous window's left edge
			$Top:=<>Stacking_Offset+$Top  //add stacking offset to previous window's top
		End if 
		
	: ($Window_Position="UL")  //Upper left corner
		$LeftSide:=20
		$Top:=43
		
	: ($Window_Position="UR")  //Upper right corner
		$LeftSide:=$Screen_Width-$Width-20
		$Top:=43
		
	: ($Window_Position="LL")  //Lower left corner
		$LeftSide:=20
		$Top:=$Screen_Height-$Height-20
		
	: ($Window_Position="LR")  //Lower right corner
		$LeftSide:=$Screen_Width-$Width-20
		$Top:=$Screen_Height-$Height-20
		
	: ($Window_Position="UT")  //1/3 from top & centered (courtesy of Vance Miller)
		$Screen_Height:=$Screen_Height/3
		$Screen_Width:=$Screen_Width/2
		$LeftSide:=$Screen_Width-($Width/2)
		$Top:=$Screen_Height-($Height/2)
		
	: ($Window_Position="LT")  //1/3 from bottom & centered (courtesy of Chip)
		$Screen_Height:=2*($Screen_Height/3)
		$Screen_Width:=$Screen_Width/2
		$LeftSide:=$Screen_Width-($Width/2)
		$Top:=$Screen_Height+($Height/2)
End case 

$RightSide:=$LeftSide+$Width
$Bottom:=$Top+$Height

$0:=Open window:C153($LeftSide; $Top; $RightSide; $Bottom; $Window_Type; $Window_Title; $Close_Method)
//
