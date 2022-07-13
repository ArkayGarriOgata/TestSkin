Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		
		
		
	: (Form event code:C388=On Load:K2:1)
		numObsolete:=0
		OBJECT SET ENABLED:C1123(bOlder; False:C215)
		OBJECT SET ENABLED:C1123(bNewer; False:C215)
		CREATE EMPTY SET:C140([Finished_Goods_DeliveryForcasts:145]; "by_cpn")
		
	: (Form event code:C388=On Close Box:K2:21)
		CLEAR SET:C117("by_cpn")
		bDone:=1
		CANCEL:C270
End case 

