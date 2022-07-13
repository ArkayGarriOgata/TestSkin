// _______
// Method: [Tool_Drawers].ControlCenter.Add   ( ) ->
// By: Mel Bohince @ 06/07/19, 15:32:09
// Description
// 
// ----------------------------------------------------

BEEP:C151
ALERT:C41("underconstruction, you'll need to search for Available")

C_OBJECT:C1216($entity)
$entity:=ds:C1482.Tool_Drawers.new()  //create a reference
$entity.Bin:=""  //store some information
$entity.Contents:="AVAILABLE"
$entity.Tags:=""
$entity.save()  //save the entity


Form:C1466.toolDrawers.data:=Form:C1466.toolDrawers.data

//$win:=Open form window([Tool_Drawers];"Detail";Modal form dialog box)
//SET WINDOW TITLE("Creating new location";$win)
//DIALOG([Tool_Drawers];"Detail";$entity;*)
//CLOSE WINDOW($win)