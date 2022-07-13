//%attributes = {"publishedWeb":true}
//(p) ChrgCodeFrmLoc 
//Returns a CompanyID based on the Bin, transfer Location
// $1 - string - Location to convert
//1/3/97 - cs 

C_TEXT:C284($1; $Location)
C_TEXT:C284($0)

$Location:=$1
Case of 
	: ($Location="H@")
		$0:="1"
	: ($Location="R@")  //Roanoke
		$0:="2"
	: ($Location="L@")  //labels
		$0:="3"
	Else   //arkay
		$0:="1"
End case 