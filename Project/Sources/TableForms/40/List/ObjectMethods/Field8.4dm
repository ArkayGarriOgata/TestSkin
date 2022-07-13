Case of 
	: ([Customers_Orders:40]Status:10="Closed")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(3+(256*15)); True:C214)  //black
	: ([Customers_Orders:40]Status:10="Opened")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(8+(256*0)); True:C214)  //blue
	: ([Customers_Orders:40]Status:10="CONTRACT")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(3+(256*0)); True:C214)  //blue    
	: ([Customers_Orders:40]Status:10="Accepted")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(8+(256*12)); True:C214)  //green  
	: ([Customers_Orders:40]Status:10="Budgeted")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(9+(256*14)); True:C214)  //dark green
	: ([Customers_Orders:40]Status:10="New")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(6+(256*0)); True:C214)  //dark green  
	: ([Customers_Orders:40]Status:10="Hold@")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(3+(256*1)); True:C214)  //
	: ([Customers_Orders:40]Status:10="Kill@")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(2+(256*15)); True:C214)
	: ([Customers_Orders:40]Status:10="Cancel@")
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(4+(256*15)); True:C214)
	Else 
		Core_ObjectSetColor(->[Customers_Orders:40]Status:10; -(3+(256*0)); True:C214)  //red
End case 