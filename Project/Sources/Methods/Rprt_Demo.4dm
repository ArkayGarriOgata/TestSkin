//%attributes = {}
//Method:  Rprt_Demo
//Description:  This method will demo a report with a custom dialog

If (True:C214)  //Initialize
	
End if   //Done initialize

Rprt_Dialog_Demo

//Fill in "ViewProArea"

VP SET TEXT VALUE(\
VP Cell("ViewProArea"; 2; 2); \
"Hello Report "+String:C10(Current time:C178()))


