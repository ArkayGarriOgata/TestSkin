//%attributes = {"publishedWeb":true}
//Procedure: BatchEDIcleanUp()  070898  MLB
//fill in the blanks
//•111098  MLB  UPR make a log
// • mel (12/17/03, 16:02:57) set brands to specific projects
// • mel 10 05 05, fix canadian PO's
//mel 060607 switch from [x_order_project_mapper] to [Customers_Brand_Lines]

C_LONGINT:C283($i; $numRels; $numFGs)
C_BOOLEAN:C305($fixed)
C_TEXT:C284($exception)
C_TEXT:C284(xTitle; xText)
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aCustId; 0)
ARRAY TEXT:C222($aLine; 0)

zwStatusMsg("EDI Cleanup"; "Cleaning up EDI releases")
MESSAGE:C88(" Searching releases…"+Char:C90(13))

xTitle:="EDI Release Cleanup "+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:=""
$exception:="CPN <t> Custid <t> Brand <cr>"+Char:C90(13)
READ WRITE:C146([Customers_ReleaseSchedules:46])
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12="?EDI?"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]CustID:12=""; *)
QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]CustomerLine:28=""; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])

If ($numRels>0)
	MESSAGE:C88(" Loading "+String:C10($numRels)+" releases…"+Char:C90(13))
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; $aCPN; [Customers_ReleaseSchedules:46]CustID:12; $aCustId; [Customers_ReleaseSchedules:46]CustomerLine:28; $aLine)
	MESSAGE:C88(" Cleaning…"+Char:C90(13))
	$fixed:=False:C215
	For ($i; 1; $numRels)
		$numFGs:=qryFinishedGood("#CPN"; $aCPN{$i})
		If ($numFGs>0)  //found an hit
			If ($aCustId{$i}="?EDI?")
				If ([Finished_Goods:26]CustID:2#"")
					$aCustId{$i}:=[Finished_Goods:26]CustID:2
					$fixed:=True:C214
				End if 
			End if 
			If ($aCustId{$i}="")
				$aCustId{$i}:=[Finished_Goods:26]CustID:2
				$fixed:=True:C214
			End if 
			If ($aLine{$i}="")
				$aLine{$i}:=[Finished_Goods:26]Line_Brand:15
				$fixed:=True:C214
			End if 
		End if 
		$exception:=$exception+$aCPN{$i}+Char:C90(9)+$aCustId{$i}+Char:C90(9)+$aLine{$i}+Char:C90(13)
	End for 
	
	If ($fixed)
		MESSAGE:C88(" Saving…"+Char:C90(13))
		ARRAY TO SELECTION:C261($aCustId; [Customers_ReleaseSchedules:46]CustID:12; $aLine; [Customers_ReleaseSchedules:46]CustomerLine:28)
	End if 
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY TEXT:C222($aCustId; 0)
	ARRAY TEXT:C222($aLine; 0)
End if   //recs  

xText:=xText+$exception+Char:C90(13)+"_______________ END OF REPORT ______________"
//*Print a list of what happened on this run
QM_Sender(xTitle; ""; xText; distributionList)
//rPrintText ("EDI_CLEANUP"+fYYMMDD (4D_Current_date)+"_"+Replace 
//«string(String(4d_Current_time;◊HHMM);":";""))
xTitle:=""
xText:=""
$stats:=""
$exception:=""

READ WRITE:C146([Customers_Order_Lines:41])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4="?EDI?")
$numRels:=Records in selection:C76([Customers_Order_Lines:41])
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aCustId; 0)
ARRAY TEXT:C222($aLine; 0)
ARRAY TEXT:C222($CustName; 0)

If ($numRels>0)
	ARRAY TEXT:C222($CustName; $numRels)
	
	MESSAGE:C88(" Loading "+String:C10($numRels)+" releases…"+Char:C90(13))
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]ProductCode:5; $aCPN; [Customers_Order_Lines:41]CustID:4; $aCustId; [Customers_Order_Lines:41]CustomerLine:42; $aLine)
	MESSAGE:C88(" Cleaning…"+Char:C90(13))
	$fixed:=False:C215
	For ($i; 1; $numRels)
		$numFGs:=qryFinishedGood("#CPN"; $aCPN{$i})
		If ($numFGs>0)  //found an hit
			If ($aCustId{$i}="?EDI?")
				If ([Finished_Goods:26]CustID:2#"")
					$aCustId{$i}:=[Finished_Goods:26]CustID:2
					$CustName{$i}:=CUST_getName($aCustId{$i})
					$fixed:=True:C214
				End if 
			End if 
			If ($aCustId{$i}="")
				$aCustId{$i}:=[Finished_Goods:26]CustID:2
				$CustName{$i}:=CUST_getName($aCustId{$i})
				$fixed:=True:C214
			End if 
			If ($aLine{$i}="")
				$aLine{$i}:=[Finished_Goods:26]Line_Brand:15
				$fixed:=True:C214
			End if 
		End if 
		$exception:=$exception+$aCPN{$i}+Char:C90(9)+$aCustId{$i}+Char:C90(9)+$aLine{$i}+Char:C90(13)
	End for 
	
	If ($fixed)
		MESSAGE:C88(" Saving…"+Char:C90(13))
		ARRAY TO SELECTION:C261($aCustId; [Customers_Order_Lines:41]CustID:4; $aLine; [Customers_Order_Lines:41]CustomerLine:42; $CustName; [Customers_Order_Lines:41]CustomerName:24)
	End if 
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY TEXT:C222($aCustId; 0)
	ARRAY TEXT:C222($aLine; 0)
End if   //recs  

READ WRITE:C146([Customers_Orders:40])
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustID:2="?EDI?")
$numRels:=Records in selection:C76([Customers_Orders:40])

