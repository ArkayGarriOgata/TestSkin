//%attributes = {}
//Method:  Help_Entr_Path
//Description:  This method will open document path with Help_View

If (True:C214)  //Intialize
	
	C_OBJECT:C1216($oView)
	
	$oView:=New object:C1471()
	
	$oView.tHelp_Key:=Form:C1466.tHelp_Key
	
End if   //Done initialize

Case of 
		
	: (Not:C34(OB Is defined:C1231(Form:C1466; "viewProcess")) & Not:C34(OB Is defined:C1231(Form:C1466; "Help_Key")))
		
		Help_Dialog_View($oView)
		
	: (Form:C1466.viewProcess=0)
		
		Help_Dialog_View($oView)
		
	Else 
		
		SHOW PROCESS:C325(Form:C1466.viewProcess)
		BRING TO FRONT:C326(Form:C1466.viewProcess)
		
End case 