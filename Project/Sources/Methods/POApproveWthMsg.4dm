//%attributes = {"publishedWeb":true}
//(p) PoApproveWthMsg
//Approve PO and handle displaying/printing message if overun
//• 6/20/97 cs created
//$1 - po no
//$2 - (optional) Flag

C_BOOLEAN:C305($Result)

$Result:=False:C215

If (Count parameters:C259=1)
	$Result:=PoOneApprove($1)  //if overbudget pooneapprove=true
Else 
	$result:=PoOneApprove($1; $2)
End if 

If ($Result)
	xText:="This PO has items which exceeded budget or Failed to process."+Char:C90(13)+Char:C90(13)+xText
	uDialog("Message"; 480; 198)
	xText:=""
	If (False:C215)
		FORM SET INPUT:C55([zz_control:1]; "Message")
	End if 
End if 