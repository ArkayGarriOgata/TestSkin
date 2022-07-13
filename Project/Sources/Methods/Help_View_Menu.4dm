//%attributes = {}
//Method: Help_View_Menu({oView})
//Description:  This method brings up the Help_View form
//  It will bring up articles related to the active window when called

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oView)
	
	C_LONGINT:C283($nNumberOfParamaters; $nProcessID)
	
	C_POINTER:C301($pCurrentFormTable)
	
	C_TEXT:C284($tCurrentFormName; $tSeperator)
	
	$oView:=New object:C1471()
	
	$nNumberOfParamaters:=Count parameters:C259
	
	If ($nNumberOfParamaters>=1)
		$oView:=$1
	End if 
	
	$tSeperator:=CorektPipe
	
End if   //Done initialize

If ($nNumberOfParamaters=0)  //Prime process
	
	$tCurrentFormName:=Current form name:C1298
	$pCurrentFormTable:=Current form table:C627
	
	Case of   //Form
			
		: ($tCurrentFormName=CorektBlank)  //No form
			
			$oView.tKeyword:="@"
			
		: (Is nil pointer:C315($pCurrentFormTable))  //Project form
			
			$oView.tKeyword:=\
				$tCurrentFormName+$tSeperator+\
				String:C10(FORM Get current page:C276)
			
		Else   //Table form
			
			$oView.tKeyword:=\
				Table name:C256($pCurrentFormTable)+$tSeperator+\
				$tCurrentFormName+$tSeperator+\
				String:C10(FORM Get current page:C276)
			
	End case   //Done form
	
	$nProcessID:=New process:C317(Current method name:C684; 0; Current method name:C684; $oView; *)
	
	SHOW PROCESS:C325($nProcessID)
	
Else   //New process
	
	Help_Dialog_View($oView)
	
End if   //Done prime process