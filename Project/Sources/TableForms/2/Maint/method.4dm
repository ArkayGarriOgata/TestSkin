<>iLayout:=201  //(LP) [ADMINISTRATOR]AdminMaint
//• 3/24/98 cs added update to ◊SerialPrn
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Records in table:C83([z_administrators:2])=1) & ([z_administrators:2]Administrator:1="")  //New
			BEEP:C151
			ALERT:C41("Only one ADMINISTRATOR file record is permitted!")
			CANCEL:C270
		Else 
			If ([z_administrators:2]AppVersion:3="")
				[z_administrators:2]AppVersion:3:=<>sVERSION
				[z_administrators:2]LastUpdate:4:=<>dLASTUPDATE
			End if 
		End if 
		OBJECT SET ENABLED:C1123(hdRec; False:C215)
		
		//: (After)
		//◊fRestrictCO:=[z_administrators]RestrictCO
		//◊fRestrictCR:=[z_administrators]RestrictCR
		//◊fRestrictJO:=[z_administrators]RestrictJO
		//◊fRestrictPO:=[z_administrators]RestrictPO
		//◊fRestrictRM:=[z_administrators]RestrictRM
		//◊SubformCalc:=[z_administrators]SubformCalcs  `3/20/95 upr 66
		//◊SerialPrn:=[z_administrators]SerialPrinting  `•041096  mBohince
		//◊fRestrictFG:=(True)
		//◊UseActCost:=[z_administrators]UseActualCost  `•072998  MLB
		//◊NewAlloccat:=[z_administrators]FixVarAllocatio  `•072998  MLB  UPR 1966
		//◊UseNRV:=[z_administrators]NetRealizaValue  `•111398  MLB  htk request
End case 
//EOLP