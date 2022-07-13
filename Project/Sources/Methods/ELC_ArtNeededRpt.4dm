//%attributes = {"publishedWeb":true}
//PM: ELC_ArtNeededRpt() -> 
//@author mlb - 10/12/01  10:20
// • mel (3/10/04, 12:00:52)`rewrite
//mlb 10/7/05 add some info columns
//mlb 10/12/11 add Tooling comment so reorders can be enumerated

//show "New" FinishedGood tooling (art,color,s&s,spc) status

MESSAGES OFF:C175
zwStatusMsg("Estée Lauder"; "Tooling Needed Report")

C_LONGINT:C283($i; $numFG)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="Tooling Needed Report"

xText:="PO"+$t+"Product Code"+$t+"Description"+$t+"1st_OrdQty"+$t+"DeliveryDate"+$t
xText:=xText+"S&S_Received"+$t+"S&S_Sent"+$t+"S&S_Approved"+$t+"SnS_No"+$t
xText:=xText+"Art_Received"+$t+"Art_Sent"+$t+"Art_Approved"+$t
xText:=xText+"Color_Received"+$t+"Color_Sent"+$t+"Color_Approved"+$t
xText:=xText+"Spec/Std_Received"+$t+"Spec/Std_Sent"+$t+"Spec/Std_Approved"+$t

