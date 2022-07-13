//%attributes = {"publishedWeb":true}
//(p) rCostdInventRpt  tmoved from rrptmthendsuite
//$1= array index
//•061295  MLB  UPR 1640 add a bill & hold report
//•021696  mBohince Exclude closed orderlines, see qetCost procs
//•1/27/97 cs - modification to #3 below for increase in speed
//  ◊aFGKey - CustID + ":" + CPN
//  ◊aQty_Oh - quantity of goods on hand
//  ◊aQty_JMI - quantity of goods created
//  ◊aMidDate - date format
//  ◊aQty_EX - process array of examining only on hand generated inside batchThcCa
//•1/31/97 cs make report printable to disk (Costed Finished Goods Inventory,
//  Costed Examining Inventory, Costed Bill & Hold Inventory)

C_LONGINT:C283($1; $Count)
C_TEXT:C284($Tab; $Cr)

$Tab:=Char:C90(9)
$Cr:=Char:C90(13)

Case of 
	: (<>MthEndSuite{$1}="Costed Finished Goods Inventory")
		READ ONLY:C145([Customers:16])  //••              
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			ALL RECORDS:C47([Finished_Goods_Locations:35])
			//SEARCH([FG_Locations];[FG_Locations]CustID="00019")   ` FOR DEBUGGING
			
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1; 1)
			
		Else 
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
			ALL RECORDS:C47([Finished_Goods_Locations:35])
			RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 query selection
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]CustID:2; >; [Finished_Goods:26]ProductCode:1; >)
		BREAK LEVEL:C302(1; 1)
		C_REAL:C285(rPrice; rPriceSub; rPriceTotal; rMargin; rMarginSub; rMarginTotal)
		ACCUMULATE:C303([Finished_Goods:26]zCount:30; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11; real12; real13; real14; real15; rPrice)
		util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt1")
		FORM SET OUTPUT:C54([Finished_Goods:26]; "FGcostingRpt1")
		
		t2:="COSTED FINISHED GOODS INVENTORY"
		t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
		t3:="(includes FG, CC, & XC locations)"
		
		If (fSave)  //•1/31/97 if saving to disk insert titles 
			SEND PACKET:C103(vDoc; $Cr+$Cr+String:C10(Current date:C33)+$Tab+String:C10(Current time:C178)+$Cr)
			SEND PACKET:C103(vDoc; t2+$Cr+t2b+$Cr+t3+$Cr)
			SEND PACKET:C103(VDoc; ($Tab*3)+"TOTAL"+($Tab*5)+"VALUED"+($Tab*5)+"EXCESS"+$Cr)
			SEND PACKET:C103(vDoc; ""+$Tab+"TOTAL"+($Tab*4)+"TOTAL"+$Tab+"VALUED"+($Tab*4)+"TOTAL"+$Tab+"EXCESS"+($Tab*4)+"TOTAL"+$Cr)
			SEND PACKET:C103(vDoc; "CPN"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Cr)
		End if 
		PDF_setUp(<>pdfFileName)
		PRINT SELECTION:C60([Finished_Goods:26]; *)
		FORM SET OUTPUT:C54([Finished_Goods:26]; "List")
		READ WRITE:C146([Customers:16])  //••       
		
	: (<>MthEndSuite{$1}="Costed Examining Inventory")
		READ ONLY:C145([Customers:16])
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="Ex@")
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1; 1)
			
		Else 
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
			QUERY:C277([Finished_Goods:26]; [Finished_Goods_Locations:35]Location:2="Ex@")
			zwStatusMsg(""; "")
		End if   // END 4D Professional Services : January 2019 query selection
		
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]CustID:2; >; [Finished_Goods:26]ProductCode:1; >)
		BREAK LEVEL:C302(1; 1)
		ACCUMULATE:C303([Finished_Goods:26]zCount:30; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11; real12; real13; real14; real15)
		util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt2")
		FORM SET OUTPUT:C54([Finished_Goods:26]; "FGcostingRpt2")
		t2:="COSTED EXAMINING INVENTORY"
		t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
		t3:=""
		
		If (fSave)  //•1/31/97 if saving to disk insert titles      , 
			SEND PACKET:C103(vDoc; $Cr+$Cr+String:C10(Current date:C33)+$Tab+String:C10(Current time:C178)+$Cr)
			SEND PACKET:C103(vDoc; t2+$Cr+t2b+$Cr+t3+$Cr)
			SEND PACKET:C103(VDoc; ($Tab*3)+"TOTAL EXAMINING"+($Tab*5)+"EXPECTED YEILD"+($Tab*5)+"EXPECTED SCRAP"+$Cr)
			SEND PACKET:C103(vDoc; ""+$Tab+"TOTAL"+($Tab*4)+"TOTAL"+$Tab+"VALUED"+($Tab*4)+"TOTAL"+$Tab+"EXCESS"+($Tab*4)+"TOTAL"+$Cr)
			SEND PACKET:C103(vDoc; "CPN"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Cr)
		End if 
		PDF_setUp(<>pdfFileName)
		PRINT SELECTION:C60([Finished_Goods:26]; *)
		FORM SET OUTPUT:C54([Finished_Goods:26]; "List")
		READ WRITE:C146([Customers:16])  //••       
		
	: (<>MthEndSuite{$1}="Costed Examining Expected Yield Inventory")
		C_TEXT:C284(sCustid)
		C_TEXT:C284(sCustName)
		READ ONLY:C145([Customers:16])  //••                     
		
		MESSAGES OFF:C175
		//••• move this block of code to start of procedure & test for size of array -
		//• 1/28/97 -cs -using interprocess arrays generated by 'BatchThcCalc' to find,
		//store and access on hand quantities to try to speed up this report (others later
		// following block of mods intended to speed report processing
		// currently for use only in this report    
		
		<>InvCalcDone:=False:C215
		$id:=New process:C317("BatchFGinventor"; 64000; "BatchFGinventor")
		<>OrdCalcDone:=False:C215
		$id:=New process:C317("BatchOrdcalc"; 64000; "BatchOrdcalc")
		If (False:C215)  //insider reference 
			
			BatchOrdcalc
			BatchFGinventor
		End if 
		uMsgWindow("Gathering Data..."+$Cr)  //•1/31/97 cs messaging to allow user to know something is occuring
		
		$Count:=0
		Repeat   //wait until above process is completed
			$Count:=$Count+1
			If ($Count%2=0)
				MESSAGE:C88("Gathering Data..."+$Cr)
			Else 
				MESSAGE:C88("Still Gathering Data..."+$Cr)
			End if 
			DELAY PROCESS:C323(Current process:C322; 900)  //delay 15 seconds  
			
		Until (<>OrdCalcDone & <>InvCalcDone)
		CLOSE WINDOW:C154
		//end speed mods
		//••• move this block of code to start of procedure & test for size of array -
		//  ◊aFGKey to determine if re-running the above routines is needed.
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="Ex@")
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16; >; [Finished_Goods_Locations:35]ProductCode:1; >)
		//• 1/29/97 cs mods for speed, will probably 
		//need to do something similar for ech report contained in this routine
		
		ARRAY REAL:C219(arNum1; Records in selection:C76([Finished_Goods_Locations:35]))  //declare arrays
		ARRAY LONGINT:C221(al1; Records in selection:C76([Finished_Goods_Locations:35]))
		ARRAY INTEGER:C220($aJobItem; Records in selection:C76([Finished_Goods_Locations:35]))  //used for job form item number
		ARRAY TEXT:C222($aJobForm; Records in selection:C76([Finished_Goods_Locations:35]))
		ARRAY TEXT:C222($aCustId; Records in selection:C76([Finished_Goods_Locations:35]))
		ARRAY TEXT:C222($aCPN; Records in selection:C76([Finished_Goods_Locations:35]))
		ARRAY TEXT:C222(aFgKey; Records in selection:C76([Finished_Goods_Locations:35]))
		ARRAY TEXT:C222(aJobFrmItem; Records in selection:C76([Finished_Goods_Locations:35]))  //will contain jobform+ item number
		
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]PercentYield:17; arNum1; [Finished_Goods_Locations:35]JobForm:19; $aJobForm; [Finished_Goods_Locations:35]JobFormItem:32; $aJobItem; [Finished_Goods_Locations:35]QtyOH:9; al1; [Finished_Goods_Locations:35]CustID:16; $aCustId; [Finished_Goods_Locations:35]ProductCode:1; $aCpn)  //•1/28/ 97cs mod for report need percent yeild & job item for identity
		
		For ($i; 1; Size of array:C274($aJobForm))  //populate jobform item array (JMI Key)
			aFgKey{$i}:=$aCustId{$i}+":"+$aCpn{$i}
			aJobFrmItem{$I}:=$aJobForm{$i}+String:C10($aJobItem{$i})
		End for 
		ARRAY TEXT:C222($aCustId; 0)
		ARRAY TEXT:C222($aCPN; 0)
		ARRAY INTEGER:C220($aJobItem; 0)
		ARRAY TEXT:C222($aJobForm; 0)
		//end mods
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1; 1)
				CREATE SET:C116([Finished_Goods:26]; "Hold")
				
				uRelateSelect(->[Customers:16]ID:1; ->[Finished_Goods:26]CustID:2)
				
			Else 
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
				RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
				CREATE SET:C116([Finished_Goods:26]; "Hold")
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Customers:16])+" file. Please Wait...")
				RELATE ONE SELECTION:C349([Finished_Goods:26]; [Customers:16])
				zwStatusMsg(""; "")
				
			End if   // END 4D Professional Services : January 2019 query selection
			
		Else 
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
			RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Customers:16])+" file. Please Wait...")
			RELATE ONE SELECTION:C349([Finished_Goods:26]; [Customers:16])
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 
		
		ARRAY TEXT:C222(aCustName; Records in selection:C76([Customers:16]))
		ARRAY TEXT:C222(aCustID; Records in selection:C76([Customers:16]))
		SELECTION TO ARRAY:C260([Customers:16]ID:1; aCustid; [Customers:16]Name:2; aCustName)  //used for customer identification on report
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("hold")
			CLEAR SET:C117("Hold")
			
		Else 
			
			//WE DON't modifie [Finished_Goods]
		End if   // END 4D Professional Services : January 2019 query selection
		
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]CustID:2; >; [Finished_Goods:26]ProductCode:1; >)
		BREAK LEVEL:C302(1; 1)
		ACCUMULATE:C303([Finished_Goods:26]zCount:30; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11; real12; real13; real14; real15)
		util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt3")
		FORM SET OUTPUT:C54([Finished_Goods:26]; "FGcostingRpt3")
		t2:="COSTED EXAMINING EXPECTED YIELD INVENTORY"
		t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
		t3:="(includes CC with FG locations)"
		If (fSave)  //•1/31/97 if saving to disk insert titles      , 
			
			SEND PACKET:C103(vDoc; $Cr+$Cr+String:C10(Current date:C33)+$Tab+String:C10(Current time:C178)+$Cr)
			SEND PACKET:C103(vDoc; t2+$Cr+t2b+$Cr+t3+$Cr)
			SEND PACKET:C103(VDoc; ($Tab*3)+"TOTAL"+($Tab*5)+"VALUED"+($Tab*5)+"EXCESS"+$Cr)
			SEND PACKET:C103(vDoc; ""+$Tab+"TOTAL"+($Tab*4)+"TOTAL"+$Tab+"VALUED"+($Tab*4)+"TOTAL"+$Tab+"EXCESS"+($Tab*4)+"TOTAL"+$Cr)
			SEND PACKET:C103(vDoc; "CPN"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Cr)
		End if 
		MESSAGES ON:C181
		PDF_setUp(<>pdfFileName)
		PRINT SELECTION:C60([Finished_Goods:26]; *)
		FORM SET OUTPUT:C54([Finished_Goods:26]; "List")
		READ WRITE:C146([Customers:16])  //••    
		
	: (<>MthEndSuite{$1}="Costed Bill & Hold Inventory")  //•061295  MLB  UPR 1640
		READ ONLY:C145([Customers:16])
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="BH@")
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1; 1)
			
			
		Else 
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
			QUERY:C277([Finished_Goods:26]; [Finished_Goods_Locations:35]Location:2="BH@")
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 query selection
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]CustID:2; >; [Finished_Goods:26]ProductCode:1; >)
		BREAK LEVEL:C302(1; 1)
		ACCUMULATE:C303([Finished_Goods:26]zCount:30; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11; real12; real13; real14; real15)
		util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt1")
		FORM SET OUTPUT:C54([Finished_Goods:26]; "FGcostingRpt1")
		t2:="COSTED BILL & HOLD INVENTORY"
		t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
		t3:=""
		
		If (fSave)  //•1/31/97 if saving to disk insert titles      , 
			SEND PACKET:C103(vDoc; $Cr+$Cr+String:C10(Current date:C33)+$Tab+String:C10(Current time:C178)+$Cr)
			SEND PACKET:C103(vDoc; t2+$Cr+t2b+$Cr+t3+$Cr)
			SEND PACKET:C103(VDoc; ($Tab*3)+"TOTAL"+($Tab*5)+"VALUED"+($Tab*5)+"EXCESS"+$Cr)
			SEND PACKET:C103(vDoc; ""+$Tab+"TOTAL"+($Tab*4)+"TOTAL"+$Tab+"VALUED"+($Tab*4)+"TOTAL"+$Tab+"EXCESS"+($Tab*4)+"TOTAL"+$Cr)
			SEND PACKET:C103(vDoc; "CPN"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Cr)
		End if 
		PDF_setUp(<>pdfFileName)
		PRINT SELECTION:C60([Finished_Goods:26]; *)
		FORM SET OUTPUT:C54([Finished_Goods:26]; "List")
		READ WRITE:C146([Customers:16])  //••   
		
	: (Position:C15("Costed F/G Inventory"; <>MthEndSuite{$1})>0)
		//◊OrdBatchDat:=!00/00/00!
		
		//BatchOrdcalc 
		
		READ ONLY:C145([Customers:16])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC:@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC:@")
			CREATE SET:C116([Finished_Goods_Locations:35]; "all")
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:A@")
			CREATE SET:C116([Finished_Goods_Locations:35]; "PayU")
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:R@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC:R@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC:R@")
			CREATE SET:C116([Finished_Goods_Locations:35]; "Roan")
			
			UNION:C120("Roan"; "PayU"; "others")
			
			DIFFERENCE:C122("all"; "others"; "Haup")
			CLEAR SET:C117("others")
			CLEAR SET:C117("all")
			
		Else 
			
			//call it when we use it
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		
		Case of 
			: (Substring:C12(<>MthEndSuite{$1}; 1; 1)="P")  //PayUse
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
					
					USE SET:C118("PayU")
					
				Else 
					
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:A@")
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				<>FgBatchDat:=!00-00-00!
				BatchFGinventor(0)
				
			: (Substring:C12(<>MthEndSuite{$1}; 1; 1)="H")  //Hauppauge
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
					
					USE SET:C118("PayU")
					BatchFGinventor(0; ""; Into current selection:K19:1)  //consume open demand with payuse invenotry first  
					
					USE SET:C118("Haup")
				Else 
					
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:A@")
					BatchFGinventor(0; ""; Into current selection:K19:1)  //consume open demand with payuse invenotry first  
					
					QUERY BY FORMULA:C48([Finished_Goods_Locations:35]; \
						(\
						([Finished_Goods_Locations:35]Location:2="FG:@")\
						 | ([Finished_Goods_Locations:35]Location:2="CC:@")\
						 | ([Finished_Goods_Locations:35]Location:2="XC:@")\
						)\
						 & ([Finished_Goods_Locations:35]Location:2#"FG:A@")\
						 & ([Finished_Goods_Locations:35]Location:2#"FG:R@")\
						 & ([Finished_Goods_Locations:35]Location:2#"CC:R@")\
						 & ([Finished_Goods_Locations:35]Location:2#"XC:R@")\
						)
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				
				
			: (Substring:C12(<>MthEndSuite{$1}; 1; 1)="R")
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
					UNION:C120("Haup"; "PayU"; "others")
					USE SET:C118("others")
					CLEAR SET:C117("others")
					<>FgBatchDat:=!00-00-00!
					BatchFGinventor(0; ""; Into current selection:K19:1)  //consume open demand with PayU&Hauppauge invenotry first  
					
					USE SET:C118("Roan")
					
				Else 
					QUERY BY FORMULA:C48([Finished_Goods_Locations:35]; (\
						(\
						([Finished_Goods_Locations:35]Location:2="FG:@")\
						 | ([Finished_Goods_Locations:35]Location:2="CC:@")\
						 | ([Finished_Goods_Locations:35]Location:2="XC:@")\
						)\
						 & ([Finished_Goods_Locations:35]Location:2#"FG:A@")\
						 & ([Finished_Goods_Locations:35]Location:2#"FG:R@")\
						 & ([Finished_Goods_Locations:35]Location:2#"CC:R@")\
						 & ([Finished_Goods_Locations:35]Location:2#"XC:R@")\
						) | \
						([Finished_Goods_Locations:35]Location:2="FG:A@")\
						)
					
					
					<>FgBatchDat:=!00-00-00!
					BatchFGinventor(0; ""; Into current selection:K19:1)  //consume open demand with PayU&Hauppauge invenotry first  
					
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:R@"; *)
					QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC:R@"; *)
					QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC:R@")
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				
		End case 
		
		//SEARCH([FG_Locations];[FG_Locations]CustID="00019")   ` FOR DEBUGGING
		CREATE SET:C116([Finished_Goods_Locations:35]; "whichWarehouse")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CLEAR SET:C117("Roan")
			CLEAR SET:C117("Haup")
			CLEAR SET:C117("PayU")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1; 1)
			
			
		Else 
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
			RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 query selection
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]CustID:2; >; [Finished_Goods:26]ProductCode:1; >)
		BREAK LEVEL:C302(1; 1)
		C_REAL:C285(rPrice; rPriceSub; rPriceTotal; rMargin; rMarginSub; rMarginTotal)
		ACCUMULATE:C303([Finished_Goods:26]zCount:30; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11; real12; real13; real14; real15; rPrice)
		util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt6")
		FORM SET OUTPUT:C54([Finished_Goods:26]; "FGcostingRpt6")
		t2:=<>MthEndSuite{$1}
		t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
		t3:="(includes FG, CC, & XC locations)"
		
		If (fSave)  //•1/31/97 if saving to disk insert titles      , 
			SEND PACKET:C103(vDoc; $Cr+$Cr+String:C10(Current date:C33)+$Tab+String:C10(Current time:C178)+$Cr)
			SEND PACKET:C103(vDoc; t2+$Cr+t2b+$Cr+t3+$Cr)
			SEND PACKET:C103(VDoc; ($Tab*3)+"TOTAL"+($Tab*5)+"VALUED"+($Tab*5)+"EXCESS"+$Cr)
			SEND PACKET:C103(vDoc; ""+$Tab+"TOTAL"+($Tab*4)+"TOTAL"+$Tab+"VALUED"+($Tab*4)+"TOTAL"+$Tab+"EXCESS"+($Tab*4)+"TOTAL"+$Cr)
			SEND PACKET:C103(vDoc; "CPN"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Tab+"QUANTITY"+$Tab+"MATERIAL"+$Tab+"LABOR"+$Tab+"BURDEN"+$Tab+"COST"+$Cr)
		End if 
		PDF_setUp(<>pdfFileName)
		PRINT SELECTION:C60([Finished_Goods:26]; *)
		FORM SET OUTPUT:C54([Finished_Goods:26]; "List")
		READ WRITE:C146([Customers:16])  //••   
		
		CLEAR SET:C117("whichWarehouse")
End case 