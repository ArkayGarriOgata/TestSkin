//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: uSetCommKey
// ----------------------------------------------------
//$1 pointer commodity code
//$2 String subgroup
//used to insure that the commodity key is formed the same way at all times
//• 9/29/97 cs created

C_TEXT:C284($2; $0)
C_POINTER:C301($1)

If (True:C214)
	RMG_getCommodityKey($1->; $2)
Else 
	If (Type:C295($1->)=0) | (Type:C295($1->)=24) | (Type:C295($1->)=2) | (Type:C295($1->)=18)  //alpha/text var/field or array element
		$0:=Substring:C12($1->; 1; 2)+"-"+$2
	Else 
		$0:=String:C10($1->; "00")+"-"+$2
	End if 
	//
End if 