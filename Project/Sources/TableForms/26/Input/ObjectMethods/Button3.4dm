xText:=""
$hold_window_title:=Get window title:C450

$winRef:=OpenSheetWindow(->[zz_control:1]; "FGNotesDisplay"; "Internal Ask Me Notes for "+[Finished_Goods:26]ProductCode:1)
FORM SET INPUT:C55([zz_control:1]; "FGNotesDisplay")
ADD RECORD:C56([zz_control:1]; *)
FORM SET INPUT:C55([zz_control:1]; "Input")
xText:=""

CLOSE WINDOW:C154
SET WINDOW TITLE:C213($hold_window_title)