For ($i; 1; $numRels)
	RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		[Customers_Orders:40]CustID:2:=[Customers_Order_Lines:41]CustID:4
		[Customers_Orders:40]CustomerLine:22:=[Customers_Order_Lines:41]CustomerLine:42
		SAVE RECORD:C53([Customers_Orders:40])
	End if 
	NEXT RECORD:C51([Customers_Orders:40])
End for 

zwStatusMsg("EDI Cleanup"; "Project Mapping")
READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Customers_Order_Lines:41])
READ WRITE:C146([Customers_ReleaseSchedules:46])

//  `run this once to convert to new method
//READ WRITE([x_order_project_mapper])  ` • mel (12/17/03, 16:02:57)
//READ WRITE([Customers_Brand_Lines])
//ALL RECORDS([x_order_project_mapper])
//While (Not(End selection([x_order_project_mapper])))
//QUERY([Customers_Brand_Lines];[Customers_Brand_Lines]LineNameOrBrand=[x_order_project_mapper]Brand)
//If (Records in selection([Customers_Brand_Lines])>0)
//[Customers_Brand_Lines]ProjectNumber:=[x_order_project_mapper]ProjectNumber
//SAVE RECORD([Customers_Brand_Lines])
//[x_order_project_mapper]Brand:="x"+Substring([x_order_project_mapper]Brand;1;19)
//SAVE RECORD([x_order_project_mapper])
//End if 
//
//If (False)
//QUERY([Customers_Orders];[Customers_Orders]ProjectNumber#[x_order_project_mapper]ProjectNumber;*)
//QUERY([Customers_Orders]; & ;[Customers_Orders]CustID=[x_order_project_mapper]custid;*)
//QUERY([Customers_Orders]; & ;[Customers_Orders]CustomerLine=[x_order_project_mapper]Brand)
//If (Records in selection([Customers_Orders])>0)
//APPLY TO SELECTION([Customers_Orders];[Customers_Orders]ProjectNumber:=[x_order_project_mapper]ProjectNumber)
//End if 
//
//QUERY([Customers_Order_Lines];[Customers_Order_Lines]ProjectNumber#[x_order_project_mapper]ProjectNumber;*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]CustID=[x_order_project_mapper]custid;*)
//QUERY([Customers_Order_Lines]; & ;[Customers_Order_Lines]CustomerLine=[x_order_project_mapper]Brand)
//If (Records in selection([Customers_Order_Lines])>0)
//APPLY TO SELECTION([Customers_Order_Lines];[Customers_Order_Lines]ProjectNumber:=[x_order_project_mapper]ProjectNumber)
//End if 
//
//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]ProjectNumber#[x_order_project_mapper]ProjectNumber;*)
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]CustID=[x_order_project_mapper]custid;*)
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]CustomerLine=[x_order_project_mapper]Brand)
//If (Records in selection([Customers_ReleaseSchedules])>0)
//APPLY TO SELECTION([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]ProjectNumber:=[x_order_project_mapper]ProjectNumber)
//End if 
//End if   `false
//
//NEXT RECORD([x_order_project_mapper])
//End while 

