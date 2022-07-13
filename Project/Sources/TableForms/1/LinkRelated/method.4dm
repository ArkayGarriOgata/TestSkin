// ----------------------------------------------------
// User name (OS): JML
// Date: 7/6/93
// ----------------------------------------------------
// Form Method: [zz_control].LinkRelated
// Description:
// This is a general interface which allows user to associate records
// from a related file to the current record.  For example, user can
// add new Addresses to the current Customer record using this interface.
// This dialog is called by uLinkRelated() and can be adapted for use by
// many differents files by adding an :(sLinkWhat="...") case to each object.
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	ARRAY TEXT:C222(asTacID; 0)
	ARRAY TEXT:C222(asTacLast; 0)
	ARRAY TEXT:C222(asTacFirst; 0)
	
	sABCTabID:=""
	sABCTabName:=""
	asTacID:=0
	asTacLast:=0
	asTacFirs:=0
	GOTO OBJECT:C206(sABCTABName)
	HIGHLIGHT TEXT:C210(sABCTABName; 1; 20)
	
	Case of 
		: (sLinkWhat="Contact-Vend")
			OBJECT SET ENABLED:C1123(bNewRelRec; False:C215)
			SetObjectProperties(""; ->bSelectRec; True:C214; "Select Vendor")
			SetObjectProperties(""; ->bNewRelRec; True:C214; "New Vendor")
			sCTitle:="Find Vendor Records & Link to Contact"
			sCTitleID:="ID"
			//sCTitleLast:="Name"
			sCTitleFirs:="Type"
			sCLabelName:="Name"
			sCLabelID:="Vend ID"
			scParent:="Contact"
			scChild:="Vendor"
			scArryTitle:=scChild+"s"
			scInstr1:="Using this interface, you can quickly find and associate a "+scChild+" record to the current "+scParent+" record.  "
			scInstr2:="Type first letter(s) of "+sCLabelName+" and press TAB."
			
		: (sLinkWhat="Vend-Contact")
			SetObjectProperties(""; ->bSelectRec; True:C214; "Select Contact")
			SetObjectProperties(""; ->bNewRelRec; True:C214; "New Contact")
			scParent:="Vendor"
			scChild:="Contact"
			scArryTitle:=scChild+"s"
			sCTitle:="Find/Create Contact Records & Link to Vendor"
			sCTitleID:="ID"
			//sCTitleLast:="Last Name"
			sCTitleFirs:="First Name"
			sCLabelName:="Last Name"
			sCLabelID:="Contact ID"
			scInstr1:="Using this interface, you can quickly find and associate a "+scChild+" record to the current "+scParent+" record.  "
			scInstr2:="Type first letter(s) of "+sCLabelName+" and press TAB."
			
		: (sLinkWhat="Contact-Cust")
			OBJECT SET ENABLED:C1123(bNewRelRec; False:C215)
			SetObjectProperties(""; ->bSelectRec; True:C214; "Select Customer")
			SetObjectProperties(""; ->bNewRelRec; True:C214; "New Customer")
			sCTitle:="Find Customer Records & Link to Contact"
			sCTitleID:="ID"
			//sCTitleLast:="Name"
			sCTitleFirs:="SalesmanID"
			sCLabelName:="Name"
			sCLabelID:="Cust ID"
			scParent:="Contact"
			scChild:="Customer"
			scArryTitle:=scChild+"s"
			scInstr1:="Using this interface, you can quickly find and associate a "+scChild+" record to the current "+scParent+" record.  "
			scInstr2:="Type first letter(s) of "+sCLabelName+" and press TAB."
			
		: (sLinkWhat="Cust-Contact")
			SetObjectProperties(""; ->bSelectRec; True:C214; "Select Contact")
			SetObjectProperties(""; ->bNewRelRec; True:C214; "New Contact")
			scParent:="Customer"
			scChild:="Contact"
			scArryTitle:=scChild+"s"
			sCTitle:="Find/Create Contact Records & Link to Customer"
			sCTitleID:="ID"
			//sCTitleLast:="Last Name"
			sCTitleFirs:="First Name"
			sCLabelName:="Last Name"
			sCLabelID:="Contact ID"
			scInstr1:="Using this interface, you can quickly find and associate a "+scChild+" record to the current "+scParent+" record.  "
			scInstr2:="Type first letter(s) of "+sCLabelName+" and press TAB."
			
		: (sLinkWhat="Cust-Address")
			SetObjectProperties(""; ->bSelectRec; True:C214; "Select Address")
			SetObjectProperties(""; ->bNewRelRec; True:C214; "New Address")
			scParent:="Customer"
			scChild:="Address"
			scArryTitle:=scChild+"es"
			sCTitle:="Find/Create Address Records & Link to Customer"
			sCTitleID:="ID"
			//sCTitleLast:="Name"
			sCTitleFirs:="City"
			sCLabelName:="Name"
			sCLabelID:="Address ID"
			scInstr1:="Using this interface, you can quickly find and associate an "+scChild+" record to the current "+scParent+" record.  "
			scInstr2:="Type first letter(s) of "+sCLabelName+" and press TAB."
			
		: (sLinkWhat="Address-Cust")
			OBJECT SET ENABLED:C1123(bNewRelRec; False:C215)
			SetObjectProperties(""; ->bSelectRec; True:C214; "Select Customer")
			SetObjectProperties(""; ->bNewRelRec; True:C214; "New Customer")
			sCTitle:="Find Customer Records & Link to Address"
			sCTitleID:="ID"
			//sCTitleLast:="Name"
			sCTitleFirs:="SalesmanID"
			sCLabelName:="Name"
			sCLabelID:="Cust ID"
			scParent:="Address"
			scChild:="Customer"
			scArryTitle:=scChild+"s"
			scInstr1:="Using this interface, you can quickly find and associate a "+scChild+" record to the current "+scParent+" record.  "
			scInstr2:="Type first letter(s) of "+sCLabelName+" and press TAB."
			
	End case 
	OBJECT SET ENABLED:C1123(bNewRelRec; False:C215)
End if 