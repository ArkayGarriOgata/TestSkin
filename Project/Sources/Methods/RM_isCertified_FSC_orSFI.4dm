//%attributes = {}
// Method: RM_isCertified_FSC_orSFI("jobit"|"RawMaterial|verify";value)
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/25/07, 15:20:15
// ----------------------------------------------------
// Description
// determine if our COC should be used based on RM used in production
// ----------------------------------------------------
// Modified by: Mel Bohince (6/11/14) 0% should be "Credit"
// Modified by: Mel Bohince (5/10/19) request end date and include pefc prefix'd materials
// Modified by: Mel Bohince (5/11/20) rewrite in orda, avoid locking r/m record
// Modified by: Mel Bohince (5/28/20) change out line 210 to if (false)
// Modified by: Garri Ogata (6/2/20) Added POID and JobIt for Heather ($bAddPOIdJobIt)
// Modified by: Garri Ogata (6/25/20) Heather wants it back to old way($bAddPOIdJobIt)
// Modified by: Garri Ogata (2/3/21) ORDA on the server was having an issue. Standalone worked fine though.
//.   Commented out original ORDA and moved it back to Classic 4D Queries
// Modified by: Garri Ogata (2/5/21) Change cause more issues flip it back to original

C_TEXT:C284($jobform; $jobit; $1; $2; coc_num)
C_TEXT:C284($certified; $statement; $0)
C_OBJECT:C1216($rmx_es; $rmx_o; $rm_es; $rm_o)  // Modified by: Mel Bohince (5/11/20) rewrite in orda, avoid locking r/m record
C_BOOLEAN:C305($bAddPOIdJobIt)  //Use to bypass addition if it slows something else down

C_BOOLEAN:C305($bUseClassic)  //Use to bypass ORDA if needed

$bAddPOIdJobIt:=False:C215  // Modified by: Garri Ogata (6/25/20) 
$bUseClassic:=False:C215  //Modified by: Garri Ogata (2/5/21)

If (False:C215)  //marker for Find in Database
	[Customers_Bills_of_Lading:49]ChainOfCustody:30:=$certified  //used in BOL_ExecuteShipment
	coc_num:=$certified  // used in Zebra_LabelSetup//<>CHAIN_OF_CUSTODY
End if 
$certified:=""
//◊CHAIN_OF_CUSTODY ` used as a marker to find in database
If (Count parameters:C259>0)
	$msg:=$1
Else 
	$msg:=Request:C163("Which (verify|jobit|RawMaterial?"; "verify")
End if 

