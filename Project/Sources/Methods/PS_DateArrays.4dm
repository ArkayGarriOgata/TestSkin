//%attributes = {"publishedWeb":true}
//PM: PS_DateArrays(size) -> 
//@author mlb - 8/13/02  17:07

If (Count parameters:C259=1)  //size
	//ARRAY TEXT($aPlant;$1)
	ARRAY TEXT:C222(<>aJML; $1)
	//ARRAY DATE(◊aMAD;$1)
	ARRAY DATE:C224(<>aREV; $1)  //• mlb - 7/31/02  10:42
	//ARRAY DATE(◊a1ST;$1)
	//ARRAY TEXT(◊aFiniAt;$1)
	//ARRAY TEXT(◊aInfo;$1)
	ARRAY DATE:C224(<>aBagGot; $1)
	ARRAY DATE:C224(<>aBagOK; $1)
	ARRAY DATE:C224(<>aStockGot; $1)
	ARRAY DATE:C224(<>aStockShted; $1)
	ARRAY DATE:C224(<>aPrinted; $1)
	
	ARRAY DATE:C224(<>aBagRtn; $1)
	ARRAY DATE:C224(<>aWIP; $1)
	ARRAY DATE:C224(<>aRTG; $1)
	//ARRAY BOOLEAN(◊aeBag;$1)
	//ARRAY TEXT(◊aOperations;$1)
	//ARRAY REAL(◊aCALIPER;$1)
	//ARRAY TEXT(◊aLAUNCH;$1)
	
Else   //insert
	INSERT IN ARRAY:C227(<>aJML; 1; 1)
	//INSERT ELEMENT(◊aMAD;$2;$1)
	INSERT IN ARRAY:C227(<>aREV; $2; $1)  //• mlb - 7/31/02  10:40
	//INSERT ELEMENT(◊a1ST;$2;$1)
	//INSERT ELEMENT(◊aFiniAt;$2;$1)
	//INSERT ELEMENT(◊aInfo;$2;$1)
	INSERT IN ARRAY:C227(<>aBagGot; $2; $1)
	INSERT IN ARRAY:C227(<>aBagOK; $2; $1)
	INSERT IN ARRAY:C227(<>aStockGot; $2; $1)
	INSERT IN ARRAY:C227(<>aStockShted; $2; $1)
	INSERT IN ARRAY:C227(<>aPrinted; $2; $1)
	
	INSERT IN ARRAY:C227(<>aBagRtn; $2; $1)
	INSERT IN ARRAY:C227(<>aWIP; $2; $1)
	INSERT IN ARRAY:C227(<>aRTG; $2; $1)
	//
	//INSERT ELEMENT(◊aeBag;$2;$1)
	//INSERT ELEMENT(◊aOperations;$2;$1)
	//INSERT ELEMENT(◊aCALIPER;$2;$1)
	//INSERT ELEMENT(◊aLAUNCH;$2;$1)
End if 