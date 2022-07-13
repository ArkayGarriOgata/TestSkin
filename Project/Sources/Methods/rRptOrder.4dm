//%attributes = {"publishedWeb":true}
//uRptOrder
//•030596  MLB  add param to skip dialogs
//•110498  MLB  print comments
C_LONGINT:C283($1)  //if present, skip dialogs
C_LONGINT:C283($needPixels)
If (Records in selection:C76([Customers_Orders:40])=1)
	If (([Customers_Orders:40]Status:10#"Accepted") & ([Customers_Orders:40]Status:10#"Budgeted") & (Count parameters:C259=0))
		BEEP:C151
		BEEP:C151
		ALERT:C41("This order has not yet been Accepted!")
	End if 
	If (Count parameters:C259=0)
		util_PAGE_SETUP(->[Estimates:17]; "Est.H1")
		PRINT SETTINGS:C106
	End if 
	
	C_LONGINT:C283($numCases; $i; $j; $numReleases)  //select one estimate before calling this proc
	maxPixels:=550  // figure on landscape
	iPage:=1
	pixels:=0
	i1:=0  //form counters
	i2:=0
	i3:=0
	i4:=0
	//----------------------- SET UP MAIN HEADER -----------
	t1:="Order Number: "+String:C10([Customers_Orders:40]OrderNumber:1; "00000")
	t2:="CUSTOMER ORDER"
	t3:=String:C10(Current date:C33; 2)+" "+String:C10(Current time:C178; 2)
	t3a:="Last Update on "+String:C10([Customers_Orders:40]ModDate:9; 1)+" by "+[Customers_Orders:40]ModWho:8
	Print form:C5([Estimates:17]; "Est.H1")
	pixels:=pixels+30
	//----------------------- SET UP ORDER HEADER -----------
	RELATE ONE:C42([Customers_Orders:40]CustID:2)
	
	t4:=[Customers_Orders:40]CustID:2+"  "+"Customer:"+Char:C90(13)+"Line:"+Char:C90(13)+"Sold by:"+Char:C90(13)+"P.O.Number:"
	t5:=[Customers:16]Name:2+Char:C90(13)+[Customers_Orders:40]CustomerLine:22+Char:C90(13)+[Customers_Orders:40]SalesRep:13+Char:C90(13)+[Customers_Orders:40]PONumber:11
	t6:="Quote Nº: "+[Customers_Orders:40]EstimateNo:3+" "+[Customers_Orders:40]CaseScenario:4+" Job Nº: "+String:C10([Customers_Orders:40]JobNo:44; "00000")+"    Entered: "+String:C10([Customers_Orders:40]DateOpened:6; 1)  //fEstOverview ($numCases)  
	t6:=t6+"   Contract Expires: "+String:C10([Customers_Orders:40]ContractExpires:12; 1)+"   Status: "+Uppercase:C13([Customers_Orders:40]Status:10)
	If ([Customers_Orders:40]IsContract:52)
		t6:=t6+" CONTRACT ORDER "+Char:C90(13)
	Else 
		t6:=t6+Char:C90(13)
	End if 
	t6:=t6+"Authorization Nº:   "+[Customers_Orders:40]AuthorizationNo:28+"  by "+[Customers_Orders:40]AuthorizedBy:27+"   Entered by: "+[Customers_Orders:40]EnteredBy:7+" Approved by: "+[Customers_Orders:40]ApprovedBy:14+Char:C90(13)+Char:C90(13)
	t6:=t6+"Terms: "+[Customers_Orders:40]Terms:23+"   Ship via: "+[Customers_Orders:40]ShipVia:24+"   F.O.B.: "+[Customers_Orders:40]FOB:25+Char:C90(13)
	If ([Addresses:30]ID:1#[Customers_Orders:40]defaultBillTo:5)
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_Orders:40]defaultBillTo:5)
	End if 
	If (Records in selection:C76([Addresses:30])=1)
		t6:=t6+"Bill to: "+[Addresses:30]Name:2+"  "+[Addresses:30]Address1:3+" "+[Addresses:30]Address2:4+" "+[Addresses:30]Address3:5+" "+[Addresses:30]City:6+" "+[Addresses:30]State:7+" "+[Addresses:30]Zip:8+" "+[Addresses:30]Country:9+Char:C90(13)
	End if 
	
	If ([Addresses:30]ID:1#[Customers_Orders:40]defaultShipto:40)
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_Orders:40]defaultShipto:40)
	End if 
	If (Records in selection:C76([Addresses:30])=1)
		t6:=t6+"Ship to: "+[Addresses:30]Name:2+"  "+[Addresses:30]Address1:3+" "+[Addresses:30]Address2:4+" "+[Addresses:30]Address3:5+" "+[Addresses:30]City:6+" "+[Addresses:30]State:7+" "+[Addresses:30]Zip:8+" "+[Addresses:30]Country:9+Char:C90(13)
	End if 
	
	t6:=t6+Char:C90(13)+"Contacts: "+[Customers_Orders:40]Contact_Agent:36+"  "+[Customers_Orders:40]z_Contact_Enginee:37+"  "+[Customers_Orders:40]EmailTo:38+Char:C90(13)
	// SEARCH([Addresses];[Addresses]ID=[CustomerOrder]defaultBillTo)
	//t7:=" Bill to:"
	//$summary:=""
	//t8:=$summary+fGetAddressText 
	Print form:C5([Estimates:17]; "Est.H2")
	pixels:=pixels+60
	
	RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)
	CREATE SET:C116([Customers_Order_Lines:41]; "theCartons")
	$numCases:=Records in selection:C76([Customers_Order_Lines:41])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
		FIRST RECORD:C50([Customers_Order_Lines:41])
		
		
	Else 
		
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	Print form:C5([Customers_Order_Lines:41]; "Ord.H3")
	pixels:=pixels+40
	
	
	For ($i; 1; $numCases)  //----------------step through the orderLines file
		//----------------------- SET UP ITEM HEADER -----------  
		rOrderLineDetai  // also updates i1 and i3
		
		RELATE MANY:C262([Customers_Order_Lines:41]OrderLine:3)
		$numReleases:=Records in selection:C76([Customers_ReleaseSchedules:46])
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]CustomerRefer:3; >)
			FIRST RECORD:C50([Customers_ReleaseSchedules:46])
			
			
		Else 
			
			ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]CustomerRefer:3; >)
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		// 
		$needPixels:=(25*$numReleases)+25+22+37
		uChk4Room($needPixels; 70; "Est.H1"; "Ord.H3")
		Print form:C5([Customers_Order_Lines:41]; "Ord.D1")
		pixels:=pixels+37
		//uChk4Room (91;70;"Est.H1";"Ord.H3")
		If ($numReleases>0)
			Print form:C5([Customers_ReleaseSchedules:46]; "RS.H4")
			pixels:=pixels+25
		End if 
		For ($j; 1; $numReleases)
			rRelSchdDetail
			uChk4Room(51; 55; "Est.H1"; "RS.H4")
			Print form:C5([Customers_ReleaseSchedules:46]; "RS.D1")
			pixels:=pixels+25
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])
		End for 
		If ($numReleases>0)
			Print form:C5([Customers_ReleaseSchedules:46]; "RS.T1")
			pixels:=pixels+22
		End if 
		Print form:C5([zz_control:1]; "OneDottedLine")
		pixels:=pixels+1
		uChk4Room(37; 70; "Est.H1"; "Ord.H3")
		NEXT RECORD:C51([Customers_Order_Lines:41])
	End for 
	uChk4Room(23; 70; "Est.H1"; "Ord.H3")
	Print form:C5([Customers_Order_Lines:41]; "Ord.T1")
	pixels:=pixels+23
	
	If (Length:C16([Customers_Orders:40]Comments:15)>0)  //•110498  MLB  
		$Comment:="COMMENTS:   "+[Customers_Orders:40]Comments:15
		Repeat 
			t20:=Substring:C12($Comment; 1; 80)
			uChk4Room(15; 70; "Est.H1")
			Print form:C5([Estimates:17]; "Est.C1")
			pixels:=pixels+15
			$Comment:=Substring:C12($Comment; 81)
		Until (Length:C16($Comment)=0)
	End if 
	
	If (False:C215)
		Print form:C5([Estimates:17]; "Est.T1")
		pixels:=pixels+17
		Print form:C5([Estimates:17]; "Est.C1")  //t20 defined above
		pixels:=pixels+15
		Print form:C5([zz_control:1]; "BlankPix8")  //blank line
		pixels:=pixels+8
		uChk4Room(50; 30; "Est.H1")
		
		//----------------------- PRINT LAST SET OF TOTALS -----------  
	End if   //false
	PAGE BREAK:C6
Else 
	BEEP:C151
	ALERT:C41("Must select '1' Order to run this report.")
End if 
//