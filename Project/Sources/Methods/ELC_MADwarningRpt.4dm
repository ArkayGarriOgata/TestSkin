//%attributes = {"publishedWeb":true}
//PM: ELC_MADwarningRpt() -> 
//@author mlb - 10/12/01  09:05
//report any jobit items where their MAD
//puts there sched release in jeapordy

C_LONGINT:C283($i; $numJMI; $numFG)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

MESSAGES OFF:C175
zwStatusMsg("Estée Lauder"; "MAD Warning Report")

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="MAD Warning Report"
xText:="Jobit"+$t+"CPN"+$t+"Line"+$t+"MAD"+$t+"Required"+$t+"Comment"+$t+"S&S"+$t+"ArtRecd"+$t+"PrepDone"+$t+"ArtOK"+$t+"Preflight"+$t+"Control#"+$cr
//$docRef:=Create document("ELC_MADwarning"+fYYMMDD (4D_Current_date))
docName:="ELC_MADwarning"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	//report excess qtys (no order release or forecasts)
	READ ONLY:C145([Customers:16])
	READ ONLY:C145([Job_Forms_Items:44])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numJMI:=ELC_query(->[Job_Forms_Items:44]CustId:15)  //get elc's jobits
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=0; *)  //just pending jobits
		QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]MAD:37#!00-00-00!)  //that have been sched'd
		
		
	Else 
		
		READ ONLY:C145([Job_Forms_Items:44])
		$critiria:=ELC_getName
		QUERY:C277([Job_Forms_Items:44]; [Customers:16]ParentCorp:19=$critiria; *)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=0; *)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37#!00-00-00!)
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	$numJMI:=Records in selection:C76([Job_Forms_Items:44])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)
		FIRST RECORD:C50([Job_Forms_Items:44])
		
	Else 
		
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)
		// see previous line
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	uThermoInit($numJMI; "MAD Warning Report")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numJMI)
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			//look for open pegged releases  
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Job_Forms_Items:44]OrderItem:2; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)  //get the earliest open release 
				If ([Customers_ReleaseSchedules:46]Sched_Date:5<=[Job_Forms_Items:44]MAD:37)  //sched late
					$numFG:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
					xText:=xText+[Job_Forms_Items:44]Jobit:4+$t+[Job_Forms_Items:44]ProductCode:3+$t+[Finished_Goods:26]Line_Brand:15+$t+String:C10([Job_Forms_Items:44]MAD:37; System date short:K1:1)+$t+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+$t
					xText:=xText+$t+String:C10([Finished_Goods:26]DateSnSReceived:57; System date short:K1:1)+$t+String:C10([Finished_Goods:26]ArtReceivedDate:56; System date short:K1:1)+$t+String:C10([Finished_Goods:26]PrepDoneDate:58; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateArtApproved:46; System date short:K1:1)+$t+String:C10([Finished_Goods:26]PreflightDate:72; System date short:K1:1)+$t+[Finished_Goods:26]ControlNumber:61+$cr
				End if 
			End if 
			
			NEXT RECORD:C51([Job_Forms_Items:44])
			uThermoUpdate($i)
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_OrderItem; 0)
		ARRAY TEXT:C222($_CustId; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_Jobit; 0)
		ARRAY DATE:C224($_MAD; 0)
		
		
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; $_OrderItem; \
			[Job_Forms_Items:44]CustId:15; $_CustId; \
			[Job_Forms_Items:44]ProductCode:3; $_ProductCode; \
			[Job_Forms_Items:44]Jobit:4; $_Jobit; \
			[Job_Forms_Items:44]MAD:37; $_MAD)
		
		For ($i; 1; $numJMI; 1)
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			//look for open pegged releases  
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$_OrderItem{$i}; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)  //get the earliest open release 
				If ([Customers_ReleaseSchedules:46]Sched_Date:5<=$_MAD{$i})  //sched late
					$numFG:=qryFinishedGood($_CustId{$i}; $_ProductCode{$i})
					xText:=xText+$_Jobit{$i}+$t+$_ProductCode{$i}+$t+[Finished_Goods:26]Line_Brand:15+$t+String:C10($_MAD{$i}; System date short:K1:1)+$t+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+$t
					xText:=xText+$t+String:C10([Finished_Goods:26]DateSnSReceived:57; System date short:K1:1)+$t+String:C10([Finished_Goods:26]ArtReceivedDate:56; System date short:K1:1)+$t+String:C10([Finished_Goods:26]PrepDoneDate:58; System date short:K1:1)+$t+String:C10([Finished_Goods:26]DateArtApproved:46; System date short:K1:1)+$t+String:C10([Finished_Goods:26]PreflightDate:72; System date short:K1:1)+$t+[Finished_Goods:26]ControlNumber:61+$cr
				End if 
			End if 
			
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