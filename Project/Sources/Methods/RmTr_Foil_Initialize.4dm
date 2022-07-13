//%attributes = {}
//Method:  RmTr_Foil_Initialize(tPhase)
//Description:  This method handles initializing values


If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_TEXT:C284($tVendor)
	C_LONGINT:C283($nWidth)
	C_TEXT:C284($tColor)
	C_LONGINT:C283($nQuantity)
	
	$tPhase:=$1
	
	$tVendor:=CorektBlank
	$nWidth:=0
	$tColor:=CorektBlank
	$nQuantity:=0
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseAssignField)
		
		$tVendor:=RmTr_atFoil_Vendor{RmTr_atFoil_Vendor}
		$nWidth:=Num:C11(RmTr_atFoil_Width{RmTr_atFoil_Width})
		$tColor:=RmTr_atFoil_Color{RmTr_atFoil_Color}
		$nQuantity:=Abs:C99(Num:C11(RmTr_atFoil_Quantity{RmTr_atFoil_Quantity}))
		
	: ($tPhase=CorektPhaseInitialize)
		
		RmTr_Foil_Fill  //Fills: RmTr_atFoil_Vendor, RmTr_atFoil_Width, RmTr_atFoil_Color, RmTr_atFoil_Quantity
		
		Case of   //Vendor
				
			: (Position:C15("ITW"; Form:C1466.PURCHASE_ITEM.VENDOR.Name)>0)
				
				RmTr_atFoil_Vendor:=Find in array:C230(RmTr_atFoil_Vendor; "ITW")
				
			: (Position:C15("Kurz"; Form:C1466.PURCHASE_ITEM.VENDOR.Name)>0)
				
				RmTr_atFoil_Vendor:=Find in array:C230(RmTr_atFoil_Vendor; "Kurz")
				
			: (Position:C15("Univacco"; Form:C1466.PURCHASE_ITEM.VENDOR.Name)>0)
				
				RmTr_atFoil_Vendor:=Find in array:C230(RmTr_atFoil_Vendor; "Univacco")
				
		End case   //Done vendor
		
		RmTr_atFoil_Width:=Find in array:C230(RmTr_atFoil_Width; "@"+String:C10(Form:C1466.RAW_MATERIAL.Flex2)+"@")
		
		RmTr_atFoil_Color:=Find in array:C230(RmTr_atFoil_Color; "@"+String:C10(Form:C1466.RAW_MATERIAL.Flex4)+"@")
		
		RmTr_atFoil_Quantity:=Find in array:C230(RmTr_atFoil_Quantity; "@"+String:C10(Abs:C99(Form:C1466.Qty))+"@")
		
End case   //Done phase