//%attributes = {}
//Method:  Compiler_FGLc_Array(tMethodName{;nRows}{;nColumns})
//Description:  This method initializes arrays

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tMethodName)
	C_LONGINT:C283($2; $nRows; $3; $nColumns)
	C_LONGINT:C283($nNumberOfParameters)
	
	C_POINTER:C301($patTitle; $patLocation; $patKey)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tMethodName:=$1
	
	$nRows:=0
	$nColumns:=0
	
	If ($nNumberOfParameters>=2)  //Optional
		$nRows:=$2
		If ($nNumberOfParameters>=3)
			$nColumns:=$3
		End if 
	End if   //Done optional
	
End if   //Done Initialize

Case of   //Method name
		
	: ($tMethodName="FGLc_Mgmt_Reason")
		
		ARRAY TEXT:C222(FGLc_atMgmt_Reason; $nRows)
		
	: ($tMethodName="FGLc_Adjust_Reason")
		
		ARRAY TEXT:C222(FGLc_atAdjust_Reason; $nRows)
		
	: ($tMethodName="FGLc_Adjust_LoadLocation1")
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Location; $nRows)
		ARRAY BOOLEAN:C223(FGLc_abLoc_Delete; $nRows)
		
	: ($tMethodName="FGLc_Adjust_LoadLocation")
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Location; $nRows)
		ARRAY BOOLEAN:C223(FGLc_abLoc_Delete; $nRows)
		
		ARRAY TEXT:C222(FGLc_atLoc_JobIT; $nRows)
		ARRAY TEXT:C222(FGLc_atLoc_Skid; $nRows)
		ARRAY TEXT:C222(FGLc_atLoc_Location; $nRows)
		ARRAY LONGINT:C221(FGLc_anLoc_Qty; $nRows)
		ARRAY LONGINT:C221(FGLc_anLoc_OriginalQty; $nRows)
		ARRAY TEXT:C222(FGLc_atLoc_Pk_id; $nRows)
		
	: ($tMethodName="FGLc_Adjust_LoadTransaction1")
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Transaction; $nRows)
		
	: ($tMethodName="FGLc_Adjust_LoadTransaction")
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Transaction; $nRows)
		
		ARRAY TEXT:C222(FGLc_atTrans_JobIT; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_Skid; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_From; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_To; $nRows)
		ARRAY LONGINT:C221(FGLc_anTrans_Qty; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_Type; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_DateTime; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_Pk_id; $nRows)
		
	: ($tMethodName="FGLc_Adjust_Negative1")
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Negative; $nRows)
		
	: ($tMethodName="FGLc_Adjust_Negative")
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Negative; $nRows)
		ARRAY TEXT:C222(FGLc_atNeg_ProductCode; $nRows)
		ARRAY LONGINT:C221(FGLc_anNeg_Quantity; $nRows)
		ARRAY TEXT:C222(FGLc_atNeg_Pk_id; $nRows)
		
	: ($tMethodName="FGLc_Adjust_Initialize")
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Negative; $nRows)
		ARRAY TEXT:C222(FGLc_atNeg_ProductCode; $nRows)
		ARRAY LONGINT:C221(FGLc_anNeg_Quantity; $nRows)
		ARRAY TEXT:C222(FGLc_atNeg_Pk_id; $nRows)
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Transaction; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_JobIT; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_Skid; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_From; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_To; $nRows)
		ARRAY LONGINT:C221(FGLc_anTrans_Qty; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_DateTime; $nRows)
		ARRAY TEXT:C222(FGLc_atTrans_Pk_id; $nRows)
		
		ARRAY BOOLEAN:C223(FGLc_abAdjust_Location; $nRows)
		ARRAY BOOLEAN:C223(FGLc_abLoc_Delete; $nRows)
		ARRAY TEXT:C222(FGLc_atLoc_JobIT; $nRows)
		ARRAY TEXT:C222(FGLc_atLoc_Skid; $nRows)
		ARRAY TEXT:C222(FGLc_atLoc_Location; $nRows)
		ARRAY LONGINT:C221(FGLc_anLoc_Qty; $nRows)
		ARRAY LONGINT:C221(FGLc_anLoc_OriginalQty; $nRows)
		ARRAY TEXT:C222(FGLc_atLoc_Pk_id; $nRows)
		
		
End case   //Done method name
