//%attributes = {}
//Method: FGLC_Infer_ReasonT=>tReason
//Description:  This assumes FGLc_Adjust_LoadTransaction has already run
//FGLc_Adjust_LoadTransacion will Sort the issues in the appropriate order
//
//.   WIP            - CC:R
//.   CC:R           - FG:R
//.   FG:R           - FG:BOL
//.   FG:BOL         - FG:V_{1-4}
//.   FG:V_{1-4}     - FG:V05-31-2
//.   FG:V05-31-2.   - V_{1-4}
//.   FG:V_{1-4}     - FG:V_SHIPPED_3
//.   FG:V_SHIPPED_3 - Customer
//
// See: FGLC_Adjust_Reason for acceptable reasons

If (True:C214)  //Intialization
	
	C_TEXT:C284($0; $tReason)
	C_LONGINT:C283($nCustomer)
	
	$tReason:=CorektBlank
	
	$nCustomer:=Find in array:C230(FGLc_atTrans_To; "Customer")
	
End if   //Done Initialize

Case of   //Reason
		
	: ($nCustomer=CoreknNoMatchFound)
		
		$tReason:="User Error"
		
	: (Position:C15("FG:V_SHIPPED"; FGLc_atTrans_From{$nCustomer})>0)
		
		$tReason:="User Error"
		
	: (Position:C15("FG:V_"; FGLc_atTrans_From{$nCustomer})>0)
		
		$tReason:="Straight from receiving"
		
	: (Position:C15("BOL"; FGLc_atTrans_From{$nCustomer})>0)
		
		$tReason:="Straight from receiving"
		
	: (Position:C15("R"; FGLc_atTrans_From{$nCustomer})>0)
		
		$tReason:="Straight from rack"
		
	: (Position:C15("FG:V"; FGLc_atTrans_From{$nCustomer})>0)
		
		$tReason:="Straight from rack"
		
	Else 
		
		$tReason:="System Issue"
		
End case   //Done reason

$0:=$tReason
