
$nSwitchWhenRollOver:=16
$nSwitchBackWhenReleased:=32
$nUseLastFrameAsDisabled:=128

$nFlags:=$nSwitchWhenRollOver+$nSwitchBackWhenReleased+$nUseLastFrameAsDisabled

$tPathName:="#Skin:Master:AcceptRound.png"

$tButtonFormat:="1; 4;"+$tPathName+";"+String:C10($nFlags)

$tButtonName:="Skin_Demo_nButton12"

OBJECT SET FORMAT:C236(*; $tButtonName; $tButtonFormat)
