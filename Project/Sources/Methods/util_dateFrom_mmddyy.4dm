//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/02/12, 12:47:42
// ----------------------------------------------------
// Method: util_dateFrom_mmddyy("mddyy")->date
// ----------------------------------------------------

C_DATE:C307($0)
C_TEXT:C284($1)

$0:=!00-00-00!

Case of 
	: (Length:C16($1)=5)
		$0:=Date:C102($1[[1]]+"/"+$1[[2]]+$1[[3]]+"/"+$1[[4]]+$1[[5]])
		
	: (Length:C16($1)=6)
		$0:=Date:C102($1[[1]]+$1[[2]]+"/"+$1[[3]]+$1[[4]]+"/"+$1[[5]]+$1[[6]])
		
	Else 
		uConfirm("Invalid date argument: "+$1+" sent to util_dateFrom_mmddyy "; "OK"; "Help")
End case 