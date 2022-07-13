//%attributes = {"publishedWeb":true}
//Procedure: doPurgeOrders()  063095  MLB
//•062995  MLB  UPR 1507
//• 4/11/97 cs added needed code to allow user to select a date range for 
//closed orders & a seperate range for killed orders
//• 3/27/98 cs added default path to file creation

READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Customers_Order_Lines:41])
READ WRITE:C146([Customers_ReleaseSchedules:46])
READ WRITE:C146([Customers_Order_Change_Orders:34])

C_LONGINT:C283($i; $recs)
C_TEXT:C284($Path)
C_TEXT:C284($CR)
C_TEXT:C284(xTitle; xText)

$Path:=<>purgeFolderPath
$CR:=Char:C90(13)
xTitle:="Order Purge Summary for "+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"+$CR+"Search includes status: "
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Customers_Orders:40]; "closed")
	CREATE EMPTY SET:C140([Customers_Orders:40]; "CoKill")
	CREATE EMPTY SET:C140([Customers_Orders:40]; "cancel")
	
	If (r16=1)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Closed"; *)
		QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]DateClosed:49<dEndDate)  //• 4/11/97 cs 
		CREATE SET:C116([Customers_Orders:40]; "closed")
		xText:=xText+"("+String:C10(Records in selection:C76([Customers_Orders:40]))+") Closed "
	End if 
	
	If (r17=1)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Kill@"; *)
		QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]DateOpened:6<(4D_Current_date-r20))  //• 4/11/97 cs 
		CREATE SET:C116([Customers_Orders:40]; "CoKill")
		xText:=xText+"("+String:C10(Records in selection:C76([Customers_Orders:40]))+") CoKill "
	End if 
	
	If (r18=1)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Cancel@")
		CREATE SET:C116([Customers_Orders:40]; "cancel")
		xText:=xText+"("+String:C10(Records in selection:C76([Customers_Orders:40]))+") Cancel "
	End if 
	UNION:C120("closed"; "CoKill"; "Orders")
	UNION:C120("Orders"; "cancel"; "Orders")
	USE SET:C118("Orders")
	CLEAR SET:C117("closed")
	CLEAR SET:C117("CoKill")
	CLEAR SET:C117("cancel")
Else 
	
	C_DATE:C307($current_date)
	$current_date:=4D_Current_date
	$result:=$current_date-r20
	
	QUERY BY FORMULA:C48([Customers_Orders:40]; \
		(\
		([Customers_Orders:40]Status:10="Closed")\
		 & \
		([Customers_Orders:40]DateClosed:49<dEndDate)\
		)\
		 | \
		(\
		([Customers_Orders:40]Status:10="Kill@")\
		 & \
		([Customers_Orders:40]DateOpened:6<$result)\
		)\
		 | \
		([Customers_Orders:40]Status:10="Cancel@")\
		)
	
	
	C_LONGINT:C283($Closed; $Kill; $CANCEL)
	ARRAY LONGINT:C221($_record_finale; 0)
	
	SELECTION TO ARRAY:C260([Customers_Orders:40]Status:10; $_Status; \
		[Customers_Orders:40]DateClosed:49; $_DateClosed; \
		[Customers_Orders:40]DateOpened:6; $_DateOpened; \
		[Customers_Orders:40]; $_record_number)
	
	For ($Iter; 1; Size of array:C274($_Status); 1)
		Case of 
			: (($_Status{$Iter}="Closed@") & ($_DateClosed{$Iter}<dEndDate) & (r16=1))
				
				APPEND TO ARRAY:C911($_record_finale; $_record_number{$Iter})
				$Closed:=$Closed+1
				
			: (($_Status{$Iter}="Kill@") & ($_DateOpened{$Iter}<$result) & (r17=1))
				
				APPEND TO ARRAY:C911($_record_finale; $_record_number{$Iter})
				$Kill:=$Kill+1
				
			: (($_Status{$Iter}="Cancel@") & (r18=1))
				
				APPEND TO ARRAY:C911($_record_finale; $_record_number{$Iter})
				$CANCEL:=$CANCEL+1
				
		End case 
		
	End for 
	
	
	If (r16=1)
		xText:=xText+"("+String:C10($Closed)+") Closed "
	End if 
	
	If (r17=1)
		xText:=xText+"("+String:C10($Kill)+") CoKill "
	End if 
	
	If (r18=1)
		xText:=xText+"("+String:C10($CANCEL)+") Cancel "
	End if 
	
	CREATE SELECTION FROM ARRAY:C640([Customers_Orders:40]; $_record_finale)
	
End if   // END 4D Professional Services : January 2019 


$recs:=Records in selection:C76([Customers_Orders:40])
//RELATE MANY SELECTION([OrderLines]Order)
//RELATE MANY SELECTION([ReleaseSchedule]OrderLine)
//RELATE MANY SELECTION([OrderChgHistory]OrderNo)

