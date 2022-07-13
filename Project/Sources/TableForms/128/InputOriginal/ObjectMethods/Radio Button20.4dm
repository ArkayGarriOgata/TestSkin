CSM_setField(->[Finished_Goods_Color_SpecMaster:128]stockPrecoat:8; ->cb4; "GVR")

CREATE RECORD:C68([Finished_Goods_Color_SpecSolids:129])
[Finished_Goods_Color_SpecSolids:129]id:1:=app_GetPrimaryKey  //String(app_AutoIncrement (->[Finished_Goods_Color_SpecSolids]);"0000000")
[Finished_Goods_Color_SpecSolids:129]masterSet:3:=[Finished_Goods_Color_SpecMaster:128]id:1
[Finished_Goods_Color_SpecSolids:129]side:15:="B"
[Finished_Goods_Color_SpecSolids:129]pass:13:=0
[Finished_Goods_Color_SpecSolids:129]rotation:7:=1
[Finished_Goods_Color_SpecSolids:129]operationType:9:="Gravure"
SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])

QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=[Finished_Goods_Color_SpecMaster:128]id:1)
ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]pass:13; >; [Finished_Goods_Color_SpecSolids:129]rotation:7; >)