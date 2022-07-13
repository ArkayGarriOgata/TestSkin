//%attributes = {"publishedWeb":true}
//PM:  zCursorMgr  092199  mlb
//manage the cursor
C_LONGINT:C283(currentCursor)
C_TEXT:C284($1)

//Case of 
//: ($1="beachBallOff")
//AP GET PARAM (2;currentCursor)  `to restore beach ball `•9/16/99  MLB  UPR
//AP SET PARAM (2;0)  `disable beach ball 
//: ($1="restore")
//SET CURSOR(1)
//AP SET PARAM (2;currentCursor)  `enable beach ball 
//
//: ($1="watch")
//SET CURSOR(4)  `set to watch icon     260 seems to work too
//
//End case 