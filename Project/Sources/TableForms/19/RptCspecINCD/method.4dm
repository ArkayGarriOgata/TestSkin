//lp  [carton_spec]rptcspecincd
//modified  -JML   8/12/93
If (Form event code:C388=On Header:K2:17)
	Text2:=fGetAddressText([Estimates:17]z_Bill_To_ID:5)
End if 

If (In break:C113)
	vreal1:=Subtotal:C97([Estimates_Carton_Specs:19]Quantity_Want:27)
	vreal2:=Subtotal:C97([Estimates_Carton_Specs:19]CostWant_Per_M:25)
	vreal3:=Subtotal:C97([Estimates_Carton_Specs:19]PriceWant_Per_M:28)
	
	voreal1:=Subtotal:C97(vRMOHQty)
	voreal2:=Subtotal:C97(vRMOHCost)
	voreal3:=Subtotal:C97([Estimates_Carton_Specs:19]PriceFGOH_M:23)
	
	vyreal3:=Subtotal:C97([Estimates_Carton_Specs:19]PriceYield_PerM:30)
	vyreal2:=Subtotal:C97([Estimates_Carton_Specs:19]CostYield_Per_M:26)
	vyreal1:=Subtotal:C97([Estimates_Carton_Specs:19]Quantity_Yield:29)
	
End if 



If (Form event code:C388=On Display Detail:K2:22)  //process each carton record
	//Find correct FormCarton. There is only one CaseScenarion per Carton_Spec
	//but within that Case Scenerio the Carton can appear on more than one form
	RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)  //get [formcarton] records.
	vFormNumbs:=""
	vNumbUp:=0
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($x; 1; Records in selection:C76([Estimates_FormCartons:48]))
			vFormNumbs:=vFormNumbs+", "+[Estimates_FormCartons:48]DiffFormID:2
			vNumbUp:=vNumbUp+[Estimates_FormCartons:48]NumberUp:4
			NEXT RECORD:C51([Estimates_FormCartons:48])
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_DiffFormID; 0)
		ARRAY LONGINT:C221($_NumberUp; 0)
		
		SELECTION TO ARRAY:C260([Estimates_FormCartons:48]DiffFormID:2; $_DiffFormID; [Estimates_FormCartons:48]NumberUp:4; $_NumberUp)
		
		For ($x; 1; Size of array:C274($_DiffFormID); 1)
			
			vFormNumbs:=vFormNumbs+", "+$_DiffFormID{$x}
			vNumbUp:=vNumbUp+$_NumberUp{$x}
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	If ($X>0)
		vFormNumbs:=Substring:C12(vFormNumbs; 3)  //remove first comma
		
		[Estimates_Carton_Specs:19]Quantity_Yield:29:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)
		
		//calculate Qty OH,   Price of oH, Cost OH
		// sFG_LastCost 
		
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Estimates_Carton_Specs:19]ProductCode:5; *)
		QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]CustID:2=[Estimates_Carton_Specs:19]CustID:6)
		If (Records in selection:C76([Finished_Goods:26])#0)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Estimates_Carton_Specs:19]ProductCode:5; *)  //sFGavailability
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Estimates:17]Cust_ID:2)
			If (Records in selection:C76([Finished_Goods_Locations:35])#0)
				vRMOHQty:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			Else 
				vRMOHQty:=0
			End if 
			[Estimates_Carton_Specs:19]PriceFGOH_M:23:=[Finished_Goods:26]LastPrice:27
			vRMOHCost:=[Finished_Goods:26]LastCost:26
			Text1:=String:C10([Finished_Goods:26]Width_Dec:10; "###0.0###")+" * "+String:C10([Finished_Goods:26]Depth_Dec:11; "###0.0###")+" * "+String:C10([Finished_Goods:26]Height_Dec:12; "###0.0###")
			Text2:=[Finished_Goods:26]CartonDesc:3+" "+[Estimates_Carton_Specs:19]OrderType:8+"  "+[Estimates_Carton_Specs:19]OriginalOrRepeat:9+"  "+(Num:C11([Estimates_Carton_Specs:19]SamplesSupplied:10)*"Sample supplied   ")
		Else 
			[Estimates_Carton_Specs:19]PriceFGOH_M:23:=0
			vRMOHCost:=0
			Text1:="0.0"+" * "+"0.0"+" * "+"0.0"
			Text2:=" "+[Estimates_Carton_Specs:19]OrderType:8+"  "+[Estimates_Carton_Specs:19]OriginalOrRepeat:9+"  "+(Num:C11([Estimates_Carton_Specs:19]SamplesSupplied:10)*"Sample supplied   ")
		End if 
		
		
		Text2:=Text2+fGetLeafText
		If ([Estimates_Carton_Specs:19]WindowMatl:35#"")
			Text2:=Text2+String:C10([Estimates_Carton_Specs:19]WindowGauge:36)+" "+[Estimates_Carton_Specs:19]WindowMatl:35+" Window "+String:C10([Estimates_Carton_Specs:19]WindowWth:37)+" Wide "+String:C10([Estimates_Carton_Specs:19]WindowHth:38)+" High.  "
		End if 
		Text2:=Text2+"Glue: "+[Estimates_Carton_Specs:19]GlueType:41+(" Inspected "*Num:C11([Estimates_Carton_Specs:19]GlueInspect:42))+(" Imaje "*Num:C11([Estimates_Carton_Specs:19]SecurityLabels:43))+(" UPC "*Num:C11([Estimates_Carton_Specs:19]UPC:44))
		Text2:=Text2+(" Strip Holes "*Num:C11([Estimates_Carton_Specs:19]StripHoles:46))
		If ([Estimates_Carton_Specs:19]CartonComment:12#"")
			Text2:=Text2+"  "+[Estimates_Carton_Specs:19]CartonComment:12
		End if 
	End if 
End if 
//