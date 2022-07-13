Case of 
	: (Form event code:C388=On Data Change:K2:15)
		GOTO RECORD:C242([To_Do_Tasks:100]; aRecNum{ListBox1})
		ToDo_collection("store"; ListBox1)
		
	: (Form event code:C388=On Double Clicked:K2:5)
		ToDo_openRecord(ListBox1)
		
End case 
