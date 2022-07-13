app_basic_list_form_method
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		RELATE ONE:C42([Job_Forms:42]JobNo:2)
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms:42]JobFormID:5)
		// Modified by: Mel Bohince (1/15/20) these jml fields below were added
		If ([Job_Forms_Master_Schedule:67]MAD:21=!00-00-00!)
			Core_ObjectSetColor("*"; "HRD"; -(0+(256*0)); True:C214)  //blak  
		Else 
			Core_ObjectSetColor("*"; "HRD"; -(15+(256*0)); True:C214)  //WHITE  
		End if 
		
		If ([Job_Forms_Master_Schedule:67]GateWayDeadLine:42=!00-00-00!)
			Core_ObjectSetColor("*"; "closing"; -(0+(256*0)); True:C214)  //blak  
		Else 
			Core_ObjectSetColor("*"; "closing"; -(15+(256*0)); True:C214)  //WHITE  
		End if 
		
		If ([Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!)
			Core_ObjectSetColor("*"; "met"; -(0+(256*0)); True:C214)  //blak  
		Else 
			Core_ObjectSetColor("*"; "met"; -(15+(256*0)); True:C214)  //WHITE  
		End if 
		
		If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
			Core_ObjectSetColor("*"; "stkrcd"; -(0+(256*0)); True:C214)  //blak  
		Else 
			Core_ObjectSetColor("*"; "stkrcd"; -(15+(256*0)); True:C214)  //WHITE  
		End if 
		
		If ([Job_Forms_Master_Schedule:67]DateStockSheeted:47=!00-00-00!)
			Core_ObjectSetColor("*"; "sheeted"; -(0+(256*0)); True:C214)  //blak  
		Else 
			Core_ObjectSetColor("*"; "sheeted"; -(15+(256*0)); True:C214)  //WHITE  
		End if 
		
		If ([Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
			Core_ObjectSetColor("*"; "printed"; -(0+(256*0)); True:C214)  //blak  
		Else 
			Core_ObjectSetColor("*"; "printed"; -(15+(256*0)); True:C214)  //WHITE  
		End if 
		
		If ([Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!)
			Core_ObjectSetColor("*"; "blanked"; -(0+(256*0)); True:C214)  //blak  
		Else 
			Core_ObjectSetColor("*"; "blanked"; -(15+(256*0)); True:C214)  //WHITE  
		End if 
		
		
End case 