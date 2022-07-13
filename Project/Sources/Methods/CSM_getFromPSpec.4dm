//%attributes = {}
// Method: CSM_getFromPSpec () -> 
// ----------------------------------------------------
// By: mel: 12/11/03, 15:38:37
// ----------------------------------------------------

MESSAGES OFF:C175

$pspec:=Request:C163("Get the Inks from Process Spec:"; ""; "Fetch"; "Cancel")

If (OK=1)
	READ ONLY:C145([Process_Specs:18])
	READ ONLY:C145([Process_Specs_Materials:56])
	READ ONLY:C145([Raw_Materials:21])
	
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]PSpecKey:106=([Finished_Goods_Color_SpecMaster:128]custId:3+":"+$pspec))
	If (Records in selection:C76([Process_Specs:18])>0)
		[Finished_Goods_Color_SpecMaster:128]stockCaliper:6:=[Process_Specs:18]Caliper:8
		[Finished_Goods_Color_SpecMaster:128]stockType:5:=[Process_Specs:18]Stock:7
		If (Length:C16([Process_Specs:18]Stamp1:41)>2) | ([Process_Specs:18]Embossing:77) | ([Process_Specs:18]Embossing2:89)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishStamps:14; ->arb2; "Stamps"; True:C214)
		End if 
		If (Length:C16([Process_Specs:18]FilmLaminate:11)>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishLaminationRMcode:15; ->drb2; "Yes, enter R/M code"; True:C214)
		End if 
		If ([Process_Specs:18]ColorsNumGravur:25>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]stockPrecoat:8; ->cb4; "GVR")
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]stockPrecoat:8; ->cb2; "F/S")
		End if 
		If ([Process_Specs:18]iColorGrav:55>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]stockPrecoat:8; ->cb4; "GVR")
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]stockPrecoat:8; ->cb3; "B/S")
		End if 
		If ([Process_Specs:18]SpotCoat1:73) | ([Process_Specs:18]SpotCoat2:74) | ([Process_Specs:18]SpotCoat3:75)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishProcess:12; ->cb12; "Spot")
		End if 
		If (([Process_Specs:18]iCoat1Type:19="Inline") | ([Process_Specs:18]iCoat2Type:21="Inline") | ([Process_Specs:18]iCoat3Type:23="Inline"))
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishProcess:12; ->cb10; "Inline")
		End if 
		If (([Process_Specs:18]iCoat1Type:19="Offline") | ([Process_Specs:18]iCoat2Type:21="Offline") | ([Process_Specs:18]iCoat3Type:23="Offline"))
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishProcess:12; ->cb10; "Offline")
		End if 
		If (([Process_Specs:18]iCoat1Type:19="Combo") | ([Process_Specs:18]iCoat2Type:21="Combo") | ([Process_Specs:18]iCoat3Type:23="Combo"))
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishProcess:12; ->cb10; "Inline")
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishProcess:12; ->cb10; "Offline")
		End if 
		If (Position:C15("Dull"; ([Process_Specs:18]Coat1Matl:14+[Process_Specs:18]Coat2Matl:16+[Process_Specs:18]Coat3Matl:18+[Process_Specs:18]iCoat1Matl:20+[Process_Specs:18]iCoat2Matl:22+[Process_Specs:18]iCoat3Matl:24))>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishGlossLevel:13; ->rb1; "Dull"; True:C214)
		End if 
		If (Position:C15("Semi"; ([Process_Specs:18]Coat1Matl:14+[Process_Specs:18]Coat2Matl:16+[Process_Specs:18]Coat3Matl:18+[Process_Specs:18]iCoat1Matl:20+[Process_Specs:18]iCoat2Matl:22+[Process_Specs:18]iCoat3Matl:24))>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishGlossLevel:13; ->rb3; "Semi"; True:C214)
		End if 
		If (Position:C15("WB"; ([Process_Specs:18]Coat1Matl:14+[Process_Specs:18]Coat2Matl:16+[Process_Specs:18]Coat3Matl:18+[Process_Specs:18]iCoat1Matl:20+[Process_Specs:18]iCoat2Matl:22+[Process_Specs:18]iCoat3Matl:24))>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishType:11; ->cb8; "W/B")
			If (Position:C15("None"; [Finished_Goods_Color_SpecMaster:128]finishType:11)=0)
				SetObjectProperties("fininsh@"; -><>NULL; True:C214)
			Else 
				SetObjectProperties("fininsh@"; -><>NULL; False:C215)
			End if 
		End if 
		If (Position:C15("W.B."; ([Process_Specs:18]Coat1Matl:14+[Process_Specs:18]Coat2Matl:16+[Process_Specs:18]Coat3Matl:18+[Process_Specs:18]iCoat1Matl:20+[Process_Specs:18]iCoat2Matl:22+[Process_Specs:18]iCoat3Matl:24))>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishType:11; ->cb8; "W/B")
			If (Position:C15("None"; [Finished_Goods_Color_SpecMaster:128]finishType:11)=0)
				SetObjectProperties("fininsh@"; -><>NULL; True:C214)
			Else 
				SetObjectProperties("fininsh@"; -><>NULL; False:C215)
			End if 
		End if 
		If (Position:C15("UV"; ([Process_Specs:18]Coat1Matl:14+[Process_Specs:18]Coat2Matl:16+[Process_Specs:18]Coat3Matl:18+[Process_Specs:18]iCoat1Matl:20+[Process_Specs:18]iCoat2Matl:22+[Process_Specs:18]iCoat3Matl:24))>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishType:11; ->cb7; "U/V")
			If (Position:C15("None"; [Finished_Goods_Color_SpecMaster:128]finishType:11)=0)
				SetObjectProperties("fininsh@"; -><>NULL; True:C214)
			Else 
				SetObjectProperties("fininsh@"; -><>NULL; False:C215)
			End if 
		End if 
		If (Position:C15("U.V."; ([Process_Specs:18]Coat1Matl:14+[Process_Specs:18]Coat2Matl:16+[Process_Specs:18]Coat3Matl:18+[Process_Specs:18]iCoat1Matl:20+[Process_Specs:18]iCoat2Matl:22+[Process_Specs:18]iCoat3Matl:24))>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishType:11; ->cb7; "U/V")
			If (Position:C15("None"; [Finished_Goods_Color_SpecMaster:128]finishType:11)=0)
				SetObjectProperties("fininsh@"; -><>NULL; True:C214)
			Else 
				SetObjectProperties("fininsh@"; -><>NULL; False:C215)
			End if 
		End if 
		
		If (Position:C15("Matte"; ([Process_Specs:18]Varn1Gloss:32+[Process_Specs:18]Varn2Gloss:48+[Process_Specs:18]iVarn1Gloss:71+[Process_Specs:18]iVarn2Gloss:69))>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishGlossLevel:13; ->rb2; "Satin"; True:C214)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishType:11; ->cb6; "O/P")
			If (Position:C15("None"; [Finished_Goods_Color_SpecMaster:128]finishType:11)=0)
				SetObjectProperties("fininsh@"; -><>NULL; True:C214)
			Else 
				SetObjectProperties("fininsh@"; -><>NULL; False:C215)
			End if 
		End if 
		
		If (Position:C15("Gloss"; ([Process_Specs:18]Varn1Gloss:32+[Process_Specs:18]Varn2Gloss:48+[Process_Specs:18]iVarn1Gloss:71+[Process_Specs:18]iVarn2Gloss:69))>0)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishGlossLevel:13; ->rb4; "Gloss"; True:C214)
			CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishType:11; ->cb6; "O/P")
			If (Position:C15("None"; [Finished_Goods_Color_SpecMaster:128]finishType:11)=0)
				SetObjectProperties("fininsh@"; -><>NULL; True:C214)
			Else 
				SetObjectProperties("fininsh@"; -><>NULL; False:C215)
			End if 
		End if 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			PSpecEstimateLd(""; "Materials")
			QUERY SELECTION:C341([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Commodity_Key:8="02@"; *)
			QUERY SELECTION:C341([Process_Specs_Materials:56];  | ; [Process_Specs_Materials:56]Commodity_Key:8="03@"; *)
			QUERY SELECTION:C341([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]Raw_Matl_Code:13#"")
			
		Else 
			
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Commodity_Key:8="02@"; *)
			QUERY:C277([Process_Specs_Materials:56];  | ; [Process_Specs_Materials:56]Commodity_Key:8="03@"; *)
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Raw_Matl_Code:13#""; *)
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1; *)
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]CustID:2=[Process_Specs:18]Cust_ID:4)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		If (Records in selection:C76([Process_Specs_Materials:56])>0)
			QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=[Finished_Goods_Color_SpecMaster:128]id:1)
			util_DeleteSelection(->[Finished_Goods_Color_SpecSolids:129])
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Real2:15; >)
				FIRST RECORD:C50([Process_Specs_Materials:56])
				
			Else 
				
				ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Real2:15; >)
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
			While (Not:C34(End selection:C36([Process_Specs_Materials:56])))
				CREATE RECORD:C68([Finished_Goods_Color_SpecSolids:129])
				[Finished_Goods_Color_SpecSolids:129]id:1:=app_GetPrimaryKey  //String(app_AutoIncrement (->[Finished_Goods_Color_SpecSolids]);"0000000")
				[Finished_Goods_Color_SpecSolids:129]masterSet:3:=[Finished_Goods_Color_SpecMaster:128]id:1
				[Finished_Goods_Color_SpecSolids:129]side:15:="F"
				[Finished_Goods_Color_SpecSolids:129]pass:13:=1
				[Finished_Goods_Color_SpecSolids:129]rotation:7:=[Process_Specs_Materials:56]Real2:15
				[Finished_Goods_Color_SpecSolids:129]inkRMcode:4:=[Process_Specs_Materials:56]Raw_Matl_Code:13
				Case of 
					: ([Process_Specs_Materials:56]Real1:14=100)
						[Finished_Goods_Color_SpecSolids:129]coveragePercent:12:="Solid"
					: ([Process_Specs_Materials:56]Real1:14>0)
						[Finished_Goods_Color_SpecSolids:129]coveragePercent:12:=String:C10([Process_Specs_Materials:56]Real1:14)+"%"
				End case 
				
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Finished_Goods_Color_SpecSolids:129]inkRMcode:4)
				If (Records in selection:C76([Raw_Materials:21])>0)
					[Finished_Goods_Color_SpecSolids:129]colorName:10:=[Raw_Materials:21]Flex5:23
				Else 
					[Finished_Goods_Color_SpecSolids:129]colorName:10:="n/a"
				End if 
				SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
				NEXT RECORD:C51([Process_Specs_Materials:56])
			End while 
			
			QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=[Finished_Goods_Color_SpecMaster:128]id:1)
			ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]side:15; <; [Finished_Goods_Color_SpecSolids:129]pass:13; >; [Finished_Goods_Color_SpecSolids:129]rotation:7; >)
			
		Else 
			BEEP:C151
			ALERT:C41($pspec+" has no inks or coatings")
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41($pspec+" not found for this customer")
	End if 
	REDUCE SELECTION:C351([Process_Specs:18]; 0)
	REDUCE SELECTION:C351([Process_Specs_Materials:56]; 0)
	REDUCE SELECTION:C351([Raw_Materials:21]; 0)
End if 
MESSAGES ON:C181