//TRACE
FIRST RECORD:C50([Customers_Orders:40])

SET CHANNEL:C77(10; $Path+("ORD_"+String:C10(4D_Current_date; 4)+"_01"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" Order records.")

For ($i; 1; $recs)
	SEND RECORD:C78([Customers_Orders:40])
	NEXT RECORD:C51([Customers_Orders:40])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)



If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	RELATE MANY SELECTION:C340([Customers_Order_Lines:41]OrderNumber:1)
	$recs:=Records in selection:C76([Customers_Order_Lines:41])
	FIRST RECORD:C50([Customers_Order_Lines:41])
	
Else 
	RELATE MANY SELECTION:C340([Customers_Order_Lines:41]OrderNumber:1)
	// see previous line
	$recs:=Records in selection:C76([Customers_Order_Lines:41])
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
CREATE SET:C116([Customers_Order_Lines:41]; "Orderlines")
SET CHANNEL:C77(10; $Path+("ORD_"+String:C10(4D_Current_date; 4)+"_02"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" Orderline records.")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	CREATE EMPTY SET:C140([Finished_Goods_Transactions:33]; "fgx")
	For ($i; 1; $recs)
		SEND RECORD:C78([Customers_Order_Lines:41])
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_Order_Lines:41]OrderLine:3+"@"))
		CREATE SET:C116([Finished_Goods_Transactions:33]; "these")
		UNION:C120("fgx"; "these"; "fgx")
		NEXT RECORD:C51([Customers_Order_Lines:41])
		uThermoUpdate($i)
		If (Not:C34(<>fContinue))  //esc pressed
			$i:=$i+$recs
		End if 
	End for 
	CLEAR SET:C117("these")
	
	
Else 
	
	ARRAY TEXT:C222($_OrderLine; 0)
	
	For ($i; 1; $recs)
		SEND RECORD:C78([Customers_Order_Lines:41])
		$OrdreLine_val:=[Customers_Order_Lines:41]OrderLine:3+"@"
		APPEND TO ARRAY:C911($_OrderLine; $OrdreLine_val)
		NEXT RECORD:C51([Customers_Order_Lines:41])
		uThermoUpdate($i)
		If (Not:C34(<>fContinue))  //esc pressed
			$i:=$i+$recs
		End if 
	End for 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "fgx")
	QUERY WITH ARRAY:C644([Finished_Goods_Transactions:33]OrderItem:16; $_OrderLine)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	
End if   // END 4D Professional Services : January 2019 
uThermoClose
SET CHANNEL:C77(11)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)
	$recs:=Records in selection:C76([Customers_ReleaseSchedules:46])
	FIRST RECORD:C50([Customers_ReleaseSchedules:46])
	
	
