//%attributes = {}
// Method: CSM_Print () -> 
// ----------------------------------------------------
// by: mel: 12/11/03, 13:07:41
// ----------------------------------------------------

If (True:C214)
	SAVE RECORD:C53([Finished_Goods_Color_SpecMaster:128])
	FORM SET OUTPUT:C54([Finished_Goods_Color_SpecMaster:128]; "print")
	
	PRINT RECORD:C71([Finished_Goods_Color_SpecMaster:128])
	FORM SET OUTPUT:C54([Finished_Goods_Color_SpecMaster:128]; "List")
	
Else 
	C_LONGINT:C283($i; $numColors)
	C_TEXT:C284(xTitle; xText; $temp)
	xTitle:="Color Specification Master: "+[Finished_Goods_Color_SpecMaster:128]id:1+" - "+[Finished_Goods_Color_SpecMaster:128]name:2
	xText:=""
	C_TEXT:C284($t; $cr)
	$t:=Char:C90(9)
	$cr:=Char:C90(13)
	
	//print ColorSpecMaster
	
	ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]side:15; <; [Finished_Goods_Color_SpecSolids:129]pass:13; >; [Finished_Goods_Color_SpecSolids:129]rotation:7; >)
	For ($i; 1; $numColors)
		
		NEXT RECORD:C51([Finished_Goods_Color_SpecSolids:129])
	End for 
	
	//print each ColorSpecSolid
	
	FIRST RECORD:C50([Finished_Goods_Color_SpecSolids:129])
	For ($i; 1; $numColors)
		
		NEXT RECORD:C51([Finished_Goods_Color_SpecSolids:129])
	End for 
End if 