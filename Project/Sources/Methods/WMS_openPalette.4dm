//%attributes = {}

// Method: WMS_openPalette ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/06/15, 08:38:14
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

SET MENU BAR:C67(<>DefaultMenu)
windowTitle:="Warehouse Management System"
$winRef:=OpenFormWindow(->[zz_control:1]; "WMSEvent"; ->windowTitle; windowTitle)
//NewWindow (230;250;1;4;"WMS Event";"wCloseWinBox")

DIALOG:C40([zz_control:1]; "WMSEvent")
CLOSE WINDOW:C154($winRef)
uWinListCleanup