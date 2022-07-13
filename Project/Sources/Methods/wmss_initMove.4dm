//%attributes = {}

// Method: wmss_initMove ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/20/15, 16:41:21
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
// Modified by: Mel Bohince (12/10/15) init a few more vars

rft_log:="Move a Case to Bin or Skid\rMove a Skid to Bin\rEnter 'Done' to quit."

rft_prompt:="What's moving?"
rft_response:=""
rft_state:="object"
rft_error_log:=""
rft_object:=""
rft_destination:=""
// Modified by: Mel Bohince (12/10/15) 
sToSkid:=""
tText:=""
rft_caseId:=""
iQty:=0
sJobit:=""
sFrom:=""
numberOfCases:=0
sToBin:=""
iToCode:=0
ams_location:=""

ARRAY BOOLEAN:C223(ListBox1; 0)
ARRAY TEXT:C222(rft_Case; 0)
ARRAY TEXT:C222(rft_Skid; 0)
ARRAY TEXT:C222(rft_Bin; 0)
ARRAY LONGINT:C221($acase_state; 0)
ARRAY TEXT:C222(rft_Status; 0)

//OBJECT SET ENABLED(bMove;False)

<>WMS_ERROR:=0


SET WINDOW TITLE:C213(rft_state)
zwStatusMsg("WMS Move"; "Scan a case or skid")

SetObjectProperties(""; ->rft_error_log; False:C215)