//%attributes = {"publishedWeb":true}
//(p) rnewvensum
//based on rVendorSumry
//print a 'vensum' report for Purchasing
//$1 optional, anything indicate that the originating call is from 
//PO Pallette
//on site, turned off search messages 4/6/95
//•062695  MLB  UPR 219
//• 12/23/96 cs add capability to print 3 differnt version of this report
// the original (all data wrapped up in one line)
// sorted by vendor with each division broken out inside each vendor
//  sorted by division with each vendor seperated out by division
//•091797  MLB  add two more options for ave$/unit and Inventoried items only
//•100797  mBohince  specify the correct layout
//• 12/22/97 cs partial rewrite - use Industry std units on reports
//• 1/8/98 cs complete re-write of BASIC (rbOrig) vensum report
//  new format showing differnt time references, and all units are Industry std
//• 2/24/98 cs new report which shows $ spent for each vendor
//• 7/6/98 cs added code to clear arrays - inserted in wrong place - stoped sumry
//•100198  MLB  range check error

C_DATE:C307($lastBegin; $lastEnd)
C_BOOLEAN:C305(fSave)
C_TIME:C306(vDoc)
C_LONGINT:C283(cbInventory; $hit; $cursor; $i)  //check box in dialog which is not used in MES

fSave:=False:C215
<>fContinue:=True:C214
ON EVENT CALL:C190("eCancelPrint")

If (Count parameters:C259=1)  //NOT called from MONTH END SUITE
	NewWindow(600; 400; 2; 4)
	SET WINDOW TITLE:C213("Vendor Summary Report")
	uDialog("DateandOptions3"; 240; 210)  //*Get Users Choice for type and date
	
	If (OK=1)  //user OKed Dialog
		util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "VenSumByDivisn")
		PRINT SETTINGS:C106
	End if 
Else 
	rbOrig:=1  //default to original report if run from month end suite  
	OK:=1
End if 

