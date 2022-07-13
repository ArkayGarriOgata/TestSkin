//%attributes = {"publishedWeb":true}
//(P)gPresswork
//upr 1136 10/12/94

C_TEXT:C284(sFrontside; sBackside)

sFrontside:=Char:C90(9)+"FRONTSIDE: "
sBackside:=Char:C90(13)+Char:C90(9)+"BACKSIDE: "

If ([Process_Specs:18]ColorsNumGravur:25>0)
	sFrontside:=sFrontside+String:C10([Process_Specs:18]ColorsNumGravur:25)+" Gravure Colors "+String:C10([Process_Specs:18]ColorsCovGravur:26)+"% Coverage, "
End if 
//If ([PROCESS_SPEC]AKcolors>0)
sFrontside:=sFrontside+(Num:C11([Process_Specs:18]AKcover:39)*"Air Knife used, ")
//End if 
If ([Process_Specs:18]ColorsNumLineOS:28>0)
	sFrontside:=sFrontside+String:C10([Process_Specs:18]ColorsNumLineOS:28)+" Line Colors Offset Lithography "+String:C10([Process_Specs:18]ColorsCovLineOS:29)+"% Coverage, "
End if 
If ([Process_Specs:18]ColorsNumProcOS:30>0)
	sFrontside:=sFrontside+String:C10([Process_Specs:18]ColorsNumProcOS:30)+" Process Colors Offset Lithography "+String:C10([Process_Specs:18]ColorsCovProcOS:31)+"% Coverage, "
End if 
If ([Process_Specs:18]ColorsNumScreen:34>0)
	sFrontside:=sFrontside+String:C10([Process_Specs:18]ColorsNumScreen:34)+" Colors Silk Screen "+String:C10([Process_Specs:18]ColorsCovScreen:35)+"% Coverage, "
End if 
If ([Process_Specs:18]Varn1Gloss:32#"")
	sFrontside:=sFrontside+[Process_Specs:18]Varn1Gloss:32+" Varnish "+String:C10([Process_Specs:18]Varn1Coverage:33)+"% Coverage, "
End if 
If ([Process_Specs:18]Varn2Gloss:48#"")
	sFrontside:=sFrontside+[Process_Specs:18]Varn2Gloss:48+" Varnish "+String:C10([Process_Specs:18]Varn2Coverage:49)+"% Coverage, "
End if 
If ([Process_Specs:18]Coat1Type:13#"")
	sFrontside:=sFrontside+[Process_Specs:18]Coat1Type:13+" "+[Process_Specs:18]Coat1Matl:14
	If ([Process_Specs:18]SpotCoat1:73=True:C214)
		sFrontside:=sFrontside+"Spot Coating, "
	Else 
		sFrontside:=sFrontside+" Coating, "
	End if 
End if 
If ([Process_Specs:18]Coat2Type:15#"")
	sFrontside:=sFrontside+[Process_Specs:18]Coat2Type:15+" "+[Process_Specs:18]Coat2Matl:16
	If ([Process_Specs:18]SpotCoat2:74=True:C214)
		sFrontside:=sFrontside+"Spot Coating, "
	Else 
		sFrontside:=sFrontside+" Coating, "
	End if 
End if 
If ([Process_Specs:18]Coat3Type:17#"")
	sFrontside:=sFrontside+[Process_Specs:18]Coat3Type:17+" "+[Process_Specs:18]Coat3Matl:18
	If ([Process_Specs:18]SpotCoat3:75=True:C214)
		sFrontside:=sFrontside+"Spot Coating, "
	Else 
		sFrontside:=sFrontside+" Coating, "
	End if 
End if 

//Backside
If ([Process_Specs:18]iColorGrav:55>0)
	sBackside:=sBackside+String:C10([Process_Specs:18]iColorGrav:55)+" Gravure Colors "+String:C10([Process_Specs:18]iCovGrav:60)+"% Coverage, "
End if 
//If ([PROCESS_SPEC]iAKcolors>0)
sBackside:=sBackside+(Num:C11([Process_Specs:18]iAKcover:36)*"Air Knife used, ")
//End if 
If ([Process_Specs:18]iColorLL:56>0)
	sBackside:=sBackside+String:C10([Process_Specs:18]iColorLL:56)+" Line Colors Offset Lithography "+String:C10([Process_Specs:18]iCovLL:61)+"% Coverage, "
End if 
If ([Process_Specs:18]iColorLP:57>0)
	sBackside:=sBackside+String:C10([Process_Specs:18]iColorLP:57)+" Process Colors Offset Lithography "+String:C10([Process_Specs:18]iCovLP:62)+"% Coverage, "
End if 
If ([Process_Specs:18]iColorsSS:58>0)
	sBackside:=sBackside+String:C10([Process_Specs:18]iColorsSS:58)+" Colors Silk Screen "+String:C10([Process_Specs:18]iCovSS:63)+"% Coverage, "
End if 
If ([Process_Specs:18]iVarn1Gloss:71#"")
	sBackside:=sBackside+[Process_Specs:18]iVarn1Gloss:71+" Varnish "+String:C10([Process_Specs:18]iVarn1Coverage:72)+"% Coverage, "
End if 
If ([Process_Specs:18]Varn2Gloss:48#"")
	sBackside:=sBackside+[Process_Specs:18]iVarn2Gloss:69+" Varnish "+String:C10([Process_Specs:18]iVarn2Coverage:70)+"% Coverage, "
End if 
If ([Process_Specs:18]iCoat1Type:19#"")
	sBackside:=sBackside+[Process_Specs:18]iCoat1Type:19+" "+[Process_Specs:18]iCoat1Matl:20
	If ([Process_Specs:18]iSpotCoat1:65=True:C214)
		sBackside:=sBackside+"Spot Coating, "
	Else 
		sBackside:=sBackside+" Coating, "
	End if 
End if 
If ([Process_Specs:18]iCoat2Type:21#"")
	sBackside:=sBackside+[Process_Specs:18]iCoat2Type:21+" "+[Process_Specs:18]iCoat2Matl:22
	If ([Process_Specs:18]iSpotCoat2:66=True:C214)
		sBackside:=sBackside+"Spot Coating, "
	Else 
		sBackside:=sBackside+" Coating, "
	End if 
End if 
If ([Process_Specs:18]iCoat3Type:23#"")
	sBackside:=sBackside+[Process_Specs:18]iCoat3Type:23+" "+[Process_Specs:18]iCoat3Matl:24
	If ([Process_Specs:18]iSpotCoat3:67=True:C214)
		sBackside:=sBackside+"Spot Coating, "
	Else 
		sBackside:=sBackside+" Coating, "
	End if 
End if 