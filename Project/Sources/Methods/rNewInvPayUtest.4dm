//%attributes = {"publishedWeb":true}
//(p) aPayU2
//$1 integer index
//Retunrs excess qty
//• 12/12/97 cs created to reduce calling proc code size

C_LONGINT:C283($1; $Hit)

$Hit:=$1
$0:=0

If (Not:C34(aPayU2{$hit}))  //not already in the report
	If (aQty{$hit}>0)
		$0:=aQty{$hit}  //accumulate the excess
	Else 
		$0:=0
	End if   //not negative            
	aPayU2{$hit}:=True:C214  //tag it.
End if 