If (OK=1)  //*Go ahead and print
	MESSAGES OFF:C175
	NewWindow(450; 150; 0; -720; "Vendor Summary")
	MESSAGE:C88(" Press Esc or Command + . to abort.")
	
	rVenSumClearArr  //clear arrays - it MAY BE that other reports are stepping on these arrays in MES
	dDate:=4D_Current_date
	tTime:=4d_Current_time
	t2:="ARKAY PACKAGING CORPORATION"
	t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	//• 12/22/97 cs there currently is insufficiant data to correctly get the lbs/MSF
	// once the data is avail this part of the code can be removed, and the lbs/msf ga
	// directly from the Rm_group record
	//*Find average pounds per MSF of B&P
	READ ONLY:C145([Raw_Materials_Groups:22])
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=1; *)
	QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]Flex3:16>0)  //get all board descriptions with lbs per msf
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		AvgLbsMSF:=Sum:C1([Raw_Materials_Groups:22]Flex3:16)/Records in selection:C76([Raw_Materials_Groups:22])
	Else 
		AvgLbsMSF:=0
	End if 
	REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
	
	//*Set up Fiscal calendar stuff
	lMonth:=Num:C11(FiscalYear("month"; dDateBegin))
	lQuarter:=Num:C11(FiscalYear("quarter"; dDateBegin))
	fiscalStart:=Date:C102(FiscalYear("start"; dDateBegin))  //[Fiscal_Calendar]StartDate
	fiscalLastStart:=Date:C102(String:C10(lMonth)+"/1/"+String:C10(Year of:C25(fiscalStart)-1))
	
	//*Pick YTD this plus all of last OR same period in this and last
	If (rbOrig=1)  //do setup especially for basic report to handle new reporting style    
		$lastBegin:=Date:C102(String:C10(Month of:C24(dDateBegin))+"/01/"+String:C10(Year of:C25(dDateBegin)-1))  //start of previous fiscal year
		$lastEnd:=dDateBegin-1  //dDatebegin is the start of the current fiscal year
		dLastEnd:=Date:C102(String:C10(Month of:C24(dDateEnd))+"/"+String:C10(Day of:C23(dDateEnd))+"/"+String:C10(Year of:C25(dDateEnd)-1))
		
		MESSAGE:C88(" Getting last year's items"+Char:C90(13))
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40>=fiscalLastStart; *)  //$lastBegin
			//QUERY([PO_Items]; & ;[PO_Items]VendorID="08251";*)  `$lastEnd
			
			QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]PoItemDate:40<=dLastEnd)  //$lastEnd
			If (cbInventory=1)
				QUERY SELECTION:C341([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]CommodityCode:16>=1; *)
				QUERY SELECTION:C341([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]CommodityCode:16<=13)
			End if 
			
			
			CREATE SET:C116([Purchase_Orders_Items:12]; "LastYr")
			
			MESSAGE:C88(" Getting this year's items"+Char:C90(13))
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40>=fiscalStart; *)
			//QUERY([PO_Items]; & ;[PO_Items]VendorID="08251";*)  `$lastEnd
			
			QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]PoItemDate:40<=dDateEnd)
			If (cbInventory=1)
				QUERY SELECTION:C341([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]CommodityCode:16>=1; *)
				QUERY SELECTION:C341([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]CommodityCode:16<=13)
			End if 
			
			CREATE SET:C116([Purchase_Orders_Items:12]; "ThisYr")
			
			MESSAGE:C88(" Combine"+Char:C90(13))
			UNION:C120("LastYr"; "ThisYr"; "BothYrs")
			USE SET:C118("BothYrs")
			CLEAR SET:C117("ThisYr")
			CLEAR SET:C117("LastYr")
			CLEAR SET:C117("BothYrs")
			
		Else 
			
			If (cbInventory=1)
				QUERY BY FORMULA:C48([Purchase_Orders_Items:12]; \
					(\
					(([Purchase_Orders_Items:12]PoItemDate:40>=fiscalLastStart) & ([Purchase_Orders_Items:12]PoItemDate:40<=dLastEnd))\
					 | \
					(([Purchase_Orders_Items:12]PoItemDate:40>=fiscalStart) & ([Purchase_Orders_Items:12]PoItemDate:40<=dDateEnd))\
					)\
					 & ([Purchase_Orders_Items:12]CommodityCode:16>=1)\
					 & ([Purchase_Orders_Items:12]CommodityCode:16<=13)\
					)
				
				
				
				
			Else 
				QUERY BY FORMULA:C48([Purchase_Orders_Items:12]; \
					(\
					([Purchase_Orders_Items:12]PoItemDate:40>=fiscalLastStart)\
					 & ([Purchase_Orders_Items:12]PoItemDate:40<=dLastEnd)\
					)\
					 | \
					(\
					([Purchase_Orders_Items:12]PoItemDate:40>=fiscalStart)\
					 & ([Purchase_Orders_Items:12]PoItemDate:40<=dDateEnd)\
					)\
					)
				
				
				
			End if 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		MESSAGE:C88(" Loading items for report..."+Char:C90(13))
		SET WINDOW TITLE:C213("Vendor Summary Report")
		$Count:=Records in selection:C76([Purchase_Orders_Items:12])
		MESSAGE:C88(Char:C90(13)+" "+String:C10($Count)+" PO Items to load")
		ARRAY DATE:C224(aDate; $Count)
		ARRAY REAL:C219(aCost; $Count)
		ARRAY REAL:C219(aPOIQty; $Count)
		ARRAY INTEGER:C220(aComCode; $Count)
		ARRAY TEXT:C222(aVend; $Count)
		ARRAY TEXT:C222(aUOM; $Count)
		ARRAY TEXT:C222(aKey; $Count)
		ARRAY REAL:C219(aFlex2; $Count)
		ARRAY REAL:C219(aFlex3; $Count)
		ARRAY TEXT:C222(aRMCode; $Count)
		SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]ExtPrice:11; aCost; [Purchase_Orders_Items:12]VendorID:39; aVend; [Purchase_Orders_Items:12]PoItemDate:40; aDate; [Purchase_Orders_Items:12]CommodityCode:16; aComCode; [Purchase_Orders_Items:12]Qty_Shipping:4; aPOIQty; [Purchase_Orders_Items:12]UM_Ship:5; aUOM; [Purchase_Orders_Items:12]Flex3:33; aFlex3; [Purchase_Orders_Items:12]Commodity_Key:26; aKey; [Purchase_Orders_Items:12]Flex2:32; aFlex2; [Purchase_Orders_Items:12]Raw_Matl_Code:15; aRmCode)
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
		ARRAY TEXT:C222(aCustID; Size of array:C274(aVend))  //• 2/24/98 cs this is being used to track unique vendors for the new followup rep
		// DISTINCT VALUES([PO_Items]VendorID;aCustID)  `• 2/24/98 cs this gets me a list 
		MESSAGE:C88(Char:C90(13)+" Sorting items and gathering vendors")
		ARRAY TEXT:C222($sortKey; Size of array:C274(aVend))
		$cursor:=0  //•092598  MLB  loose the expensive sort and distinct values
		For ($i; 1; Size of array:C274(aVend))
			If (aVend{$i}="")  //•100198  MLB  range check error
				aVend{$i}:=" n/a"
			End if 
			$sortKey{$i}:=String:C10(aComCode{$i}; "000")+aVend{$i}
			$hit:=Find in array:C230(aCustID; aVend{$i})
			If ($hit=-1)
				$cursor:=$cursor+1
				aCustID{$cursor}:=aVend{$i}
			End if 
			IDLE:C311
			If (Not:C34(<>fContinue))
				$i:=$i+Size of array:C274(aVend)  //break
			End if 
		End for 
		ARRAY TEXT:C222(aCustID; $cursor)
		SORT ARRAY:C229(aCustID; >)
		SORT ARRAY:C229($sortKey; aCost; aVend; aDate; aComCode; aPOIQty; aUOM; aFlex3; aKey; aFlex2; aRmCode; >)
		ARRAY TEXT:C222($sortKey; 0)
		
		//• 2/24/98 cs arrays for new report
		ARRAY TEXT:C222(aDesc; $cursor)  //vendor name
		ARRAY REAL:C219(ayA2; $cursor)  //month to date
		ARRAY REAL:C219(ayA3; $cursor)  //quarter to date
		ARRAY REAL:C219(ayBx; $cursor)  //year to date
		ARRAY REAL:C219(ayA4; $cursor)  //last year month to date
		ARRAY REAL:C219(ayA5; $cursor)  //last year quarter to date
		ARRAY REAL:C219(ayA6; $cursor)  //YTD , last year
		ARRAY REAL:C219(ayA7; $cursor)  //last year
		CLOSE WINDOW:C154
		
	Else   //* NOT printing new format do different setup
		fNewVenSum:=True:C214  //• 12/22/97 cs added conversion for industry standard units
		MESSAGES OFF:C175
		
		//same date range but a year ago 
		MESSAGE:C88(" Getting last year's items"+Char:C90(13))
		$lastBegin:=Date:C102(String:C10(Month of:C24(dDateBegin))+"/"+String:C10(Day of:C23(dDateBegin))+"/"+String:C10((Year of:C25(dDateBegin)-1)))  //1 year ago from begin
		$lastEnd:=Date:C102(String:C10(Month of:C24(dDateEnd))+"/"+String:C10(Day of:C23(dDateEnd))+"/"+String:C10((Year of:C25(dDateEnd)-1)))
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40>=$lastBegin; *)
			QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]PoItemDate:40<=$lastEnd)
			CREATE SET:C116([Purchase_Orders_Items:12]; "LastYr")
			
			MESSAGE:C88(" Getting this year's items"+Char:C90(13))
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40>=dDateBegin; *)
			QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]PoItemDate:40<=dDateEnd)
			CREATE SET:C116([Purchase_Orders_Items:12]; "ThisYr")
			
			MESSAGE:C88(" Combine"+Char:C90(13))
			UNION:C120("LastYr"; "ThisYr"; "BothYrs")
			USE SET:C118("BothYrs")
			CLEAR SET:C117("ThisYr")
			CLEAR SET:C117("LastYr")
			CLEAR SET:C117("BothYrs")
			
		Else 
			
			QUERY BY FORMULA:C48([Purchase_Orders_Items:12]; \
				(\
				([Purchase_Orders_Items:12]PoItemDate:40>=$lastBegin)\
				 & ([Purchase_Orders_Items:12]PoItemDate:40<=$lastEnd)\
				)\
				 | \
				(\
				([Purchase_Orders_Items:12]PoItemDate:40>=dDateBegin)\
				 & ([Purchase_Orders_Items:12]PoItemDate:40<=dDateEnd)\
				)\
				)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if   //orig
	
	If (<>fContinue)
		Case of 
			: (rbOrig=1)  //original report (all division wrapped into one line - new format
				t2b:="TOTAL PURCHASES BY COMMODITY"
				If (cbInventory=1)
					t2b:=t2b+" (Inventory Items Only)"
				End if 
				
				rBasicVenSum
				BEEP:C151
				BEEP:C151
				rSpendingSummry(Count parameters:C259=1)
				rVenSumClearArr
				
				If (Count parameters:C259=1)
					CLOSE DOCUMENT:C267(vDoc)
				End if 
				
			: (rbVendor=1)  //break report so each division is reported inside vendor
				BREAK LEVEL:C302(3)
				ACCUMULATE:C303([Purchase_Orders_Items:12]zCount:21; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11)
				t2b:="TOTAL PURCHASES BY COMMODITY, (Vendors by Division)  (Indust Std units)"
				
				util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "VendSumByVendor")
				FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "VendSumByVendor")
				MESSAGE:C88("Sorting")
				ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]CommodityCode:16; >; [Purchase_Orders_Items:12]VendorID:39; >; [Purchase_Orders_Items:12]CompanyID:45; >)
				
			: (rbDivision=1)  //break report so each vendor is reported inside division
				BREAK LEVEL:C302(3)
				ACCUMULATE:C303([Purchase_Orders_Items:12]zCount:21; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11)
				t2b:="TOTAL PURCHASES BY COMMODITY, (Divisions by Vendor) (Indust Std units)"
				util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "VenSumByDivisn")
				FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "VenSumByDivisn")
				MESSAGE:C88("Sorting")
				ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]CommodityCode:16; >; [Purchase_Orders_Items:12]CompanyID:45; >; [Purchase_Orders_Items:12]VendorID:39; >)
				
			: (rb1=1)  //•091797  MLB 
				BREAK LEVEL:C302(2)
				ACCUMULATE:C303([Purchase_Orders_Items:12]zCount:21; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11)
				util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "VenSumAveUnitC")
				FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "VenSumAveUnitC")  //•100797  mBohince  specify the correct layout
				t2b:="TOTAL PURCHASES BY COMMODITY WITH AVE UNIT COST (Indust Std units)"
				ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]CommodityCode:16; >; [Purchase_Orders_Items:12]VendorID:39; >)
				
			: (rb2=1)  //•091797  MLB
				
				QUERY SELECTION:C341([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]CommodityCode:16<9; *)
				QUERY SELECTION:C341([Purchase_Orders_Items:12];  | ; [Purchase_Orders_Items:12]CommodityCode:16=13)
				
				BREAK LEVEL:C302(2)
				ACCUMULATE:C303([Purchase_Orders_Items:12]zCount:21; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11)
				util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "VenSumAveUnitC")
				fNewVenSum:=False:C215
				FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "VenSumAveUnitC")  //•100797  mBohince  specify the correct layout
				t2b:="TOTAL PURCHASES BY INVENTORIED COMMODITIES (Indust Std units)"
				ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]CommodityCode:16; >; [Purchase_Orders_Items:12]VendorID:39; >)
		End case 
		PDF_setUp
		PRINT SELECTION:C60([Purchase_Orders_Items:12]; *)
		FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "List")
	End if 
	
End if 
ARRAY DATE:C224(aDate; 0)
ARRAY TEXT:C222(aPeriod; 0)
MESSAGES ON:C181