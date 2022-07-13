//%attributes = {}
// Method: util_dateFromYYYYMMDD ("YYYY/MM/DD") -> date
// ----------------------------------------------------
// by: mel: 06/09/05, 15:15:58
// ----------------------------------------------------
// Description:
// Rtn a date from a string like YYYY/MM/DD
// ----------------------------------------------------

C_DATE:C307($0)
C_TEXT:C284($1)

$0:=!00-00-00!

Case of 
	: (Length:C16($1)=6)
		$0:=Date:C102($1[[3]]+$1[[4]]+"/"+$1[[5]]+$1[[6]]+"/"+$1[[1]]+$1[[2]])
	: (Length:C16($1)=8)
		$0:=Date:C102($1[[5]]+$1[[6]]+"/"+$1[[7]]+$1[[8]]+"/"+$1[[1]]+$1[[2]]+$1[[3]]+$1[[4]])
	: (Length:C16($1)=10)
		$0:=Date:C102(Substring:C12($1; 6; 2)+"/"+Substring:C12($1; 9; 2)+"/"+Substring:C12($1; 1; 4))
	Else 
		uConfirm("Invalid date argument: "+$1+" sent to util_dateFromYYYYMMDD "; "OK"; "Help")
End case 