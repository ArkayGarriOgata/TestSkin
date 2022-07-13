//%attributes = {"publishedWeb":true}
//(p) mRptRmOhCost2
//$1 - string - Commkey to look for
//• 4/18/97 cs rewritten
//this should be faster, and is simpler to work with
//• 4/18/97 cs upr 1856, install an interface to allow comm & Div selection
//• 7/8/97 cs fixed an obvious typo - caused string truncation error
//• cs 1/14/98 fixed incorrect occurance on Alert for no items found
//• 6/1/98 cs changed call from MES so that it is possible to print report
//   with any desired commkey (including all)
//• 7/2/98 cs fixed problem with no company report header
//• 8/24/98 cs this situation left sCommkey empty

C_LONGINT:C283($i; $Division)  //2/28/95 for use in the month end suite
C_TEXT:C284($Title; $Company)  //title for repor2
C_TEXT:C284(sCmpnyPrnt; $1)  //•1/27/97 replaced local variable with process var for report search

If (Count parameters:C259=1)  //called from month end suite
	$CommKey:=$1
	
	If (Character code:C91($1)#(Character code:C91("@")))
		$CommKey:=$CommKey+"@"
		$Title:="Stock On Hand - Commodity "+$1
	Else 
		$Title:="Stock On Hand - All Materials"
	End if 
	
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Commodity_Key:12=$CommKey)  //locate desired commkey
	OK:=1
	util_PAGE_SETUP(->[Raw_Materials:21]; "OnHandAndCost")
	FORM SET OUTPUT:C54([Raw_Materials:21]; "OnHandAndCost")
	$Division:=3  //Number of divisions to Print  
	rbArkay:=1
	rbRoanoke:=1
	rbLabel:=1
Else   //called from report popup menu (PI palette or RM Palette)
	uClearSelection(->[Raw_Materials_Locations:25])
	FilePtr:=->[Raw_Materials_Locations:25]
	uDialog("SelectDivision"; 250; 200)  //ask user what to print
	
	If (OK=1)  //user oked selection criteria
		If (sCommKey#"")
			sCommKey:=String:C10(Num:C11(sCommKey); "00")+"@"
		Else   //• 8/24/98 cs this situation left the var empty
			sCommKey:="@"
		End if 
	Else 
		sCommKey:="@"
	End if 
	
	Case of   //locate records to print
		: (rbArkay=1)
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="1"; *)
			
		: (rbRoanoke=1)
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="2"; *)
			
		: (rbLabel=1)
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="3"; *)
		Else   //all divisions
			rbArkay:=1
			rbRoanoke:=1
			rbLabel:=1
	End case 
	
	Case of 
		: (cbAllComm=1) & (rbAll=0)  //specified location, all commodities
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Commodity_Key:12=sCommkey; *)
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]QtyOH:9>0)
		: (cbAllComm=0) & (rbAll=1)  //specified commodity, all locations
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Commodity_Key:12=sCommkey; *)
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]QtyOH:9>0)
		: (cbAllComm=0)  //specified location, specified commodity
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Commodity_Key:12=sCommkey; *)
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]QtyOH:9>0)
		Else   //all comodities, all locations
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]QtyOH:9>0)
	End case 
	$Division:=(3*Num:C11(rbAll=1))+(1*Num:C11(rbAll=0))  //Number of divisions to Print, 3 (all) or 1 (specified)
	SET WINDOW TITLE:C213(String:C10(Records in selection:C76([Raw_Materials:21]))+" records: On-hand Report (with costs)")
	$Title:="RM On-Hand W/Costs"
	FORM SET OUTPUT:C54([Raw_Materials:21]; "OnHandAndCost")
	util_PAGE_SETUP(->[Raw_Materials:21]; "OnHandAndCost")
	PRINT SETTINGS:C106
End if 

If (OK=1)  //above passed
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		CREATE SET:C116([Raw_Materials_Locations:25]; "Qty")  //create set so that different divisions can be found
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="PI Adj"; *)  //used in the report to remove transactions
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Location:15="Create:PI"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
		CREATE SET:C116([Raw_Materials_Transactions:23]; "receipts")
		
	Else 
		
		CREATE SET:C116([Raw_Materials_Locations:25]; "Qty")  //create set so that different divisions can be found
		SET QUERY DESTINATION:C396(Into set:K19:2; "receipts")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="PI Adj"; *)  //used in the report to remove transactions
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Location:15="Create:PI"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	For ($i; 1; $Division+1)  //# Divisions to print +1 to catch any blank Division indicators
		Case of   //determine which division to print on this iteration
			: (rbArkay=1)  //radio buttons are set either in Dlog (above), or by code above if from MntEnd
				$Company:="Hauppauge"
				sCmpnyPrnt:="1"
				rbArkay:=0
			: (rbRoanoke=1)
				$Company:="Roanoke"
				sCmpnyPrnt:="2"
				rbRoanoke:=0
			: (rbLabel=1)
				$Company:="Labels"
				sCmpnyPrnt:="3"  //• 7/8/97 cs fixed an obvious typo - caused string truncation error
				rbLabel:=0
			Else   //insure that un-identified company ids are captured and printed
				$Company:="No Company"
				sCmpnyPrnt:=""
		End case 
		t2:=$Title+" ("+$Company+")"  //Setup report printing title  
		USE SET:C118("Qty")
		QUERY SELECTION:C341([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27=sCmpnyPrnt)  //locate Rm_Bins for printing Division, 
		RELATE ONE SELECTION:C349([Raw_Materials_Locations:25]; [Raw_Materials:21])  //locate Rawmaterials need to print this repo
		
		If (Records in selection:C76([Raw_Materials:21])>0)  //if something was found... sort & print
			ORDER BY:C49([Raw_Materials:21]; [Raw_Materials:21]CommodityCode:26; >; [Raw_Materials:21]Commodity_Key:2; >; [Raw_Materials:21]Raw_Matl_Code:1; >)
			BREAK LEVEL:C302(2)
			ACCUMULATE:C303(rOnHand; rOHPrice)
			PRINT SELECTION:C60([Raw_Materials:21]; *)
		Else 
			
			If (Count parameters:C259<1) & (sCmpnyPrnt#"")  //do not display a message if no bad records found`• cs 1/14/98
				BEEP:C151
				ALERT:C41("There were No Records with  quantity on-hand found for: "+$Company)  //• cs 1/14/98
			End if 
		End if 
		
		If (OK=0)  //user canceled report
			$i:=5  //set value of loop counter larger than possible max
		End if 
	End for 
	CLEAR SET:C117("Qty")
	CLEAR SET:C117("Receipts")
End if 
FORM SET OUTPUT:C54([Raw_Materials:21]; "List")