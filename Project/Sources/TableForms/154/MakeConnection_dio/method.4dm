// _______
// Method: [edi_Inbox].MakeConnection_dio   ( ) ->
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (9/9/21) clean up the ui

Case of 
	: (Form event code:C388=On Load:K2:1)
		cb1:=1  //get
		cb2:=1  //send
		cb3:=0  //reports
		cb4:=1  //passive
		cb5:=1  //transcript
		com_usePassive:=True:C214
		com_Trace:=True:C214
		com_delay:=0  //80 normally works for sterling
		
		OBJECT SET VISIBLE:C603(*; "advanced@"; False:C215)  // Modified by: Mel Bohince (9/9/21) clean up the ui
		
		QUERY:C277([edi_COM_Account:156]; [edi_COM_Account:156]Disabled:9=False:C215)
		ARRAY TEXT:C222(aPopUp; 0)
		ARRAY INTEGER:C220(aDelay; 0)
		SELECTION TO ARRAY:C260([edi_COM_Account:156]Name:1; aPopUp; [edi_COM_Account:156]DefaultDelay:11; aDelay)
		
		If (Size of array:C274(aPopUp)>0)
			QUERY:C277([edi_COM_Account:156]; [edi_COM_Account:156]useDefault:10=True:C214)
			If (Records in selection:C76([edi_COM_Account:156])=1)  //default found
				$WhichElem:=Find in array:C230(aPopUp; [edi_COM_Account:156]Name:1)
				If ($WhichElem>-1)  //set to default acct
					aPopUp:=$WhichElem
					com_account:=aPopUp{$WhichElem}
					com_delay:=aDelay{$WhichElem}
				End if 
			Else   //no default, just set ot first
				aPopUp:=1
				com_account:=aPopUp{1}
				com_delay:=aDelay{1}
			End if 
			
		Else 
			uConfirm("No edi_COM_Accounts found. Go to Prefs to set."; "OK"; "Cancel")
			If (ok=0)
				CANCEL:C270
			End if 
		End if 
		
	: (Form event code:C388=On Unload:K2:2)
		ARRAY TEXT:C222(aPopUp; 0)
		ARRAY INTEGER:C220(aDelay; 0)
End case 