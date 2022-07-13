//%attributes = {"publishedWeb":true}
//(p) DoPurgePos
//purge of POs & po Items
//• 11/6/97 cs created 
//• 11/21/97 cs added interprocess flag to allow this to be branched off
//   normal purge routine since this seems to be causing memory problems
//• 12/23/97 cs stop removal of Consignment ink po
//• 3/27/98 cs added default path to file creation
//• 4/16/98 cs remove only completely filled/closed orders
//• 7/15/98 cs undo saving of consignment POs
//•110398  MLB  UPR 1993 exclude po's with bins
//•092799  mlb  UPR add rmxfers

C_TEXT:C284($cr)
C_TEXT:C284(xTitle; xText; $Path)
C_BOOLEAN:C305(<>Activity)
C_DATE:C307($PurgeDate)

$cr:=Char:C90(13)
$Path:=<>purgeFolderPath  //GetDefaultPath 
$PurgeDate:=Date:C102(FiscalYear("start"; 4D_Current_date))
$PurgeDate:=Add to date:C393($PurgeDate; -1; 0; 0)
//If (Month of(4D_Current_date)<[CONTROL]FiscalYearStart)  `if this month
//« is before the start of fiscal year, go back 2 years 
//$PurgeDate:=Date(String([CONTROL]FiscalYearStart;"00")+"/01/"+String
//«(Year of(4D_Current_date)-2;"0000"))-1
//Else   `go back one year
//$PurgeDate:=Date(String([CONTROL]FiscalYearStart;"00")+"/01/"+String(Yea
//«r of(4D_Current_date)-1;"0000"))-1
//End if 

xTitle:="Purchase Orders Purge Summary for "+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"
xText:=$cr+"Search was for POs before "+String:C10($Purgedate; <>SHORTDATE)

MESSAGE:C88($cr+"gathering PO information to Purge...")
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PODate:4<$PurgeDate)
//QUERY([PURCHASE_ORDER]; & ;[PURCHASE_ORDER]Status # "Partial@")  `•092399  mlb  
//• 7/15/98 cs 
//SEARCH([PURCHASE_ORDER]; & ;[PURCHASE_ORDER]Consignment=False)
utl_Trace
//QUERY SELECTION([PURCHASE_ORDER];[PURCHASE_ORDER]Status="Closed";*)  `• 4/16/98 
//QUERY SELECTION([PURCHASE_ORDER]; | ;[PURCHASE_ORDER]Status="Full@")
CREATE SET:C116([Purchase_Orders:11]; "POs2Del")
//•110398  MLB  UPR 1993 protect PO which still have inventory`xFindRMorphans
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	ALL RECORDS:C47([Raw_Materials_Locations:25])
	uRelateSelect(->[Purchase_Orders_Items:12]POItemKey:1; ->[Raw_Materials_Locations:25]POItemKey:19; 0)
	uRelateSelect(->[Purchase_Orders:11]PONo:1; ->[Purchase_Orders_Items:12]PONo:2; 0)
	
	CREATE SET:C116([Purchase_Orders:11]; "HaveINV")
	DIFFERENCE:C122("POs2Del"; "HaveINV"; "POs2Del")
	USE SET:C118("POs2Del")
	CLEAR SET:C117("HaveINV")
	//•110398  MLB  end 
	//TRACE
	uRelateSelect(->[Purchase_Orders_Items:12]PONo:2; ->[Purchase_Orders:11]PONo:1; 0)  //get all po_items for locaatd Purchase orders
	CREATE SET:C116([Purchase_Orders_Items:12]; "Remove")
	uRelateSelect(->[Purchase_Orders_Releases:79]POitemKey:1; ->[Purchase_Orders_Items:12]POItemKey:1; 0)
	CREATE SET:C116([Purchase_Orders_Releases:79]; "HoldRels")
	
	uRelateSelect(->[Raw_Materials_Transactions:23]POItemKey:4; ->[Purchase_Orders_Items:12]POItemKey:1; 0)  //•092799  mlb  
	QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2#"Issue")  //•092799  mlb  
	CREATE SET:C116([Raw_Materials_Transactions:23]; "rmxfers")  //•092799  mlb  
	
	uRelateSelect(->[Purchase_Orders_Job_forms:59]POItemKey:1; ->[Purchase_Orders_Items:12]POItemKey:1; 0)
	CREATE SET:C116([Purchase_Orders_Job_forms:59]; "PoJobits")
	USE SET:C118("POs2Del")
	uRelateSelect(->[Purchase_Orders_Chg_Orders:13]PONo:3; ->[Purchase_Orders:11]PONo:1; 0)
	CREATE SET:C116([Purchase_Orders_Chg_Orders:13]; "ChngOrds")
	
