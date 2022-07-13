//%attributes = {}
// ----------------------------------------------------
// Method: EDI_send_reponse
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/11/09, 11:27:16
//
// Modified by: Mel Bohince (10/29/10) exclude line items without a [Customers_Orders]edi_sender_id
// Modified by: Mel Bohince (4/24/20) add test account


C_BOOLEAN:C305(<>fContinue; <>DEBUGGING)
C_REAL:C285($price)  //mlb 070903 suddenly UOM of price is a problem
C_LONGINT:C283($sendThisOrder; $1; <>BlockSize; $lUniqueMessageID; $edi_segment_counter; $errCode; $timeStamp; $i; $numOrderHeaders; $j)
C_TEXT:C284($date; $time; $currency)
C_TEXT:C284($now)
C_TEXT:C284($tMessageHeader; $tSegDel; $tElDel; $tSubElDel; $tAccountID; $errText; $arkay_edi_id; $po)
C_TEXT:C284($tDomAcctID; $tIntlAcctID; $tSAPAcctID; $ICN_PLACE_HOLDER; $tHeader; $tResponseFooter; $tAccount_Name)

ON EVENT CALL:C190("eCancelProc")

<>fContinue:=True:C214  //set this to true to undo the setting of Sent flags 
<>BlockSize:=28000  // limitor for text variable
$date:=fYYMMDD(Current date:C33)
$time:=Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
$now:=$date+"."+$time
$timeStamp:=TSTimeStamp
$currency:="USD"  // assert [Customers_Orders]Currency  `"USD"  `****** may need to deal with Euro's with SAP
$tDomAcctID:="5164547103"  //set up for switch statement to differenciate style of response
$tIntlAcctID:="BEESL.ESL001"  //[Order]Senders_EDI_ID holds the comparison from the mapping step
$tSAPAcctID:="6315311578"
$tSAPtestID:="6314547000Q"  // Modified by: Mel Bohince (4/24/20) add test account

If (Count parameters:C259=1)
	$sendThisOrder:=$1
	<>DEBUGGING:=True:C214
Else 
	<>DEBUGGING:=False:C215
End if 
//These will be used to construct the EDI response message
//it should be generalized to used the settings from preferences obtained by AccountID
$arkay_edi_id:="001635622"  //10019122