Case of 
	: ($msg="verify")  //called RM_FSC_Verification 
		C_TEXT:C284($t; $r)
		C_TEXT:C284(xTitle; xText; docName)
		C_TIME:C306($docRef)
		
		$t:=Char:C90(9)
		$r:=Char:C90(13)
		xTitle:=""
		xText:=""
		docName:="FSC_Verification"+fYYMMDD(Current date:C33(*))+"_"+Replace string:C233(String:C10(Current time:C178(*); <>HHMM); ":"; "")+".xls"
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			READ ONLY:C145([Raw_Materials_Transactions:23])
			READ ONLY:C145([Finished_Goods_Transactions:33])
			READ ONLY:C145([Customers_ReleaseSchedules:46])
			READ WRITE:C146([Customers_Invoices:88])
			READ WRITE:C146([Customers_Bills_of_Lading:49])
			ARRAY TEXT:C222($aJobforms; 0)
			
			If (Count parameters:C259<2)
				$repair:=False:C215
				CONFIRM:C162("Do repairs?"; "NO"; "Repair")
				If (ok=0)
					$repair:=True:C214
				End if 
				
				$endDate:=Date:C102(Request:C163("Year ending on? Click Cancel for all."; String:C10(Current date:C33; Internal date short:K1:7)))
				If (ok=1)
					$beginDate:=Date:C102(Request:C163("Beginning on? Click Cancel for all."; String:C10(Current date:C33; Internal date short:K1:7)))  //Add to date($endDate;-1;0;0)// Modified by: Mel Bohince (5/10/19) 
				Else 
					$endDate:=Current date:C33
					$beginDate:=!2007-01-01!
				End if 
				
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="fsc@"; *)
				QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="sfi@"; *)
				QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="pefc@"; *)  // Modified by: Mel Bohince (5/10/19) 
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="issue")
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					DISTINCT VALUES:C339([Raw_Materials_Transactions:23]JobForm:12; $aJobforms)  //jobs using fsc stock
				End if 
				
			Else 
				ARRAY TEXT:C222($aJobforms; 1)
				$aJobforms{1}:=$2
			End if 
			
			//QUERY WITH ARRAY([Finished_Goods_Transactions]JobForm;$aJobforms)
			//QUERY SELECTION([Finished_Goods_Transactions];[Finished_Goods_Transactions]XactionType="Ship";*)
			//QUERY SELECTION([Finished_Goods_Transactions];[Finished_Goods_Transactions]XactionDate>$beginDate;*)
			//QUERY SELECTION([Finished_Goods_Transactions];[Finished_Goods_Transactions]XactionDate<=$endDate)
			$t:=Char:C90(9)
			$r:=Char:C90(13)
			
			If ($bAddPOIdJobIt)
				xText:="RELEASE"+$t+"CPN"+$t+"DATE"+$t+"INVOICE"+$t+"PO ID"+$t+"JOB"+$t+"iSTMT"+$t+"iGONO"+$t+"BOL"+$t+"bSTMT"+$t+"bGONO"+$t+"RM_Code"+$t+"DESC"+$t+"FLEX6"+$t+"SHOULDBE"+$t+"JobForm"+Char:C90(13)
			Else 
				xText:="RELEASE"+$t+"CPN"+$t+"DATE"+$t+"INVOICE"+$t+"iSTMT"+$t+"iGONO"+$t+"BOL"+$t+"bSTMT"+$t+"bGONO"+$t+"RM_Code"+$t+"DESC"+$t+"FLEX6"+$t+"SHOULDBE"+$t+"JobForm"+Char:C90(13)
			End if 
			
			$numElements:=Size of array:C274($aJobforms)
			uThermoInit($numElements; "Verify FSC/SFI")
			For ($job; 1; $numElements)  //check if shipped, if so check the bol and invoice
				If (Length:C16(xText)>25000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				uThermoUpdate($job)
				$shouldBe:=RM_isCertified_FSC_orSFI("jobit"; $aJobforms{$job})
				$rm_stuff:=RM_isCertified_FSC_orSFI("rm_detail"; $aJobforms{$job})
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=$aJobforms{$job}; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="ship"; *)
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>$beginDate; *)
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=$endDate)
				DISTINCT VALUES:C339([Finished_Goods_Transactions:33]OrderItem:16; $aOrderItems)
				
				For ($shipment; 1; Size of array:C274($aOrderItems))
					
					If ($bAddPOIdJobIt)  //Get POItemKey and JobForm
						
						ARRAY TEXT:C222($atJobForm; 0)
						
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=$aOrderItems{$shipment})
						
						DISTINCT VALUES:C339([Finished_Goods_Transactions:33]JobForm:5; $atJobForm)
						
						QUERY WITH ARRAY:C644([Raw_Materials_Transactions:23]JobForm:12; $atJobForm)
						
						ARRAY TEXT:C222($atJobForm; 0)
						ARRAY TEXT:C222($atPOItemKey; 0)
						ARRAY INTEGER:C220($anSequence; 0)
						
						ARRAY TEXT:C222($atJob; 0)
						ARRAY TEXT:C222($atPO; 0)
						
						SELECTION TO ARRAY:C260(\
							[Raw_Materials_Transactions:23]JobForm:12; $atJobForm; \
							[Raw_Materials_Transactions:23]POItemKey:4; $atPOItemKey; \
							[Raw_Materials_Transactions:23]Sequence:13; $anSequence)
						
						$nNumberOfJobs:=Size of array:C274($atJobForm)
						
						For ($nJob; 1; $nNumberOfJobs)  //Loop thru jobs
							
							$nJobLocation:=Core_Array_PositionN(->$atJob; $atJobForm{$nJob})
							$nPOLocation:=Core_Array_PositionN(->$atPO; $atPOItemKey{$nJob})
							
							Case of   //Add information
									
								: ($anSequence{$nJob}#10)  //Only Sheeter
									
								: (($nJobLocation=CoreknNoMatchFound) & ($nPOLocation=CoreknNoMatchFound))
									
									APPEND TO ARRAY:C911($atJob; $atJobForm{$nJob})
									APPEND TO ARRAY:C911($atPO; $atPOItemKey{$nJob})
									
								: ($nJobLocation=$nPOLocation)  //Already exist do nothing
									
								: (($nJobLocation=CoreknNoMatchFound) & ($nPOLocation#CoreknNoMatchFound))
									
									$atJob{$nPOLocation}:=Choose:C955($atJobForm{$nJob}=CorektBlank; \
										$atJob{$nPOLocation}; \
										$atJob{$nPOLocation}+CorektPipe+$atJobForm{$nJob})
									
								: (($nJobLocation#CoreknNoMatchFound) & ($nPOLocation=CoreknNoMatchFound))
									
									$atPO{$nJobLocation}:=Choose:C955($atPOItemKey{$nJob}=CorektBlank; \
										$atPO{$nJobLocation}; \
										$atPO{$nJobLocation}+CorektPipe+$atPOItemKey{$nJob})
									
								: (($nJobLocation#CoreknNoMatchFound) & ($nPOLocation#CoreknNoMatchFound))  //Different locations
									
									$atPO{$nPOLocation}:=Choose:C955($atPOItemKey{$nJob}=CorektBlank; \
										$atPO{$nPOLocation}; \
										$atPO{$nPOLocation}+CorektPipe+$atPOItemKey{$nJob})
									
							End case   //Done add information
							
						End for   //Done loop thru jobs
						
						$tJobForm:=Core_Array_ToTextT(->$atJob; CorektPipe)
						$tPOItemKey:=Core_Array_ToTextT(->$atPO)
						
					End if   //Done get POItemKey and JobForm
					
					$release:=Num:C11(Substring:C12($aOrderItems{$shipment}; (Position:C15("/"; $aOrderItems{$shipment})+1)))
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$release)
					
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						$problem:=String:C10($release)+$t+"' "+[Customers_ReleaseSchedules:46]ProductCode:11+$t+String:C10([Customers_ReleaseSchedules:46]Actual_Date:7)+$t
						QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1=[Customers_ReleaseSchedules:46]InvoiceNumber:9)
						If (Records in selection:C76([Customers_Invoices:88])>0)
							
							If ($bAddPOIdJobIt)
								$problem:=$problem+String:C10([Customers_Invoices:88]InvoiceNumber:1)+$t+$tPOItemKey+$t+$tJobForm+$t+Replace string:C233([Customers_Invoices:88]InvComment:12; Char:C90(13); "! ")+$t
							Else 
								$problem:=$problem+String:C10([Customers_Invoices:88]InvoiceNumber:1)+$t+Replace string:C233([Customers_Invoices:88]InvComment:12; Char:C90(13); "! ")+$t
							End if 
							
							If (Position:C15($shouldBe; [Customers_Invoices:88]InvComment:12)#0)
								$problem:=$problem+"GO"+$t
							Else 
								$problem:=$problem+"NOGO"+$t
								If ($repair)
									[Customers_Invoices:88]InvComment:12:=[Customers_Invoices:88]InvComment:12+" "+RM_isCertified_FSC_orSFI("jobit"; $aJobforms{$job})
									SAVE RECORD:C53([Customers_Invoices:88])
								End if 
							End if 
						End if 
						
						QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=[Customers_ReleaseSchedules:46]B_O_L_number:17)
						If (Records in selection:C76([Customers_Bills_of_Lading:49])>0)
							$problem:=$problem+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+$t+Replace string:C233([Customers_Bills_of_Lading:49]ChainOfCustody:30; Char:C90(13); "! ")+$t
							If (Position:C15($shouldBe; [Customers_Bills_of_Lading:49]ChainOfCustody:30)#0)  //◊CHAIN_OF_CUSTODY ` used as a marker to find in database
								$problem:=$problem+"GO"+$t
							Else 
								$problem:=$problem+"NOGO"+$t
								If ($repair)
									[Customers_Bills_of_Lading:49]ChainOfCustody:30:=RM_isCertified_FSC_orSFI("jobit"; $aJobforms{$job})
									SAVE RECORD:C53([Customers_Bills_of_Lading:49])
								End if 
							End if 
						End if 
						
						If (Length:C16($problem)>0)
							$shouldBeText:=Replace string:C233($shouldBe; Char:C90(13); "! ")
							$problem:=$problem+$rm_stuff+$t+$shouldBeText+$t+$aJobforms{$job}
							xText:=xText+$problem+Char:C90(13)
							$problem:=""
						End if 
					End if   //found release
					
				End for   //shipments
			End for   //jobform
			uThermoClose
			
			SEND PACKET:C103($docRef; xText)
			SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
			CLOSE DOCUMENT:C267($docRef)
			
			// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
			$err:=util_Launch_External_App(docName)
			
			
			REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
			REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
			REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
			REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
			REDUCE SELECTION:C351([Customers_Bills_of_Lading:49]; 0)
			
		Else 
			BEEP:C151
			ALERT:C41(docName+" couldn't be created.")
		End if 
		
	: ($msg="jobit")  //most used call
		$jobit:=$2
		$jobform:=Substring:C12($jobit; 1; 8)
		//do the fsc/sfi/pefc separately as they have different rules for the statement
		
		//check for FSC
		
		//***** GNO CHANGE 2-3-20 *****
		
		If ($bUseClassic)  //Classic
			
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$jobform; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="issue"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="fsc@")
			
			If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
				
				FIRST RECORD:C50([Raw_Materials_Transactions:23])
				
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
				
				If (Records in selection:C76([Raw_Materials:21])>0)
					
					Case of 
						: (Num:C11([Raw_Materials:21]Flex6:24)>0)
							$fsc_percent:=String:C10(Num:C11([Raw_Materials:21]Flex6:24))+"%"  //percent specified
							$statement:="FSC Mix "+$fsc_percent
							
						: (Num:C11([Raw_Materials:21]Flex6:24)=0)  // just say Credit -- Modified by: Mel Bohince (6/11/14) This years complaint
							$fsc_percent:="Credit"
							$statement:="FSC Mix "+$fsc_percent
							
						Else   //legacy r/m, not updated to 2014 SOP
							$statement:="[Raw_Matl]Flex6 ERROR"
					End case 
					
				Else 
					
					$certified:=$jobform+"\tR/M Not Found\t"
					
				End if 
				
			Else 
				
				$certified:=$jobform+"\tNOT FSC/SFI/PEFC\t"
				
			End if 
			
		Else   //ORDA 
			
			$rmx_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Xfer_Type = :2; and Raw_Matl_Code = :3"; $jobform; "issue"; "fsc@")
			If ($rmx_es.length>0)  //found fsc transactions
				
				$rmx_o:=$rmx_es.first()  //load one
				If ($rmx_o.RAW_MATERIAL#Null:C1517)  //build the fsc statement phrase //This was failing and shouldn't have been
					Case of 
						: (Num:C11($rmx_o.RAW_MATERIAL.Flex6)>0)
							$fsc_percent:=String:C10(Num:C11($rm_o.Flex6))+"%"  //percent specified
							$statement:="FSC Mix "+$fsc_percent
							
						: (Num:C11($rmx_o.RAW_MATERIAL.Flex6)=0)  // just say Credit -- Modified by: Mel Bohince (6/11/14) This years complaint
							$fsc_percent:="Credit"
							$statement:="FSC Mix "+$fsc_percent
							
						Else   //legacy r/m, not updated to 2014 SOP
							$statement:="[Raw_Matl]Flex6 ERROR"
					End case 
					
				Else   //wtf, are you kidding me? 
					$statement:="R/M Not Found"
				End if 
				
				$certified:=$certified+"FSC#: "+<>CHAIN_OF_CUSTODY+" \r"+$statement
			End if   //transactions found
			
		End if   //Done classic
		
		//***** DONE GNO CHANGE 2-3-20 *****
		
		//check for SFI
		If (ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Xfer_Type = :2; and Raw_Matl_Code = :3"; $jobform; "issue"; "sfi@").length>0)
			$certified:=$certified+"BV-SFICOC-US005068-1 "+"SFI at Least 15% Certified Forest Content. "
			$certified:=$certified+"This SFI product was made according to the SFI Chain of Custody requirements as reviewed and approved by top management."
		End if 
		
		//check for PEFC
		If (ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Xfer_Type = :2; and Raw_Matl_Code = :3"; $jobform; "issue"; "PEFC@").length>0)
			$certified:=$certified+"BV-PEFCCOC-US009046-1.  x % PEFC certified. "
			$certified:=$certified+"Contact John Sheridan at phone #: 540-977-3031 for a copy of our PEFC Certificate."
		End if 
		
	: ($msg="RawMaterial")  //called by JOB_BAG_Report
		$rmCode:=$2
		If (False:C215)  // (($rmCode="fsc@") | ($rmCode="sfi@") | ($rmCode="pefc@"))   // Modified by: Mel Bohince (5/28/20) 
			$rmx_es:=ds:C1482.Purchase_Orders_Items.query("Raw_Matl_Code = :1"; $rmCode)
			If ($rmx_es.length>0)
				$rmx_es:=$rmx_es.orderBy("PoItemDate desc")
				$rmx_o:=$rmx_es.first().PURCHASE_ORDER
				If ($rmx_o#Null:C1517)
					$certified:=$rmx_o.ChainOfCustody
				End if 
			End if 
		End if 
		
	: ($msg="rm_detail")  //not called
		$jobit:=$2
		$jobform:=Substring:C12($jobit; 1; 8)
		
		//***** GNO CHANGE 2-3-20 *****
		
		If ($bUseClassic)  //Classic
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$jobform; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="issue"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="fsc@"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="sfi@"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="pefc@")
			
			If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
				
				FIRST RECORD:C50([Raw_Materials_Transactions:23])
				
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
				
				If (Records in selection:C76([Raw_Materials:21])>0)
					
					$certified:=[Raw_Materials:21]Raw_Matl_Code:1+"\t"+Replace string:C233([Raw_Materials:21]Description:4; Char:C90(13); "!")+"\t"+String:C10(Num:C11([Raw_Materials:21]Flex6:24))+"%"
					
				Else 
					
					$certified:=$jobform+"\tR/M Not Found\t"
					
				End if 
				
			Else 
				
				$certified:=$jobform+"\tNOT FSC/SFI/PEFC\t"
				
			End if 
			
		Else   //ORDA
			
			$rmx_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Xfer_Type = :2; and Raw_Matl_Code in :3"; $jobform; "issue"; New collection:C1472("fsc@"; "sfi@"; "pefc@"))
			If ($rmx_es.length>0)
				$rmx_o:=$rmx_es.first()  //load one
				If ($rmx_o.RAW_MATERIAL#Null:C1517)  //build the fsc statement phrase
					$certified:=$rmx_o.Raw_Matl_Code+"\t"+Replace string:C233($rmx_o.RAW_MATERIAL.Description; Char:C90(13); "!")+"\t"+String:C10(Num:C11($rmx_o.RAW_MATERIAL.Flex6))+"%"
					
				Else   //wtf, are you kidding me? 
					$certified:=$jobform+"\tR/M Not Found\t"  //This does not work on the server for some records $rmx_o.RAW_MATERIAL=Null.
				End if 
				
			Else 
				$certified:=$jobform+"\tNOT FSC/SFI/PEFC\t"
			End if 
			
		End if   //Done classic
		
		//***** DONE GNO CHANGE 2-3-20 *****
		
	: ($msg="placeholder")  //called by trigger_CustomersReleaseSchedul
		//do nothing, this is so we can find related code next time they change the rules
End case 

$0:=$certified