C_TEXT:C284($cpn)
C_BOOLEAN:C305($found; $leaf)
If (User in group:C338(Current user:C182; "Planners"))
	If ([Finished_Goods:26]Status:14#"Final")
		$cpn:=Request:C163("Make this FG like Product Code:"; [Finished_Goods:26]ProductCode:1)
		If (ok=1)
			$custid:=[Finished_Goods:26]CustID:2
			PUSH RECORD:C176([Finished_Goods:26])
			
			If (qryFinishedGood($custid; $cpn)>0)
				$found:=True:C214
				//$CustID:=[Finished_Goods]CustID  ` • 1/8/97 multiple customers on one job
				//$ProductCode:=[Finished_Goods]ProductCode
				//$Description:=[Finished_Goods]CartonDesc
				$OutLineNumb:=[Finished_Goods:26]OutLine_Num:4
				$SquareInche:=[Finished_Goods:26]SquareInch:6
				$Width:=[Finished_Goods:26]Width:7
				$Depth:=[Finished_Goods:26]Depth:8
				$Height:=[Finished_Goods:26]Height:9
				$Width_Dec:=[Finished_Goods:26]Width_Dec:10
				$Depth_Dec:=[Finished_Goods:26]Depth_Dec:11
				$Height_Dec:=[Finished_Goods:26]Height_Dec:12
				$Style:=[Finished_Goods:26]Style:32
				$ProcessSpec:=[Finished_Goods:26]ProcessSpec:33
				$StripHoles:=[Finished_Goods:26]StripHoles:38
				$WindowMatl:=[Finished_Goods:26]WindowMatl:39
				$WindowGauge:=[Finished_Goods:26]WindowGauge:40
				$WindowWth:=[Finished_Goods:26]WindowWth:41
				$WindowHth:=[Finished_Goods:26]WindowHth:42
				$GlueType:=[Finished_Goods:26]GlueType:34
				$GlueInspect:=[Finished_Goods:26]GlueInspect:35
				$Imaje:=[Finished_Goods:26]SecurityLabels:36
				$DieCutOptio:=[Finished_Goods:26]DieCutOptions:44
				$UPC:=[Finished_Goods:26]UPC:37
				$ArtReceived:=[Finished_Goods:26]DateArtApproved:46
				$PackingQty:=[Finished_Goods:26]PackingQty:45
				$Classificat:=[Finished_Goods:26]ClassOrType:28
				$notes:=[Finished_Goods:26]Notes:20  //•011696  MLB  to hold glue speed
				$OrderType:=[Finished_Goods:26]OrderType:59  //• 5/23/97 cs upr 1857    
				If (False:C215)  //v1.0.3-JJG (03/28/17) - unused deprecated subtable? Doesn't have a linked table
					//ALL SUBRECORDS([Finished_Goods]notused_LeafInformation)
					//If (Records in subselection([Finished_Goods]notused_LeafInformation)>0)
					//$leaf:=True
					//Else 
					//$leaf:=False
					//End if 
				End if 
				
			Else 
				$found:=False:C215
				BEEP:C151
				ALERT:C41($cpn+" was not found in Finished Goods item master.")
			End if 
			POP RECORD:C177([Finished_Goods:26])
			
			If ($found)
				FG_Virgin_ize
				//[Finished_Goods]CartonDesc:=$Description
				//[Finished_Goods]OutLine_Num:=$OutLineNumb
				[Finished_Goods:26]SquareInch:6:=$SquareInche
				[Finished_Goods:26]ProcessSpec:33:=$ProcessSpec
				If ([Finished_Goods:26]ProcessSpec:33#"")
					QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Finished_Goods:26]ProcessSpec:33; *)
					QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Finished_Goods:26]CustID:2)
					If (Records in selection:C76([Process_Specs:18])=0)
						BEEP:C151
						ALERT:C41([Finished_Goods:26]ProcessSpec:33+" has not been defined for this customer.")
						[Finished_Goods:26]ProcessSpec:33:=""
					End if 
				End if 
				// [Finished_Goods]Status:="Ordered"
				[Finished_Goods:26]ClassOrType:28:=$Classificat
				[Finished_Goods:26]Width:7:=$Width
				[Finished_Goods:26]Depth:8:=$Depth
				[Finished_Goods:26]Height:9:=$Height
				[Finished_Goods:26]Width_Dec:10:=$Width_Dec
				[Finished_Goods:26]Depth_Dec:11:=$Depth_Dec
				[Finished_Goods:26]Height_Dec:12:=$Height_Dec
				[Finished_Goods:26]Style:32:=$Style
				[Finished_Goods:26]StripHoles:38:=$StripHoles
				[Finished_Goods:26]WindowMatl:39:=$WindowMatl
				[Finished_Goods:26]WindowGauge:40:=$WindowGauge
				[Finished_Goods:26]WindowWth:41:=$WindowWth
				[Finished_Goods:26]WindowHth:42:=$WindowHth
				[Finished_Goods:26]GlueType:34:=$GlueType
				[Finished_Goods:26]GlueInspect:35:=$GlueInspect
				[Finished_Goods:26]SecurityLabels:36:=$Imaje
				[Finished_Goods:26]UPC:37:=$UPC
				[Finished_Goods:26]DieCutOptions:44:=$DieCutOptio
				[Finished_Goods:26]PackingQty:45:=$PackingQty
				// [Finished_Goods]ArtReceived:=$ArtReceived
				[Finished_Goods:26]Notes:20:="Attributes inherited from "+$cpn+Char:C90(13)+[Finished_Goods:26]Notes:20+Char:C90(13)+$notes  //•011696  MLB  to hold glue speed
				[Finished_Goods:26]OrderType:59:=$OrderType
				QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=$Classificat)
				[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
				[Finished_Goods:26]ModWho:25:=<>zResp
				[Finished_Goods:26]ModDate:24:=4D_Current_date
				If ([Finished_Goods:26]Acctg_UOM:29="")  //upr 1268 chip 02/17/95
					[Finished_Goods:26]Acctg_UOM:29:="M"
				End if 
				If (False:C215)  //v1.0.3-JJG (03/28/17) - field marked not used (old subtable); never hits
					//If ($leaf)
					//BEEP
					//ALERT($cpn+" had leaf, you must enter it manually.")
					//End if 
				End if 
			End if 
			
		End if   //ok
		
	Else 
		BEEP:C151
		ALERT:C41("Can't change while status = 'Final'")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Must be a Planner to change.")
End if 
//

//