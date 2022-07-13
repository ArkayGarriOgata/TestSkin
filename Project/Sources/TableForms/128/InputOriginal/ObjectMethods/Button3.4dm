// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]colorName:10="")


// ******* Verified  - 4D PS - January 2019 (end) *********
$existing:=Records in selection:C76([Finished_Goods_Color_SpecSolids:129])
If ($existing<4)
	For ($i; $existing+1; 4)
		CREATE RECORD:C68([Finished_Goods_Color_SpecSolids:129])
		[Finished_Goods_Color_SpecSolids:129]id:1:=app_GetPrimaryKey  //String(app_AutoIncrement (->[Finished_Goods_Color_SpecSolids]);"0000000")
		[Finished_Goods_Color_SpecSolids:129]masterSet:3:=[Finished_Goods_Color_SpecMaster:128]id:1
		[Finished_Goods_Color_SpecSolids:129]side:15:="F"
		[Finished_Goods_Color_SpecSolids:129]pass:13:=1
		[Finished_Goods_Color_SpecSolids:129]rotation:7:=0
		SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
	End for 
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]colorName:10="")
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]rotation:7; >)
	FIRST RECORD:C50([Finished_Goods_Color_SpecSolids:129])
	
	
Else 
	
	ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]rotation:7; >)
	
End if   // END 4D Professional Services : January 2019 First record

[Finished_Goods_Color_SpecSolids:129]colorName:10:="c"
CSM_getRMbyColor
SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
NEXT RECORD:C51([Finished_Goods_Color_SpecSolids:129])
[Finished_Goods_Color_SpecSolids:129]colorName:10:="y"
CSM_getRMbyColor
SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
NEXT RECORD:C51([Finished_Goods_Color_SpecSolids:129])
[Finished_Goods_Color_SpecSolids:129]colorName:10:="m"
CSM_getRMbyColor
SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
NEXT RECORD:C51([Finished_Goods_Color_SpecSolids:129])
[Finished_Goods_Color_SpecSolids:129]colorName:10:="k"
CSM_getRMbyColor
SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])

QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=[Finished_Goods_Color_SpecMaster:128]id:1)
ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]side:15; <; [Finished_Goods_Color_SpecSolids:129]pass:13; >; [Finished_Goods_Color_SpecSolids:129]rotation:7; >)
