//%attributes = {"publishedWeb":true}
//(P) gPrintD_E
//• 12/15/97 cs added optional parameter to allow printing of new JCO header
//• 4/13/98 cs added new line to end of report 'conversion factor'
//• 8/6/98 cs add percentage of materials to this report - Howard

C_TEXT:C284($1; $Param)
C_REAL:C285($TotManCost)  //• 8/6/98 cs 

zwStatusMsg("Close Out"; "    printing totals"+Char:C90(13))

If (Count parameters:C259=0)
	$Param:=""
Else 
	$Param:=$1
End if 
fBold:=False:C215

For ($i; 4; 10)
	aSubTitle:=ayD1{$i}
	rD2:=ayD2{$i}
	rD3:=ayD3{$i}
	rD4:=ayD4{$i}
	rD5:=ayD5{$i}
	rD6:=ayD6{$i}
	rD7:=ayD7{$i}
	If (cbPrint=1)  //printing a form
		gChkPixel($Param)
	End if 
	zzi:=$i
	
	If (($i=7) | ($i=8) | ($i=9) | ($i=10))  //direct cost, contrib., contrib. factor
		rD5:=ayD2{$i}
	End if 
	
	If (($i=8) | ($i=9) | ($i=10))  //sales rev, contrib., contrib. factor
		rD9:=ayD5{$i}
	End if 
	
	If (($i=6) | ($i=8) | ($i=10))
		fBold:=False:C215
	Else   //total conv, total mfg, or contribution
		fBold:=True:C214
	End if 
	
	//------------------------------------------
	Case of 
		: ($i=4)  //total conv.
			rD8:=rD8_D4
			$TotLabCost:=rD6  //• 8/6/98 cs 
		: ($i=5)  //total mfg
			rD8:=rD8_D5
			$TotManCost:=rD6  //• 8/6/98 cs 
		Else 
			rD8:=0
	End case 
	
	If ($i=6)  //outsid comm/other
		If (cbPrint=1)  //printing a form
			Print form:C5([Job_Forms:42]; "CloseOutRept_LN")
			iPixel:=iPixel+3
		End if 
	End if 
	
	Case of 
		: ($i=7)  //direct cost
			sBudget:="Budget"
			If (cbPrint=1)  //printing a form
				Print form:C5([Job_Forms:42]; "CloseoutRept_BT")
			End if 
		: (($i=6) | ($i=8) | ($i=9) | ($i=10))
			If (cbPrint=1)  //printing a form
				Print form:C5([Job_Forms:42]; "CloseOutRept_LT")
			End if 
			
			If ($i=10)  //• 4/13/98 cs Fred wanted a Contribution factor this is the code
				If (cbPrint=1)  //printing a form
					gChkPixel($Param)  //
				End if 
				aSubTitle:="Conversion Factor"
				rD2:=0
				rD3:=0
				rD4:=uNANCheck(Round:C94(ayD4{9}/ayD4{4}; 2))  //total mfg - materials (Adj by Prod) PV
				rD5:=0
				rD9:=uNANCheck(Round:C94(ayD5{9}/ayD2{4}; 2))  //total mfg - materials (budget) PV
				rD6:=uNANCheck(Round:C94(ayD6{9}/ayD6{4}; 2))  //total mfg - materials (Actual) PV
				If (cbPrint=1)  //printing a form
					Print form:C5([Job_Forms:42]; "CloseOutRept_LT")
					//* Howard wants to see a % of materials `• 8/6/98 cs 
					gChkPixel($Param)
				End if 
				aSubTitle:="Percentage of Materials"
				rD2:=0
				rD3:=0
				rD4:=$TotManCost-$TotLabCost  //total  materials 
				rD5:=0
				rD9:=$TotManCost  //total mfg - costs 
				rD6:=uNANCheck(Round:C94((rD4/ayD5{8})*100; 2))  //% - materials 
				If (cbPrint=1)  //printing a form
					Print form:C5([Job_Forms:42]; "CloseOutRept_MT")  //• 8/6/98 cs end
				End if 
			End if 
		Else 
			If (cbPrint=1)  //printing a form
				Print form:C5([Job_Forms:42]; "CloseoutRept_D")
			End if 
	End case 
	
End for 
//-------------------------------------------
iPixel:=777
fHdgChg:=True:C214
//For ($i;1;24)
aSubTitle:=ayE1{$i}
rD6:=ayE2{$i}
iPixel:=iPixel+15

If (iPixel>700) & (False:C215)  //mlb skip second page
	If (cbPrint=1)  //printing a form
		iPixel:=185
		iPage:=iPage+1
		
		PAGE BREAK:C6(>)
	End if 
	zwStatusMsg("Close Out"; "    printing waste summary"+Char:C90(13))
	If (fHdgChg)
		//util_PAGE_SETUP(->[JobForm];"CloseoutReptW_H")`••• bad things happen on line in v6!!!!
		If (cbPrint=1)  //printing a form
			Print form:C5([Job_Forms:42]; "CloseoutReptW_H")
		End if 
	Else 
		If (cbPrint=1)  //printing a form
			Print form:C5([Job_Forms:42]; "CloseoutRept_H3")
		End if 
	End if 
End if 
zzi:=$i