//%attributes = {"publishedWeb":true}
//(S) [ReleaseSchedule]'List'bInclude
//• 1/22/98 cs added print settings
//• 3/23/98 cs added new version of report upr 1938

C_LONGINT:C283($bol_number)

NewWindow(230; 380; 6; 1)
DIALOG:C40([Customers_ReleaseSchedules:46]; "PickReport_dio")
CLOSE WINDOW:C154

$bol_number:=0
If (ok=1)
	util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "PickList4b")
	PRINT SETTINGS:C106
	
	If (OK=1)
		READ ONLY:C145([Customers:16])  //••
		dAsof:=4D_Current_date
		tTime:=4d_Current_time
		xReptTitle:="Finished Goods Release List"
		
		Case of 
			: (byShipToCPN=1)
				If (bSendToWMS=1)  //
					FIRST RECORD:C50([Customers_ReleaseSchedules:46])
					C_TEXT:C284(SetNameToSend)
					SetNameToSend:=BOL_AcceptableReleaseBatch  // will leave us with a set that is ok to ship
					USE SET:C118(SetNameToSend)
					
					//now going to make 1 bol for each combination of billto, shipto, and payuse
					ARRAY TEXT:C222($aShipTos; 0)
					ARRAY TEXT:C222($aBillTos; 0)
					ARRAY INTEGER:C220($aPayUse; 0)
					ARRAY TEXT:C222($aKeyType; 0)
					SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Shipto:10; $aShipTos; [Customers_ReleaseSchedules:46]Billto:22; $aBillTos; [Customers_ReleaseSchedules:46]PayU:31; $aPayUse; [Customers_ReleaseSchedules:46]Billto_BOL:43; $aBillBOL; [Customers_ReleaseSchedules:46]CustID:12; $aCustID)
					For ($i; 1; Size of array:C274($aShipTos))
						$key:=String:C10($aPayUse{$i})+String:C10(Num:C11($aShipTos{$i}); "00000")+String:C10(Num:C11($aCustID{$i}); "00000")+String:C10(Num:C11($aBillTos{$i}); "00000")+String:C10(Num:C11($aBillBOL{$i}); "00000")
						$hit:=Find in array:C230($aKeyType; $key)
						If ($hit=-1)
							APPEND TO ARRAY:C911($aKeyType; $key)
						End if 
					End for 
					
					//validate each release and create a bol for each unique shipto in the selected records,
					//look for pending bol's to that shipto on offer to append it if desired 
					For ($i; 1; Size of array:C274($aKeyType))
						$payuse:=Substring:C12($aKeyType{$i}; 1; 1)  //0
						$dest:=Substring:C12($aKeyType{$i}; 2; 5)  //100000`if n/a, it wont be found in searches
						$cust:=Substring:C12($aKeyType{$i}; 7; 5)  //12345600000
						$billto:=Substring:C12($aKeyType{$i}; 12; 5)  //1234567890100000
						If ($billto="00000")  //this should let bill and holds ship
							$billto:="n/a"
						End if 
						$billBOL:=Substring:C12($aKeyType{$i}; 17; 5)  //123456789012345600000
						If ($billBOL="00000")
							$billBOL:=""
						End if 
						USE SET:C118(SetNameToSend)  //remove releases to from old BOL
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$dest; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto:22=$billto; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31=$payuse; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=$cust; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto_BOL:43=$billBOL; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]B_O_L_pending:45#0)
						
						
						If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
							uConfirm(String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" releases have pending BOL's, Do you want to put them on a new BOL?"; "New BOL"; "Ignor them")
							If (ok=1)
								SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]B_O_L_pending:45; $aRemoveBOL; [Customers_ReleaseSchedules:46]ReleaseNumber:1; $aRemoveRelease)
								$numRels:=Size of array:C274($aRemoveBOL)
								ARRAY LONGINT:C221($aZeroBOL; $numRels)
								ARRAY TEXT:C222($aClearExpedite; $numRels)
								ARRAY LONGINT:C221($aUniqueBOL; 0)
								For ($zeroIt; 1; $numRels)
									$aZeroBOL{$zeroIt}:=0
									$aClearExpedite{$zeroIt}:=""
									$hit:=Find in array:C230($aUniqueBOL; $aRemoveBOL{$zeroIt})  //going to process each bol in next step
									If ($hit=-1)
										APPEND TO ARRAY:C911($aUniqueBOL; $aRemoveBOL{$zeroIt})
									End if 
								End for 
								FIRST RECORD:C50([Customers_ReleaseSchedules:46])
								ARRAY TO SELECTION:C261($aZeroBOL; [Customers_ReleaseSchedules:46]B_O_L_pending:45; $aClearExpedite; [Customers_ReleaseSchedules:46]Expedite:35)  //clear the refer
								ARRAY LONGINT:C221($aZeroBOL; 0)  //done with this
								ARRAY TEXT:C222($aClearExpedite; 0)  //done with this
								SORT ARRAY:C229($aUniqueBOL; >)
								SORT ARRAY:C229($aRemoveBOL; $aRemoveRelease; >)
								
								For ($bol; 1; Size of array:C274($aUniqueBOL))  //focus on each bol, deal with its releases, then move on
									QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=$aUniqueBOL{$bol})
									If (BLOB size:C605([Customers_Bills_of_Lading:49]BinPicks:27)>0)
										BOL_ListBox1("restore-from-blob")
										
										For ($rel; 1; Size of array:C274($aRemoveRelease))  //each release, clear it if its on the bol that is in focus
											If ($aRemoveBOL{$rel}=$aUniqueBOL{$bol})
												$hit:=Find in array:C230(aReleases; $aRemoveRelease{$rel})
												If ($hit>-1)
													DELETE FROM ARRAY:C228(aReleases; $hit; 1)
													DELETE FROM ARRAY:C228(aCPN2; $hit; 1)
													DELETE FROM ARRAY:C228(aLocation2; $hit; 1)
													DELETE FROM ARRAY:C228(aRecNo2; $hit; 1)
													DELETE FROM ARRAY:C228(aNumCases2; $hit; 1)
													DELETE FROM ARRAY:C228(aPackQty2; $hit; 1)
													DELETE FROM ARRAY:C228(aTotalPicked2; $hit; 1)
													DELETE FROM ARRAY:C228(aWgt2; $hit; 1)
													DELETE FROM ARRAY:C228(aPallet2; $hit; 1)
													DELETE FROM ARRAY:C228(aJobit2; $hit; 1)
													DELETE FROM ARRAY:C228(arValues; $hit; 1)
												End if 
											End if 
										End for   //each bol/release pair
										
										BOL_ListBox1("save-to-blob")
										SAVE RECORD:C53([Customers_Bills_of_Lading:49])
									End if 
								End for   //unique bol
							End if 
						End if 
						
						USE SET:C118(SetNameToSend)  //add releases to new BOL
						
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$dest; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto:22=$billto; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31=$payuse; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=$cust; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto_BOL:43=$billBOL; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]B_O_L_pending:45=0)
						
						
						If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)  //create a bol and stamp each release with it
							REDUCE SELECTION:C351([Customers_Bills_of_Lading:49]; 0)
							CREATE RECORD:C68([Customers_Bills_of_Lading:49])
							BOL_ListBox1("init")
							$bol_number:=app_AutoIncrement(->[Customers_Bills_of_Lading:49])
							[Customers_Bills_of_Lading:49]ShippersNo:1:=$bol_number
							zwStatusMsg("NEW BOL"; "Creating BOL# "+String:C10($bol_number))
							[Customers_Bills_of_Lading:49]zCount:6:=1
							[Customers_Bills_of_Lading:49]Status:32:="Sent to WMS"
							[Customers_Bills_of_Lading:49]ShipDate:20:=4D_Current_date  //4/5/95 use ship date for xactions and invoice
							If (User in group:C338(Current user:C182; "Roanoke"))  //• mlb - 8/9/01  11:07 for flexware acct number
								[Customers_Bills_of_Lading:49]ShippedFrom:5:="2"
							Else 
								[Customers_Bills_of_Lading:49]ShippedFrom:5:="1"
							End if 
							
							[Customers_Bills_of_Lading:49]CustID:2:=$cust
							[Customers_Bills_of_Lading:49]ShipTo:3:=$dest
							[Customers_Bills_of_Lading:49]BillTo:4:=$billto
							[Customers_Bills_of_Lading:49]BillTo_BOL:25:=[Customers_ReleaseSchedules:46]Billto_BOL:43
							[Customers_Bills_of_Lading:49]PayUseFlag:11:=Num:C11($payuse)
							[Customers_Bills_of_Lading:49]PayUse:23:=([Customers_Bills_of_Lading:49]PayUseFlag:11=1)
							[Customers_Bills_of_Lading:49]WasBilled:29:=False:C215
							[Customers_Bills_of_Lading:49]SentToWMS:31:=True:C214
							
							zwStatusMsg("NEW BOL"; "Created BOL# "+String:C10($bol_number))
							If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
								
								ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1; >)
								For ($rel; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
									APPEND TO ARRAY:C911(aReleases; [Customers_ReleaseSchedules:46]ReleaseNumber:1)
									APPEND TO ARRAY:C911(aCPN2; [Customers_ReleaseSchedules:46]ProductCode:11)
									APPEND TO ARRAY:C911(aLocation2; "Sent-To-WMS")
									APPEND TO ARRAY:C911(aJobit2; "T.B.D.")
									xMemo:=""  //pack up a bundle of reference info
									$rtnText:=util_TaggedText("put"; "orderline"; [Customers_ReleaseSchedules:46]OrderLine:4; ->xMemo)
									$rtnText:=util_TaggedText("put"; "remark1"; [Customers_ReleaseSchedules:46]RemarkLine1:25; ->xMemo)
									$rtnText:=util_TaggedText("put"; "remark2"; [Customers_ReleaseSchedules:46]RemarkLine2:26; ->xMemo)
									$rtnText:=util_TaggedText("put"; "sch-qty"; String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6); ->xMemo)
									$rtnText:=util_TaggedText("put"; "cust-refer"; [Customers_ReleaseSchedules:46]CustomerRefer:3; ->xMemo)
									
									RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
									If (Records in selection:C76([Customers_Order_Lines:41])>0)
										$rtnText:=util_TaggedText("put"; "cust-po"; [Customers_Order_Lines:41]PONumber:21; ->xMemo)
									Else 
										$rtnText:=util_TaggedText("put"; "cust-po"; "OL:"+[Customers_ReleaseSchedules:46]OrderLine:4+"N/F"; ->xMemo)
									End if 
									$rtnText:=util_TaggedText("put"; "cust-id"; [Customers_ReleaseSchedules:46]CustID:12; ->xMemo)
									APPEND TO ARRAY:C911(arValues; xMemo)
									
									//[Customers_ReleaseSchedules]B_O_L_pending:=$bol_number
									//SAVE RECORD([Customers_ReleaseSchedules])
									NEXT RECORD:C51([Customers_ReleaseSchedules:46])
								End for 
								
								UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])  //can't be locked when bol trigger runs
								REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
								
								
							Else 
								
								//Laghzaoui replace next by selection  and unlod and reduce by reduce and ordre by by sort
								
								SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ReleaseNumber:1; $_ReleaseNumber; \
									[Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
									[Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine; \
									[Customers_ReleaseSchedules:46]RemarkLine1:25; $_RemarkLine1; \
									[Customers_ReleaseSchedules:46]RemarkLine2:26; $_RemarkLine2; \
									[Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; \
									[Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer; \
									[Customers_ReleaseSchedules:46]CustID:12; $_CustID)
								
								SORT ARRAY:C229($_ReleaseNumber; $_ProductCode; $_OrderLine; $_RemarkLine1; $_RemarkLine2; $_Sched_Qty; $_CustomerRefer; $_CustID; >)
								
								For ($rel; 1; Size of array:C274($_ReleaseNumber); 1)
									APPEND TO ARRAY:C911(aReleases; $_ReleaseNumber{$rel})
									APPEND TO ARRAY:C911(aCPN2; $_ProductCode{$rel})
									APPEND TO ARRAY:C911(aLocation2; "Sent-To-WMS")
									APPEND TO ARRAY:C911(aJobit2; "T.B.D.")
									xMemo:=""  //pack up a bundle of reference info
									$rtnText:=util_TaggedText("put"; "orderline"; $_OrderLine{$rel}; ->xMemo)
									$rtnText:=util_TaggedText("put"; "remark1"; $_RemarkLine1{$rel}; ->xMemo)
									$rtnText:=util_TaggedText("put"; "remark2"; $_RemarkLine2{$rel}; ->xMemo)
									$rtnText:=util_TaggedText("put"; "sch-qty"; String:C10($_Sched_Qty{$rel}); ->xMemo)
									$rtnText:=util_TaggedText("put"; "cust-refer"; $_CustomerRefer{$rel}; ->xMemo)
									
									QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$_OrderLine{$rel})
									If (Records in selection:C76([Customers_Order_Lines:41])>0)
										$rtnText:=util_TaggedText("put"; "cust-po"; [Customers_Order_Lines:41]PONumber:21; ->xMemo)
									Else 
										$rtnText:=util_TaggedText("put"; "cust-po"; "OL:"+$_OrderLine{$rel}+"N/F"; ->xMemo)
									End if 
									$rtnText:=util_TaggedText("put"; "cust-id"; $_CustID{$rel}; ->xMemo)
									APPEND TO ARRAY:C911(arValues; xMemo)
								End for 
								
								
								REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
								
							End if   // END 4D Professional Services : January 2019 
							
							$numRels:=Size of array:C274(aReleases)
							ARRAY LONGINT:C221(aNumCases2; $numRels)
							ARRAY LONGINT:C221(aPackQty2; $numRels)
							ARRAY LONGINT:C221(aTotalPicked2; $numRels)
							ARRAY LONGINT:C221(aWgt2; $numRels)
							ARRAY LONGINT:C221(aRecNo2; $numRels)
							ARRAY TEXT:C222(aPallet2; $numRels)
							BOL_ListBox1("save-to-blob")
							SAVE RECORD:C53([Customers_Bills_of_Lading:49])
							UNLOAD RECORD:C212([Customers_Bills_of_Lading:49])
						End if 
					End for 
					
					USE SET:C118(SetNameToSend)
					wms_api_SendReleases  // ($bol_number)
					CLEAR SET:C117(SetNameToSend)
				End if 
				
				Case of 
					: (sortRel=1)
						ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1; >)
					: (sortShip=1)
						ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
					Else 
						ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3; >)
				End case 
				
				
				BREAK LEVEL:C302(2; 1)
				ACCUMULATE:C303([Customers_ReleaseSchedules:46]OpenQty:16)
				xReptTitle:="Release Pick Sheet"
				xComment:="'one page per release'"
				FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList4b")
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
					
					COPY NAMED SELECTION:C331([Customers_ReleaseSchedules:46]; "OnePagers")
					C_LONGINT:C283($i)
					ON EVENT CALL:C190("eCancelProc")
					<>fContinue:=True:C214
					$rels:=Records in selection:C76([Customers_ReleaseSchedules:46])
					For ($i; 1; $rels)
						USE NAMED SELECTION:C332("OnePagers")
						GOTO SELECTED RECORD:C245([Customers_ReleaseSchedules:46]; $i)
						ONE RECORD SELECT:C189([Customers_ReleaseSchedules:46])
						$docName:="Pick_"+[Customers_ReleaseSchedules:46]ProductCode:11+"_"+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+".pdf"
						If (Length:C16($docName)>31)
							$docName:="Pick_"+[Customers_ReleaseSchedules:46]ProductCode:11+"_"+String:C10($i)+".pdf"
						End if 
						PDF_setUp($docName)
						PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
						If (Not:C34(<>fContinue))
							$i:=$i+$rels
						End if 
					End for 
					USE NAMED SELECTION:C332("OnePagers")
					CLEAR NAMED SELECTION:C333("OnePagers")
					ON EVENT CALL:C190("")
					
				Else 
					
					ARRAY LONGINT:C221($_OnePagers; 0)
					LONGINT ARRAY FROM SELECTION:C647([Customers_ReleaseSchedules:46]; $_OnePagers)
					C_LONGINT:C283($i)
					ON EVENT CALL:C190("eCancelProc")
					<>fContinue:=True:C214
					$rels:=Size of array:C274($_OnePagers)
					For ($i; 1; $rels)
						GOTO RECORD:C242([Customers_ReleaseSchedules:46]; $_OnePagers{$i})
						$docName:="Pick_"+[Customers_ReleaseSchedules:46]ProductCode:11+"_"+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+".pdf"
						If (Length:C16($docName)>31)
							$docName:="Pick_"+[Customers_ReleaseSchedules:46]ProductCode:11+"_"+String:C10($i)+".pdf"
						End if 
						PDF_setUp($docName)
						PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
						If (Not:C34(<>fContinue))
							$i:=$i+$rels
						End if 
					End for 
					CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_OnePagers)
					
					ON EVENT CALL:C190("")
					
				End if   // END 4D Professional Services : January 2019 query selection
				
			: (byOrder=1)
				ORDER BY:C49([Customers_ReleaseSchedules:46]OrderNumber:2; >; [Customers_ReleaseSchedules:46]ProductCode:11; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
				BREAK LEVEL:C302(2; 1)
				ACCUMULATE:C303([Customers_ReleaseSchedules:46]OpenQty:16)
				xComment:="sorted by Order Nº, Product Code, and Scheduled Release Date"
				FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList1")
				PRINT SELECTION:C60([Customers_ReleaseSchedules:46])
				
			: (byDate=1)
				ORDER BY:C49([Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]Shipto:10; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
				BREAK LEVEL:C302(2; 1)
				ACCUMULATE:C303([Customers_ReleaseSchedules:46]OpenQty:16)
				xComment:="sorted by Scheduled Release Date, Ship To, and Product Code"
				FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList2")
				PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
				
			: (byCPN=1)
				ORDER BY:C49([Customers_ReleaseSchedules:46]ProductCode:11; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]Shipto:10; >)
				BREAK LEVEL:C302(2; 1)
				ACCUMULATE:C303([Customers_ReleaseSchedules:46]OpenQty:16)
				xComment:="sorted by Product Code, Scheduled Release Date, and Ship To"
				FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList3")
				PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
				
			: (byShipTo=1)
				ORDER BY:C49([Customers_ReleaseSchedules:46]Shipto:10; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
				BREAK LEVEL:C302(2; 1)
				ACCUMULATE:C303([Customers_ReleaseSchedules:46]OpenQty:16)
				xComment:="sorted by Ship to, Scheduled Release Date and Product Code"
				FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList4b")
				PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
				
			: (byCustId=1)
				ORDER BY:C49([Customers_ReleaseSchedules:46]CustID:12; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
				BREAK LEVEL:C302(2; 1)
				ACCUMULATE:C303([Customers_ReleaseSchedules:46]OpenQty:16)
				xComment:="sorted by Customer Id, Scheduled Release Date and Product Code"
				FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList5")
				PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
				
			: (byOpenRel=1)
				ORDER BY:C49([Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]Shipto:10; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
				//BREAK LEVEL(2;1)
				//ACCUMULATE([ReleaseSchedule]OpenQty)
				xComment:="sorted by Scheduled Release Date; only count 'FG:' bin quantities"
				FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList6")
				PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
				
			: (byOpenRel2=1)  //• 3/23/98 cs new picklist version upr 1938
				ORDER BY:C49([Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]Shipto:10; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
				xComment:="sorted by Scheduled Release Date; only count 'FG:' bin quantities"
				util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "PickList7")  //• 3/23/98 cs prints at 98%
				FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "PickList7")
				PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
				
		End case 
		
		FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "ReleaseMgmt")
		
		If (bPickSheet=1)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				uRelateSelect(->[Finished_Goods_Locations:35]ProductCode:1; ->[Customers_ReleaseSchedules:46]ProductCode:11; 0)
				
			Else 
				ARRAY TEXT:C222($_ProductCode; 0)
				DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode)
				QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
				
			End if   // END 4D Professional Services : January 2019 query selection
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "PickINCD")
				ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1; >; [Finished_Goods_Locations:35]JobForm:19; >; [Finished_Goods_Locations:35]Location:2; >)
				ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9)
				BREAK LEVEL:C302(1; 1)
				PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
				FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")
			End if 
		End if 
		READ WRITE:C146([Customers:16])
	End if 
End if 