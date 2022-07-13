//%attributes = {"publishedWeb":true}
//(p) ITStatusConvert (IT = Issue Ticket)
//$1 - pointer - to field to convert
//• 11/5/97 cs created
C_POINTER:C301($1)
C_TEXT:C284($0)

Case of 
	: ($1->=0)
		$0:="Not Posted"
	: ($1->=1)
		$0:="OK"
	: ($1->=2)
		$0:="No Posting - POI"
	: ($1->=3)
		$0:="New Bin"
End case 
//