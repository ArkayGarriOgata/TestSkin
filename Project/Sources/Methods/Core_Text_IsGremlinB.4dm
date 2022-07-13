//%attributes = {}
//Method: Core_Text_IsGremlinB(nAscii)=>bGremlin
//Description:  This method determines what is considered a gremlin
// https://www.ascii-code.com/

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bGremlin)
	C_LONGINT:C283($1; $nAscii)
	
	$nAscii:=$1
	
	$bGremlin:=False:C215
	
End if   //Done Initialize

Case of   //Gremlin
		
		//: ($nAscii=9)  //Tabs are considered gremlins
		
	: ($nAscii=13)  //  Carriage Return not a gremlin
		
	: (($nAscii>=32) & ($nAscii<=126))  //not gremlins
		
		//: ($nAscii=32)  //  Space
		//: (($nAscii>=33) & ($nAscii<=39)) //  !"#$%&' 
		//: (($nAscii>=40) & ($nAscii<=47))  //  ()*+,-./
		//: (($nAscii>=48) & ($nAscii<=57))  // 0-9
		//: (($nAscii>=58)& ($nAscii<=64))  //  :;<=>?@
		//: (($nAscii>=65) & ($nAscii<=90))  //  A-Z
		//: (($nAscii>=90) & ($nAscii<=96))  //  [\]^_`
		//: (($nAscii>=97) & ($nAscii<=122))  //  a-z
		//: (($nAscii>=123) & ($nAscii<=126))  //  {|}~
		
		//:($nAscii=149)// • <option><8> Bullet is a gremlin
		
		//: ($nAscii=228)  // å is a gremlin
		//: ($nAscii=232)  // e Latin small letter e with grave is a gremlin
		//: ($nAscii=233)  // e Latin small letter e with acute is a gremlin
		
	Else   //Its a gremlin
		
		$bGremlin:=True:C214
		
End case   //Done gremlin

$0:=$bGremlin