xText:=xText+"Price"+$t+"Customer"+$t+"Project"+$t+"1stRelQty"+$t
xText:=xText+"ClosingOnFG"+$t+"ShipOnFG"+$t+"DeliveryOnFG"+$t+"ToolingComment"+$cr
docName:="ELC_ArtNeeded"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	
	READ ONLY:C145([Customers:16])
	READ ONLY:C145([Customers_Projects:9])
	READ ONLY:C145([Finished_Goods_Color_SpecMaster:128])
	READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
	READ ONLY:C145([Finished_Goods:26])
	READ ONLY:C145([Finished_Goods_Specifications:98])
	READ ONLY:C145([Customers_Order_Lines:41])
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	
	CONFIRM:C162("Only Estee Lauder Companies or Query Editor?"; "Lauder"; "Query Editor")
	If (OK=1)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
			
			$numFG:=ELC_query(->[Finished_Goods:26]CustID:2)  //get elc's fr
			QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]Status:14="New")
			
		Else 
			$criteria:=ELC_getName
			QUERY:C277([Finished_Goods:26]; [Customers:16]ParentCorp:19=$criteria; *)
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Status:14="New")
			
		End if   // END 4D Professional Services : January 2019 ELC_query
		
	Else 
		QUERY:C277([Finished_Goods:26])
	End if 
	
	$numFG:=Records in selection:C76([Finished_Goods:26])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)
		FIRST RECORD:C50([Finished_Goods:26])
		
	Else 
		
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)
		// see previous line
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	uThermoInit($numFG; "Art Needed Report")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numFG)
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Finished_Goods:26]ProjectNumber:82)
			If (Records in selection:C76([Customers_Projects:9])>0)
				$custName:=[Customers_Projects:9]CustomerName:4
			Else 
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
				$custName:=[Customers:16]Name:2
			End if 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0)
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; >)
				$po:=[Customers_Order_Lines:41]PONumber:21
				$ordqty:=[Customers_Order_Lines:41]Qty_Open:11
				$price:=[Customers_Order_Lines:41]Price_Per_M:8
			Else 
				$po:="N/A"
				$ordqty:=0
				$price:=0
			End if 
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
				$reldate:=[Customers_ReleaseSchedules:46]Promise_Date:32
				$relqty:=[Customers_ReleaseSchedules:46]Sched_Qty:6
			Else 
				$reldate:=!00-00-00!
				$relqty:=0
			End if 
			
			If (False:C215)  //disable workflow system 11/18/04 mlb
				RELATE ONE:C42([Finished_Goods:26]ControlNumber:61)
				RELATE ONE:C42([Finished_Goods:26]OutLine_Num:4)
				RELATE ONE:C42([Finished_Goods:26]ColorSpecMaster:77)
				xText:=xText+$po+$t+[Finished_Goods:26]ProductCode:1+$t+[Finished_Goods:26]CartonDesc:3+$t+String:C10($ordqty)+$t+String:C10($reldate; System date short:K1:1)+$t
				xText:=xText+String:C10([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4; System date short:K1:1)+$t+String:C10([Finished_Goods_SizeAndStyles:132]z_DateSent:7; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateSnS_Approved:83; System date short:K1:1)+$t+[Finished_Goods:26]OutLine_Num:4+$t
				xText:=xText+String:C10([Finished_Goods_Specifications:98]DateArtReceived:63; System date short:K1:1)+$t+String:C10([Finished_Goods_Specifications:98]DateSentToCustomer:8; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateArtApproved:46)+$t
				xText:=xText+String:C10([Finished_Goods_Color_SpecMaster:128]DateApproved:18; System date short:K1:1)+$t+String:C10([Finished_Goods_Color_SpecMaster:128]DateSent:21; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateColorApproved:86; System date short:K1:1)+$t
			Else 
				xText:=xText+$po+$t+[Finished_Goods:26]ProductCode:1+$t+[Finished_Goods:26]CartonDesc:3+$t+String:C10($ordqty)+$t+String:C10($reldate; System date short:K1:1)+$t
				xText:=xText+String:C10([Finished_Goods:26]DateSnSReceived:57; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateSnSsent:98; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateSnS_Approved:83; System date short:K1:1)+$t+[Finished_Goods:26]OutLine_Num:4+$t
				xText:=xText+String:C10([Finished_Goods:26]ArtReceivedDate:56; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateArtSent:101; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateArtApproved:46)+$t
				xText:=xText+String:C10([Finished_Goods:26]DateColorReceived:99; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateColorSent:100; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateColorApproved:86; System date short:K1:1)+$t
				
			End if 
			
			xText:=xText+String:C10([Finished_Goods:26]DateSpecReceived:87; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateSpecSent:88; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateSpecApproved:89; System date short:K1:1)+$t
			
			xText:=xText+String:C10($price)+$t+$custName+$t+[Customers_Projects:9]Name:2+$t+String:C10($relqty)+$t
			xText:=xText+String:C10([Finished_Goods:26]DateClosing:92; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateShip:91; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateDockDelivery:90; System date short:K1:1)+$t+[Finished_Goods:26]ToolingComment:114+$cr
			NEXT RECORD:C51([Finished_Goods:26])
			uThermoUpdate($i)
		End for 
		
	Else 
		
		
		ARRAY TEXT:C222($_ProjectNumber; 0)
		ARRAY TEXT:C222($_CustID; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_CartonDesc; 0)
		ARRAY DATE:C224($_DateSnSReceived; 0)
		ARRAY DATE:C224($_DateSnSsent; 0)
		ARRAY DATE:C224($_DateSnS_Approved; 0)
		ARRAY TEXT:C222($_OutLine_Num; 0)
		ARRAY DATE:C224($_ArtReceivedDate; 0)
		ARRAY DATE:C224($_DateArtSent; 0)
		ARRAY DATE:C224($_DateArtApproved; 0)
		ARRAY DATE:C224($_DateColorReceived; 0)
		ARRAY DATE:C224($_DateColorSent; 0)
		ARRAY DATE:C224($_DateColorApproved; 0)
		ARRAY DATE:C224($_DateSpecReceived; 0)
		ARRAY DATE:C224($_DateSpecSent; 0)
		ARRAY DATE:C224($_DateSpecApproved; 0)
		ARRAY DATE:C224($_DateClosing; 0)
		ARRAY DATE:C224($_DateShip; 0)
		ARRAY DATE:C224($_DateDockDelivery; 0)
		ARRAY TEXT:C222($_ToolingComment; 0)
		
		
		SELECTION TO ARRAY:C260([Finished_Goods:26]ProjectNumber:82; $_ProjectNumber; \
			[Finished_Goods:26]CustID:2; $_CustID; \
			[Finished_Goods:26]ProductCode:1; $_ProductCode; \
			[Finished_Goods:26]CartonDesc:3; $_CartonDesc; \
			[Finished_Goods:26]DateSnSReceived:57; $_DateSnSReceived; \
			[Finished_Goods:26]DateSnSsent:98; $_DateSnSsent; \
			[Finished_Goods:26]DateSnS_Approved:83; $_DateSnS_Approved; \
			[Finished_Goods:26]OutLine_Num:4; $_OutLine_Num; \
			[Finished_Goods:26]ArtReceivedDate:56; $_ArtReceivedDate; \
			[Finished_Goods:26]DateArtSent:101; $_DateArtSent; \
			[Finished_Goods:26]DateArtApproved:46; $_DateArtApproved; \
			[Finished_Goods:26]DateColorReceived:99; $_DateColorReceived; \
			[Finished_Goods:26]DateColorSent:100; $_DateColorSent; \
			[Finished_Goods:26]DateColorApproved:86; $_DateColorApproved; \
			[Finished_Goods:26]DateSpecReceived:87; $_DateSpecReceived; \
			[Finished_Goods:26]DateSpecSent:88; $_DateSpecSent; \
			[Finished_Goods:26]DateSpecApproved:89; $_DateSpecApproved; \
			[Finished_Goods:26]DateClosing:92; $_DateClosing; \
			[Finished_Goods:26]DateShip:91; $_DateShip; \
			[Finished_Goods:26]DateDockDelivery:90; $_DateDockDelivery; \
			[Finished_Goods:26]ToolingComment:114; $_ToolingComment)
		
		For ($i; 1; $numFG; 1)
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$_ProjectNumber{$i})
			If (Records in selection:C76([Customers_Projects:9])>0)
				$custName:=[Customers_Projects:9]CustomerName:4
			Else 
				QUERY:C277([Customers:16]; [Customers:16]ID:1=$_CustID{$i})
				$custName:=[Customers:16]Name:2
			End if 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$_ProductCode{$i}; *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0)
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; >)
				$po:=[Customers_Order_Lines:41]PONumber:21
				$ordqty:=[Customers_Order_Lines:41]Qty_Open:11
				$price:=[Customers_Order_Lines:41]Price_Per_M:8
			Else 
				$po:="N/A"
				$ordqty:=0
				$price:=0
			End if 
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$_ProductCode{$i}; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
				$reldate:=[Customers_ReleaseSchedules:46]Promise_Date:32
				$relqty:=[Customers_ReleaseSchedules:46]Sched_Qty:6
			Else 
				$reldate:=!00-00-00!
				$relqty:=0
			End if 
			xText:=xText+$po+$t+$_ProductCode{$i}+$t+$_CartonDesc{$i}+$t+String:C10($ordqty)+$t+String:C10($reldate; System date short:K1:1)+$t
			xText:=xText+String:C10($_DateSnSReceived{$i}; System date short:K1:1)+$t+String:C10($_DateSnSsent{$i}; System date short:K1:1)+$t+String:C10($_DateSnS_Approved{$i}; System date short:K1:1)+$t+$_OutLine_Num{$i}+$t
			xText:=xText+String:C10($_ArtReceivedDate{$i}; System date short:K1:1)+$t+String:C10($_DateArtSent{$i}; System date short:K1:1)+$t+String:C10($_DateArtApproved{$i})+$t
			xText:=xText+String:C10($_DateColorReceived{$i}; System date short:K1:1)+$t+String:C10($_DateColorSent{$i}; System date short:K1:1)+$t+String:C10($_DateColorApproved{$i}; System date short:K1:1)+$t
			xText:=xText+String:C10($_DateSpecReceived{$i}; System date short:K1:1)+$t+String:C10($_DateSpecSent{$i}; System date short:K1:1)+$t+String:C10($_DateSpecApproved{$i}; System date short:K1:1)+$t
			xText:=xText+String:C10($price)+$t+$custName+$t+[Customers_Projects:9]Name:2+$t+String:C10($relqty)+$t
			xText:=xText+String:C10($_DateClosing{$i}; System date short:K1:1)+$t+String:C10($_DateShip{$i}; System date short:K1:1)+$t+String:C10($_DateDockDelivery{$i}; System date short:K1:1)+$t+$_ToolingComment{$i}+$cr
			
			uThermoUpdate($i)
		End for 
		
	End if   // END 4D Professional Services : January 2019 
	
	SEND PACKET:C103($docRef; xText)
	uThermoClose
	
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
End if   //open doc