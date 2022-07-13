//OM: ◊aCAR_Locations() -> 
//@author mlb - 10/24/01  16:33

// Modified by: Mel Bohince (9/18/12) protect against range check error


If (<>aCAR_Locations>0) & (<>aCAR_Locations<=Size of array:C274(<>aCAR_Locations))
	[QA_Corrective_Actions:105]Location:6:=<>aCAR_Locations{<>aCAR_Locations}
	GOTO RECORD:C242([QA_Corrective_ActionsLocations:107]; <>aCAR_LocationsRec{<>aCAR_Locations})
End if 