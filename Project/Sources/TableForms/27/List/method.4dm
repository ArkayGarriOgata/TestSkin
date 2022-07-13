//•5/8/95 chip upr 1519
app_basic_list_form_method
Case of 
		//: ((Before) & (Not(During)))
		//  uHandleMenu (1;"Selection";"COST_CENTER")
	: (In header:C112)  //•5/8/95 start changes
		If (Records in set:C195("CCCurrent")#0)
			OBJECT SET ENABLED:C1123(bRestore; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bRestore; False:C215)
		End if   //•5/8/95 end changes
End case 
//