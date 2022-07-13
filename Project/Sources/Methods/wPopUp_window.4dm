//%attributes = {"publishedWeb":true}
//METHOD: PopUp_window(I;I;I;S;S)
//$1 window width
//$2 window hight
//$3 window type (optional)
//$4 window title(optional)
//$5 close box method(optional)


//Written by: Georgios Bizas/ODENSOFT
//Written date: 10/10/1998
//Last Modified:05/20/1999



C_LONGINT:C283($1; $2; $3)
C_TEXT:C284($4)
C_TEXT:C284($5)

C_LONGINT:C283($WW; $WH; $SW; $SH; $globalTopCoord; $globalLeftCoord; $globalRightCoord; $globalBottomCoord; $vl_button)

C_LONGINT:C283($left; $top; $right; $bottom; $vl_distanceToVerticalEnd; $vl_distanceToHorizontalEnd)


GET WINDOW RECT:C443($left; $top; $right; $bottom)

//$SW:=$right-$left
$SW:=Screen width:C187

//$SH:=$bottom-$top

$SH:=Screen height:C188

$WW:=$1
$WH:=$2

GET MOUSE:C468($globalLeftCoord; $globalTopCoord; $vl_button; *)  //get screen relative coordinates

$vl_distanceToVerticalEnd:=$SW-$globalLeftCoord
$vl_distanceToHorizontalEnd:=$SH-$globalTopCoord

Case of 
	: (($vl_distanceToVerticalEnd<$WW) & ($vl_distanceToHorizontalEnd<$WH))
		$globalRightCoord:=$globalLeftCoord
		$globalBottomCoord:=$globalTopCoord
		$globalTopCoord:=$globalTopCoord-$WH
		$globalLeftCoord:=$globalLeftCoord-$WW
	: ($vl_distanceToVerticalEnd<$WW)
		$globalRightCoord:=$globalLeftCoord
		$globalBottomCoord:=$globalTopCoord+$WH
		$globalLeftCoord:=$globalLeftCoord-$WW
	: ($vl_distanceToHorizontalEnd<$WH)
		$globalBottomCoord:=$globalTopCoord
		$globalTopCoord:=$globalTopCoord-$WH
		$globalRightCoord:=$globalLeftCoord+$WW
	Else 
		$globalRightCoord:=$globalLeftCoord+$WW
		$globalBottomCoord:=$globalTopCoord+$WH
End case 


Case of 
	: (Count parameters:C259=2)
		Open window:C153($globalLeftCoord; $globalTopCoord; $globalRightCoord; $globalBottomCoord)
	: (Count parameters:C259=3)
		Open window:C153($globalLeftCoord; $globalTopCoord; $globalRightCoord; $globalBottomCoord; $3)
	: (Count parameters:C259=4)
		Open window:C153($globalLeftCoord; $globalTopCoord; $globalRightCoord; $globalBottomCoord; $3; $4)
	: (Count parameters:C259=5)
		Open window:C153($globalLeftCoord; $globalTopCoord; $globalRightCoord; $globalBottomCoord; $3; $4; $5)
End case 

