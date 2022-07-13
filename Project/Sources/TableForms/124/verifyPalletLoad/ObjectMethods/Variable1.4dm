If (i=0)
	i:=i+1
	marker:=t1
	aBuffer{i}:=t1
	t1:=""
	BEEP:C151
Else 
	i:=i+1
	aBuffer{i}:=t1
	t1:=""
	If (aBuffer{i}=marker)
		wms_verifyPalletContents  //go process the buffer
		ARRAY TEXT:C222(aBuffer; 0)  //start over
		ARRAY TEXT:C222(aBuffer; 200)
		t1:=""
		i:=0
	End if 
End if 



//given a jobit
//get the pack spec
//divid yld by case count to get cases, round up
//divide cases by pallet cnt to ge pallets
//print pack spec
//print pallet labels
//print case labels
