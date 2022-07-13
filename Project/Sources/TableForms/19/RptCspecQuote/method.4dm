Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		Text1:=[Estimates_Carton_Specs:19]Width:17+" * "+[Estimates_Carton_Specs:19]Depth:18+" * "+[Estimates_Carton_Specs:19]Height:19
		//Text1:=[Finished_Goods]Width+" * "+[Finished_Goods]Depth+" * "+[Finished_Goods]Height
		Text2:=[Estimates_Carton_Specs:19]Description:14+" "+[Estimates_Carton_Specs:19]OrderType:8+"  "+[Estimates_Carton_Specs:19]OriginalOrRepeat:9+"  "+(Num:C11([Estimates_Carton_Specs:19]SamplesSupplied:10)*"Sample supplied   ")
		Text2:=Text2+fGetLeafText
		If ([Estimates_Carton_Specs:19]WindowMatl:35#"")
			Text2:=Text2+String:C10([Estimates_Carton_Specs:19]WindowGauge:36)+" "+[Estimates_Carton_Specs:19]WindowMatl:35+" Window "+String:C10([Estimates_Carton_Specs:19]WindowWth:37)+" Wide "+String:C10([Estimates_Carton_Specs:19]WindowHth:38)+" High.  "
		End if 
		Text2:=Text2+"Glue: "+[Estimates_Carton_Specs:19]GlueType:41+(" Inspected "*Num:C11([Estimates_Carton_Specs:19]GlueInspect:42))+(" Imaje "*Num:C11([Estimates_Carton_Specs:19]SecurityLabels:43))+(" UPC "*Num:C11([Estimates_Carton_Specs:19]UPC:44))
		Text2:=Text2+(" Strip Holes "*Num:C11([Estimates_Carton_Specs:19]StripHoles:46))
		If ([Estimates_Carton_Specs:19]CartonComment:12#"")
			Text2:=Text2+Char:C90(13)+[Estimates_Carton_Specs:19]CartonComment:12
		End if 
End case 