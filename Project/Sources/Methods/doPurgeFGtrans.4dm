//%attributes = {"publishedWeb":true}
//Procedure: doPurgeFGtrans()  062995  MLB
//•062995  MLB  UPR 1507
//• 10/20/97 cs rewrote for new interface in Purge dialog 
//• 12/2/97 cs fix problems found during archive
//• 12/18/97 cs renamed numerics to avoid conflict with Estimate, fixed spelling 
//• 3/27/98 cs added default path to file creation

//mod if ication to this routine -
//project FgLocations -> fgtransactions
//create set of transactions
//create set of all transactions
//difference sets
//search selection for date range
//send, delete
//• 8/27/98 cs chnages to Layout
//•092899  mlb  UPR keep if fg inv from same form
//•101399  mlb  UPR use $i instead of $hit to get the recnumber

C_TEXT:C284($CR)
C_TEXT:C284(xTitle; xText; $Path)

$Path:=<>purgeFolderPath
$CR:=Char:C90(13)
xTitle:="FG_Transaction Purge Summary for "+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"

SET CHANNEL:C77(10; $Path+"FGX_"+fYYMMDD(4D_Current_date))
//arrays to test for presense of inventory from the same jobform
ALL RECORDS:C47([Finished_Goods_Locations:35])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Finished_Goods_Transactions:33]JobForm:5; ->[Finished_Goods_Locations:35]JobForm:19)
	
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Transactions:33])+" file. Please Wait...")
	ARRAY TEXT:C222($_JobForm; 0)
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]JobForm:19; $_JobForm)
	QUERY WITH ARRAY:C644([Finished_Goods_Transactions:33]JobForm:5; $_JobForm)
	zwStatusMsg(""; "")
	
End if   // END 4D Professional Services : January 2019 query selection
CREATE SET:C116([Finished_Goods_Transactions:33]; "FGinventory")
//set to remove payuse transactions
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG:AV@")
CREATE SET:C116([Finished_Goods_Transactions:33]; "PayUse")

UNION:C120("PayUse"; "FGinventory"; "fgxKeepers")
CLEAR SET:C117("PayUse")
CLEAR SET:C117("FGinventory")

If (cb3=1)  //find 0 qty transactions, that are NOT payuse
	$Date:=4D_Current_date-rFg60
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<$Date; *)  //• 12/2/97 cs referenceing wrong Var
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Qty:6=0)
	CREATE SET:C116([Finished_Goods_Transactions:33]; "Zeros")
	DIFFERENCE:C122("Zeros"; "fgxKeepers"; "Zeros")
	USE SET:C118("Zeros")
	doPurgeFgsWork("Zero Qty Transactions"; 4D_Current_date-rFg60)
	CLEAR SET:C117("Zeros")
End if 

If (cb4=1)  //find moves that are not payuse
	$Date:=4D_Current_date-rFg61
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Move"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<$Date)
	CREATE SET:C116([Finished_Goods_Transactions:33]; "Moves")
	DIFFERENCE:C122("Moves"; "fgxKeepers"; "Moves")
	USE SET:C118("Moves")
	doPurgeFgsWork("Non-Pay Use Moves"; $Date)  //• 12/18/97 cs 'Move' was 'Moves' which fails search
	CLEAR SET:C117("Moves")
End if 

If (cb5=1)  //Everything else
	$Date:=4D_Current_date-rFg62
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<$Date)
	CREATE SET:C116([Finished_Goods_Transactions:33]; "AllRemaining")
	DIFFERENCE:C122("AllRemaining"; "fgxKeepers"; "AllRemaining")
	
	ALL RECORDS:C47([Job_Forms:42])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		uRelateSelect(->[Finished_Goods_Transactions:33]JobForm:5; ->[Job_Forms:42]JobFormID:5)
		
		
	Else 
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Transactions:33])+" file. Please Wait...")
		RELATE MANY SELECTION:C340([Finished_Goods_Transactions:33]JobForm:5)
		zwStatusMsg(""; "")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	CREATE SET:C116([Finished_Goods_Transactions:33]; "haveJobs")
	DIFFERENCE:C122("AllRemaining"; "haveJobs"; "AllRemaining")
	CLEAR SET:C117("haveJobs")
	
	USE SET:C118("AllRemaining")
	CLEAR SET:C117("AllRemaining")
	//
	doPurgeFgsWork("All Other Transactions"; $Date)
End if 

CLEAR SET:C117("fgxKeepers")
SET CHANNEL:C77(11)
MESSAGE:C88("Flushing buffers...")
FLUSH CACHE:C297

xText:=xText+$CR+"_______________ END OF REPORT ______________"+String:C10(4d_Current_time; <>HMMAM)
//*Print a list of what happened on this run
rPrintText("FGTRANAX_PURGE_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
xTitle:=""
xText:=""