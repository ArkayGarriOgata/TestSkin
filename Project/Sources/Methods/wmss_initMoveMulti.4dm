//%attributes = {}
// ----------------------------------------------------
// Method: wmss_initMoveMulti   ( ) ->
// By: Mel Bohince @ 04/06/16, 14:08:08
// Description
// based on wmss_initMove
// ----------------------------------------------------


rft_log:="Move a Case to Bin or Skid\rMove a Skid to Bin\rEnter 'Move' to apply.\rEnter 'Done' to quit.\r"

rft_prompt:="Where to?"
rft_response:=""  //this is the scan field, <<tab>> to fire script, clear at end of script
rft_state:="destination"  // can be destination or object, switch used by state machine

//gathered from scan
//rft_error_log:=""// clear at beginning of event
rft_object:=""  //can be skid or case
rft_destination:=""  //can be bin or skid
rft_caseId:=""
// Modified by: Mel Bohince (12/10/15) 


//rft_caseId:=""
iQty:=0

sFrom:=""
numberOfCases:=0

//gathered from existing bin or skid
sJobit:=""
sCPN:=""
iToCode:=100
ams_location:="FG"
sToBin:=""
modDateTime:=TS_ISO_String_TimeStamp
sToSkid:=""

//build as we go
tSQL:=""
tSQLwhere:=""


//listbox arrays
ARRAY BOOLEAN:C223(ListBox1; 0)
ARRAY TEXT:C222(rft_Case; 0)
ARRAY TEXT:C222(rft_Skid; 0)
ARRAY TEXT:C222(rft_Bin; 0)
ARRAY TEXT:C222(rft_jobit; 0)
//ARRAY LONGINT($acase_state;0)//used to get verbose status
ARRAY TEXT:C222(rft_Status; 0)

<>WMS_ERROR:=0


SET WINDOW TITLE:C213(rft_state)
zwStatusMsg("WMS Move"; "Scan a Skid or Bin Location")

SetObjectProperties(""; ->rft_error_log; False:C215)