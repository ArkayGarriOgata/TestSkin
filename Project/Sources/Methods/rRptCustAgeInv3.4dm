//%attributes = {"publishedWeb":true}
//Procedure: rRptCustAgeInv3()  120195  MLB
//based on:  (had a page breaking problem)
//rRptCustAgeInv  upr1439 2/23/95
//•031496  MLB based on rRptCustAgeInv2
//*Inits
//• 1/20/97 -cs- this report took 7 or so minutes to print in single user
//  however it took over 70 to print in client/server. So this is an attempt to
//  speed this report processing - replace all looping through records with arrays
//  where the arrays are populated with selection to array.  
//  sorts are still being done on records to insure that the correct sort order
//  of the data
//  Also I found that if the report is canceld and it is being saved to disk 
//  the disk file is NOT closed
//
//•120397  MLB  refer to QtyOpen, not QtyTemp
//•100698  mlb  UPR 1979 Remove B&H from open quantity
C_DATE:C307($1)
C_TEXT:C284($2)
C_REAL:C285(r1; r2; r3; r4; r5; r6; r7; r8; r9; r10; r11; r12; r21; r22; r23; r24; r25; r26; r27; r28; r29; r32; r33; r0; r00; r0t; r00t)  //•051695  MLB  UPR 1526
C_TEXT:C284(t2; t2b; t3; t10)
C_TEXT:C284(sCPN)
C_BOOLEAN:C305(fSave; $Cancel)
C_DATE:C307(under03; under06; under12; under09)
C_LONGINT:C283($i; j; $locations; $numCusts; $qtyAccum; $hit)
C_TEXT:C284($lastCust)
C_TEXT:C284($lastCPN)

READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Customers:16])
$Cancel:=False:C215  //• 1/20/97 flag for tracking user cancelation of report
AgeTime:=0
TallyTime:=0
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "CustAgeInvHead")
PDF_setUp(<>pdfFileName)
//*Select the FG Location records of interest
Case of   //upr 1461
	: (Count parameters:C259=1)  //*     MES FG only
		t3:="F/G & C/C inventory locations, Sorted by Customer Nº, No Examining"
		dDateEnd:=$1
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)  //•080995  MLB ks direction
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@")  //•080995  MLB ks direction
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>0)  //•051695  MLB  UPR 1526 add or
			
			
		Else 
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)  //•080995  MLB ks direction
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•080995  MLB ks direction
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>0)  //•051695  MLB  UPR 1526 add or
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		ok:=1
		
	: (Count parameters:C259=2)  //*     MES Exam only
		t3:="F/G inventory locations, Sorted by Customer Nº, Examining Only"
		dDateEnd:=$1
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="Ex@"; *)
		//SEARCH SELECTION([FG_Locations];[FG_Locations]QtyOH>0)  `•051695  MLB 
		//« UPR 1526 add or
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9>0)  //•1/15/97 -cs- try to speed up,`•120397  MLB  use the correct field
		ok:=1
		
	Else   //*     fg popup, user search
		t3:="F/G inventory locations, Sorted by Customer Nº, Data Selection - User Determined"
		dDateEnd:=4D_Current_date
		fSave:=False:C215
		uConfirm("Would you like to also save this report in Excel format?"; "Save file"; "Don't save")
		If (ok=1)
			docName:="CustAgedInv_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
			vDoc:=util_putFileName(->docName)
			If (ok=1)
				fSave:=True:C214
			End if 
		End if 
		
		PRINT SETTINGS:C106  //070795 MLB was #1 which messes up the ME
		If (ok=1)
			QUERY:C277([Finished_Goods_Locations:35])  //•051295 remove search selection!
		Else 
			$Cancel:=True:C214  //•1/2 0/97 flag user cancel so disk file can be closed
		End if 
		
End case 