Else 
	
	ALL RECORDS:C47([Raw_Materials_Locations:25])
	RELATE ONE SELECTION:C349([Raw_Materials_Locations:25]; [Purchase_Orders:11])
	
	CREATE SET:C116([Purchase_Orders:11]; "HaveINV")
	DIFFERENCE:C122("POs2Del"; "HaveINV"; "POs2Del")
	USE SET:C118("POs2Del")
	CLEAR SET:C117("HaveINV")
	//•110398  MLB  end 
	//TRACE
	RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]PONo:2)
	CREATE SET:C116([Purchase_Orders_Items:12]; "Remove")
	ARRAY TEXT:C222($_POitemKey; 0)
	DISTINCT VALUES:C339([Purchase_Orders_Items:12]POItemKey:1; $_POitemKey)
	QUERY WITH ARRAY:C644([Purchase_Orders_Releases:79]POitemKey:1; $_POitemKey)
	
	CREATE SET:C116([Purchase_Orders_Releases:79]; "HoldRels")
	
	RELATE MANY SELECTION:C340([Raw_Materials_Transactions:23]POItemKey:4)
	QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2#"Issue")  //•092799  mlb  
	CREATE SET:C116([Raw_Materials_Transactions:23]; "rmxfers")  //•092799  mlb  
	
	RELATE MANY SELECTION:C340([Purchase_Orders_Job_forms:59]POItemKey:1)
	CREATE SET:C116([Purchase_Orders_Job_forms:59]; "PoJobits")
	USE SET:C118("POs2Del")
	RELATE MANY SELECTION:C340([Purchase_Orders_Chg_Orders:13]PONo:3)
	CREATE SET:C116([Purchase_Orders_Chg_Orders:13]; "ChngOrds")
	
End if   // END 4D Professional Services : January 2019 query selection

ALL RECORDS:C47([Purchase_Orders_Chg_Orders:13])
CREATE SET:C116([Purchase_Orders_Chg_Orders:13]; "AllChngO")
DIFFERENCE:C122("AllChngO"; "ChngOrds"; "AllChngO")  //all change orders minus those about to be removed
USE SET:C118("AllChngO")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Purchase_Orders:11]PONo:1; ->[Purchase_Orders_Chg_Orders:13]PONo:3; 0)  //pos for the remainder Change orders
	uRelateSelect(->[Purchase_Orders_Chg_Orders:13]PONo:3; ->[Purchase_Orders:11]PONo:1; 0)  //get change orders that have POs
	
	
Else 
	
	RELATE ONE SELECTION:C349([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders:11])
	RELATE MANY SELECTION:C340([Purchase_Orders_Chg_Orders:13]PONo:3)
	
	
End if   // END 4D Professional Services : January 2019 query selection
CREATE SET:C116([Purchase_Orders_Chg_Orders:13]; "Forget")
DIFFERENCE:C122("AllChngO"; "Forget"; "AllChngO")  //those change orders without pos
UNION:C120("AllChngO"; "ChngOrds"; "ChngOrds")  //add to those about to be removed
CLEAR SET:C117("AllChngO")

//----------- POs
SET CHANNEL:C77(10; $Path+"POs"+fYYMMDD(4D_Current_date))
$recs:=Records in set:C195("POs2Del")
USE SET:C118("POs2Del")
CLEAR SET:C117("POs2Del")
FIRST RECORD:C50([Purchase_Orders:11])
uThermoInit($recs; "Purging "+String:C10($recs; "###,##0 ")+"from Purchase Order records.")

For ($i; 1; $Recs)
	SEND RECORD:C78([Purchase_Orders:11])
	NEXT RECORD:C51([Purchase_Orders:11])
	uThermoUpdate($i)
End for 
SET CHANNEL:C77(11)
MESSAGE:C88("Deleting Purchase Orders...")
DELETE SELECTION:C66([Purchase_Orders:11])
FLUSH CACHE:C297
uThermoClose
xText:=xText+$cr+String:C10($Recs; "^^^,^^^,^^0 ")+" Purchase Orders deleted and exported to: POs"+fYYMMDD(4D_Current_date)

//----------- PO Items
$Recs:=Records in set:C195("Remove")
USE SET:C118("Remove")
CLEAR SET:C117("Remove")
SET CHANNEL:C77(10; $Path+"POItems"+fYYMMDD(4D_Current_date))
FIRST RECORD:C50([Purchase_Orders_Items:12])
uThermoInit($recs; "Purging "+String:C10($recs; "###,##0 ")+"from Purchase Order Item records.")

For ($i; 1; Records in selection:C76([Purchase_Orders_Items:12]))
	SEND RECORD:C78([Purchase_Orders_Items:12])
	NEXT RECORD:C51([Purchase_Orders_Items:12])
	uThermoUpdate($i)
End for 
SET CHANNEL:C77(11)
MESSAGE:C88("Deleting Purchase Orders Items...")
DELETE SELECTION:C66([Purchase_Orders_Items:12])
FLUSH CACHE:C297
uThermoClose
xText:=xText+$cr+String:C10($Recs; "^^^,^^^,^^0 ")+" PO Items deleted and exported to: POItems"+fYYMMDD(4D_Current_date)

