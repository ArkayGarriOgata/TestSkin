//%attributes = {"publishedWeb":true}
//(p) ChrgCodetoLoc 
//Returns a Division name from a CompanyID 
// $1 - string - Division name
//1/31/97 - cs 

C_TEXT:C284($1; $Location)
C_TEXT:C284($0)

$Location:=$1
Case of 
	: ($Location="")
		$0:="blank"
	: ($Location="1")  //Roanoke
		$0:="Hauppauge"
	: ($Location="2")  //Roanoke
		$0:="Roanoke"
	: ($Location="3")  //labels
		$0:="Administration"
	Else   //arkay
		$0:="Arkay"
End case 