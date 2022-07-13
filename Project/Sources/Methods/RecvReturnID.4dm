//%attributes = {"publishedWeb":true}
//(p) RecvReturnId
//$1 - string - Id number to return (including leading charater)
//• 4/30/98 cs created

C_TEXT:C284($1)
C_TEXT:C284($Set)

If ($1#"")  //if receiver number is NOT empty
	$Set:=$1[[1]]
	
	Case of 
		: ($Set="C")  //Consignment
			uResetID(8000; Num:C11(Substring:C12($1; 2)))
		: ($Set="R")  //Roanoke
			uResetID(8002; Num:C11(Substring:C12($1; 2)))
		: ($Set="A")  //Hauppauge
			uResetID(8001; Num:C11(Substring:C12($1; 2)))
		: ($Set="V")  //Vista
			uResetID(8004; Num:C11(Substring:C12($1; 2)))
	End case 
End if 