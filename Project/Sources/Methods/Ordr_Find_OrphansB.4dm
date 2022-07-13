//%attributes = {}
//Method:  Ordr_Find_OrphansB({bDelete}
//Description:

If (False:C215)  //Methods of interest
	
	CloseCustOrders
	doPurgeOrders
	ams_PurgeBtn
	ams_Purge_Server_Side
	fSalesCommissionAdj
	Pjt_ActivitySummary
	
End if   //Done methods of interest

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($1; $bDelete)
	C_LONGINT:C283($nNumberOfParameters)
	
	C_LONGINT:C283($nOrderNumber; $nNumberOfOrderNumbers)
	C_LONGINT:C283($nTable; $nNumberOfTables)
	
	ARRAY LONGINT:C221($anOrderNumber; 0)
	ARRAY TEXT:C222($atOrderNumber; 0)
	
	ARRAY TEXT:C222($atTable; 0)
	ARRAY LONGINT:C221($anZero; 0)
	ARRAY LONGINT:C221($anOrphan; 0)
	ARRAY LONGINT:C221($anOrder; 0)
	ARRAY LONGINT:C221($anMultiple; 0)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$bDelete:=False:C215
	If ($nNumberOfParameters>=1)
		$bDelete:=$1
	End if 
	
	ARRAY POINTER:C280($apColumn; 0)
	
	APPEND TO ARRAY:C911($apColumn; ->$atTable)
	APPEND TO ARRAY:C911($apColumn; ->$anZero)
	APPEND TO ARRAY:C911($apColumn; ->$anOrphan)
	APPEND TO ARRAY:C911($apColumn; ->$anOrder)
	APPEND TO ARRAY:C911($apColumn; ->$anMultiple)
	
	ARRAY POINTER:C280($apTableOrderNumber; 0)
	
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Finished_Goods_Specifications:98]OrderNumber:59)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Finished_Goods_Transactions:33]OrderNo:15)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Finished_Goods:26]LastOrderNo:18)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Prep_Charges:103]OrderNumber:8)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Jobs:15]OrderNo:15)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Customers_Orders:40]OrderNumber:1)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Customers_Order_Lines:41]OrderNumber:1)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Customers_Order_Change_Orders:34]OrderNo:5)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Customers_ReleaseSchedules:46]OrderNumber:2)
	APPEND TO ARRAY:C911($apTableOrderNumber; ->[Customers_Invoices:88]OrderLine:4)  //INV_testCommission
	
	$nNumberOfTables:=Size of array:C274($apTableOrderNumber)
	
End if   //Done Initialize

SET QUERY DESTINATION:C396(Into variable:K19:4; $nOrderCount)

For ($nTable; 1; $nNumberOfTables)  //Loop through tables with ordernumber
	
	$pTableOrderNumber:=$apTableOrderNumber{$nTable}
	
	$nTableOrderNumberType:=Type:C295($pTableOrderNumber->)
	
	$pTable:=Table:C252(Table:C252($pTableOrderNumber))
	
	READ ONLY:C145($pTable->)
	
	$nZero:=0
	$nOrphan:=0
	$nOrder:=0
	$nMultiple:=0
	
	ARRAY LONGINT:C221($anOrderNumber; 0)
	ARRAY TEXT:C222($atOrderNumber; 0)
	
	ALL RECORDS:C47($pTable->)
	
	$nTableOrderNumberType:=Type:C295($pTableOrderNumber->)
	
	If ($nTableOrderNumberType=Is longint:K8:6)
		
		DISTINCT VALUES:C339($pTableOrderNumber->; $anOrderNumber)
		$nNumberOfOrderNumbers:=Size of array:C274($anOrderNumber)
		
	Else 
		
		DISTINCT VALUES:C339($pTableOrderNumber->; $atOrderNumber)
		$nNumberOfOrderNumbers:=Size of array:C274($atOrderNumber)
		
	End if 
	
	For ($nOrderNumber; 1; $nNumberOfOrderNumbers)  //Loop through OrderNumber
		
		$nOrderCount:=0
		
		If ($nTableOrderNumberType=Is longint:K8:6)
			
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=$anOrderNumber{$nOrderNumber})
			
		Else 
			
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=Num:C11($atOrderNumber{$nOrderNumber}))
			
		End if 
		
		Case of   //$nOrderCount
				
			: ($nTableOrderNumberType=Is longint:K8:6)
				
				Case of   //Count
						
					: ($anOrderNumber{$nOrderNumber}=0)
						
						$nZero:=$nZero+1
						
					: ($nOrderCount=0)
						
						$nOrphan:=$nOrphan+1
						
					: ($nOrderCount=1)
						
						$nOrder:=$nOrder+1
						
					Else 
						
						$nMultiple:=$nMultiple+1
						
				End case   //Done count
				
			: ($nTableOrderNumberType=Is alpha field:K8:1)
				
				Case of   //Count
						
					: ($atOrderNumber{$nOrderNumber}="0")
						
						$nZero:=$nZero+1
						
					: ($nOrderCount=0)
						
						$nOrphan:=$nOrphan+1
						
					: ($nOrderCount=1)
						
						$nOrder:=$nOrder+1
						
					Else 
						
						$nMultiple:=$nMultiple+1
						
				End case   //Done count
				
		End case   //Done $nOrderCount
		
	End for   //Done looping through OrderNumber
	
	APPEND TO ARRAY:C911($atTable; Table name:C256($pTable))
	APPEND TO ARRAY:C911($anZero; $nZero)
	APPEND TO ARRAY:C911($anOrphan; $nOrphan)
	APPEND TO ARRAY:C911($anOrder; $nOrder)
	APPEND TO ARRAY:C911($anMultiple; $nMultiple)
	
End for   //Done looping through tables with ordernumber

SET QUERY DESTINATION:C396(Into current selection:K19:1)

Core_Array_ToDocument(->$apColumn)