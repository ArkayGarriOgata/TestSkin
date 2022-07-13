Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Record number:C243([Purchase_Orders_Requisitions:80])=-3)
			[Purchase_Orders_Requisitions:80]id:1:=[Job_Forms_Master_Schedule:67]ProjectNumber:26
		End if 
		
	: (Form event code:C388=On Display Detail:K2:22)
		
		If ([Purchase_Orders_Requisitions:80]requisitioned_by:4=!00-00-00!)
			Core_ObjectSetColor(->[Purchase_Orders_Requisitions:80]requisitioned_by:4; -(12+(256*0)))
		Else 
			Core_ObjectSetColor(->[Purchase_Orders_Requisitions:80]requisitioned_by:4; -(15+(256*0)))
		End if 
		If ([Purchase_Orders_Requisitions:80]date_requisition:5=!00-00-00!)
			Core_ObjectSetColor(->[Purchase_Orders_Requisitions:80]date_requisition:5; -(12+(256*0)))
		Else 
			Core_ObjectSetColor(->[Purchase_Orders_Requisitions:80]date_requisition:5; -(15+(256*0)))
		End if 
End case 
//