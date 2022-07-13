//%attributes = {"publishedWeb":true}
//CUST_ValidateNameEntry formerly known as (p) uCustNameChk
//1/12/95  upr 1392
//upr 1404 1/19/94
//• 10/7/97 cs found the '◊oldame was not getting an assignment when needed,
// and curent selection of customer is lost
//• 10/10/97 cs fixed a fuckup with new customer
C_LONGINT:C283($ID)
txt_CapNstrip(->[Customers:16]Name:2)

If ([Customers:16]Name:2#"")
	
	If (Record number:C243([Customers:16])#-3)  //• 10/10/97 cs below line of code fucked up if this is a new record
		CREATE SET:C116([Customers:16]; "Hold")  //• 10/7/97 cs 
	End if 
	
	If (Not:C34(CUST_FindSimilarNames([Customers:16]Name:2)))  //passes back false for dup
		POST KEY:C465(46; 256)  //post a cancel
	End if 
	
	If (sFile="CUSTOMER")
		
		If ([Customers:16]Name:2#Old:C35([Customers:16]Name:2)) | (cbCorrect=1)
			
			If (Record number:C243([Customers:16])#-3)  //upr 1404 1/19/94
				
				If ((Current user:C182="Designer") | (Current user:C182="Admin@") | (User in group:C338(Current user:C182; "AccountManager")))  //1/12/95  upr 1392
					<>lProcess:=Current process:C322
					C_TEXT:C284(<>Cust)  //1/12/95  upr 1392
					C_TEXT:C284(<>Name)  //1/12/95  upr 1392
					SAVE RECORD:C53([Customers:16])
					<>Cust:=[Customers:16]ID:1
					<>Name:=[Customers:16]Name:2
					<>OldName:=Old:C35([Customers:16]Name:2)  //• 10/7/97 cs 
					$ID:=New process:C317("CUST_ApplyNameChange"; <>lMinMemPart)
					If (False:C215)
						CUST_ApplyNameChange
					End if 
					
				Else 
					BEEP:C151
					ALERT:C41("Must be Administrator or AccountManager group to change the name.")
					[Customers:16]Name:2:=Old:C35([Customers:16]Name:2)
				End if   //secureity
				
			End if   //not new record
			
		End if   //name change
		
	End if   //via cust
	
	If (Record number:C243([Customers:16])#-3)  //• 10/10/97 cs 
		USE SET:C118("Hold")  //• 10/7/97 cs 
		CLEAR SET:C117("Hold")
	End if 
	
	If (Length:C16([Customers:16]DynamicsPrefix:20)=0) | ([Customers:16]DynamicsPrefix:20="_____")  //•052799  mlb  UPR 236
		[Customers:16]DynamicsPrefix:20:=Invoice_CustomerMapping
		[Customers:16]ModFlag:37:=True:C214
	End if 
	
Else 
	ALERT:C41("Customer MUST have a name.")
End if 


If (Length:C16([Customers:16]Name:2)>0)
	If (Length:C16([Customers:16]ShortName:57)=0)
		[Customers:16]ShortName:57:=[Customers:16]Name:2
	End if 
End if 
//