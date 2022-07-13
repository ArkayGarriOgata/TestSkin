//%attributes = {"publishedWeb":true}
//text:=fGetAddressText(int)
//•092995  MLB  test for record found
//•022597  MLB 
C_TEXT:C284($1; $2)  //search first flag
C_TEXT:C284($r)
$r:=Char:C90(13)
C_TEXT:C284($0)
$0:=""
If (Count parameters:C259>=1)
	SET QUERY LIMIT:C395(1)
	READ ONLY:C145([Addresses:30])
	QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$1)
	SET QUERY LIMIT:C395(0)
End if 

If (Records in selection:C76([Addresses:30])=1)
	If (Count parameters:C259=2)
		$0:=("ATTN:  "+[Addresses:30]AttentionOf:14+<>sCr)*Num:C11([Addresses:30]AttentionOf:14#"")
		$0:=$0+[Addresses:30]Name:2+$r
	Else 
		$0:=[Addresses:30]Name:2+$r
	End if 
	$0:=$0+[Addresses:30]Address1:3+$r
	$0:=$0+[Addresses:30]Address2:4+$r
	$0:=$0+[Addresses:30]Address3:5+$r
	$0:=$0+[Addresses:30]City:6+" "+[Addresses:30]State:7+" "
	$0:=$0+Replace string:C233([Addresses:30]Zip:8; "_"; "")+" "+(Num:C11([Addresses:30]Country:9#"USA")*[Addresses:30]Country:9)
	$0:=txt_VerticalConcatenate($0)
	
Else 
	$0:=""
End if 
//