If (ok=1)
	t2:="A R K A Y   P A C K A G I N G"
	t2b:="C U S T O M E R   A G E D  I N V E N T O R Y"
	dDate:=4D_Current_date
	tTime:=4d_Current_time
	//under06:=dDateEnd-(((365/12)*6)-1)
	//under09:=dDateEnd-(((365/12)*9)-1)
	//under12:=dDateEnd-(((365/12)*12)-1)
	
	under03:=Add to date:C393(dDateEnd; 0; -3; 0)
	under06:=Add to date:C393(dDateEnd; 0; -6; 0)
	under09:=Add to date:C393(dDateEnd; 0; -9; 0)
	under12:=Add to date:C393(dDateEnd; 0; -12; 0)
	
	
	If (fSave)
		SEND PACKET:C103(vDoc; String:C10(dDate; 2)+Char:C90(9)+Char:C90(9)+t2+Char:C90(13))
		SEND PACKET:C103(vDoc; String:C10(tTime; 5)+Char:C90(9)+Char:C90(9)+t2b+Char:C90(13))
		SEND PACKET:C103(vDoc; Char:C90(9)+Char:C90(9)+t3+Char:C90(13)+Char:C90(13))
		SEND PACKET:C103(vDoc; "Customer"+Char:C90(9)+"< 3 Months"+Char:C90(9)+Char:C90(9)+"< 6 Months"+Char:C90(9)+Char:C90(9)+"6 to < 9 Months"+Char:C90(9)+Char:C90(9))
		SEND PACKET:C103(vDoc; "9 to < 12 Months"+Char:C90(9)+Char:C90(9)+"12 Months and Over"+Char:C90(9)+Char:C90(9)+"Non-Valued"+Char:C90(9)+"Total Valued"+Char:C90(13))
		SEND PACKET:C103(vDoc; Char:C90(9)+"Cartons"+Char:C90(9)+"$ Revenue"+Char:C90(9)+"Cartons"+Char:C90(9)+"$ Revenue"+Char:C90(9)+"Cartons"+Char:C90(9)+"$ Revenue"+Char:C90(9))
		SEND PACKET:C103(vDoc; "Cartons"+Char:C90(9)+"$ Revenue"+Char:C90(9)+"Cartons"+Char:C90(9)+"$ Revenue"+Char:C90(9)+"Cartons"+Char:C90(9)+"Cartons"+Char:C90(9)+"$ Revenue"+Char:C90(9)+Char:C90(13)+Char:C90(13))
	End if 
	
	//•1/20/97 -cs- speed up mods, moving orderlines into array for speed
	$OrderLines:=qryOpenOrdLines  //retrieve orderlines
	// CREATE SET([OrderLines];"opens")` •1/20/97 removed not needed anymore
	$OrderLines:=Records in selection:C76([Customers_Order_Lines:41])  //• setup arrays
	ARRAY TEXT:C222(aCPN; 0)
	ARRAY TEXT:C222(aCustId; 0)
	ARRAY DATE:C224(aDate; 0)
	ARRAY LONGINT:C221(aQty; 0)
	ARRAY LONGINT:C221(aQty2; 0)
	ARRAY REAL:C219(aPoQty; 0)
	ARRAY REAL:C219(aPoPrice; 0)
	ARRAY TEXT:C222(aOrderline; 0)  //•100698  mlb  UPR 1979
	ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]CustID:4; >; [Customers_Order_Lines:41]DateOpened:13; <)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]ProductCode:5; aCPN; [Customers_Order_Lines:41]CustID:4; aCustID; [Customers_Order_Lines:41]DateOpened:13; aDate; [Customers_Order_Lines:41]Qty_Open:11; aQty; [Customers_Order_Lines:41]Quantity:6; aQty2; [Customers_Order_Lines:41]OverRun:25; aPoQty; [Customers_Order_Lines:41]Price_Per_M:8; aPoPrice; [Customers_Order_Lines:41]OrderLine:3; aOrderline)
	//end speed mods
	//•100698  mlb  UPR 1979 Remove B&H from open quantity
	READ ONLY:C145([Finished_Goods_Transactions:33])
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="B&H@")
	ARRAY TEXT:C222($aHasBillHol; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]CustID:12; $aHasBillHol)
	
	For ($i; 1; Size of array:C274(aCustID))
		$hit:=Find in array:C230($aHasBillHol; aCustID{$i})
		If ($hit>-1)  //this customer has some bill and holds, so check this orderline
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="B&H@"; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]OrderItem:16=aOrderline{$i}+"@")
			If (Records in selection:C76([Finished_Goods_Transactions:33])>0)  //reduce qty open by the amount of b&H
				$billHold:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
				aQty{$i}:=aQty{$i}-$billHold
			End if 
		End if 
	End for 
	REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
	ARRAY TEXT:C222($aHasBillHol; 0)
	//•100698  mlb  UPR 1979 end  
	
	//*Set up arrays
	C_LONGINT:C283($maxSize)
	$maxSize:=Records in table:C83([Customers:16])
	//* Customer
	ARRAY TEXT:C222(aCustomer; $maxSize)
	//* Revenues
	ARRAY REAL:C219(rGroup0; $maxSize)
	ARRAY REAL:C219(rGroup1; $maxSize)
	ARRAY REAL:C219(rGroup2; $maxSize)
	ARRAY REAL:C219(rGroup3; $maxSize)
	ARRAY REAL:C219(rGroup4; $maxSize)
	ARRAY REAL:C219(rGroup5; $maxSize)
	ARRAY REAL:C219(rGroup6; 6)  //totals of revenues
	//* Qtys
	ARRAY LONGINT:C221(aL0; $maxSize)
	ARRAY LONGINT:C221(aL1; $maxSize)
	ARRAY LONGINT:C221(aL2; $maxSize)
	ARRAY LONGINT:C221(aL3; $maxSize)
	ARRAY LONGINT:C221(aL4; $maxSize)
	ARRAY LONGINT:C221(aL5; $maxSize)
	ARRAY LONGINT:C221(aL6; $maxSize)
	ARRAY LONGINT:C221(aL7; 7)  //totals of qtys
	//*Load arrays
	SET WINDOW TITLE:C213(fNameWindow(->[Finished_Goods_Locations:35])+" Customer Aged Inventory")
	//SORT SELECTION([FG_Locations];[FG_Locations]CustID;>;[FG_Locations]ProductCode;>
	//• 1/21/97 do sort in array instead
	
	MESSAGES OFF:C175
	
	//• 1/20/97 cs- replacing for loop on fg_location records with arrays to try to 
	//  speed execution
	$Locations:=Records in selection:C76([Finished_Goods_Locations:35])
	ARRAY TEXT:C222($aLocation; $Locations)  //• 1/ 20/97set up arrays
	ARRAY TEXT:C222($aCustId; $Locations)
	ARRAY TEXT:C222($aProdCode; $Locations)
	ARRAY LONGINT:C221($aQtyOh; $Locations)
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16; >; [Finished_Goods_Locations:35]ProductCode:1; >)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aLocation; [Finished_Goods_Locations:35]CustID:16; $aCustID; [Finished_Goods_Locations:35]ProductCode:1; $aProdCode; [Finished_Goods_Locations:35]QtyOH:9; $aQtyOh)
	//end speed mods
	$numCusts:=0
	$lastCust:=""
	$lastCPN:=""
	$qtyAccum:=0
	uThermoInit($locations; "Aging Customer Inventories")  //•1/21/97 removed reference to external 
	//•1/20/97 cs speed up mods
	//  all references to fg_locations table replaced by references to
	//   array equivelants from above selection to array
	For ($i; 1; $locations)
		//zwStatusMsg (String($i);$aLocation{$i})
		//DELAY PROCESS(Current process;10)
		If (Substring:C12($aLocation{$i}; 1; 2)#"BH")  //don't include bill & holds,`•1/20/97 cs speed up mods
			//* Same cpn test?
			If ($lastCPN#($aCustID{$i}+":"+$aProdCode{$i}))  //•031496  MLB add cust id,`•1/20/97 cs speed up mods
				
				If ($qtyAccum>0)  //*    finish 'age' last cpn
					//*       Get the orderlines demand
					uAgeDemand($lastCPN; $qtyAccum; $numCusts)  //• 1/20 /97 speed mods to this procedure
				End if 
				
				//*    set up for next CPN
				$lastCPN:=$aCustID{$i}+":"+$aProdCode{$i}  //•031496  MLB add cust id,`•1/20/97 cs speed up mods
				$qtyAccum:=$aQtyOh{$i}  //•1/20/97 cs speed up mods
				
			Else   //*  else accum the qty
				$qtyAccum:=$qtyAccum+$aQtyOh{$i}  //•1/20/97 cs speed up mods
			End if   //same cpn        
			
			If ($lastCust#$aCustID{$i})  //* Same customer test? ,`•1/20/97 cs speed up mods
				//*      Calculate horizontal totals
				uAgeTallyCust($numCusts)
				
				//*   set up for next customer
				$numCusts:=$numCusts+1
				$lastCust:=$aCustID{$i}  //•1/20/97 cs speed up mods
				If ([Customers:16]ID:1#$lastCust)
					QUERY:C277([Customers:16]; [Customers:16]ID:1=$lastCust)
				End if 
				If (Records in selection:C76([Customers:16])=1)
					aCustomer{$numCusts}:=[Customers:16]Name:2
				Else 
					aCustomer{$numCusts}:="** '"+$lastCust+"' NOT FOUND **"
				End if 
				
			End if   //same customer
			
		End if   //not bill and hold location
		
		uThermoUpdate($i)
	End for 
	//end speed up mods  
	uThermoClose
	uAgeDemand($lastCPN; $qtyAccum; $numCusts)
	uAgeTallyCust($numCusts)
	
	//*Adjust (shrink) the arrays size
	//* Customer
	ARRAY TEXT:C222(aCustomer; $numCusts)
	//* Revenues
	ARRAY REAL:C219(rGroup0; $numCusts)
	ARRAY REAL:C219(rGroup1; $numCusts)
	ARRAY REAL:C219(rGroup2; $numCusts)
	ARRAY REAL:C219(rGroup3; $numCusts)
	ARRAY REAL:C219(rGroup4; $numCusts)
	ARRAY REAL:C219(rGroup5; $numCusts)
	//* Qtys
	ARRAY LONGINT:C221(aL0; $numCusts)
	ARRAY LONGINT:C221(aL1; $numCusts)
	ARRAY LONGINT:C221(aL2; $numCusts)
	ARRAY LONGINT:C221(aL3; $numCusts)
	ARRAY LONGINT:C221(aL4; $numCusts)
	ARRAY LONGINT:C221(aL5; $numCusts)
	ARRAY LONGINT:C221(aL6; $numCusts)
	
	//*Print & Export the arrays
	SORT ARRAY:C229(aCustomer; aL1; aL2; aL3; aL4; aL5; aL6; rGroup1; rGroup2; rGroup3; rGroup4; rGroup5; aL0; rGroup0; >)
	
	C_LONGINT:C283($lineCounter; $maxLines)
	$lineCounter:=1
	$maxLines:=35
	iPage:=1
	Print form:C5([Finished_Goods_Locations:35]; "CustAgeInvHead")  //the header
	
	For ($i; 1; Size of array:C274(aCustomer))
		If (fSave)
			SEND PACKET:C103(vDoc; aCustomer{$i}+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(aL0{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(rGroup0{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(aL1{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(rGroup1{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(aL2{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(rGroup2{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(aL3{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(rGroup3{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(aL4{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(rGroup4{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(aL5{$i})+Char:C90(9))  //non valued
			SEND PACKET:C103(vDoc; String:C10(aL6{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(rGroup5{$i})+Char:C90(13))
		End if 
		
		
		If ($lineCounter>$maxLines)
			$lineCounter:=0
			PAGE BREAK:C6(>)
			iPage:=iPage+1
			Print form:C5([Finished_Goods_Locations:35]; "CustAgeInvHead")  //the header    
		End if 
		
		sCustName:=aCustomer{$i}
		r0:=aL0{$i}
		r00:=rGroup0{$i}
		r1:=aL1{$i}
		r2:=rGroup1{$i}
		r3:=aL2{$i}
		r4:=rGroup2{$i}
		r5:=aL3{$i}
		r6:=rGroup3{$i}
		r7:=aL4{$i}
		r8:=rGroup4{$i}
		r11:=aL5{$i}
		r9:=aL6{$i}
		r12:=rGroup5{$i}
		
		Print form:C5([Finished_Goods_Locations:35]; "CustAgeInvDetai")  //the detail   
		$lineCounter:=$lineCounter+1
	End for 
	
	r0t:=aL7{1}
	r00t:=rGroup6{1}
	r21:=aL7{2}
	r22:=rGroup6{2}
	r23:=aL7{3}
	r24:=rGroup6{3}
	r25:=aL7{4}
	r26:=rGroup6{4}
	r27:=aL7{5}
	r28:=rGroup6{5}
	r29:=aL7{7}
	r32:=rGroup6{6}
	r33:=aL7{6}  //•051695  MLB  UPR 1526
	Print form:C5([Finished_Goods_Locations:35]; "CustAgeInvTotal")  //the totals  
	PAGE BREAK:C6
	
	If (OK=0)  //• 1/20/97 if this is printing to screen and user cancels
		$Cancel:=True:C214
	End if 
	
	If (fSave)
		SEND PACKET:C103(vDoc; "Grand Totals:"+Char:C90(9))
	End if 
	
	For ($i; 1; 5)  //the totals
		If (fSave)
			SEND PACKET:C103(vDoc; String:C10(aL7{$i})+Char:C90(9))
			SEND PACKET:C103(vDoc; String:C10(rGroup6{$i})+Char:C90(9))
		End if 
	End for 
	
	If (fSave)
		SEND PACKET:C103(vDoc; String:C10(aL7{6})+Char:C90(9))
		SEND PACKET:C103(vDoc; String:C10(aL7{7})+Char:C90(9))
		SEND PACKET:C103(vDoc; String:C10(rGroup6{6})+Char:C90(13))
	End if 
	
	//*Clean up
	CLEAR SET:C117("opens")
	If (fSave)
		If (Count parameters:C259<1) | ($Cancel)  //• 1/20/97 if the user canceld printing
			CLOSE DOCUMENT:C267(vDoc)
			// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
			$err:=util_Launch_External_App(docName)
		Else 
			SEND PACKET:C103(vDoc; Char:C90(13)+Char:C90(13))  //•061495  MLB 
		End if 
		
	End if 
	
	
	//*Clear arrays
	$maxSize:=0
	ARRAY TEXT:C222(aCustomer; $maxSize)
	ARRAY REAL:C219(rGroup1; $maxSize)
	ARRAY REAL:C219(rGroup2; $maxSize)
	ARRAY REAL:C219(rGroup3; $maxSize)
	ARRAY REAL:C219(rGroup4; $maxSize)
	ARRAY REAL:C219(rGroup5; $maxSize)
	ARRAY REAL:C219(rGroup6; 0)  //totals of revenues
	ARRAY LONGINT:C221(aL1; $maxSize)
	ARRAY LONGINT:C221(aL2; $maxSize)
	ARRAY LONGINT:C221(aL3; $maxSize)
	ARRAY LONGINT:C221(aL4; $maxSize)
	ARRAY LONGINT:C221(aL5; $maxSize)
	ARRAY LONGINT:C221(aL6; $maxSize)
	ARRAY LONGINT:C221(aL7; 0)  //totals of qtys
	$OrderLines:=0
	ARRAY TEXT:C222(aCPN; $OrderLines)  //reused process
	ARRAY TEXT:C222(aCustId; $OrderLines)
	ARRAY DATE:C224(aDate; $OrderLines)
	ARRAY LONGINT:C221(aQty; $OrderLines)
	ARRAY LONGINT:C221(aQty2; $OrderLines)
	ARRAY REAL:C219(aPoQty; $OrderLines)
	ARRAY REAL:C219(aPoPrice; $OrderLines)
	MESSAGES ON:C181
Else 
	If (fSave) & ($Cancel)
		CLOSE DOCUMENT:C267(vDoc)
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		$err:=util_Launch_External_App(docName)
	End if 
End if 
//