//%attributes = {"publishedWeb":true}
//(P) gPrintB_C
//-------------------------------------------
//• 12/15/97 cs added optional parameter to allow printing of new JCO header

C_TEXT:C284($1; $Param)

zwStatusMsg("Close Out"; "    printing machines"+Char:C90(13))

If (Count parameters:C259=0)
	$Param:=""
Else 
	$Param:=$1
End if 
fBold:=False:C215
aSubTitle:="M  A  C  H  I  N  E   ( m a k e  r e a d y )"
If (cbPrint=1)  //printing a form
	gChkPixel($Param)
	Print form:C5([Job_Forms:42]; "CloseoutRept_H2")
End if 
//-------------------------------------------
fBold:=False:C215
For ($i; 1; Size of array:C274(ayB1))
	aSubTitle:=ayB1{$i}
	rD2:=ayB2{$i}
	rD3:=ayB3{$i}
	rD4:=ayB4{$i}
	rD5:=ayB5{$i}
	rD6:=ayB6{$i}
	rD7:=ayB7{$i}
	If (cbPrint=1)  //printing a form
		gChkPixel($Param)
		Print form:C5([Job_Forms:42]; "CloseoutRept_D")
	End if 
End for 
fBold:=True:C214
aSubTitle:=ayD1{2}
rD2:=ayD2{2}
rD3:=ayD3{2}
rD4:=ayD4{2}
rD5:=ayD5{2}
rD6:=ayD6{2}
rD7:=ayD7{2}
If (cbPrint=1)  //printing a form
	gChkPixel($Param)
End if 
//PRINT LAYOUT([JOB];"CloseoutRept_D")
rOV:=rD3-rD2
rSV:=rD7-rOV
If (cbPrint=1)  //printing a form
	Print form:C5([Job_Forms:42]; "CloseoutRept_MV")
	iPixel:=iPixel+27
End if 
//-------------------------------------------
aSubTitle:="M  A  C  H  I  N  E   ( r u n )"
If (cbPrint=1)  //printing a form
	gChkPixel($Param)
	Print form:C5([Job_Forms:42]; "CloseoutRept_H2")
End if 
//-------------------------------------------
fBold:=False:C215
For ($i; 1; Size of array:C274(ayC1))
	aSubTitle:=ayC1{$i}
	rD2:=ayC2{$i}
	rD3:=ayC3{$i}
	rD4:=ayC4{$i}
	rD5:=ayC5{$i}
	rD6:=ayC6{$i}
	rD7:=ayC7{$i}
	If (cbPrint=1)  //printing a form
		gChkPixel($Param)
		Print form:C5([Job_Forms:42]; "CloseoutRept_D")
	End if 
End for 
fBold:=True:C214
aSubTitle:=ayD1{3}
rD2:=ayD2{3}
rD3:=ayD3{3}
rD4:=ayD4{3}
rD5:=ayD5{3}
rD6:=ayD6{3}
rD7:=ayD7{3}
If (cbPrint=1)  //printing a form
	gChkPixel($Param)
	Print form:C5([Job_Forms:42]; "CloseoutRept_D")
End if 
//-------------------------------------------
aSubTitle:="T  O  T  A  L  S"
If (cbPrint=1)  //printing a form
	gChkPixel($Param)
	Print form:C5([Job_Forms:42]; "CloseoutRept_H2")
End if 