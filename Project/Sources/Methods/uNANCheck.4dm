//%attributes = {"publishedWeb":true}
//(p) uNanCheck
//determine if the incomming value is a NAN, if it is
//return 0 (zero) else return original value
//• 1/28/98 cs created
//• 8/4/98 cs changed ascii check from <40 -> <48 & Not 45 ('-')

C_REAL:C285($1)

Case of 
	: (String:C10($1)="-INF")
		$0:=0
		//if Ascii value of 1st character (Ascci gets ONLY First character) of String of 
		//number being tested is NOT numeric (out of range 0-9)  -- This is a Nan
		//If Length of the string is of the number being tested is zero this is Also a Nan
		//(a Null Character)
	: ((Character code:C91(String:C10($1))<48) & (Character code:C91(String:C10($1))#45)) | (Character code:C91(String:C10($1))>57) | (Length:C16(String:C10($1))=0)
		$0:=0
	Else 
		$0:=$1
End case 