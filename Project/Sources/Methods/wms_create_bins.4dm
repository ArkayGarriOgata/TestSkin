//%attributes = {}
// ----------------------------------------------------
// Method: wms_create_bins   ( ) ->


// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/14/11, 14:22:53
// ----------------------------------------------------
// Method: _version20110414
// Description
// reconfigure warehouse
//isles 1 - 9 stay same with 28 rows
//10 - 16 only have 20 rows
//new 17 & 18 have 12 rows

// Parameters
// ----------------------------------------------------

READ WRITE:C146([WMS_AllowedLocations:73])

//QUERY([WMS_AllowedLocations];[WMS_AllowedLocations]ValidLocation="fg:r1@-02@-@";*)
//QUERY([WMS_AllowedLocations]; & ;[WMS_AllowedLocations]ValidLocation#"@-020-@")
//util_DeleteSelection (->[WMS_AllowedLocations])

//For ($isle;1;12)
//For ($row;1;40)
//For ($shelf;1;5)
//CREATE RECORD([WMS_AllowedLocations])
//[WMS_AllowedLocations]ValidLocation:="FG:V"+String($isle;"00")+"-"+String($row;"00")+"-"+String($shelf;"0")
//[WMS_AllowedLocations]BarcodedID:=wms_convert_bin_id ("wms";[WMS_AllowedLocations]ValidLocation)
//SAVE RECORD([WMS_AllowedLocations])
//End for 
//End for 
//End for 
//UNLOAD RECORD([WMS_AllowedLocations])

// Modified by: Mel Bohince (3/9/16) //one extra rack
//$isle:=13
//For ($row;1;12)
//For ($shelf;1;4)
//CREATE RECORD([WMS_AllowedLocations])
//[WMS_AllowedLocations]ValidLocation:="FG:V"+String($isle;"00")+"-"+String($row;"00")+"-"+String($shelf;"0")
//[WMS_AllowedLocations]BarcodedID:=wms_convert_bin_id ("wms";[WMS_AllowedLocations]ValidLocation)
//SAVE RECORD([WMS_AllowedLocations])
//End for 
//End for 
CONFIRM:C162("Normal or LittleBin?"; "Normal"; "Little")
If (ok=1)
	
	For ($isle; 1; 12)
		For ($row; 41; 42)
			For ($shelf; 1; 5)
				CREATE RECORD:C68([WMS_AllowedLocations:73])
				[WMS_AllowedLocations:73]ValidLocation:1:="FG:V"+String:C10($isle; "00")+"-"+String:C10($row; "00")+"-"+String:C10($shelf; "0")
				[WMS_AllowedLocations:73]BarcodedID:2:=wms_convert_bin_id("wms"; [WMS_AllowedLocations:73]ValidLocation:1)
				SAVE RECORD:C53([WMS_AllowedLocations:73])
			End for 
		End for 
	End for 
	
Else 
	$begin:=Num:C11(Request:C163("Starting number: "; "1"))
	$end:=Num:C11(Request:C163("Ending number: "; "10"))
	For ($shelf; $begin; $end)
		CREATE RECORD:C68([WMS_AllowedLocations:73])
		[WMS_AllowedLocations:73]ValidLocation:1:="FG:V-"+String:C10($shelf)
		[WMS_AllowedLocations:73]BarcodedID:2:=wms_convert_bin_id("wms"; [WMS_AllowedLocations:73]ValidLocation:1)
		SAVE RECORD:C53([WMS_AllowedLocations:73])
	End for 
	
End if 

UNLOAD RECORD:C212([WMS_AllowedLocations:73])
