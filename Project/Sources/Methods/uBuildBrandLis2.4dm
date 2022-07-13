//%attributes = {"publishedWeb":true}
//uBuildBrandLis2  see also uBuildBrandList
//upr 1221 11/22/94
//•022597  MLB  clear selection
C_LONGINT:C283($numRecs)  //do the product line thing
ARRAY TEXT:C222(aBrand; 0)
If (iMode>2)
	ARRAY TEXT:C222(aBrand; 1)
	If (Count parameters:C259=1)
		aBrand{1}:=$1->
	Else 
		aBrand{1}:=[Customers_Orders:40]CustomerLine:22
	End if 
	aBrand:=1
Else 
	READ ONLY:C145([Customers_Brand_Lines:39])
	QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=[Customers_Orders:40]CustID:2)
	$numRecs:=Records in selection:C76([Customers_Brand_Lines:39])
	SELECTION TO ARRAY:C260([Customers_Brand_Lines:39]LineNameOrBrand:2; aBrand)
	SORT ARRAY:C229(aBrand; >)
	If (Count parameters:C259=1)
		aBrand:=Find in array:C230(aBrand; $1->)
	Else 
		aBrand:=Find in array:C230(aBrand; [Customers_Orders:40]CustomerLine:22)
	End if 
	uClearSelection(->[Customers_Brand_Lines:39])
End if 
//