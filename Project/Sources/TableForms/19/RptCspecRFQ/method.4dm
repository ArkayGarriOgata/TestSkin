Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		t11:=String:C10([Finished_Goods:26]Width_Dec:10; "###0.0###")+" * "+String:C10([Finished_Goods:26]Depth_Dec:11; "###0.0###")+" * "+String:C10([Finished_Goods:26]Height_Dec:12; "###0.0###")
		t12:=[Estimates_Carton_Specs:19]OrderType:8+"  "+[Estimates_Carton_Specs:19]OriginalOrRepeat:9+"  "+(Num:C11([Estimates_Carton_Specs:19]SamplesSupplied:10)*"Sample supplied   ")
		t12:=t12+fGetLeafText
		If ([Estimates_Carton_Specs:19]WindowMatl:35#"")
			t12:=t12+String:C10([Estimates_Carton_Specs:19]WindowGauge:36)+" "+[Estimates_Carton_Specs:19]WindowMatl:35+" Window "+String:C10([Estimates_Carton_Specs:19]WindowWth:37)+" Wide "+String:C10([Estimates_Carton_Specs:19]WindowHth:38)+" High.  "
		End if 
		t12:=t12+"Glue: "+[Estimates_Carton_Specs:19]GlueType:41+(" Inspected "*Num:C11([Estimates_Carton_Specs:19]GlueInspect:42))+(" Imaje "*Num:C11([Estimates_Carton_Specs:19]SecurityLabels:43))+(" UPC "*Num:C11([Estimates_Carton_Specs:19]UPC:44))
		t12:=t12+(" Strip Holes "*Num:C11([Estimates_Carton_Specs:19]StripHoles:46))
		If ([Estimates_Carton_Specs:19]CartonComment:12#"")
			t12:=t12+Char:C90(13)+[Estimates_Carton_Specs:19]CartonComment:12
		End if 
End case 