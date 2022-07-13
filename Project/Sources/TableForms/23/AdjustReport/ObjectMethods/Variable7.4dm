//(s) T1 (Company Name on report)
//•1/14/97 -cs- added code for exception
Case of 
	: ([Raw_Materials_Transactions:23]CompanyID:20="1") & (Level:C101=2)
		Self:C308->:="Hauppauge"
	: ([Raw_Materials_Transactions:23]CompanyID:20="2") & (Level:C101=2)
		Self:C308->:="Roanoke"
	: ([Raw_Materials_Transactions:23]CompanyID:20="3") & (Level:C101=2)
		Self:C308->:="Label"
	: (Level:C101=2)  //•1/14/97 this should not happen but just in case
		Self:C308->:=""
End case 