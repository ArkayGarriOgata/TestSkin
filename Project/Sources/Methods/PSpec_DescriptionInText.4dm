//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/12/06, 12:19:18
// ----------------------------------------------------
// Method: PSpec_DescriptionInText
// ----------------------------------------------------

C_TEXT:C284($t; $cr)
C_TEXT:C284($description; $0; sFinish)

$t:=Char:C90(9)
$cr:=Char:C90(13)
$description:="STOCK: "+String:C10(([Process_Specs:18]Caliper:8*1000); "##.# pt. ")+" "+[Process_Specs:18]Stock:7+" "+[Process_Specs:18]VendorOfColorMatchStock:105
If ([Process_Specs:18]formShortGrain:64)
	$description:=$description+" SHORT GRAIN "
End if 

If ([Process_Specs:18]FoilType:9#"")
	$description:=$description+" "+[Process_Specs:18]FoilType:9+" Foil "
End if 
If ([Process_Specs:18]FilmLaminate:11#"")
	$description:=$description+" "+[Process_Specs:18]FilmLaminate:11+" Laminate "
End if 
$description:=$description+$cr
gPresswork
$description:=$description+"PRESSWORK:"+$cr+sFrontside+$cr+sBackside+$cr
sFinish:=""

If ([Process_Specs:18]DieCut:51)
	sFinish:=sFinish+" Die Cut"
End if 

If ([Process_Specs:18]Stripping:52)
	sFinish:=sFinish+", Stripped"
End if 

If ([Process_Specs:18]CriticalRegistr:6)
	sFinish:=sFinish+", Register Critical"
End if 

If ([Process_Specs:18]HandLabor:53)
	sFinish:=sFinish+", Hand Labor"
End if 

If ([Process_Specs:18]Examining:54)
	sFinish:=sFinish+", Examined"
End if 

If ([Process_Specs:18]LeafColor1:44#"")
	sFinish:=sFinish+[Process_Specs:18]LeafColor1:44+" Leaf. "
End if 
If ([Process_Specs:18]LeafColor2:45#"")
	sFinish:=sFinish+[Process_Specs:18]LeafColor2:45+" Leaf. "
End if 
If ([Process_Specs:18]LeafColor3:46#"")
	sFinish:=sFinish+[Process_Specs:18]LeafColor3:46+" Leaf. "
End if 
If ([Process_Specs:18]Embossing:77)
	If ([Process_Specs:18]EmbossOverall:80)
		sFinish:=sFinish+" Overall embossing. "
	Else 
		sFinish:=sFinish+" "+String:C10([Process_Specs:18]EmbossPercent:78)+"% fitted embossing. "
	End if 
End if 
If ([Process_Specs:18]Embossing2:89)
	If ([Process_Specs:18]Emboss2Overall:92)
		sFinish:=sFinish+", Overall embossing inside. "
	Else 
		sFinish:=sFinish+" "+String:C10([Process_Specs:18]Emboss2Percent:90)+"% fitted embossing inside. "
	End if 
End if 

If ([Process_Specs:18]Windowed:50)
	sFinish:=sFinish+", Windowed with "+[Process_Specs:18]WindowMaterial:47
End if 

$description:=$description+$cr+"FINISHING:"+$t+sFinish+$cr
$0:=$description