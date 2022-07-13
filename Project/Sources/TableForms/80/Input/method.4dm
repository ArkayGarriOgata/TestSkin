//Layout Proc.: Input()  021898  MLB
Case of 
	: (Form event code:C388=On Load:K2:1)
		If ([Job_Forms_Master_Schedule:67]JobForm:4#[Purchase_Orders_Requisitions:80]JobForm:7) & ([Purchase_Orders_Requisitions:80]JobForm:7#"")
			Case of 
				: (Length:C16([Finished_Goods_Color_Submission:78]JobForm:8)<8)
					QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=([Finished_Goods_Color_Submission:78]JobForm:8+"@"))
				: (Length:C16([Finished_Goods_Color_Submission:78]JobForm:8)=8)
					QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Finished_Goods_Color_Submission:78]JobForm:8)
			End case 
		End if 
		
		If ([Purchase_Orders_Requisitions:80]id:1="")
			[Purchase_Orders_Requisitions:80]id:1:=[Job_Forms_Master_Schedule:67]ProjectNumber:26
			//If (Length([JobMasterLog]Job_Number)=8) & (Substring([JobMasterLog
			//«]Job_Number;7;2)#"**")
			[Purchase_Orders_Requisitions:80]JobForm:7:=[Job_Forms_Master_Schedule:67]JobForm:4
			//End if 
		End if 
End case 
//