//%attributes = {"publishedWeb":true}
//Procedure: uINVauxil()  080996  MLB
//reduce the size of (P)rptNewInventor2
//since it exceeded 32k
//•022097  MLB  close search (THIS IS SUPERCEDED)
//• 8/14/97 cs clear batch date field if user is printing for just on e customer
//• 10/23/97 cs new case,4 to retreive JMI based on ORDER not INVENTORY 
//• 10/27/97 cs new case,5 to allow gather'g of 0 qty orderlines see qryorderlines
//•121197  MLB  UPR 1906 case,6 gather open releases, added * comments
//•121197  MLB  UPR 1906 case,7 like case2, but Consider open Forecasts
C_LONGINT:C283($1; $3)  //1= switch
C_TEXT:C284($2)
C_DATE:C307($4)
C_TEXT:C284($cr)
C_LONGINT:C283($i; $hit; $openOrds; $openRels)

Case of 
	: ($1=1)  //*1=Load FG inventory and Order demand
		If ($2="")  //*   for all customers, or
			BatchFGinventor
			BatchOrdcalc
		Else   //*   for specific customer(s)
			BatchFGinventor(0; $2)
			BatchOrdcalc(0; $2)
		End if 
		
	: ($1=2)  //*2=Calc Total Excess, and Create a "UsedYet" flag in the FG object
		//*    $3 == size of FG invnetory collection
		ARRAY BOOLEAN:C223(aPayU2; 0)  //*    aPayU2 == "UsedYet" flag in the FG object
		ARRAY LONGINT:C221(aQty; 0)  //*    aQty == total excess
		ARRAY BOOLEAN:C223(aPayU2; $3)  //*    aPayU2 == "UsedYet" flag in the FG object
		ARRAY LONGINT:C221(aQty; $3)  //*    aQty == total excess
		
		For ($i; 1; $3)  //init the array  to false
			aPayU2{$i}:=False:C215
			$hit:=Find in array:C230(<>aOrdKey; <>aFGKey{$i})
			If ($hit<0)  //no orders
				aQty{$i}:=<>aQty_OH{$i}  //all excess
			Else   //some excess
				aQty{$i}:=<>aQty_OH{$i}-(<>aQty_Open{$hit}+<>aQty_ORun{$hit})
			End if 
		End for 
		
	: ($1=7)  //*7=Calc Total Excess w|FORECAST, and Create a "UsedYet" flag in the FG object
		
		ARRAY BOOLEAN:C223(aPayU2; $3)  //*    aPayU2 == "UsedYet" flag in the FG object
		ARRAY LONGINT:C221(aQty; $3)  //*    aQty == total excess
		
		For ($i; 1; $3)  //init the array  to true      
			
			aPayU2{$i}:=False:C215
			$hit:=Find in array:C230(<>aOrdKey; <>aFGKey{$i})
			If ($hit<0)  //no orders
				$openOrds:=0
			Else   //some excess
				$openOrds:=<>aQty_Open{$hit}+<>aQty_ORun{$hit}
			End if 
			
			$hit:=Find in array:C230(<>aRelKey; <>aFGKey{$i})
			If ($hit<0)  //no orders
				$openRels:=0
			Else   //some excess
				$openRels:=<>aRel_Open{$hit}
			End if 
			
			If ($openRels>$openOrds)  //*    User the greater of Open Rels or Open Orders
				$openOrds:=$openRels
			End if 
			
			If ($openOrds<=0)  //no orders
				aQty{$i}:=<>aQty_OH{$i}  //all excess
			Else   //some excess
				aQty{$i}:=<>aQty_OH{$i}-$openOrds
			End if 
		End for 
		
	: ($1=3)  //*3=Get just aged OrderLines sorted by custname and their related FG, Bin, and JM
		//*  Reduce selection to aged Orderlines    
		If ($2#"")  //limit to one customer
			MESSAGE:C88($CR+"     limiting to "+$2)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24=$2)
				qryOpenOrdLines("*"; "*")
				MESSAGE:C88($CR+"     limiting to "+String:C10($3)+" months...")
				QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
				
			Else 
				
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24=$2; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
				MESSAGE:C88($CR+"     limiting to "+String:C10($3)+" months...")
				
			End if   // END 4D Professional Services : January 2019 query selection
			
		Else 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				qryOpenOrdLines("*")
				MESSAGE:C88($CR+"     limiting to "+String:C10($3)+" months...")
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
				
				
			Else 
				
				
				MESSAGE:C88($CR+"     limiting to "+String:C10($3)+" months...")
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
				
				
			End if   // END 4D Professional Services : January 2019 query selection
		End if 
		
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24; >; [Customers_Order_Lines:41]CustomerLine:42; >; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]PONumber:21; >)  //•072696  MLB       
			//uRelateSelect (»[Finished_Goods]ProductCode;»[OrderLines]ProductCode;1)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				uRelateSelect(->[Finished_Goods_Locations:35]ProductCode:1; ->[Customers_Order_Lines:41]ProductCode:5; 1)  //*    Inventory related to orderlines
				uRelateSelect(->[Job_Forms_Items:44]ProductCode:3; ->[Finished_Goods_Locations:35]ProductCode:1; 1)  //*    Production related to INVENTORY•••
				
			Else 
				
				ARRAY TEXT:C222($_ProductCode_ordre; 0)
				ARRAY TEXT:C222($_ProductCode_Locations; 0)
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Locations:35])+" file. Please Wait...")
				DISTINCT VALUES:C339([Customers_Order_Lines:41]ProductCode:5; $_ProductCode_ordre)
				QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode_ordre)
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items:44])+" file. Please Wait...")
				DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode_Locations)
				QUERY WITH ARRAY:C644([Job_Forms_Items:44]ProductCode:3; $_ProductCode_Locations)
				
				zwStatusMsg(""; "")
				
			End if   // END 4D Professional Services : January 2019 query selection
			
		End if 
		
	: ($1=4)  //*4=Get just aged OrderLines sorted by custname and their related FG, Bin, and JM
		//*  Reduce selection to aged Orderlines
		If ($2#"")  //limit to one customer
			
			MESSAGE:C88($CR+"     limiting to "+$2)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24=$2)
				qryOpenOrdLines("*"; "*")
				MESSAGE:C88($CR+"     limiting to "+String:C10($3)+" months...")
				QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
				
			Else 
				MESSAGE:C88($CR+"     limiting to "+String:C10($3)+" months...")
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24=$2; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
				
			End if   // END 4D Professional Services : January 2019 query selection
			
		Else 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				qryOpenOrdLines("*")
				MESSAGE:C88($CR+"     limiting to "+String:C10($3)+" months...")
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
				
			Else 
				
				MESSAGE:C88($CR+"     limiting to "+String:C10($3)+" months...")
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
				
			End if   // END 4D Professional Services : January 2019 query selection
			
		End if 
		
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24; >; [Customers_Order_Lines:41]CustomerLine:42; >; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]PONumber:21; >)  //•072696  MLB       
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				uRelateSelect(->[Finished_Goods_Locations:35]ProductCode:1; ->[Customers_Order_Lines:41]ProductCode:5; 1)  //*    Inventory related to orderlines
				uRelateSelect(->[Job_Forms_Items:44]OrderItem:2; ->[Customers_Order_Lines:41]OrderLine:3; 1)  //*    Production related to ORDERLINES•••  
				
			Else 
				
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY TEXT:C222($_OrderLine; 0)
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Locations:35])+" file. Please Wait...")
				DISTINCT VALUES:C339([Customers_Order_Lines:41]ProductCode:5; $_ProductCode)
				QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
				zwStatusMsg(""; "")
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items:44])+" file. Please Wait...")
				If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
					
					DISTINCT VALUES:C339([Customers_Order_Lines:41]OrderLine:3; $_OrderLine)
					QUERY WITH ARRAY:C644([Job_Forms_Items:44]OrderItem:2; $_OrderLine)
					
				Else 
					
					RELATE MANY SELECTION:C340([Job_Forms_Items:44]OrderItem:2)
				End if   // END 4D Professional Services : January 2019 
				zwStatusMsg(""; "")
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			
		End if 
		
	: ($1=5)  //*5=Gathering aged Open Orderlines even if ZERO QTY OPEN, see qryorderlines
		rMaryKayOrdLine($1; $2; $3; $4)  //(switch;custid;month;endDate
		
	: ($1=6)  //*6=Gather Open Releases into an array
		If ($2="")  //*   for all customers, or
			BatchRelCalc
		Else   //*   for specific customer(s)
			BatchRelCalc(0; $2)
		End if 
		
End case 
//*-
//*Turn Batch date (◊FgBatchDat) OFF if proc wasn't used for ALL customers
If (<>FgBatchDat=4D_Current_date) & (tCust#"")  //• 8/14/97 cs tCust from user dialog setting up report
	<>FgBatchDat:=!00-00-00!  //• 8/14/97 cs clear date field because lena runs this for indidual customers and 
	//batch routines set this date, do this at end so that an othe call does not 
	//think that the batch rutines have been run yet
End if 
//