//----------- PO Releases
$Recs:=Records in set:C195("HoldRels")
USE SET:C118("HoldRels")
CLEAR SET:C117("HoldRels")
SET CHANNEL:C77(10; $Path+"PORels"+fYYMMDD(4D_Current_date))
FIRST RECORD:C50([Purchase_Orders_Releases:79])
uThermoInit($recs; "Purging "+String:C10($recs; "###,##0 ")+"from Purchasing Release records.")

For ($i; 1; Records in selection:C76([Purchase_Orders_Releases:79]))
	SEND RECORD:C78([Purchase_Orders_Releases:79])
	NEXT RECORD:C51([Purchase_Orders_Releases:79])
End for 
SET CHANNEL:C77(11)
MESSAGE:C88("Deleting Po Releases...")
DELETE SELECTION:C66([Purchase_Orders_Releases:79])
FLUSH CACHE:C297
uThermoClose
xText:=xText+$cr+String:C10($Recs; "^^^,^^^,^^0 ")+" Po Releases deleted and exported to: PORels"+fYYMMDD(4D_Current_date)

//----------- PO Change orders
$Recs:=Records in set:C195("ChngOrds")
USE SET:C118("ChngOrds")
CLEAR SET:C117("ChngOrds")
SET CHANNEL:C77(10; $Path+"POChgOs"+fYYMMDD(4D_Current_date))
FIRST RECORD:C50([Purchase_Orders_Chg_Orders:13])
uThermoInit($recs; "Purging "+String:C10($recs; "###,##0 ")+"from PO Change Order records.")

For ($i; 1; Records in selection:C76([Purchase_Orders_Chg_Orders:13]))
	SEND RECORD:C78([Purchase_Orders_Chg_Orders:13])
	NEXT RECORD:C51([Purchase_Orders_Chg_Orders:13])
End for 
SET CHANNEL:C77(11)
MESSAGE:C88("Deleting PO Change Order...")
DELETE SELECTION:C66([Purchase_Orders_Chg_Orders:13])
FLUSH CACHE:C297
uThermoClose
xText:=xText+$cr+String:C10($Recs; "^^^,^^^,^^0 ")+" PO Change Orders deleted and exported to: POChgOs"+fYYMMDD(4D_Current_date)

//----------- PO Item JobLinks
$Recs:=Records in set:C195("POJobits")
USE SET:C118("POJobits")
CLEAR SET:C117("POJobits")
SET CHANNEL:C77(10; $Path+"POItemJobLinks"+fYYMMDD(4D_Current_date))
FIRST RECORD:C50([Purchase_Orders_Job_forms:59])
uThermoInit($recs; "Purging "+String:C10($recs; "###,##0 ")+"from PO Item JobLink records.")

For ($i; 1; Records in selection:C76([Purchase_Orders_Job_forms:59]))
	SEND RECORD:C78([Purchase_Orders_Job_forms:59])
	NEXT RECORD:C51([Purchase_Orders_Job_forms:59])
End for 
SET CHANNEL:C77(11)
MESSAGE:C88("Deleting PO Item JobLink...")
DELETE SELECTION:C66([Purchase_Orders_Job_forms:59])
FLUSH CACHE:C297
uThermoClose
xText:=xText+$cr+String:C10($Recs; "^^^,^^^,^^0 ")+" PO Item JobLinks deleted and exported to: POItemJobLink "+fYYMMDD(4D_Current_date)

//----------- rmxfers
$Recs:=Records in set:C195("rmxfers")
READ WRITE:C146([Raw_Materials_Transactions:23])
USE SET:C118("rmxfers")
CLEAR SET:C117("rmxfers")
SET CHANNEL:C77(10; $Path+"RM_Xfers"+fYYMMDD(4D_Current_date))
FIRST RECORD:C50([Raw_Materials_Transactions:23])
uThermoInit($recs; "Purging "+String:C10($recs; "###,##0 ")+"from PO Item JobLink records.")

For ($i; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
	SEND RECORD:C78([Raw_Materials_Transactions:23])
	NEXT RECORD:C51([Raw_Materials_Transactions:23])
End for 
SET CHANNEL:C77(11)
MESSAGE:C88("Deleting rm xfers...")
DELETE SELECTION:C66([Raw_Materials_Transactions:23])
uThermoClose
xText:=xText+$cr+String:C10($Recs; "^^^,^^^,^^0 ")+" rmxfers deleted and exported to: RM_Xfers"+fYYMMDD(4D_Current_date)

xText:=xText+$cr+"_______________ END OF REPORT ______________"+String:C10(4d_Current_time; <>HMMAM)
//*Print a list of what happened on this run
rPrintText("Purchase Order Purge"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
xTitle:=""
xText:=""
MESSAGE:C88($cr+"Flushing Buffers...")
FLUSH CACHE:C297

REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
REDUCE SELECTION:C351([Purchase_Orders_Job_forms:59]; 0)
REDUCE SELECTION:C351([Purchase_Orders_Chg_Orders:13]; 0)
REDUCE SELECTION:C351([Purchase_Orders_Releases:79]; 0)
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
//CLOSE WINDOW
<>Activity:=True:C214  //• 11/21/97 cs tell calling process that this has completed
uWinListCleanup