//%attributes = {}
// Method: CSM_getFromPrep () -> 
// ----------------------------------------------------
// by: mel: 03/15/04, 12:05:58
// ----------------------------------------------------


C_TEXT:C284($controlNum)

MESSAGES OFF:C175
$controlNum:=Request:C163("Get the Inks from Control Number:"; ""; "Fetch"; "Cancel")

If (OK=1)
	QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=[Finished_Goods_Color_SpecMaster:128]id:1)
	util_DeleteSelection(->[Finished_Goods_Color_SpecSolids:129])
	
	READ ONLY:C145([Finished_Goods_Specifications:98])
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$controlNum)
	If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
		RELATE MANY:C262([Finished_Goods_Specifications:98]Ink:24)
		ORDER BY:C49([Finished_Goods_Specs_Inks:188]; [Finished_Goods_Specs_Inks:188]Side:2; >; [Finished_Goods_Specs_Inks:188]Rotation:1; >)
		While (Not:C34(End selection:C36([Finished_Goods_Specs_Inks:188])))
			CREATE RECORD:C68([Finished_Goods_Color_SpecSolids:129])
			[Finished_Goods_Color_SpecSolids:129]id:1:=app_GetPrimaryKey  //String(app_AutoIncrement (->[Finished_Goods_Color_SpecSolids]);"0000000")
			[Finished_Goods_Color_SpecSolids:129]masterSet:3:=[Finished_Goods_Color_SpecMaster:128]id:1
			[Finished_Goods_Color_SpecSolids:129]pass:13:=1
			[Finished_Goods_Color_SpecSolids:129]rotation:7:=[Finished_Goods_Specs_Inks:188]Rotation:1
			If ([Finished_Goods_Specs_Inks:188]Side:2="F/S")
				[Finished_Goods_Color_SpecSolids:129]side:15:="F"
			Else 
				[Finished_Goods_Color_SpecSolids:129]side:15:="B"
			End if 
			[Finished_Goods_Color_SpecSolids:129]colorName:10:=[Finished_Goods_Specs_Inks:188]Color:4
			[Finished_Goods_Color_SpecSolids:129]inkRMcode:4:=[Finished_Goods_Specs_Inks:188]InkNumber:3
			[Finished_Goods_Color_SpecSolids:129]operationType:9:=[Finished_Goods_Specs_Inks:188]Operation:5
			SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
			
			NEXT RECORD:C51([Finished_Goods_Specs_Inks:188])
		End while 
		
		QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=[Finished_Goods_Color_SpecMaster:128]id:1)
		ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]side:15; <; [Finished_Goods_Color_SpecSolids:129]pass:13; >; [Finished_Goods_Color_SpecSolids:129]rotation:7; >)
		
	Else 
		BEEP:C151
		ALERT:C41($controlNum+" was not found.")
	End if 
End if 