READ ONLY:C145([Customers_Brand_Lines:39])  // • mel (12/17/03, 16:02:57)
QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]ProjectNumber:14#"")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	While (Not:C34(End selection:C36([Customers_Brand_Lines:39])))
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]ProjectNumber:53#[Customers_Brand_Lines:39]ProjectNumber:14; *)
		QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]CustID:2=[Customers_Brand_Lines:39]CustID:1; *)
		QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]CustomerLine:22=[Customers_Brand_Lines:39]LineNameOrBrand:2)
		If (Records in selection:C76([Customers_Orders:40])>0)
			APPLY TO SELECTION:C70([Customers_Orders:40]; [Customers_Orders:40]ProjectNumber:53:=[Customers_Brand_Lines:39]ProjectNumber:14)
		End if 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50#[Customers_Brand_Lines:39]ProjectNumber:14; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Customers_Brand_Lines:39]CustID:1; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustomerLine:42=[Customers_Brand_Lines:39]LineNameOrBrand:2)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50:=[Customers_Brand_Lines:39]ProjectNumber:14)
		End if 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40#[Customers_Brand_Lines:39]ProjectNumber:14; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=[Customers_Brand_Lines:39]CustID:1; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerLine:28=[Customers_Brand_Lines:39]LineNameOrBrand:2)
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40:=[Customers_Brand_Lines:39]ProjectNumber:14)
		End if 
		
		NEXT RECORD:C51([Customers_Brand_Lines:39])
	End while 
	
Else 
	//laghzaoui reduce next each next generate query
	
	SELECTION TO ARRAY:C260([Customers_Brand_Lines:39]ProjectNumber:14; $_ProjectNumber; \
		[Customers_Brand_Lines:39]CustID:1; $_CustID; \
		[Customers_Brand_Lines:39]LineNameOrBrand:2; $_LineNameOrBrand)
	
	For ($Iter; 1; Size of array:C274($_ProjectNumber); 1)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]ProjectNumber:53#$_ProjectNumber{$Iter}; *)
		QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]CustID:2=$_CustID{$Iter}; *)
		QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]CustomerLine:22=$_LineNameOrBrand{$Iter})
		If (Records in selection:C76([Customers_Orders:40])>0)
			APPLY TO SELECTION:C70([Customers_Orders:40]; [Customers_Orders:40]ProjectNumber:53:=$_ProjectNumber{$Iter})
		End if 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50#$_ProjectNumber{$Iter}; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=$_CustID{$Iter}; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustomerLine:42=$_LineNameOrBrand{$Iter})
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50:=$_ProjectNumber{$Iter})
		End if 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40#$_ProjectNumber{$Iter}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=$_CustID{$Iter}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerLine:28=$_LineNameOrBrand{$Iter})
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40:=$_ProjectNumber{$Iter})
		End if 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 

zwStatusMsg("EDI Cleanup"; "Canadian BillTo's")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	$hits:=ELC_query(->[Customers_Orders:40]CustID:2; 1)
	QUERY SELECTION:C341([Customers_Orders:40]; [Customers_Orders:40]PONumber:11="X@"; *)
	QUERY SELECTION:C341([Customers_Orders:40];  & ; [Customers_Orders:40]defaultBillTo:5#"01859"; *)
	QUERY SELECTION:C341([Customers_Orders:40];  & ; [Customers_Orders:40]defaultBillTo:5#"00073"; *)
	QUERY SELECTION:C341([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10="accepted")
	
	
Else 
	
	READ WRITE:C146([Customers_Orders:40])
	$criteria:=ELC_getName
	QUERY:C277([Customers_Orders:40]; [Customers:16]ParentCorp:19=$criteria; *)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]PONumber:11="X@"; *)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]defaultBillTo:5#"01859"; *)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]defaultBillTo:5#"00073"; *)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="accepted")
	
	
End if   // END 4D Professional Services : January 2019 ELC_query
If (Records in selection:C76([Customers_Orders:40])>0)
	APPLY TO SELECTION:C70([Customers_Orders:40]; [Customers_Orders:40]defaultBillTo:5:="01859")
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	$hits:=ELC_query(->[Customers_Order_Lines:41]CustID:4; 1)
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PONumber:21="X@"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]defaultBillto:23#"01859"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]defaultBillto:23#"00073"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9="accepted")
	
	
Else 
	
	READ WRITE:C146([Customers_Order_Lines:41])
	$criteria:=ELC_getName
	QUERY:C277([Customers_Order_Lines:41]; [Customers:16]ParentCorp:19=$criteria; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PONumber:21="X@"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]defaultBillto:23#"01859"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]defaultBillto:23#"00073"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9="accepted")
	
	
End if   // END 4D Professional Services : January 2019 ELC_query
If (Records in selection:C76([Customers_Order_Lines:41])>0)
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]defaultBillto:23:="01859")
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	$hits:=ELC_query(->[Customers_ReleaseSchedules:46]CustID:12; 1)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="X@"; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto:22#"01859"; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto:22#"00073"; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
	
Else 
	
	$criteria:=ELC_getName
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$criteria; *)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="X@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto:22#"01859"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto:22#"00073"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
	
End if   // END 4D Professional Services : January 2019 ELC_query

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Billto:22:="01859")
End if 

REDUCE SELECTION:C351([Customers_Orders:40]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([x_order_project_mapper:131]; 0)
zwStatusMsg("EDI Cleanup"; "Finished")