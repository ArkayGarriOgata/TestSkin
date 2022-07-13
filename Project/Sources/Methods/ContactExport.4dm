//%attributes = {"publishedWeb":true}
//(p) ContactExport
//exports contacts for use by NowContacts
//$1 - (optional) string - any - flag to export only new records
//• 7/23/97 cs changes to reflect different interpretation of contact imports
//• 9/3/97 cs changes to match Mel's modifications to the exports

C_LONGINT:C283($j)
C_TEXT:C284(xText; xTitle)
C_BOOLEAN:C305(<>fContinue)  //used to control the loop execution

READ WRITE:C146([Contacts:51])

<>fContinue:=True:C214
uClearSelection(->[Contacts:51])

If (Count parameters:C259=0)  //• 9/3/97 cs changed from 1 -> 0
	uConfirm("Export all NEW Contacts,"+Char:C90(13)+"or"+Char:C90(13)+"Make a selection."; "New"; "Select")  //• 9/3/97 cs 
	
	If (OK=1)  //• 9/3/97 cs 
		QUERY:C277([Contacts:51]; [Contacts:51]Exported:2=False:C215)
	Else 
		QUERY:C277([Contacts:51])  //• 9/3/97 cs 
	End if 
Else 
	ALL RECORDS:C47([Contacts:51])
End if 

