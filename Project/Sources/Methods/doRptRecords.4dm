//%attributes = {"publishedWeb":true}
//Procedure: doRptRecords()  MLB
//group various reports together
//•030596  MLB allow multi print cust orders
//•022597  MLB  clear some selections
//• 5/23/97 cs try to stop records being grabbed in readwrite wile printing
//•030398  MLB  add Change History
//  this is causing a locking problem sometimes.

C_TEXT:C284($rptAlias)
C_LONGINT:C283($j)

$rptAlias:=<>whichRpt
uSetUp(1; 1)
Open window:C153(2; 40; 638; 478; 8; fNameWindow(filePtr)+" Reporting")
NumRecs1:=fSelectBy  //generic search equal or range on any four fields 

If (OK=1)  //performed search  
	If (NumRecs1>1)
		CONFIRM:C162("You are About to Print "+String:C10(NumRecs1)+" Item(s) on the Selected Report."+<>sCr+"Continue?")
	Else 
		OK:=1
	End if 
	
	If (OK=1)
		SET WINDOW TITLE:C213(fNameWindow(filePtr)+" "+$rptAlias)
		Case of 
			: ($rptAlias="RFQ")
				HelpCode:=71
				ESTIMATE_ReadOnly  //• 5/23/97 cs make estmate & related read only while printing
				rRpt_1_RFQ
				uClearEstimates
				ESTIMATE_ReadWrite  //• 5/23/97 cs make estmate & related read /write now that printing is done
			: ($rptAlias="Quote")  //Estimate
				HelpCode:=71
				ESTIMATE_ReadOnly  //• 5/23/97 cs make estmate & related read only while printing
				rRpt_1_Quote
				uClearEstimates
				ESTIMATE_ReadWrite  //• 5/23/97 cs make estmate & related read /write now that printing is done
			: ($rptAlias="Estimate Worksheet")
				BEEP:C151
				ALERT:C41("Estimate Worksheet not implemented")
			: ($rptAlias="Cost & Qty Estimate")
				ESTIMATE_ReadOnly  //• 5/23/97 cs make estmate & related read only while printing        
				rRptEstimate
				uClearEstimates
				ESTIMATE_ReadWrite  //• 5/23/97 cs make estmate & related read /write now that printing is done       
			: ($rptAlias="Quantity Estimate")
				ESTIMATE_ReadOnly  //• 5/23/97 cs make estmate & related read only while printing        
				rRptEstimateQty
				uClearEstimates
				ESTIMATE_ReadWrite  //• 5/23/97 cs make estmate & related read /write now that printing is done
			: ($rptAlias="Preparatory Costs")
				ESTIMATE_ReadOnly  //• 5/23/97 cs make estmate & related read only while printing        
				rRptEst_Prep
				uClearEstimates
				ESTIMATE_ReadWrite  //• 5/23/97 cs make estmate & related read /write now that printing is done
			: ($rptAlias="Cust_Order")  //•030596  MLB allow multi print cust orders
				READ ONLY:C145([Customers_Order_Lines:41])
				util_PAGE_SETUP(->[Estimates:17]; "Est.H1")
				PRINT SETTINGS:C106
				
				If (OK=1)
					
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
						COPY NAMED SELECTION:C331([Customers_Orders:40]; "OnePagers")
						C_LONGINT:C283($i; $rels)
						ON EVENT CALL:C190("eCancelProc")
						<>fContinue:=True:C214
						$rels:=Records in selection:C76([Customers_Orders:40])
						For ($i; 1; $rels)
							USE NAMED SELECTION:C332("OnePagers")
							GOTO SELECTED RECORD:C245([Customers_Orders:40]; $i)
							ONE RECORD SELECT:C189([Customers_Orders:40])
							rRptOrder(1)
							
							If (Not:C34(<>fContinue))
								$i:=$i+$rels
							End if 
						End for 
						USE NAMED SELECTION:C332("OnePagers")
						CLEAR NAMED SELECTION:C333("OnePagers")
						ON EVENT CALL:C190("")
					Else 
						
						C_LONGINT:C283($i; $rels)
						ON EVENT CALL:C190("eCancelProc")
						<>fContinue:=True:C214
						$rels:=Records in selection:C76([Customers_Orders:40])
						ARRAY LONGINT:C221($_record_number; 0)
						LONGINT ARRAY FROM SELECTION:C647([Customers_Orders:40]; $_record_number)
						$rels:=Size of array:C274($_record_number)
						For ($i; 1; $rels)
							GOTO RECORD:C242([Customers_Orders:40]; $_record_number{$i})
							rRptOrder(1)
							
							If (Not:C34(<>fContinue))
								$i:=$i+$rels
							End if 
						End for 
						CREATE SELECTION FROM ARRAY:C640([Customers_Orders:40]; $_record_number)
						
						ON EVENT CALL:C190("")
					End if   // END 4D Professional Services : January 2019 query selection
					
					
				End if 
				READ WRITE:C146([Customers_Order_Lines:41])
			: ($rptAlias="Change Order")
				rRptCustChgOrd
			: ($rptAlias="Change History")
				rptChangHistor
				
			: ($rptAlias="Order Quote")
				rRptCOQuote
			: ($rptAlias="Shortage Report")
				rRptCOShortages
			: ($rptAlias="Endorsement")
				HelpCode:=80
				PRINT SETTINGS:C106
				For ($j; 1; NumRecs1)
					USE SET:C118("all")
				End for 
				CLEAR SET:C117("all")
				//--- PURCHASE ORDER REPORTS 
			: ($rptAlias="PO Status")
				rRptPOStat
			: ($rptAlias="PO Listing")
				rRptPOList
				//--- PO CLAUSE REPORTS
			: ($rptAlias="PO Clause Summary")
				rRptCIDSumry
			: ($rptAlias="PO Clause Listing")
				rRptCIDList
				//--- VENDOR REPORTS
			: ($rptAlias="Vendor Listing")
				rRptVendList
			: ($rptAlias="Performance")
				rRptVendPerf
				//---AD HOC REPORTS
			: ($rptAlias="Listing")
				rRptGeneric(1)
			: ($rptAlias="Labels")
				rRptGeneric(2)
			: ($rptAlias="Letter")
				rRptGeneric(3)
			: ($rptAlias="Miscellaneous")
				//        rRptMisc
				//: ($rptAlias="Help Item Report")
				//uHelpRept2 `• 8/20/97 cs removed help system
			: ($rptAlias="Cost Center Listing")
				rRptCCList
				//--Salesman Listing
			: ($rptAlias="Salesman Listing")
				rRptSaleList
				//--Customer Detail Report
			: ($rptAlias="Customer Detail Report")
				rRptCustDet
				
				
			Else 
				BEEP:C151
				ALERT:C41($rptAlias+" is not available.")
		End case 
		CLOSE WINDOW:C154
	End if   //ok search
End if   //confirm # of records
UNLOAD RECORD:C212(filePtr->)
// uClearTextVars
uSetUp(0; 0)