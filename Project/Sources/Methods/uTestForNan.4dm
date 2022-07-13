//%attributes = {"publishedWeb":true}
//(p) uTestForNan
//This routine will test the incoming paramter for the existance
//of a 'Nan' value
//Returns - boolean , true if the value is/contains a 'Nan'
//• 4/23/97 cs created
C_REAL:C285($1)
C_BOOLEAN:C305($0)
$Str:=String:C10($1)

Case of 
	: (Length:C16($Str)<1)  //length = 0 (<1) this is a nan
		$0:=True:C214
	: ($str="-INF")
		$0:=True:C214
		
	: ((Character code:C91($Str[[1]])<40) | (Character code:C91($str[[1]])>57))  //if the ascii value of the 1st character is NOT aa number we have a NaN
		$0:=True:C214
	Else   //this is numeric - is OK - no NaN
		$0:=False:C215
End case 
//