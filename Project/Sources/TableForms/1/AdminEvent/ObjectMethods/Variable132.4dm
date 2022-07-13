//(s) bExclusion (admin event)
uYesNoCancel("You May:"+<>sCr+"'Add' Words to Customer Exclusions"+<>sCr+"'List' Current Customer Exclusions"+<>sCr+"'Exit'"; "Add"; "List"; "Exit \\x11.")

Case of 
	: (OK=1)
		ViewSetter(1; ->[y_Customers_Name_Exclusions:76])
	: (bNo=1)  //list
		ViewSetter(2; ->[y_Customers_Name_Exclusions:76])
End case 
//eos
