// ----------------------------------------------------
// Form Method: [Finished_Goods_Color_SpecMaster].Input
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		C_TEXT:C284(<>ColorSpecMasterID)  // Added by: Mark Zinke (3/26/13)
		
		READ ONLY:C145([Customers_Projects:9])
		READ ONLY:C145([Customers:16])
		
		stockList:=RM_BuildStockList("init")
		SAVE LIST:C384(hlStockTypes; "CaliperByStock")
		
		If (Is new record:C668([Finished_Goods_Color_SpecMaster:128]))
			[Finished_Goods_Color_SpecMaster:128]DateCreated:17:=4D_Current_date
			If (Length:C16(<>ColorSpecMasterID)=5)
				[Finished_Goods_Color_SpecMaster:128]id:1:=<>ColorSpecMasterID
				<>ColorSpecMasterID:=""
			Else 
				[Finished_Goods_Color_SpecMaster:128]id:1:=String:C10(app_AutoIncrement(->[Finished_Goods_Color_SpecMaster:128]); "00000")
				pjtID:=[Finished_Goods_Color_SpecMaster:128]id:1  // Added by: Mark Zinke (3/27/13)
			End if 
			[Finished_Goods_Color_SpecMaster:128]projectId:4:=Pjt_getReferId
			If (Length:C16([Finished_Goods_Color_SpecMaster:128]projectId:4)=5)
				QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Finished_Goods_Color_SpecMaster:128]projectId:4)
				If (Records in selection:C76([Customers_Projects:9])>0)
					[Finished_Goods_Color_SpecMaster:128]custId:3:=[Customers_Projects:9]Customerid:3
				End if 
			End if 
			
			
			[Finished_Goods_Color_SpecMaster:128]stockPrecoat:8:=" None "
			[Finished_Goods_Color_SpecMaster:128]finishType:11:=" None "
			[Finished_Goods_Color_SpecMaster:128]finishProcess:12:=" None "
			[Finished_Goods_Color_SpecMaster:128]finishGlossLevel:13:=" None "
			[Finished_Goods_Color_SpecMaster:128]finishStamps:14:=" None "
			[Finished_Goods_Color_SpecMaster:128]finishLaminationRMcode:15:=" None "
			For ($i; 1; 8)
				CREATE RECORD:C68([Finished_Goods_Color_SpecSolids:129])
				[Finished_Goods_Color_SpecSolids:129]id:1:=app_GetPrimaryKey  //String(app_AutoIncrement (->[Finished_Goods_Color_SpecSolids]);"0000000")
				[Finished_Goods_Color_SpecSolids:129]masterSet:3:=[Finished_Goods_Color_SpecMaster:128]id:1
				[Finished_Goods_Color_SpecSolids:129]rotation:7:=$i
				[Finished_Goods_Color_SpecSolids:129]pass:13:=1
				[Finished_Goods_Color_SpecSolids:129]side:15:="F"
				SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
			End for 
			C_TEXT:C284($cr)
			$cr:=Char:C90(13)
			[Finished_Goods_Color_SpecMaster:128]comment:9:="•Color Break:"+$cr+$cr+"•Frontside Coatings:"+$cr+$cr+"•Trapping and Spread:"+$cr+$cr+"•Barcode:"+$cr+$cr+"•Control Code:"+$cr+$cr
		End if 
		
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods_Color_SpecMaster:128]custId:3)
		
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Finished_Goods_Color_SpecMaster:128]projectId:4)
		
		READ WRITE:C146([Finished_Goods_Color_SpecSolids:129])
		QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=[Finished_Goods_Color_SpecMaster:128]id:1)
		ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]side:15; <; [Finished_Goods_Color_SpecSolids:129]pass:13; >; [Finished_Goods_Color_SpecSolids:129]rotation:7; >)
		
		cb2:=Num:C11(Position:C15("F/S"; [Finished_Goods_Color_SpecMaster:128]stockPrecoat:8)>0)
		cb3:=Num:C11(Position:C15("B/S"; [Finished_Goods_Color_SpecMaster:128]stockPrecoat:8)>0)
		//cb4:=Num(Position("GVR";[Finished_Goods_Color_SpecMaster]stockPrecoat)>0)
		
		//cb6:=Num(Position("O/P";[Finished_Goods_Color_SpecMaster]finishType)>0)
		//cb7:=Num(Position("U/V";[Finished_Goods_Color_SpecMaster]finishType)>0)
		//cb8:=Num(Position("W/B";[Finished_Goods_Color_SpecMaster]finishType)>0)
		If (Position:C15("None"; [Finished_Goods_Color_SpecMaster:128]finishType:11)=0)
			SetObjectProperties("fininsh@"; -><>NULL; True:C214)
		Else 
			SetObjectProperties("fininsh@"; -><>NULL; False:C215)
		End if 
		
		//cb10:=Num(Position("Inline";[Finished_Goods_Color_SpecMaster]finishProcess)>0)
		//cb11:=Num(Position("Offline";[Finished_Goods_Color_SpecMaster]finishProcess)>0)
		//cb12:=Num(Position("Spot";[Finished_Goods_Color_SpecMaster]finishProcess)>0)
		//cb13:=Num(Position("Solid";[Finished_Goods_Color_SpecMaster]finishProcess)>0)
		
		//rb5:=Num(Position("None";[Finished_Goods_Color_SpecMaster]finishGlossLevel)>0)
		//rb1:=Num(Position("Dull";[Finished_Goods_Color_SpecMaster]finishGlossLevel)>0)
		//rb2:=Num(Position("Satin";[Finished_Goods_Color_SpecMaster]finishGlossLevel)>0)
		//rb3:=Num(Position("Semi";[Finished_Goods_Color_SpecMaster]finishGlossLevel)>0)
		//rb4:=Num(Position("Gloss";[Finished_Goods_Color_SpecMaster]finishGlossLevel)>0)
		
		//arb1:=Num(Position("None";[Finished_Goods_Color_SpecMaster]finishStamps)>0)
		//arb2:=Num(Position("Stamps";[Finished_Goods_Color_SpecMaster]finishStamps)>0)
		
		//drb1:=Num(Position("None";[Finished_Goods_Color_SpecMaster]finishLaminationRMcode)>0)
		//drb2:=Num(Position("None";[Finished_Goods_Color_SpecMaster]finishLaminationRMcode)=0)
		SET WINDOW TITLE:C213("CSM: "+[Finished_Goods_Color_SpecMaster:128]name:2)
		
	: (Form event code:C388=On Close Box:K2:21)
		ACCEPT:C269
		SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
		UNLOAD RECORD:C212([Finished_Goods_Color_SpecSolids:129])
		
		
	: (Form event code:C388=On Validate:K2:3)
		SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
		UNLOAD RECORD:C212([Finished_Goods_Color_SpecSolids:129])
		READ WRITE:C146([Finished_Goods:26])
		If ([Finished_Goods_Color_SpecMaster:128]DateApproved:18#Old:C35([Finished_Goods_Color_SpecMaster:128]DateApproved:18))  //(Modified([Finished_Goods_Color_SpecMaster]DateReceived))
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ColorSpecMaster:77=[Finished_Goods_Color_SpecMaster:128]id:1)
			APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]DateColorReceived:99:=[Finished_Goods_Color_SpecMaster:128]DateApproved:18)
		End if 
		If ([Finished_Goods_Color_SpecMaster:128]DateSent:21#Old:C35([Finished_Goods_Color_SpecMaster:128]DateSent:21))  //(Modified([Finished_Goods_Color_SpecMaster]DateSent))
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ColorSpecMaster:77=[Finished_Goods_Color_SpecMaster:128]id:1)
			APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]DateColorSent:100:=[Finished_Goods_Color_SpecMaster:128]DateSent:21)
		End if 
		If ([Finished_Goods_Color_SpecMaster:128]DateApproved:18#Old:C35([Finished_Goods_Color_SpecMaster:128]DateApproved:18))  //(Modified([Finished_Goods_Color_SpecMaster]Approved))
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ColorSpecMaster:77=[Finished_Goods_Color_SpecMaster:128]id:1)
			If ([Finished_Goods_Color_SpecMaster:128]DateApproved:18#!00-00-00!)
				APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]DateColorApproved:86:=[Finished_Goods_Color_SpecMaster:128]DateApproved:18)
			Else 
				APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]DateColorApproved:86:=!00-00-00!)
			End if 
		End if 
		
	: (Form event code:C388=On Unload:K2:2)
		UNLOAD RECORD:C212([Finished_Goods_Color_SpecSolids:129])
End case 