Else 
	
	RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)
	// see previous line
	$recs:=Records in selection:C76([Customers_ReleaseSchedules:46])
	
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
CREATE SET:C116([Customers_ReleaseSchedules:46]; "Rels")
SET CHANNEL:C77(10; $Path+("ORD_"+String:C10(4D_Current_date; 4)+"_03"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" Release records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Customers_ReleaseSchedules:46])
	NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	RELATE MANY SELECTION:C340([Customers_Order_Change_Orders:34]OrderNo:5)
	$recs:=Records in selection:C76([Customers_Order_Change_Orders:34])
	FIRST RECORD:C50([Customers_Order_Change_Orders:34])
	
	
Else 
	
	RELATE MANY SELECTION:C340([Customers_Order_Change_Orders:34]OrderNo:5)
	// see previous line
	$recs:=Records in selection:C76([Customers_Order_Change_Orders:34])
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
CREATE SET:C116([Customers_Order_Change_Orders:34]; "CCOs")
SET CHANNEL:C77(10; ($Path+"ORD_"+String:C10(4D_Current_date; 4)+"_04"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" Change Order records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Customers_Order_Change_Orders:34])
	NEXT RECORD:C51([Customers_Order_Change_Orders:34])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	RELATE MANY SELECTION:C340([Customers_BilledPayUse:86]Orderline:1)
	$recs:=Records in selection:C76([Customers_BilledPayUse:86])
	FIRST RECORD:C50([Customers_BilledPayUse:86])
	
	
Else 
	
	RELATE MANY SELECTION:C340([Customers_BilledPayUse:86]Orderline:1)
	// see previous line
	$recs:=Records in selection:C76([Customers_BilledPayUse:86])
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
CREATE SET:C116([Customers_BilledPayUse:86]; "BPUs")
SET CHANNEL:C77(10; ($Path+"ORD_"+String:C10(4D_Current_date; 4)+"_06"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" Billed PayUse records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Customers_BilledPayUse:86])
	NEXT RECORD:C51([Customers_BilledPayUse:86])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

USE SET:C118("fgx")
$recs:=Records in selection:C76([Finished_Goods_Transactions:33])
FIRST RECORD:C50([Finished_Goods_Transactions:33])
SET CHANNEL:C77(10; ($Path+"ORD_"+String:C10(4D_Current_date; 4)+"_05"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" FG xfer records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Finished_Goods_Transactions:33])
	NEXT RECORD:C51([Finished_Goods_Transactions:33])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

USE SET:C118("Orders")
USE SET:C118("Orderlines")
USE SET:C118("Rels")
USE SET:C118("CCOs")
MESSAGE:C88($CR+"Deleting Orders")
If (<>fContinue)
	xText:=xText+$CR+String:C10(Records in set:C195("Orders"); "^^^,^^^,^^0 ")+" Order deleted and exported to ORD_"+String:C10(4D_Current_date; 4)+"_1"
	MESSAGE:C88($CR+"Deleting Orders")
	DELETE SELECTION:C66([Customers_Orders:40])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in set:C195("Orderlines"); "^^^,^^^,^^0 ")+" Orderlines deleted and exported to ORD_"+String:C10(4D_Current_date; 4)+"_2"
	MESSAGE:C88($CR+"Deleting Orderlines")
	DELETE SELECTION:C66([Customers_Order_Lines:41])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in set:C195("Rels"); "^^^,^^^,^^0 ")+" Releases deleted and exported to ORD_"+String:C10(4D_Current_date; 4)+"_3"
	MESSAGE:C88($CR+"Deleting Release")
	DELETE SELECTION:C66([Customers_ReleaseSchedules:46])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in set:C195("CCOs"); "^^^,^^^,^^0 ")+" Change Orders deleted and exported to ORD_"+String:C10(4D_Current_date; 4)+"_4"
	MESSAGE:C88($CR+"Deleting Change Orders")
	DELETE SELECTION:C66([Customers_Order_Change_Orders:34])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in set:C195("fgx"); "^^^,^^^,^^0 ")+" FG Transactions deleted and exported to ORD_"+String:C10(4D_Current_date; 4)+"_5"
	MESSAGE:C88($CR+"Deleting FG transactions")
	DELETE SELECTION:C66([Finished_Goods_Transactions:33])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in set:C195("BPUs"); "^^^,^^^,^^0 ")+" Billed PayUse deleted and exported to ORD_"+String:C10(4D_Current_date; 4)+"_6"
	MESSAGE:C88($CR+"Deleting Billed PayUse")
	DELETE SELECTION:C66([Customers_BilledPayUse:86])
	FLUSH CACHE:C297
	
	ALL RECORDS:C47([Customers_BilledPayUse:86])
	CREATE SET:C116([Customers_BilledPayUse:86]; "allPayUse")
	RELATE ONE SELECTION:C349([Customers_BilledPayUse:86]; [Customers_Order_Lines:41])
	RELATE MANY SELECTION:C340([Customers_BilledPayUse:86]Orderline:1)
	CREATE SET:C116([Customers_BilledPayUse:86]; "stillThere")
	DIFFERENCE:C122("allPayUse"; "stillThere"; "orphans")
	USE SET:C118("orphans")
	$recs:=Records in selection:C76([Customers_BilledPayUse:86])
	FIRST RECORD:C50([Customers_BilledPayUse:86])
	SET CHANNEL:C77(10; ($Path+"ORD_"+String:C10(4D_Current_date; 4)+"_07"))
	uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" Orphan PayUse records.")
	For ($i; 1; $recs)
		SEND RECORD:C78([Customers_BilledPayUse:86])
		NEXT RECORD:C51([Customers_BilledPayUse:86])
		uThermoUpdate($i)
		If (Not:C34(<>fContinue))  //esc pressed
			$i:=$i+$recs
		End if 
	End for 
	uThermoClose
	SET CHANNEL:C77(11)
	
	xText:=xText+$CR+String:C10(Records in set:C195("BPUs"); "^^^,^^^,^^0 ")+" Orphan Billed PayUse deleted and exported to ORD_"+String:C10(4D_Current_date; 4)+"_7"
	MESSAGE:C88($CR+"Deleting Orphaned Billed PayUse")
	DELETE SELECTION:C66([Customers_BilledPayUse:86])
	FLUSH CACHE:C297
	
	
	MESSAGE:C88($CR+"                                 "+$CR)
	
Else 
	xText:=xText+$CR+"Purge Canceled, no Orders were deleted."
End if 
CLEAR SET:C117("Orders")
CLEAR SET:C117("Orderlines")
CLEAR SET:C117("Rels")
CLEAR SET:C117("CCOs")
CLEAR SET:C117("BPUs")
CLEAR SET:C117("allPayUse")
CLEAR SET:C117("stillThere")
CLEAR SET:C117("orphans")

xText:=xText+$CR+"_______________ END OF REPORT ______________"+String:C10(4d_Current_time; <>HMMAM)
//*Print a list of what happened on this run
rPrintText("ORDER_PURGE_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
xTitle:=""
xText:=""