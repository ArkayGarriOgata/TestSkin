Case of 
	: (Form event code:C388=On Load:K2:1)
		// TRACE
		//make sure the JML is correct
		If ([Job_Forms_Master_Schedule:67]JobForm:4#([Finished_Goods_Color_Submission:78]JobForm:8+"@")) & ([Finished_Goods_Color_Submission:78]JobForm:8#"")
			Case of 
				: (Length:C16([Finished_Goods_Color_Submission:78]JobForm:8)<8)
					QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=([Finished_Goods_Color_Submission:78]JobForm:8+"@"))
				: (Length:C16([Finished_Goods_Color_Submission:78]JobForm:8)=8)
					QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Finished_Goods_Color_Submission:78]JobForm:8)
			End case 
		End if 
		
		If ([Finished_Goods_Color_Submission:78]ProjectNo:1="")
			[Finished_Goods_Color_Submission:78]ProjectNo:1:=[Job_Forms_Master_Schedule:67]ProjectNumber:26
			[Finished_Goods_Color_Submission:78]JobForm:8:=[Job_Forms_Master_Schedule:67]JobForm:4
		End if 
		
End case 