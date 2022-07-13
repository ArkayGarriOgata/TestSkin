//(s) T1 (Company Name on report)
//•1/14/97 -cs- added code for exception
Case of 
	: ([Raw_Materials_Transactions:23]viaLocation:11="Roanoke")
		Self:C308->:=[Raw_Materials_Transactions:23]viaLocation:11
		
	: ([Raw_Materials_Transactions:23]viaLocation:11="Hauppauge")  //• mlb - 4/8/03  16:57
		Self:C308->:=[Raw_Materials_Transactions:23]viaLocation:11
		
	: ([Raw_Materials_Transactions:23]viaLocation:11="Arkay")
		Self:C308->:="Hauppauge"
		
	: ([Raw_Materials_Transactions:23]viaLocation:11="Vista WH")  //• mlb - 4/8/03  16:57
		Self:C308->:=[Raw_Materials_Transactions:23]viaLocation:11
		
	Else 
		Self:C308->:="Unknown"  //• mlb - 4/8/03  16:57
		
		//: ([RM_XFER]CompanyID="1") & (Level=2)
		//Self->:="Hauppauge"
		//: ([RM_XFER]CompanyID="2") & (Level=2)
		//Self->:="Roanoke"
		//: ([RM_XFER]CompanyID="3") & (Level=2)
		//Self->:="Co ID 3"
		//: (Level=2)  `•1/14/97 this should not happen but just in case
		//Self->:=""
End case 