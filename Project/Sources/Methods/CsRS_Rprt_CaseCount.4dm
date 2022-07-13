//%attributes = {}
//Method:  CsRS_Rprt_CaseCount
//Description:  This method will create a report for case counts for a customer

If (True:C214)  //Initialize
	
	C_DATE:C307($dStartDate; $dEndDate)
	
	C_TEXT:C284($tTable; $tQuery)
	C_TEXT:C284($tBillTo; $tShipTo)
	
	C_OBJECT:C1216($eCustomersReleaseSchedule)
	C_OBJECT:C1216($esCustomersReleaseSchedules)
	
	
	ARRAY TEXT:C222($atProductCode; 0)
	ARRAY TEXT:C222($atProductDescription; 0)
	ARRAY TEXT:C222($atCaseCount; 0)
	ARRAY TEXT:C222($atSkidCount; 0)
	ARRAY TEXT:C222($atBoxCount; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	APPEND TO ARRAY:C911($apColumn; ->$atProductCode)
	APPEND TO ARRAY:C911($apColumn; ->$atProductDescription)
	APPEND TO ARRAY:C911($apColumn; ->$atCaseCount)
	APPEND TO ARRAY:C911($apColumn; ->$atSkidCount)
	APPEND TO ARRAY:C911($apColumn; ->$atBoxCount)
	
	
	$dStartDate:=!2019-01-01!
	
	//$dStartDate:=!2021-03-01!
	$dEndDate:=Current date:C33(*)
	
	$tBillTo:="09467"
	$tShipTo:="09466"
	
	$tTable:=Table name:C256(->[Customers_ReleaseSchedules:46])
	
	$tQuery:=CorektBlank
	
	$tQuery:=$tQuery+"Actual_Date >= "+String:C10($dStartDate)+" And "
	$tQuery:=$tQuery+"Actual_Date <= "+String:C10($dEndDate)+" And "
	$tQuery:=$tQuery+"Billto = "+$tBillTo+" And "
	$tQuery:=$tQuery+"Shipto = "+$tShipTo
	
	//$tQuery:=$tQuery+" orderBy ProductCode"
	
	$esCustomersReleaseSchedules:=New object:C1471()
	
	$eCustomersReleaseSchedule:=New object:C1471()
	
	$bDoAll:=True:C214
	
End if   //Done initialize

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=$dStartDate; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7<=$dEndDate; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10=$tShipTo; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto:22=$tBillTo)

ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11; >)

$nNumberOfProducts:=Records in selection:C76([Customers_ReleaseSchedules:46])

READ ONLY:C145([Finished_Goods:26])

For ($nProduct; 1; $nNumberOfProducts)  //Products
	
	GOTO SELECTED RECORD:C245([Customers_ReleaseSchedules:46]; $nProduct)
	
	$nNumberOfFinishedGoods:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
	
	Case of   //Count
			
		: ($nNumberOfFinishedGoods<=0)
			
		: ($bDoAll)
			
			$tCurrentProductCode:=[Customers_ReleaseSchedules:46]ProductCode:11
			$tCurrentProductDescription:=[Finished_Goods:26]CartonDesc:3
			
			$nCaseCount:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
			$nSkidCount:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
			
			$nTotalCaseCount:=$nCaseCount
			$nTotalSkidCount:=$nSkidCount
			
			APPEND TO ARRAY:C911($atProductCode; $tCurrentProductCode)
			APPEND TO ARRAY:C911($atProductDescription; $tCurrentProductDescription)
			APPEND TO ARRAY:C911($atCaseCount; String:C10($nTotalCaseCount))
			APPEND TO ARRAY:C911($atSkidCount; String:C10($nTotalSkidCount))
			APPEND TO ARRAY:C911($atBoxCount; String:C10($nTotalSkidCount/$nTotalCaseCount))
			
		: ($nProduct=1)  //First
			
			$tCurrentProductCode:=[Customers_ReleaseSchedules:46]ProductCode:11
			$tCurrentProductDescription:=[Finished_Goods:26]CartonDesc:3
			
			$nCaseCount:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
			$nSkidCount:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
			
			$nTotalCaseCount:=$nCaseCount
			$nTotalSkidCount:=$nSkidCount
			
		: ($tCurrentProductCode#[Customers_ReleaseSchedules:46]ProductCode:11)  //Different
			
			APPEND TO ARRAY:C911($atProductCode; $tCurrentProductCode)
			APPEND TO ARRAY:C911($atProductDescription; $tCurrentProductDescription)
			APPEND TO ARRAY:C911($atCaseCount; String:C10($nTotalCaseCount))
			APPEND TO ARRAY:C911($atSkidCount; String:C10($nTotalSkidCount))
			APPEND TO ARRAY:C911($atBoxCount; String:C10($nTotalSkidCount/$nTotalCaseCount))
			
			$tCurrentProductCode:=[Customers_ReleaseSchedules:46]ProductCode:11
			$tCurrentProductDescription:=[Finished_Goods:26]CartonDesc:3
			
			$nCaseCount:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
			$nSkidCount:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
			
			$nTotalCaseCount:=$nCaseCount
			$nTotalSkidCount:=$nSkidCount
			
			If ($nProduct=$nNumberOfProducts)  //Last
				
				APPEND TO ARRAY:C911($atProductCode; $tCurrentProductCode)
				APPEND TO ARRAY:C911($atProductDescription; $tCurrentProductDescription)
				APPEND TO ARRAY:C911($atCaseCount; String:C10($nTotalCaseCount))
				APPEND TO ARRAY:C911($atSkidCount; String:C10($nTotalSkidCount))
				APPEND TO ARRAY:C911($atBoxCount; String:C10($nTotalSkidCount/$nTotalCaseCount))
				
			End if   //Done last
			
		Else   //Same
			
			$nCaseCount:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
			$nSkidCount:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
			
			$nTotalCaseCount:=$nTotalCaseCount+$nCaseCount
			$nTotalSkidCount:=$nTotalSkidCount+$nSkidCount
			
			If ($nProduct=$nNumberOfProducts)  //Last
				
				APPEND TO ARRAY:C911($atProductCode; $tCurrentProductCode)
				APPEND TO ARRAY:C911($atProductDescription; $tCurrentProductDescription)
				APPEND TO ARRAY:C911($atCaseCount; String:C10($nTotalCaseCount))
				APPEND TO ARRAY:C911($atSkidCount; String:C10($nTotalSkidCount))
				APPEND TO ARRAY:C911($atBoxCount; String:C10($nTotalSkidCount/$nTotalCaseCount))
				
			End if   //Done last
			
	End case   //Done count
	
End for   //Done products


Core_Array_ToDocument(->$apColumn)


//CsRS_Dialog_Count  //Dialog with search criteria

//$esCustomersReleaseSchedules:=ds[$tTable].query($tQuery)

//For each ($eCustomersReleaseSchedule;$esCustomersReleaseSchedules)


//End for each 
