//%attributes = {}
//PM: PS_SetCompleteColors() -> 
//@author mlb - 6/18/02  10:53

$color:=-(Light grey:K11:13+(256*Grey:K11:15))
Core_ObjectSetColor("*"; "c@"; $color)
zProdSched_Color_Main:=String:C10($color)
zProdSched_ColorNum_Main:=$color
//
tText:="Completed:"+TS2String([ProductionSchedules:110]Completed:23)
Core_ObjectSetColor(->tText; -(Yellow:K11:2+(256*Dark grey:K11:12)))

$rvb:=(153*256*256)+(153*256)+153
OBJECT SET RGB COLORS:C628(*; "BackRect"; 127; $rvb)
//
zProdSched_Color_BackRect:=String:C10($rvb)
zProdSched_ColorNum_BackRect:=$rvb