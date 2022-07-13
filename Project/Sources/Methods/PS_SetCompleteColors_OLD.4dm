//%attributes = {"publishedWeb":true}
//PM: PS_SetCompleteColors() -> 
//@author mlb - 6/18/02  10:53

tText:="Completed:"+TS2String([ProductionSchedules:110]Completed:23)
$color:=-(Light grey:K11:13+(256*Grey:K11:15))
Core_ObjectSetColor("*"; "c@"; $color)
Core_ObjectSetColor(->tText; -(Yellow:K11:2+(256*Dark grey:K11:12)))

$rvb:=(153*256*256)+(153*256)+153
OBJECT SET RGB COLORS:C628(*; "BackRect"; 127; $rvb)