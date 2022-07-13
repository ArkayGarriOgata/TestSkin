//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 12/12/06, 09:34:51
// ----------------------------------------------------
// Method: app_GetPrimaryKey(void)  --> str:10
// Description
// use a datetime stamp to set id number
//
// ----------------------------------------------------

C_TEXT:C284($0)
C_TEXT:C284($station)

$station:=String:C10(Num:C11(<>SERVER_DESIGNATION)+1)  // assuming haup as 0 and roan as 2
//$0:=GNT_DateTime ("TimeStampGet";$station+"/8")
$0:=app_Id_Encoder(Num:C11(<>SERVER_DESIGNATION))
