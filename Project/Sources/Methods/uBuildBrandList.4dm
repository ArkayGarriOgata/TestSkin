//%attributes = {"publishedWeb":true}
//uBuildBrandList  see also uBuildBrandLis2
//•022597  MLB  clear selections
// • mel (2/11/04, 10:58:51) setup combo box

C_POINTER:C301($1)

ARRAY TEXT:C222(aBrand; 0)
aBrand{0}:=""

If (iMode>2)  //don't set up choices
	ARRAY TEXT:C222(aBrand; 1)
	If (Count parameters:C259=1)
		aBrand{1}:=$1->
	Else 
		aBrand{1}:=[Estimates:17]Brand:3
	End if 
	aBrand:=1
	aBrand{0}:=aBrand{1}
	
Else 
	READ ONLY:C145([Customers_Brand_Lines:39])
	If (Records in selection:C76([Customers:16])=1)
		QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=[Customers:16]ID:1)
		SELECTION TO ARRAY:C260([Customers_Brand_Lines:39]LineNameOrBrand:2; aBrand)
		SORT ARRAY:C229(aBrand; >)
		If (Count parameters:C259=1)
			aBrand:=Find in array:C230(aBrand; $1->)
		Else 
			aBrand:=Find in array:C230(aBrand; [Estimates:17]Brand:3)
		End if 
		
		If (aBrand>-1)
			aBrand{0}:=aBrand{aBrand}
		Else 
			aBrand{0}:=""
		End if 
		
		uClearSelection(->[Customers_Brand_Lines:39])
		
	Else 
		ARRAY TEXT:C222(aBrand; 2)
		aBrand{1}:=$1->
		aBrand{2}:=""
		aBrand:=1
		aBrand{0}:=aBrand{1}
	End if 
End if 
//