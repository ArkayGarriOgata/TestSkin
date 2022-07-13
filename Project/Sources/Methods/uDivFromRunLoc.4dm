//%attributes = {"publishedWeb":true}
//(p) uDivFromRunLoc
//determine the running location for a specific Jobform
//$1 - string - Jobform Run location
//Returns - String - Company/Diviaion ID
//• 8/11/98 cs created
C_TEXT:C284($1)
C_TEXT:C284($0)

Case of 
	: ($1="Hauppauge")
		$0:="1"
	: ($1="Roanoke")
		$0:="2"
	: ($1="Start Hauppauge")
		$0:="1"
	: ($1="Start Roanoke")
		$0:=$2
	Else   //default
		$0:="1"
End case 
//