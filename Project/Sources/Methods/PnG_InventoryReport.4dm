//%attributes = {}
// _______
// Method: PnG_InventoryReport   ( ) ->
// By: Mel Bohince @ 08/04/20, 09:50:11
// Description
// Do it in two sections: summary then detail
// match existing inventory to open orders from before 7/1/20 contract change
// each code can have more than one glue date, and each order for an item can have a different price
// ----------------------------------------------------
//
//
C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor; $productCode)
$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"

If (True:C214)  //summary
	//find all the PnG F/G inventory rolled up by productcode
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	Begin SQL
		select ProductCode, sum(QtyOH) 
		from Finished_Goods_Locations 
		where CustID = '00199' and Location like 'FG%' 
		group by ProductCode
		into :$_ProductCode, :$_QtyOH
	End SQL
	$numCPN:=Size of array:C274($_ProductCode)
	
	$csvToExport:="SUMMARY:"+$recordDelimitor
	$csvToExport:=$csvToExport+"GCAS"+$fieldDelimitor+"ON_HAND"+$fieldDelimitor+"OPEN_ORDER"+$recordDelimitor
	C_LONGINT:C283($_TTL_Qty_Open)
	For ($cpn; 1; $numCPN)
		$code:=$_ProductCode{$cpn}
		$_TTL_Qty_Open:=0
		Begin SQL
			select sum(Qty_Open)
			from Customers_Order_Lines
			where ProductCode = :$code and DateOpened < '07/01/20' and upper(Status) = 'ACCEPTED' and Qty_Open > 0
			group by ProductCode
			into :$_TTL_Qty_Open
		End SQL
		
		If ($_TTL_Qty_Open>0)
			$csvToExport:=$csvToExport+$_ProductCode{$cpn}+$fieldDelimitor+String:C10($_QtyOH{$cpn})+$fieldDelimitor+String:C10($_TTL_Qty_Open)+$recordDelimitor
		End if 
	End for 
	
End if   //summary

If (True:C214)  //detail
	$csvToExport:=$csvToExport+$recordDelimitor+$recordDelimitor+"DETAIL"+$recordDelimitor
	//find all the PnG F/G inventory rolled up by jobit
	ARRAY TEXT:C222($_Jobit; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	Begin SQL
		select Jobit, sum(QtyOH) 
		from Finished_Goods_Locations 
		where CustID = '00199' and Location like 'FG%' 
		group by Jobit
		into :$_Jobit, :$_QtyOH
	End SQL
	$numJobits:=Size of array:C274($_Jobit)
	//
	//
	//get the product code and glue date, then sort by product and jobit
	ARRAY TEXT:C222($_ProductCode; $numJobits)
	ARRAY DATE:C224($_Glued; $numJobits)
	
	For ($jobit; 1; $numJobits)
		$_ProductCode{$jobit}:=JMI_getCPN($_Jobit{$jobit})
		$_Glued{$jobit}:=JMI_getGlueDate($_Jobit{$jobit})
	End for 
	
	MULTI SORT ARRAY:C718($_ProductCode; >; $_Jobit; >; $_QtyOH; $_Glued)
	//
	//
	//get the related order line info if old contract liabilites exist
	ARRAY TEXT:C222($_OrderInfo; $numJobits)
	$csvToExport:=$csvToExport+"GCAS,Jobit,Glued,Onhand,1stOrder,1stPrice,1stDate,1stQtyPOpen,2ndOrder,2ndPrice,2ndDate,2ndQtyPOpen,3rdOrder,3rdPrice,3rdDate,3rdQtyPOpen\r"
	For ($jobit; 1; $numJobits)
		$productCode:=$_ProductCode{$jobit}
		ARRAY TEXT:C222($_Orderline; 0)
		ARRAY REAL:C219($_Price_Per_M; 0)
		ARRAY DATE:C224($_DateOpened; 0)
		ARRAY LONGINT:C221($_Qty_Open; 0)
		Begin SQL
			select OrderLine, DateOpened, Price_Per_M, Qty_Open
			from Customers_Order_Lines
			where ProductCode = :$productCode and DateOpened < '07/01/20' and upper(Status) = 'ACCEPTED' and Qty_Open > 0
			into :$_Orderline, :$_DateOpened, :$_Price_Per_M, :$_Qty_Open
		End SQL
		
		$_OrderInfo{$jobit}:=""
		For ($order; 1; Size of array:C274($_Orderline))
			$_OrderInfo{$jobit}:=$_OrderInfo{$jobit}+$_Orderline{$order}+$fieldDelimitor+String:C10($_Price_Per_M{$order})+$fieldDelimitor+String:C10($_DateOpened{$order}; Internal date short special:K1:4)+$fieldDelimitor+String:C10($_Qty_Open{$order})+$fieldDelimitor
		End for 
		
		If (Size of array:C274($_Orderline)>0)
			$csvToExport:=$csvToExport+$_ProductCode{$jobit}+$fieldDelimitor+$_Jobit{$jobit}+$fieldDelimitor+String:C10($_Glued{$jobit}; Internal date short special:K1:4)+$fieldDelimitor+String:C10($_QtyOH{$jobit})+$fieldDelimitor+$_OrderInfo{$jobit}+$recordDelimitor
		End if 
	End for 
	
End if   //detail

//save the text to a document
C_TEXT:C284($docName)
C_TIME:C306($docRef)

$docName:="CSV_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $csvToExport)
CLOSE DOCUMENT:C267($docRef)

$err:=util_Launch_External_App($docName)