$errText:=EDI_AccountInfo("init")
If (OK=1)  //got account
	//*Preserve users view
	CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "before")
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_line_status:55="Reviewed")
		RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Customers_Orders:40])
		
		//*Perserve this set for undo if necessary
		CREATE SET:C116([Customers_Orders:40]; "RestoreHeaders")  //•020498  MLB  for abort recovery
		CREATE SET:C116([Customers_Order_Lines:41]; "RestoreDetailsEDI")  //•020498  MLB  for abort recovery
		
	Else 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_line_status:55="Reviewed")
		QUERY:C277([Customers_Orders:40]; [Customers_Order_Lines:41]edi_line_status:55="Reviewed")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		$numOrderHeaders:=Records in selection:C76([Customers_Orders:40])
		ORDER BY:C49([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1; >)
		FIRST RECORD:C50([Customers_Orders:40])
		
	Else 
		
		$numOrderHeaders:=Records in selection:C76([Customers_Orders:40])
		ORDER BY:C49([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1; >)
		// see previous line
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	uThermoInit($numOrderHeaders; "Creating Response Documents & Updating aMs")
	For ($i; 1; $numOrderHeaders)  //*For each selected header
		//*   Find its details
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Orders:40]edi_sender_id:57#"")  // Modified by: Mel Bohince (10/29/10) exclude line items without a [Customers_Orders]edi_sender_id
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]LineItem:2; >)  //•081596 mlb 
		If (Records in selection:C76([Customers_Order_Lines:41])>0)  //don't send empty headers
			
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]edi_response_code:62; $aLineResponses)
			[Customers_Orders:40]edi_response_code:59:=29
			For ($line_item; 1; Size of array:C274($aLineResponses))
				If ($aLineResponses{$line_item}=6)
					[Customers_Orders:40]edi_response_code:59:=34
				End if 
			End for 
			FIRST RECORD:C50([Customers_Order_Lines:41])
			
			$po:=[Customers_Orders:40]PONumber:11
			$ICN:=[Customers_Orders:40]edi_ICN:56
			$edi_segment_counter:=0
			$edi_message_counter:=0
			
			$partner:=EDI_AccountInfo("getAcctName"; [Customers_Orders:40]edi_sender_id:57)
			$tSellerCode:=EDI_AccountInfo("getSellerCode"; [Customers_Orders:40]edi_sender_id:57)
			$tSegDel:=Char:C90(Num:C11(EDI_AccountInfo("getSegDelim"; [Customers_Orders:40]edi_sender_id:57)))  //"'"
			$tElDel:=Char:C90(Num:C11(EDI_AccountInfo("getEleDelim"; [Customers_Orders:40]edi_sender_id:57)))  //"+"
			$test_indicator:=EDI_AccountInfo("getACK"; [Customers_Orders:40]edi_sender_id:57)
			$tSubElDel:=Char:C90(Num:C11(EDI_AccountInfo("getSubDelim"; [Customers_Orders:40]edi_sender_id:57)))  //":"
			$tActualICN:=String:C10(EDI_GetNextIDfromPreferences("ICN_"+[Customers_Orders:40]edi_sender_id:57); "0000000")
			$lUniqueMessageID:=EDI_GetNextIDfromPreferences("TXN_"+[Customers_Orders:40]edi_sender_id:57)
			
			$tHeader:="UNA"+$tSubElDel+$tElDel+".? "+$tSegDel
			$tHeader:=$tHeader+"UNB"+$tElDel+"UNOA"+$tSubElDel+"1"+$tElDel
			$tCommon:=fYYMMDD(Current date:C33)+$tSubElDel+Replace string:C233(String:C10(Current time:C178; <>HHMM); ":"; "")+$tElDel  //date & time
			$tCommon:=$tCommon+$tActualICN+$tElDel  //unique sequence number
			$tCommon:=$tCommon+$tElDel+"ORDRSP"+$tElDel
			
			//prep the header's response
			$tMessageHeader:="UNH"+$tElDel+String:C10($lUniqueMessageID)+$tElDel+"ORDRSP"+$tSubElDel
			$edi_message_counter:=$edi_message_counter+1
			Case of 
				: ([Customers_Orders:40]edi_sender_id:57=$tIntlAcctID)
					$tHeader:=$tHeader+$arkay_edi_id+$tSubElDel+"01"+$tElDel  //sender
					$tHeader:=$tHeader+[Customers_Orders:40]edi_sender_id:57+$tSubElDel+"ZZ"+$tElDel  //recipient
					$tHeader:=$tHeader+$tCommon
					$tHeader:=$tHeader+"S"+$tElDel+$tElDel
					
					If (Position:C15("Whitman"; [Customers_Orders:40]defaultBillTo:5)>0) | (Position:C15("5411111000033"; [Customers_Orders:40]edi_ShipTo_text:61)>0)
						$tSellerCode:="W3315"  //Whitman
					End if 
					
					Case of   //we are prefix Oevel orders with "BP0" so taht the po matches the delfor when it comes
						: (Position:C15(Substring:C12($po; 1; 2); "BB BP BR ")#0)  //we seem to use an R, they use the P
							$po:=Substring:C12($po; 4)
						: (Position:C15(Substring:C12($po; 1; 2); " WB WP WR")#0)  //we seem to use an R, they use the P
							$po:=Substring:C12($po; 4)
					End case 
					
					$tMessageHeader:=$tMessageHeader+"90"+$tSubElDel+"1"+$tSegDel
					$tMessageHeader:=$tMessageHeader+"BGM"+$tElDel+"231"+$tElDel  //Purchase Order response
					$tMessageHeader:=$tMessageHeader+$po+$tElDel  //PO Number
					$tMessageHeader:=$tMessageHeader+$date+$tSubElDel+$time+$tElDel+String:C10([Customers_Orders:40]edi_response_code:59)+$tSegDel  //date, time msgfunc
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"BY"+$tElDel+[Customers_Orders:40]edi_ShipTo_text:61+$tSegDel  // see _FixShipToBillToText for details
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"IV"+$tElDel+[Customers_Orders:40]edi_BillTo_text:60+$tSegDel
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"DP"+$tElDel+[Customers_Orders:40]edi_ShipTo_text:61+$tSegDel
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"SE"+$tElDel+$tSellerCode+$tSubElDel+"51"+$tElDel+"Arkay Packaging Corp NY"+$tSegDel
					$tMessageHeader:=$tMessageHeader+"CUX"+$tElDel+$currency+$tElDel+"OC"+$tSegDel  //currency
					$tMessageHeader:=$tMessageHeader+"UNS"+$tElDel+"D"+$tSegDel
					$edi_segment_counter:=8  // this means there are eight segments added in this chunk
					
				: ([Customers_Orders:40]edi_sender_id:57=$tDomAcctID)
					$tHeader:=$tHeader+$arkay_edi_id+$tSubElDel+"01"+$tSubElDel+$arkay_edi_id+$tElDel  //sender
					$tHeader:=$tHeader+[Customers_Orders:40]edi_sender_id:57+$tSubElDel+"12"+$tSubElDel+[Customers_Orders:40]edi_sender_id:57+$tElDel  //recipient
					$tHeader:=$tHeader+$tCommon
					$tHeader:=$tHeader+"A"
					
					$tDifference:=$tElDel+"Arkay Packaging Corp"
					$tMessageHeader:=$tMessageHeader+"91"+$tSubElDel+"1"+$tSubElDel+"UN"+$tSubElDel+"EDIFCT"+$tSegDel
					$tMessageHeader:=$tMessageHeader+"BGM"+$tElDel+"231"+$tElDel+String:C10([Customers_Orders:40]OrderNumber:1)+$tElDel+String:C10([Customers_Orders:40]edi_response_code:59)+$tSegDel  //Message function 29=Accepted without ammendment
					$tMessageHeader:=$tMessageHeader+"DTM"+$tElDel+"4"+$tSubElDel+$date+$tSubElDel+"101"+$tSegDel  //4 for purchase order, 55 for release, 101 for YYMMDD format
					$tMessageHeader:=$tMessageHeader+"RFF"+$tElDel+"OP"+$tSubElDel+$po+$tSegDel  //what is OP for?  hard coded?
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"SU"+$tElDel+$tSellerCode+$tSubElDel+$tSubElDel+"92"+$tDifference+$tSegDel
					$tMessageHeader:=$tMessageHeader+"CTA"+$tElDel+"SU"+$tElDel+""+$tSubElDel+"G.Goldman"+$tSegDel  //supplier contact
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"BY"+$tElDel+[Customers_Orders:40]edi_BillTo_text:60+$tSegDel  //+$tSubElDel+$tSubElDel+"92"+$tSegDel  `buyer
					$tMessageHeader:=$tMessageHeader+"CTA"+$tElDel+"OC"+$tElDel+Substring:C12([Customers_Orders:40]Contact_Agent:36; 2; Position:C15(")"; [Customers_Orders:40]Contact_Agent:36)-2)+$tSegDel  //order contact ex 3F, 3V
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"ST"+$tElDel+[Customers_Orders:40]edi_ShipTo_text:61+$tSegDel  //  `Substring([Order]Ship_To;1;Position($t;[Order]Ship_To)-1)+$tSubElDel+$tSubElDel+"92"+$tElDel+Substring([Order]Ship_To;Position($t;[Order]Ship_To)+1)+$tSegDel  `ship to
					$tMessageHeader:=$tMessageHeader+"UNS"+$tElDel+"D"+$tSegDel
					$edi_segment_counter:=10  // this means there are ten segments added in this chunk
					
				: ([Customers_Orders:40]edi_sender_id:57=$tSAPAcctID) | ([Customers_Orders:40]edi_sender_id:57=$tSAPtestID)  // Modified by: Mel Bohince (4/24/20) add test account
					$tHeader:=$tHeader+$arkay_edi_id+$tSubElDel+"01"+$tSubElDel+$arkay_edi_id+$tElDel  //sender
					$tHeader:=$tHeader+[Customers_Orders:40]edi_sender_id:57+$tSubElDel+"12"+$tSubElDel+[Customers_Orders:40]edi_sender_id:57+$tElDel  //recipient
					$tHeader:=$tHeader+$tCommon
					$tHeader:=$tHeader+"A"
					
					$tDifference:=""
					$tMessageHeader:=$tMessageHeader+"91"+$tSubElDel+"1"+$tSubElDel+"UN"+$tSubElDel+"EDIFCT"+$tSegDel
					$tMessageHeader:=$tMessageHeader+"BGM"+$tElDel+"231"+$tElDel+String:C10([Customers_Orders:40]OrderNumber:1)+$tElDel+String:C10([Customers_Orders:40]edi_response_code:59)+$tSegDel  //Message function 29=Accepted without ammendment
					$tMessageHeader:=$tMessageHeader+"DTM"+$tElDel+"4"+$tSubElDel+$date+$tSubElDel+"101"+$tSegDel  //4 for purchase order, 101 for YYMMDD format
					$tMessageHeader:=$tMessageHeader+"RFF"+$tElDel+"OP"+$tSubElDel+$po+$tSegDel
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"SU"+$tElDel+$tSellerCode+$tSubElDel+$tSubElDel+"92"+$tDifference+$tSegDel
					$tMessageHeader:=$tMessageHeader+"CTA"+$tElDel+"SU"+$tElDel+""+$tSubElDel+"G.Goldman"+$tSegDel  //supplier contact
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"BY"+$tElDel+[Customers_Orders:40]edi_BillTo_text:60+$tSegDel  //  `buyer
					$tMessageHeader:=$tMessageHeader+"CTA"+$tElDel+"OC"+$tElDel+Substring:C12([Customers_Orders:40]Contact_Agent:36; 2; Position:C15(")"; [Customers_Orders:40]Contact_Agent:36)-2)+$tSegDel  //order contact ex 3F, 3V
					$tMessageHeader:=$tMessageHeader+"NAD"+$tElDel+"ST"+$tElDel+[Customers_Orders:40]edi_ShipTo_text:61+$tSegDel  //  `ship to
					$tMessageHeader:=$tMessageHeader+"UNS"+$tElDel+"D"+$tSegDel
					$edi_segment_counter:=10  // this means there are ten segments added in this chunk
					
				Else 
					uConfirm("[Customers_Orders]edi_sender_id "+[Customers_Orders:40]edi_sender_id:57+" is not set for Domestic, Intl, or SAP"; "OK"; "Help")
			End case 
			
			$tHeader:=$tHeader+$test_indicator+$tSegDel
			
			$details:=""  //if there are no qualifing details, don't send responce
			
			//*      For each detail, prep the response
			For ($j; 1; Records in selection:C76([Customers_Order_Lines:41]))
				
				If ([Customers_Order_Lines:41]edi_line_status:55="REVIEWED")  //*       not sent yet   `*         but has been reviewed, prep edi text 
					zwStatusMsg("SEND EDI"; [Customers_Order_Lines:41]OrderLine:3+"  "+[Customers_Order_Lines:41]ProductCode:5+"  "+[Customers_Order_Lines:41]PONumber:21)
					
					Case of   //different map for domestic and international   
						: ([Customers_Orders:40]edi_sender_id:57=$tIntlAcctID)  //international                          
							//only send if not Same or is Same, but modified by Arkay planner       
							If ([Customers_Order_Lines:41]edi_response_code:62=6) | (True:C214)
								$details:=$details+"LIN"+$tElDel+String:C10([Customers_Order_Lines:41]LineItem:2)+$tElDel+String:C10([Customers_Order_Lines:41]edi_response_code:62)+$tElDel+Replace string:C233([Customers_Order_Lines:41]ProductCode:5; "-"; "")+$tSubElDel+"IN"
								$details:=$details+$tElDel+$tElDel+"21"+$tSubElDel+String:C10([Customers_Order_Lines:41]Quantity:6)+$tSubElDel+[Customers_Order_Lines:41]edi_UOM_qty:56+$tElDel
								$details:=$details+String:C10([Customers_Order_Lines:41]Price_Per_M:8)+$tSubElDel+"PU"+$tSubElDel+"1"+$tSubElDel+[Customers_Order_Lines:41]edi_UOM_price:57+$tSegDel
								$numFG:=qryFinishedGood("#CPN"; [Customers_Order_Lines:41]ProductCode:5)
								$details:=$details+"IMD"+$tElDel+"F"+$tElDel+$tElDel+$tElDel+Substring:C12(edi_filter_delimiters([Finished_Goods:26]CartonDesc:3); 1; 35)+$tSegDel  // Modified by: mel (12/7/09)
								
								$date_needed:=fYYMMDD([Customers_Order_Lines:41]NeedDate:14)
								$details:=$details+"DTM"+$tElDel+"55"+$tElDel+$date_needed+$tSegDel
								
								$details:=$details+"RFF"+$tElDel+"OP"+$tElDel+$po+$tSubElDel+"1"+$tSegDel
								$edi_segment_counter:=$edi_segment_counter+4
								
								//mlb 03.24.06 add truncate to 70 char per subsegment in case slips past input form's scripts
								If (Length:C16([Customers_Order_Lines:41]edi_FreeText1:58)>0)
									$details:=$details+"FTX"+$tElDel+"LIN"+$tElDel+"3"+$tElDel+$tElDel+Substring:C12(edi_filter_delimiters([Customers_Order_Lines:41]edi_FreeText1:58); 1; 70)+$tSubElDel  //•063098  MLB  add the 4453 code
									If (Length:C16([Customers_Order_Lines:41]edi_FreeText2:59)>0)
										$details:=$details+Substring:C12(edi_filter_delimiters([Customers_Order_Lines:41]edi_FreeText2:59); 1; 70)+$tSubElDel
										If (Length:C16([Customers_Order_Lines:41]edi_FreeText3:60)>0)
											$details:=$details+Substring:C12(edi_filter_delimiters([Customers_Order_Lines:41]edi_FreeText3:60); 1; 70)+$tSubElDel
										Else 
											$details:=$details+$tSubElDel
										End if 
									Else 
										$details:=$details+($tSubElDel*2)
									End if 
									
									$details:=$details+($tSubElDel*1)+$tSegDel  //•062398  MLB map supts 5 lines, belgim only 3
									$edi_segment_counter:=$edi_segment_counter+1
								End if 
							End if   //type to send
							
						: ([Customers_Orders:40]edi_sender_id:57=$tDomAcctID)  //domestic
							$currPO:=""  //spl case for domestic LIN segments 
							If ($currPO#[Customers_Order_Lines:41]OrderLine:3)  //•081696  MLB only print LIN once per po orderline
								If ([Customers_Order_Lines:41]edi_UOM_qty:56="PCE")
									$price:=[Customers_Order_Lines:41]Price_Per_M:8/1000
								Else 
									$price:=[Customers_Order_Lines:41]Price_Per_M:8
								End if 
								
								$details:=$details+"LIN"+$tElDel+String:C10([Customers_Order_Lines:41]LineItem:2)+$tElDel+String:C10([Customers_Order_Lines:41]edi_response_code:62)+$tElDel+[Customers_Order_Lines:41]ProductCode:5+$tSegDel
								$details:=$details+"MOA"+$tElDel+"146"+$tSubElDel+String:C10($price)+$tSubElDel+"USD"+$tSubElDel+"9"+$tSegDel
								$edi_segment_counter:=$edi_segment_counter+2
								
								$ftx:=edi_format_FTX_segment(->[Customers_Order_Lines:41]edi_FreeText1:58; ->[Customers_Order_Lines:41]edi_FreeText2:59; ->[Customers_Order_Lines:41]edi_FreeText3:60; $tElDel; $tSubElDel; $tSegDel)
								If (Length:C16($ftx)>0)
									$details:=$details+$ftx
									$edi_segment_counter:=$edi_segment_counter+1
								End if 
								
								$currPO:=[Customers_Order_Lines:41]OrderLine:3
							End if 
							
							//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]OrderLine=[Customers_Order_Lines]OrderLine;*)
							//QUERY([Customers_ReleaseSchedules];*;[Customers_ReleaseSchedules]Actual_Date=!00/00/00!)
							//ORDER BY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]CustomerRefer;>)
							If (False:C215) & (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
								For ($rel; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
									$buyerAssignedRel:=Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; (Length:C16([Customers_ReleaseSchedules:46]CustomerRefer:3)-2); 3)  //•2/08/01  mlb  
									$remarkLine2:=""  //[ReleaseSchedule]RemarkLine2 `mlb 070604 used for el's planner
									
									$details:=$details+"SCC"+$tElDel+"9"+$tElDel+"DD"+$tSegDel
									$details:=$details+"FTX"+$tElDel+"SUR"+$tElDel+"3"+$tElDel+$tElDel+[Customers_ReleaseSchedules:46]RemarkLine1:25+$tSegDel
									$details:=$details+"RFF"+$tElDel+"RE"+$tSubElDel+$buyerAssignedRel+$tSegDel
									$details:=$details+"QTY"+$tElDel+"131"+$tSubElDel+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+$tSubElDel+[Customers_Order_Lines:41]edi_UOM_qty:56+$tSegDel
									$date_needed:=fYYMMDD([Customers_ReleaseSchedules:46]Sched_Date:5)
									$details:=$details+"DTM"+$tElDel+"55"+$tSubElDel+$date_needed+$tSubElDel+"101"+$tSegDel
									$edi_segment_counter:=$edi_segment_counter+5
									NEXT RECORD:C51([Customers_ReleaseSchedules:46])
								End for 
							Else 
								$buyerAssignedRel:="001"  //•2/08/01  mlb  
								$remarkLine1:=""
								$remarkLine2:=""
								$details:=$details+"SCC"+$tElDel+"9"+$tElDel+"DD"+$tSegDel
								$details:=$details+"FTX"+$tElDel+"SUR"+$tElDel+"3"+$tElDel+$tElDel+$remarkLine1+$tSegDel
								$details:=$details+"RFF"+$tElDel+"RE"+$tSubElDel+$buyerAssignedRel+$tSegDel
								$details:=$details+"QTY"+$tElDel+"131"+$tSubElDel+String:C10([Customers_Order_Lines:41]Quantity:6)+$tSubElDel+[Customers_Order_Lines:41]edi_UOM_qty:56+$tSegDel
								$date_needed:=fYYMMDD([Customers_Order_Lines:41]NeedDate:14)
								$details:=$details+"DTM"+$tElDel+"55"+$tSubElDel+$date_needed+$tSubElDel+"101"+$tSegDel
								$edi_segment_counter:=$edi_segment_counter+5
							End if 
							
						: ([Customers_Orders:40]edi_sender_id:57=$tSAPAcctID) | ([Customers_Orders:40]edi_sender_id:57=$tSAPtestID)  // Modified by: Mel Bohince (4/24/20)  add test to sap //sap
							If ([Customers_Order_Lines:41]edi_UOM_price:57="146")
								$price:=[Customers_Order_Lines:41]Price_Per_M:8/1000
							Else 
								$price:=[Customers_Order_Lines:41]Price_Per_M:8
							End if 
							
							$details:=$details+"LIN"+$tElDel+String:C10(([Customers_Order_Lines:41]LineItem:2*10))+$tElDel+String:C10([Customers_Order_Lines:41]edi_response_code:62)+$tElDel+Replace string:C233([Customers_Order_Lines:41]ProductCode:5; "-"; "")+$tSegDel
							$details:=$details+"MOA"+$tElDel+[Customers_Order_Lines:41]edi_UOM_price:57+$tSubElDel+String:C10($price)+$tSubElDel+$currency+$tSubElDel+"9"+$tSegDel
							$edi_segment_counter:=$edi_segment_counter+2
							
							$ftx:=edi_format_FTX_segment(->[Customers_Order_Lines:41]edi_FreeText1:58; ->[Customers_Order_Lines:41]edi_FreeText2:59; ->[Customers_Order_Lines:41]edi_FreeText3:60; $tElDel; $tSubElDel; $tSegDel)
							If (Length:C16($ftx)>0)
								$details:=$details+$ftx
								$edi_segment_counter:=$edi_segment_counter+1
							End if 
							
							$buyerAssignedRel:="001"  //•2/08/01  mlb  
							$remarkLine1:=""
							$remarkLine2:=""
							$details:=$details+"SCC"+$tElDel+"9"+$tElDel+"DD"+$tSegDel
							$details:=$details+"FTX"+$tElDel+"SUR"+$tElDel+"3"+$tElDel+$tElDel+$remarkLine1+$tSegDel
							$details:=$details+"RFF"+$tElDel+"RE"+$tSubElDel+$buyerAssignedRel+$tSegDel
							$details:=$details+"QTY"+$tElDel+"131"+$tSubElDel+String:C10([Customers_Order_Lines:41]Quantity:6)+$tSubElDel+[Customers_Order_Lines:41]edi_UOM_qty:56+$tSegDel
							$date_needed:=fYYMMDD([Customers_Order_Lines:41]NeedDate:14)
							$details:=$details+"DTM"+$tElDel+"55"+$tSubElDel+$date_needed+$tSubElDel+"101"+$tSegDel
							$edi_segment_counter:=$edi_segment_counter+5
							
						Else   //who knows what kind a map they'll think of next
							$details:=$details+"UNKNOW MAPPING"
					End case   //different maps
					
					[Customers_Order_Lines:41]edi_line_status:55:="SENT"
					
				End if   //not previously sent
				
				SAVE RECORD:C53([Customers_Order_Lines:41])
				NEXT RECORD:C51([Customers_Order_Lines:41])
			End for 
			
			If (Length:C16($details)>0)
				$tMessageHeader:=$tMessageHeader+$details
				$tMessageHeader:=$tMessageHeader+"UNS"+$tElDel+"S"+$tSegDel
				$tMessageHeader:=$tMessageHeader+"UNT"+$tElDel+String:C10($edi_segment_counter+2)+$tElDel+String:C10($lUniqueMessageID)+$tSegDel  //added 2 for these tags
				
				$tResponseFooter:="UNZ"+$tElDel+String:C10($edi_message_counter)+$tElDel+$tActualICN+$tSegDel
				
				//*Write rsp's to their files
				zwStatusMsg("SEND RSVP"; "Filename: "+$partner+"."+$now)
				
				C_BLOB:C604($blobOrdRspl)
				SET BLOB SIZE:C606($blobOrdRspl; 0)
				
				TEXT TO BLOB:C554($tHeader; $blobOrdRspl; Mac text without length:K22:10; *)
				TEXT TO BLOB:C554($tMessageHeader; $blobOrdRspl; Mac text without length:K22:10; *)
				TEXT TO BLOB:C554($tResponseFooter; $blobOrdRspl; Mac text without length:K22:10; *)
				
				CREATE RECORD:C68([edi_Outbox:155])
				[edi_Outbox:155]ID:1:=Sequence number:C244([edi_Outbox:155])
				[edi_Outbox:155]Path:2:="ORDRSP_"+$tActualICN+".temp"
				SET BLOB SIZE:C606([edi_Outbox:155]Content:3; 0)
				[edi_Outbox:155]Com_AccountName:7:=[Customers_Orders:40]edi_sender_id:57
				[edi_Outbox:155]SentTimeStamp:4:=0
				[edi_Outbox:155]Subject:5:="ORDRSP_"+$tActualICN
				[edi_Outbox:155]PO_Number:8:=$po  //mlb 03.21.06
				[edi_Outbox:155]OrderID:9:=String:C10([Customers_Orders:40]OrderNumber:1)  //mlb 03.21.06
				[edi_Outbox:155]Content:3:=$blobOrdRspl
				[edi_Outbox:155]ContentText:10:=""  // set in trigger
				[edi_Outbox:155]CrossReference:6:=$ICN
				SAVE RECORD:C53([edi_Outbox:155])
				REDUCE SELECTION:C351([edi_Outbox:155]; 0)
				
				[Customers_Orders:40]edi_status:58:="SENT"
				//[Customers_Orders]edi_ICN:=$tActualICN  `mlb 03.21.06
				//[Customers_Orders]Outbox_timestamp:=$timeStamp  `mlb 03.21.06
				SAVE RECORD:C53([Customers_Orders:40])
				
			End if   //detail data
			
		End if   //there are detail records
		
		NEXT RECORD:C51([Customers_Orders:40])
		uThermoUpdate($i; 1)
	End for   //each order
	uThermoClose
	
	//*RECOVER FROM ABORT
	If (Not:C34(<>fContinue))
		BEEP:C151
		zwStatusMsg("SEND"; "Process ABORTED, retoring initial state.")
		//*   Untag headers      
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			USE SET:C118("RestoreHeaders")
			
			
		Else 
			
			QUERY:C277([Customers_Orders:40]; [Customers_Order_Lines:41]edi_line_status:55="Reviewed")
			
		End if   // END 4D Professional Services : January 2019 query selection
		$numOrderHeaders:=Records in selection:C76([Customers_Orders:40])
		ARRAY TEXT:C222($aSent; $numOrderHeaders)
		For ($i; 1; $numOrderHeaders)
			$aSent{$i}:="READY"
		End for 
		ARRAY TO SELECTION:C261($aSent; [Customers_Orders:40]edi_status:58)
		ARRAY TEXT:C222($aSent; 0)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			USE SET:C118("RestoreDetailsEDI")
			
			
		Else 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_line_status:55="Reviewed")
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		$numOrderHeaders:=Records in set:C195("RestoreDetailsEDI")
		ARRAY TEXT:C222($aSent; $numOrderHeaders)
		For ($i; 1; $numOrderHeaders)
			$aSent{$i}:="REVIEWED"
		End for 
		ARRAY TO SELECTION:C261($aSent; [Customers_Order_Lines:41]edi_line_status:55)
		
		uConfirm("A serious error occured during the 'Send' process."+Char:C90(13)+"The header flags have be restored to their state before this operation began."; "OK"; "Help")
	End if   //aborted
	
	USE NAMED SELECTION:C332("before")
	BEEP:C151
	
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		CLEAR SET:C117("RestoreHeaders")
		CLEAR SET:C117("RestoreDetailsEDI")
		
	Else 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	ON EVENT CALL:C190("")
	
Else 
	uConfirm("No account information found, reponse not sent."; "Oh no!"; "Help")
End if   //got account