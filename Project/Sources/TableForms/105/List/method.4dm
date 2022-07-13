//FM: Output() -> 
//@author mlb - 7/19/01  11:24
//DJC - 5-5-05 - unremmed lastTab line to eliminate syntax error on testing
app_basic_list_form_method
Case of 
	: (Form event code:C388=On Load:K2:1)
		b1:=0
		b2:=0
		b3:=0
		b4:=1
		b5:=0
		b6:=0
		b7:=0
		
		i1:=1
		i2:=1
		lastTab:=1  //previously remmed out put back in - was getting syntax error
		SELECT LIST ITEMS BY POSITION:C381(iJMLTabs; lastTab)
		FORM GOTO PAGE:C247(1)
		
		
		//: (Form event=On Display Detail )
		//JML_setColors 
		//utl_Trace 
End case 