//%attributes = {"publishedWeb":true}
//PM:  Est_FormDimensionCheck  9/14/99  MLB
//formerly `fCalcDimCheck ()-JML   8/4/93
//used by the fCalc.,...() procedures to verify that incoming sheets can be used
//on current cost center.

C_BOOLEAN:C305($0)

If (<>fContinue)
	Case of   //equip specs
		: (Position:C15([Cost_Centers:27]ID:1; <>GLUERS)>0)  //no dimension check
			
		: (([Cost_Centers:27]minWidth:26=0) & ([Cost_Centers:27]maxWidth:28=0) & ([Cost_Centers:27]minLength:27=0) & ([Cost_Centers:27]maxLength:29=0))
			
		: (([Estimates_DifferentialsForms:47]Width:5<[Cost_Centers:27]minWidth:26) | ([Estimates_DifferentialsForms:47]Width:5>[Cost_Centers:27]maxWidth:28))
			BEEP:C151
			ALERT:C41([Cost_Centers:27]ID:1+" Sheet width must be between "+String:C10([Cost_Centers:27]minWidth:26)+" and "+String:C10([Cost_Centers:27]maxWidth:28)+" inches.")
			<>fContinue:=True:C214
			tCalculationLog:=tCalculationLog+[Cost_Centers:27]ID:1+"WARNING Sheet width must be between "+String:C10([Cost_Centers:27]minWidth:26)+" and "+String:C10([Cost_Centers:27]maxWidth:28)+" inches."+Char:C90(13)
			estCalcError:=False:C215
			
		: (([Estimates_DifferentialsForms:47]Lenth:6<[Cost_Centers:27]minLength:27) | ([Estimates_DifferentialsForms:47]Lenth:6>[Cost_Centers:27]maxLength:29))
			BEEP:C151
			ALERT:C41([Cost_Centers:27]ID:1+" WARNING Sheet width must be between "+String:C10([Cost_Centers:27]minLength:27)+" and "+String:C10([Cost_Centers:27]maxLength:29)+" inches.")
			<>fContinue:=True:C214
			tCalculationLog:=tCalculationLog+"WARNING Sheet width must be between "+String:C10([Cost_Centers:27]minLength:27)+" and "+String:C10([Cost_Centers:27]maxLength:29)+" inches."+Char:C90(13)
			estCalcError:=False:C215
	End case 
End if 

$0:=<>fContinue