If (Records in selection:C76([Contacts:51])>0)
	// ON EVENT CALL("eCancelProc")  `• 9/3/97 cs 
	uThermoInit(Records in selection:C76([Contacts:51]); "Exporting Contacts for 'Now Contacts'")  //• 9/3/97 cs 
	ORDER BY:C49([Contacts:51]; [Contacts:51]LastName:26; >)  //sort s export is in aplha order
	Doc:=Create document:C266("Contacts for week of "+String:C10(4D_Current_date))
	xTitle:="FirstName"+Char:C90(9)+"Mi"+Char:C90(9)+"Last"+Char:C90(9)+"Company"+Char:C90(9)+"Department"+Char:C90(9)+"Title"+Char:C90(9)
	xTitle:=xTitle+"Salut"+Char:C90(9)+"Address"+Char:C90(9)+"Address2"+Char:C90(9)+"City"+Char:C90(9)+"St"+Char:C90(9)+"Zip"+Char:C90(9)+"Country"+Char:C90(9)
	xTitle:=xTitle+"Phone"+Char:C90(9)+"Home"+Char:C90(9)+"Fax"+Char:C90(9)+"Car"+Char:C90(9)+"SalesRep(s)"+Char:C90(9)+"Bday"+Char:C90(9)
	xTitle:=xTitle+"ContactType"+Char:C90(9)+"1st Entry"+Char:C90(9)+"AMS CustID"+Char:C90(9)+"AMS ContactID"+Char:C90(9)+"CustType"+Char:C90(9)
	xTitle:=xTitle+"xMas"+Char:C90(9)+"Notes"+Char:C90(13)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($j; 1; Records in selection:C76([Contacts:51]))  //• 9/3/97 cs entire xtext buildup changed
			xText:=""
			xText:=[Contacts:51]FirstName:27+Char:C90(9)+[Contacts:51]MI:28+Char:C90(9)+[Contacts:51]LastName:26+Char:C90(9)
			xText:=xText+[Contacts:51]Company:3+Char:C90(9)+[Contacts:51]Department:30+Char:C90(9)+[Contacts:51]BusinessFunc:31+Char:C90(9)+[Contacts:51]Salutation:29+Char:C90(9)
			xText:=xText+[Contacts:51]Address2:4+Char:C90(9)+[Contacts:51]Address3:5+Char:C90(9)+[Contacts:51]City:6+Char:C90(9)+[Contacts:51]State:7+Char:C90(9)+[Contacts:51]Zip:8+Char:C90(9)+[Contacts:51]Country:9+Char:C90(9)
			xText:=xText+[Contacts:51]Phone:10+Char:C90(9)+[Contacts:51]Fax:11+Char:C90(9)+[Contacts:51]HomePhone:21+Char:C90(9)+[Contacts:51]CellPhone:25+Char:C90(9)
			
			//insert all sales man ids    
			ARRAY TEXT:C222($SalesPeople; 0)
			RELATE MANY:C262([Contacts:51]ContactID:1)  //get cutcontlink records
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				uRelateSelect(->[Customers:16]ID:1; ->[Customers_Contacts:52]CustID:1; 0)  //get customers for contact
				
				
			Else 
				
				RELATE ONE SELECTION:C349([Customers_Contacts:52]; [Customers:16])
				
			End if   // END 4D Professional Services : January 2019 query selection
			SELECTION TO ARRAY:C260([Customers:16]SalesmanID:3; $SalesPeople)
			FIRST RECORD:C50([Customers:16])
			$Text:=""
			
			For ($k; 1; Size of array:C274($SalesPeople))  //for every customer - check sales person
				If (Position:C15($SalesPeople{$k}; $Text)=0)  //if the sales person is NOT in export for this contact yet, insert
					If ($k#1)  //if this is NOT the first sales person insert ',' as seperator
						$Text:=$Text+", "
					End if 
					$Text:=$Text+$SalesPeople{$k}  //build up sales person text
				End if 
			End for 
			xText:=xText+$Text+Char:C90(9)+String:C10([Contacts:51]BirthDate:36)+Char:C90(9)+[Contacts:51]BusinessFunc:31+Char:C90(9)
			xText:=xText+[Contacts:51]ModWho:20+Char:C90(9)+[Customers:16]ID:1+Char:C90(9)+[Contacts:51]ContactID:1+Char:C90(9)
			xText:=xText+[Contacts:51]ContactType:17+Char:C90(9)
			
			//setup Mail list text
			$Text:=""
			$Text:=$Text+("Xmas,"*Num:C11([Contacts:51]Mailing_XMAS:33))
			$Text:=$Text+("Bday,"*Num:C11([Contacts:51]Mailing_BDay:32))
			$Text:=$Text+("Other"*Num:C11([Contacts:51]Mailing_Other:34))
			xText:=xText+$Text+Char:C90(9)+[Contacts:51]Notes:13+Char:C90(13)
			//`• 9/3/97 cs changes for xtext
			
			If ($j=1)  //• 9/3/97 cs send titles
				SEND PACKET:C103(Doc; xTitle)
			End if 
			SEND PACKET:C103(Doc; xText)
			NEXT RECORD:C51([Contacts:51])
			
			If (Not:C34(<>fContinue))  //• 9/3/97 cs 
				$j:=Records in selection:C76([Contacts:51])+1
				xText:=""
			End if   //• 9/3/97 cs 
			uThermoUpdate($j)
		End for 
		
		
	Else 
		
		SELECTION TO ARRAY:C260([Contacts:51]Address2:4; $_Address2; \
			[Contacts:51]Address3:5; $_Address3; \
			[Contacts:51]FirstName:27; $_FirstName; \
			[Contacts:51]LastName:26; $_LastName; \
			[Contacts:51]MI:28; $_MI; \
			[Contacts:51]Company:3; $_Company; \
			[Contacts:51]Department:30; $_Department; \
			[Contacts:51]BusinessFunc:31; $_BusinessFunc; \
			[Contacts:51]Salutation:29; $_Salutation; \
			[Contacts:51]City:6; $_City; \
			[Contacts:51]Zip:8; $_Zip; \
			[Contacts:51]Country:9; $_Country; \
			[Contacts:51]Phone:10; $_Phone; \
			[Contacts:51]Fax:11; $_Fax; \
			[Contacts:51]HomePhone:21; $_HomePhone; \
			[Contacts:51]CellPhone:25; $_CellPhone; \
			[Contacts:51]ContactID:1; $_ContactID; \
			[Contacts:51]State:7; $_State; \
			[Contacts:51]Zip:8; $_Zip; \
			[Contacts:51]Country:9; $_Country; \
			[Contacts:51]Phone:10; $_Phone; \
			[Contacts:51]Fax:11; $_Fax; \
			[Contacts:51]HomePhone:21; $_HomePhone; \
			[Contacts:51]CellPhone:25; $_CellPhone; \
			[Contacts:51]ContactID:1; $_ContactID; \
			[Contacts:51]BirthDate:36; $_BirthDate; \
			[Contacts:51]BusinessFunc:31; $_BusinessFunc; \
			[Contacts:51]ModWho:20; $_ModWho; \
			[Contacts:51]ContactType:17; $_ContactType; \
			[Contacts:51]Mailing_XMAS:33; $_Mailing_XMAS; \
			[Contacts:51]Mailing_BDay:32; $_Mailing_BDay; \
			[Contacts:51]Mailing_Other:34; $_Mailing_Other; \
			[Contacts:51]Notes:13; $_Notes)
		
		
		For ($j; 1; Size of array:C274($_Address2); 1)  //• 9/3/97 cs entire xtext buildup changed
			xText:=""
			xText:=$_FirstName{$j}+Char:C90(9)+$_MI{$j}+Char:C90(9)+$_LastName{$j}+Char:C90(9)
			xText:=xText+$_Company{$j}+Char:C90(9)+$_Department{$j}+Char:C90(9)+$_BusinessFunc{$j}+Char:C90(9)+$_Salutation{$j}+Char:C90(9)
			xText:=xText+$_Address2{$j}+Char:C90(9)+$_Address3{$j}+Char:C90(9)+$_City{$j}+Char:C90(9)+$_State{$j}+Char:C90(9)+$_Zip{$j}+Char:C90(9)+$_Country{$j}+Char:C90(9)
			xText:=xText+$_Phone{$j}+Char:C90(9)+$_Fax{$j}+Char:C90(9)+$_HomePhone{$j}+Char:C90(9)+$_CellPhone{$j}+Char:C90(9)
			
			//insert all sales man ids    
			ARRAY TEXT:C222($SalesPeople; 0)
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2=$_ContactID{$j})
			RELATE ONE SELECTION:C349([Customers_Contacts:52]; [Customers:16])
			SELECTION TO ARRAY:C260([Customers:16]SalesmanID:3; $SalesPeople)
			FIRST RECORD:C50([Customers:16])
			$Text:=""
			
			For ($k; 1; Size of array:C274($SalesPeople))  //for every customer - check sales person
				If (Position:C15($SalesPeople{$k}; $Text)=0)  //if the sales person is NOT in export for this contact yet, insert
					If ($k#1)  //if this is NOT the first sales person insert ',' as seperator
						$Text:=$Text+", "
					End if 
					$Text:=$Text+$SalesPeople{$k}  //build up sales person text
				End if 
			End for 
			xText:=xText+$Text+Char:C90(9)+String:C10($_BirthDate{$j})+Char:C90(9)+$_BusinessFunc{$j}+Char:C90(9)
			xText:=xText+$_ModWho{$j}+Char:C90(9)+[Customers:16]ID:1+Char:C90(9)+$_ContactID{$j}+Char:C90(9)
			xText:=xText+$_ContactType{$j}+Char:C90(9)
			
			//setup Mail list text
			$Text:=""
			$Text:=$Text+("Xmas,"*Num:C11($_Mailing_XMAS{$j}))
			$Text:=$Text+("Bday,"*Num:C11($_Mailing_BDay{$j}))
			$Text:=$Text+("Other"*Num:C11($_Mailing_Other{$j}))
			xText:=xText+$Text+Char:C90(9)+$_Notes{$j}+Char:C90(13)
			//`• 9/3/97 cs changes for xtext
			
			If ($j=1)  //• 9/3/97 cs send titles
				SEND PACKET:C103(Doc; xTitle)
			End if 
			SEND PACKET:C103(Doc; xText)
			
			If (Not:C34(<>fContinue))  //• 9/3/97 cs 
				$j:=Size of array:C274($_Address2)+1
				xText:=""
			End if   //• 9/3/97 cs 
			uThermoUpdate($j)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	MESSAGES OFF:C175
	
	If (<>fContinue)  //user did not stop execution`• 9/3/97 cs 
		Repeat 
			MESSAGE:C88(Char:C90(13)+"Marking records as exported..."+Char:C90(13))
			APPLY TO SELECTION:C70([Contacts:51]; [Contacts:51]Exported:2:=True:C214)
			
			If (Records in set:C195("LockedSet")>0)
				USE SET:C118("LockedSet")
				MESSAGE:C88(Char:C90(13)+"Waiting for locked records..."+Char:C90(13))
				DELAY PROCESS:C323(Current process:C322; 60)
			End if 
			
			If (Not:C34(<>fContinue))  //user canceled while here`• 9/3/97 cs 
				uConfirm("Stopping the export here will cause Data incongruities."+Char:C90(13)+"Some/All exported records will not be marked as such."+Char:C90(13)+"Stop Export?"; "Continue"; "Stop Exp")
				
				If (OK=0)  //user wants to stop
					CLEAR SET:C117("LockedSet")
				End if 
			End if   //• 9/3/97 cs 
			
		Until (Records in set:C195("LockedSet")=0)
	End if 
	MESSAGES ON:C181
	CLOSE DOCUMENT:C267(Doc)
	uClearSelection(->[Contacts:51])
	ON EVENT CALL:C190("")
End if 
<>fContinue:=True:C214

uWinListCleanup