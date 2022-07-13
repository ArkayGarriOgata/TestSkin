//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 11:49:48
// ----------------------------------------------------
// Method: trigger_Customers()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		If (Length:C16([Customers:16]ShortName:57)=0)
			[Customers:16]ShortName:57:=[Customers:16]Name:2
		End if 
		
		If (Length:C16([Customers:16]Std_Incoterms:11)=0)
			[Customers:16]Std_Incoterms:11:="EXW"
		End if 
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		If (Length:C16([Customers:16]ShortName:57)=0)
			[Customers:16]ShortName:57:=[Customers:16]Name:2
		End if 
		
		If (Length:C16([Customers:16]Std_Incoterms:11)=0)
			[Customers:16]Std_Incoterms:11:="EXW"
		End if 
End case 