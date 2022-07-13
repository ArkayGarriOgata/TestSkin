//%attributes = {"publishedWeb":true}
//(p) gReviewManifest
// Modified by: MelvinBohince (6/8/22) comment out [Customers_Bills_of_Lading];"BOLRevuRpt", v19 no likey

C_TEXT:C284($User)
C_DATE:C307($Yesterday)
C_BOOLEAN:C305($UnAuthorize; $Indirect)
ARRAY TEXT:C222(aCustId; 0)

SET WINDOW TITLE:C213("Locating BOLs…")
READ ONLY:C145([Users:5])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Bills_of_Lading:49])
QUERY:C277([Users:5]; [Users:5]UserName:11=Current user:C182)
$Yesterday:=4D_Current_date-1+(-2*Num:C11(Day number:C114(4D_Current_date)=2))  //2= mondayadjusdt for weekend

If (Records in selection:C76([Users:5])=1)
	$User:=[Users:5]Initials:1
	
	Case of 
		: (User in group:C338(Current user:C182; "SalesReps"))
			QUERY:C277([Customers:16]; [Customers:16]SalesmanID:3=$User)
			$Indirect:=True:C214
		: (User in group:C338(Current user:C182; "SalesCoordinator"))
			QUERY:C277([Customers:16]; [Customers:16]SalesCoord:45=$User)
			$Indirect:=True:C214
		: (User in group:C338(Current user:C182; "FGInventory"))
			uClearSelection(->[Customers:16])
			uConfirm("Do You Want to Review All 'BOLs' for the Past Day,"+" or use the Search Editor to Find Specific Customer(s)?"; "All"; "Search \\x11.")
			
			If (OK=1)  //all for previous day (sat & sun if this is a Mon)
				QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShipDate:20>=$Yesterday; *)
				QUERY:C277([Customers_Bills_of_Lading:49];  & ; [Customers_Bills_of_Lading:49]ShipDate:20<4D_Current_date)
				$Indirect:=False:C215
			Else 
				QUERY:C277([Customers:16])  //give user the search editor
				If (Records in selection:C76([Customers:16])>0)
					$Indirect:=True:C214
				Else 
					ALERT:C41("There were No Customers Found Matching Your Search Criteria.")
					uClearSelection(->[Customers_Bills_of_Lading:49])  //insure that the display part is not executed
					$Indirect:=False:C215
				End if 
			End if 
		Else 
			ALERT:C41("You Do Not Have Authorization to use this Report.")
			uClearSelection(->[Customers:16])
			uClearSelection(->[Customers_Bills_of_Lading:49])
			$UnAuthorize:=True:C214
	End case 
	ORDER BY:C49([Customers:16]; [Customers:16]NetDaysDue:44; >)
	SELECTION TO ARRAY:C260([Customers:16]ID:1; aCustId)
	
	If (Records in selection:C76([Customers:16])>0) & ($Indirect)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Customers_Bills_of_Lading:49]CustID:2; ->[Customers:16]ID:1)
			QUERY SELECTION:C341([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShipDate:20>=$Yesterday; *)
			QUERY SELECTION:C341([Customers_Bills_of_Lading:49];  & ; [Customers_Bills_of_Lading:49]ShipDate:20<4D_Current_date)
			
		Else 
			
			ARRAY TEXT:C222($_Customers_ID; 0)
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Customers_Bills_of_Lading:49])+" file. Please Wait...")
			If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
				
				DISTINCT VALUES:C339([Customers:16]ID:1; $_Customers_ID)
				QUERY WITH ARRAY:C644([Customers_Bills_of_Lading:49]CustID:2; $_Customers_ID)
				
			Else 
				
				RELATE MANY SELECTION:C340([Customers_Bills_of_Lading:49]CustID:2)
				
			End if   // END 4D Professional Services : January 2019 
			QUERY SELECTION:C341([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShipDate:20>=$Yesterday; *)
			QUERY SELECTION:C341([Customers_Bills_of_Lading:49];  & ; [Customers_Bills_of_Lading:49]ShipDate:20<4D_Current_date)
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if 
	
	If (Not:C34($UnAuthorize))
		If (Records in selection:C76([Customers_Bills_of_Lading:49])>0)
			uConfirm("Do You Want to Review the Selected BOLs on the Screen or as a Print Out?"; "Print"; "Screen \\x11.")
			
			If (OK=1)
				gPrntBOLRevuRpt
			Else 
				CLOSE WINDOW:C154
				
				$winRef:=NewWindow(600; 300; 6; 8; "")
				SET WINDOW TITLE:C213("Review BOLs : "+String:C10(Records in selection:C76([Customers_Bills_of_Lading:49]))+" of "+String:C10(Records in table:C83([Customers_Bills_of_Lading:49])))
				//FORM SET OUTPUT([Customers_Bills_of_Lading];"RevueBOLList")
				MODIFY SELECTION:C204([Customers_Bills_of_Lading:49])
				FORM SET OUTPUT:C54([Customers_Bills_of_Lading:49]; "List")
				CLOSE WINDOW:C154($winRef)
			End if 
		Else 
			ALERT:C41("There Were No Shipments for Customers between "+String:C10($Yesterday-1)+" and "+String:C10($Yesterday))
		End if 
	End if 
End if 