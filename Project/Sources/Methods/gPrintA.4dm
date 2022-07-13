//%attributes = {"publishedWeb":true}
//(P) gPrintA
//-------------------------------------------
//• 12/15/97 cs added optional parameter to allow printing of new JCO header

C_TEXT:C284($1; $Param)

zwStatusMsg("Close Out"; "    printing materials"+Char:C90(13))

If (Count parameters:C259=0)
	$Param:=""
Else 
	$Param:=$1
End if 
fBold:=False:C215
rD8:=0

For ($i; 1; Size of array:C274(ayA1))  //print detail lines for materials
	aSubTitle:=ayA1{$i}
	rD2:=ayA2{$i}
	rD3:=ayA3{$i}
	rD4:=ayA4{$i}
	rD5:=ayA5{$i}
	rD6:=ayA6{$i}
	rD7:=ayA7{$i}
	If (cbPrint=1)  //printing a form
		gChkPixel($Param)
		If (Position:C15("Board"; aSubTitle)=0)
			Print form:C5([Job_Forms:42]; "CloseoutRept_D")
		Else 
			Print form:C5([Job_Forms:42]; "CloseOutRept_D2")
		End if 
	End if 
End for 

fBold:=True:C214  //print total line for materials
aSubTitle:=ayD1{1}
rD2:=ayD2{1}
rD3:=ayD3{1}
rD4:=ayD4{1}
rD5:=ayD5{1}
rD6:=ayD6{1}
rD7:=ayD7{1}
rD8:=rD8_D1
If (cbPrint=1)  //printing a form
	gChkPixel($Param)
	Print form:C5([Job_Forms:42]; "CloseoutRept_D")
End if 
rD8:=0