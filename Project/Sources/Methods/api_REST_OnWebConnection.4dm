//%attributes = {}
// _______
// Method: api_REST_OnWebConnection   ( ) ->
// By: Mel Bohince @ 10/18/19, 12:20:40
// Description
// 
// ----------------------------------------------------


C_TEXT:C284($url; $1; $2)

$url:=$1


Case of 
	: ($url="api/blank@")
		vtTitle:="Blank"
		WEB SEND FILE:C619("/shuttle/blank.html")
		
	: ($url="api/dashboard@")
		WEB_DASHBOARD
		//vtTitle:="Dashboard"
		//WEB SEND FILE("/shuttle/dashboard.html")
		
	: ($url="api/schedule@")
		vtTitle:="Schedule"
		WEB SEND FILE:C619("/shuttle/schedule.html")
		
	: ($url="api/releases@")
		vtTitle:="Releases"
		WEB SEND FILE:C619("/shuttle/releases.html")
		
	: ($url="api/jobits@")
		vtTitle:="Glue Schedule"
		WEB SEND FILE:C619("/shuttle/jobits.html")
		
	: ($url="api/jobforms@")
		vtTitle:="Job Forms"
		WEB SEND FILE:C619("/shuttle/jobforms.html")
		
	Else 
		OWC_API($url; $2)
End case 