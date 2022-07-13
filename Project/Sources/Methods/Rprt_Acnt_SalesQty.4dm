//%attributes = {}
//Method:  Rprt_Acnt_SalesQty
//Description:  This method will return a report based on sales person

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oParameter)
	
	C_BOOLEAN:C305($bFirst)
	
	C_DATE:C307($dStart; $dEnd)
	
	C_LONGINT:C283($nStartYear; $nEndYear; $nYearRange)
	C_LONGINT:C283($nYear)
	C_LONGINT:C283($nCustomerID; $nNumberOfCustomerIDs)
	C_LONGINT:C283($nInvoice; $nNumberOfInvoices)
	C_LONGINT:C283($nCurrentRow)
	C_LONGINT:C283($nNumberOfSamples)
	C_LONGINT:C283($nPosition)
	
	C_TEXT:C284($tSalesPerson)
	C_TEXT:C284($tCustomer)
	C_TEXT:C284($tLine)
	
	C_COLLECTION:C1488($cColumnHeader)
	C_COLLECTION:C1488($cRowValue)
	C_COLLECTION:C1488($cRowsValue)
	C_COLLECTION:C1488($cTitle)
	
	C_COLLECTION:C1488($cCustomerTotal)
	C_COLLECTION:C1488($cGrandTotal)
	C_COLLECTION:C1488($cBlankLine)
	C_COLLECTION:C1488($cFindReplace)
	
	C_COLLECTION:C1488($cCustomersInvoices)
	C_OBJECT:C1216($oCustomerInvoice)
	
	C_COLLECTION:C1488($cFilter)
	
	C_COLLECTION:C1488($cSamples)
	
	C_OBJECT:C1216($oTitle)
	C_OBJECT:C1216($oFindReplace)
	C_OBJECT:C1216($oParameter)
	C_OBJECT:C1216($oNameYear)
	C_OBJECT:C1216($oCustomerInvoice)
	C_OBJECT:C1216($oSample)
	
	C_OBJECT:C1216($esCustomersInvoices)
	
	ARRAY DATE:C224($adInvoice; 0)
	ARRAY TEXT:C222($atCustomerID; 0)
	ARRAY TEXT:C222($atCustomerLine; 0)
	ARRAY REAL:C219($arExtendedPrice; 0)
	ARRAY LONGINT:C221($anQuantity; 0)
	
	ARRAY TEXT:C222($atCustomer; 0)
	ARRAY LONGINT:C221($anYear; 0)
	
	ARRAY LONGINT:C221($anSampleYear; 0)
	ARRAY TEXT:C222($atSampleCustomer; 0)
	ARRAY TEXT:C222($atSampleLine; 0)
	ARRAY REAL:C219($arSampleExtendedPrice; 0)
	ARRAY LONGINT:C221($anSampleQuantity; 0)
	
	ARRAY LONGINT:C221($anYearRange; 0)
	
	$oParameter:=New object:C1471()
	
	$nYear:=0
	$tCustomer:=CorektBlank
	$tLine:=CorektBlank
	$nCurrentRow:=0
	
	$oParameter:=$1
	
	$dStart:=$oParameter.dStart
	$dEnd:=$oParameter.dEnd
	$tSalesPerson:=$oParameter.tSalesPerson
	$tReportBy:=$oParameter.tReportBy
	
	$bFirst:=True:C214
	
	Case of   //Report by
			
		: ($tReportBy="Yearly")
			
			$nStartYear:=Year of:C25($dStart)
			$nEndYear:=Year of:C25($dEnd)
			
		: ($tReportBy="Monthly")
			
	End case   //Done report by
	
	$oTitle:=New object:C1471()
	
	Case of   //Report by
			
		: ($tReportBy="Yearly")
			
			$oTitle.nLastColumn:=(2*($nEndYear-$nStartYear+1))+2
			
		: ($tReportBy="Monthly")
			
			$oTitle.nLastColumn:=(2*(Core_Date_NumberOfMonthsN($dStart; $dEnd)))+2
			
	End case   //Done report by
	
	$cBlankLine:=New collection:C1472()
	
	$cBlankLine.push(CorektBlank; CorektBlank)
	
	Case of   //Report by
			
		: ($tReportBy="Yearly")
			
			For ($nYear; $nStartYear; $nEndYear)
				APPEND TO ARRAY:C911($anYearRange; $nYear)
				$cBlankLine.push(CorektBlank; CorektBlank)
			End for 
			
		: ($tReportBy="Monthly")
			
			For ($nMonth; 1; $oTitle.nLastColumn)
				$cBlankLine.push(CorektBlank)
			End for 
			
	End case   //Done report by
	
	$cColumnHeader:=New collection:C1472()
	$cRowValue:=New collection:C1472()
	$cRowsValue:=New collection:C1472()
	$cTitle:=New collection:C1472()
	
	$oSample:=New object:C1471()
	$cSamples:=New collection:C1472()
	
	$cCustomerTotal:=New collection:C1472()
	$cGrandTotal:=New collection:C1472()
	
	$oFindReplace:=New object:C1471()
	$cFindReplace:=New collection:C1472()
	
	$cFindReplace.push(0)
	$cFindReplace.push(CorektDash)
	
	$oFindReplace.cFindReplace:=$cFindReplace
	
	$tTableName:=Table name:C256(->[Customers_Invoices:88])
	
	$tQuery:="SalesPerson="+CorektSingleQuote+$tSalesPerson+CorektSingleQuote+" & "+\
		"Invoice_Date>="+Core_Date_yyyymmddT($dStart; CorektDash)+" & "+\
		"Invoice_Date<="+Core_Date_yyyymmddT($dEnd; CorektDash)
	
	$esCustomersInvoices:=New object:C1471()
	
	$cFilter:=New collection:C1472(\
		"Invoice_Date"; \
		"CustomerID"; \
		"CustomerLine"; \
		"ExtendedPrice"; \
		"Quantity")
	
End if   //Done initialize

$esCustomersInvoices:=ds:C1482[$tTableName].query($tQuery)

$cCustomersInvoices:=$esCustomersInvoices.toCollection($cFilter)

If (False:C215)  //Collection
	
	For each ($oNameYear; $cCustomersInvoices)  //NameYear (1)
		
		$oNameYear.customerName:=CUST_getName($oNameYear.CustomerID; "elc")
		$oNameYear.year:=Year of:C25($oNameYear.Invoice_Date)
		
	End for each   //Done NameYear
	
	$cCustomersInvoices:=$cCustomersInvoices.orderBy("year asc, customerName asc, CustomerLine asc")
	
	For each ($oCustomerInvoice; $cCustomersInvoices)  //Group (2)
		
		If (\
			($nYear#$oCustomerInvoice.year) | \
			($tCustomer#$oCustomerInvoice.customerName) | \
			($tLine#$oCustomerInvoice.CustomerLine))  //New
			
			$nYear:=$oCustomerInvoice.year
			$tCustomer:=$oCustomerInvoice.customerName
			$tLine:=$oCustomerInvoice.CustomerLine
			
			$oSample:=New object:C1471()
			
			$oSample.Year:=$nYear
			$oSample.Customer:=$tCustomer
			$oSample.Line:=$tLine
			$oSample.ExtendedPrice:=$oCustomerInvoice.ExtendedPrice
			$oSample.Quantity:=$oCustomerInvoice.Quantity
			
			$cSamples.push($oSample)
			
		Else   //Same
			
			$oSample.ExtendedPrice:=$oSample.ExtendedPrice+$oCustomerInvoice.ExtendedPrice
			$oSample.Quantity:=$oSample.Quantity+$oCustomerInvoice.Quantity
			
		End if   //Done New
		
	End for each   //Done group
	
	$cSamples:=$cSamples.orderBy("Customer asc, Line asc, ExtendedPrice asc")
	
	For each ($oSample; $cSamples)  //Grand totals
		
		Case of   //$cRowValue
				
			: ($bFirst)  //First sample
				
				$bFirst:=False:C215
				
				$cRowValue.clear()
				
				$cRowValue.push(CorektBlank; CorektBlank)  //Pre fill collection
				
				For ($nYearRange; $nStartYear; $nEndYear)
					$cRowValue.push(0; 0)
				End for 
				
				$cRowValue[0]:=$oSample.Customer
				$cRowValue[1]:=$oSample.Line
				
				$nPosition:=(2*(Find in array:C230($anYearRange; $oSample.Year)))
				
				$cRowValue[$nPosition]:=$oSample.ExtendedPrice
				$cRowValue[$nPosition+1]:=$oSample.Quantity
				
				//Customer Total
				$cCustomerTotal.clear()
				$cCustomerTotal.push(CorektBlank; CorektBlank)  //Pre fill collection
				
				For ($nYearRange; $nStartYear; $nEndYear)
					$cCustomerTotal.push(0; 0)
				End for 
				
				$cCustomerTotal[$nPosition]:=$oSample.ExtendedPrice
				$cCustomerTotal[$nPosition+1]:=$oSample.Quantity
				
				//Grand Total
				$cGrandTotal.clear()
				$cGrandTotal.push(CorektBlank; "TOTAL")  //Pre fill collection
				
				For ($nYearRange; $nStartYear; $nEndYear)
					$cGrandTotal.push(0; 0)
				End for 
				
				$cGrandTotal[$nPosition]:=$oSample.ExtendedPrice
				$cGrandTotal[$nPosition+1]:=$oSample.Quantity
				
				$tCustomer:=Sample.Customer
				$tLine:=Sample.Line
				
			: (($tCustomer=$oSample.Customer) & \
				($tLine=$oSample.Line))  //Same customer, same line
				
				$nPosition:=(2*(Find in array:C230($anYearRange; $oSample.Year)))
				
				$cRowValue[$nPosition]:=$oSample.ExtendedPrice
				$cRowValue[$nPosition+1]:=$oSample.Quantity
				
				$cCustomerTotal[$nPosition]:=$cCustomerTotal[$nPosition]+$oSample.ExtendedPrice
				$cCustomerTotal[$nPosition+1]:=$cCustomerTotal[$nPosition+1]+$oSample.Quantity
				
				$cGrandTotal[$nPosition]:=$cGrandTotal[$nPosition]+$oSample.ExtendedPrice
				$cGrandTotal[$nPosition+1]:=$cGrandTotal[$nPosition+1]+$oSample.Quantity
				
			: (($tCustomer=$oSample.Customer) & \
				($tLine#$oSample.Line))  //Same customer, new line
				
				Core_Cltn_Replace($cRowValue; 0; CorektDash)
				$cRowsValue.push($cRowValue.copy())
				
				$cRowValue.clear()
				
				$cRowValue.push(CorektBlank; CorektBlank)  //Pre fill collection
				
				For ($nYearRange; $nStartYear; $nEndYear)
					$cRowValue.push(0; 0)
				End for 
				
				$cRowValue[1]:=$oSample.Line
				
				$nPosition:=(2*(Find in array:C230($anYearRange; $oSample.Year)))
				
				$cRowValue[$nPosition]:=$oSample.ExtendedPrice
				$cRowValue[$nPosition+1]:=$oSample.Quantity
				
				$cCustomerTotal[$nPosition]:=$cCustomerTotal[$nPosition]+$oSample.ExtendedPrice
				$cCustomerTotal[$nPosition+1]:=$cCustomerTotal[$nPosition+1]+$oSample.Quantity
				
				$cGrandTotal[$nPosition]:=$cGrandTotal[$nPosition]+$oSample.ExtendedPrice
				$cGrandTotal[$nPosition+1]:=$cGrandTotal[$nPosition+1]+$oSample.Quantity
				
				$tLine:=$oSample.Line
				
			: (($tCustomer#$oSample.Customer) & \
				($tLine#$oSample.Line))  //New customer, new line
				
				Core_Cltn_Replace($cRowValue; 0; CorektDash)
				
				$cRowsValue.push($cRowValue.copy())
				
				If ($cRowValue[0]=CorektBlank)
					
					Core_Cltn_Replace($cCustomerTotal; 0; CorektDash)
					$cRowsValue.push($cCustomerTotal.copy())
					
				End if 
				
				$cRowsValue.push($cBlankLine.copy())
				
				$cRowValue.clear()
				$cCustomerTotal.clear()
				
				$cRowValue.push(CorektBlank; CorektBlank)  //Pre fill collection
				$cCustomerTotal.push(CorektBlank; CorektBlank)
				
				For ($nYearRange; $nStartYear; $nEndYear)
					$cRowValue.push(0; 0)
					$cCustomerTotal.push(0; 0)
				End for 
				
				$cRowValue[0]:=$oSample.Customer
				$cRowValue[1]:=$oSample.Line
				
				$nPosition:=(2*(Find in array:C230($anYearRange; $oSample.Year)))
				
				$cRowValue[$nPosition]:=$oSample.ExtendedPrice
				$cRowValue[$nPosition+1]:=$oSample.Quantity
				
				$cCustomerTotal[$nPosition]:=$cCustomerTotal[$nPosition]+$oSample.ExtendedPrice
				$cCustomerTotal[$nPosition+1]:=$cCustomerTotal[$nPosition+1]+$oSample.Quantity
				
				$cGrandTotal[$nPosition]:=$cGrandTotal[$nPosition]+$oSample.ExtendedPrice
				$cGrandTotal[$nPosition+1]:=$cGrandTotal[$nPosition+1]+$oSample.Quantity
				
				$tCustomer:=$oSample.Customer
				$tLine:=$oSample.Line
				
		End case   //Done $cRowValue
		
	End for each   //Done grand totals
	
End if   //Done collection

If (False:C215)  //Array
	
	If (True:C214)  //1
		
		COLLECTION TO ARRAY:C1562($cCustomersInvoices; \
			$adInvoice; "Invoice_Date"; \
			$atCustomerID; "CustomerID"; \
			$atCustomerLine; "CustomerLine"; \
			$arExtendedPrice; "ExtendedPrice"; \
			$anQuantity; "Quantity"; \
			$atCustomer; "CUSTOMER.Name")
		
		$nNumberOfCustomerIDs:=Size of array:C274($atCustomerID)
		
		For ($nCustomerID; 1; $nNumberOfCustomerIDs)
			
			APPEND TO ARRAY:C911($anYear; Year of:C25($adInvoice{$nCustomerID}))
			
		End for 
		
		MULTI SORT ARRAY:C718($anYear; >; $atCustomer; >; $atCustomerLine; >; $arExtendedPrice; $anQuantity)
	End if   //Done 1
	
	If (True:C214)  //2
		
		$nNumberOfInvoices:=Size of array:C274($adInvoice)
		
		For ($nInvoice; 1; $nNumberOfInvoices)  //Invoice
			
			If (\
				($nYear#$anYear{$nInvoice}) | \
				($tCustomer#$atCustomer{$nInvoice}) | \
				($tLine#$atCustomerLine{$nInvoice}))  //Calculation
				
				$nYear:=$anYear{$nInvoice}
				$tCustomer:=$atCustomer{$nInvoice}
				$tLine:=$atCustomerLine{$nInvoice}
				
				APPEND TO ARRAY:C911($anSampleYear; $nYear)
				APPEND TO ARRAY:C911($atSampleCustomer; $tCustomer)
				APPEND TO ARRAY:C911($atSampleLine; $tLine)
				APPEND TO ARRAY:C911($arSampleExtendedPrice; $arExtendedPrice{$nInvoice})
				APPEND TO ARRAY:C911($anSampleQuantity; $anQuantity{$nInvoice})
				
				$nCurrentRow:=Size of array:C274($arSampleExtendedPrice)
				
			Else   //Same year customer and line
				
				$arSampleExtendedPrice{$nCurrentRow}:=$arSampleExtendedPrice{$nCurrentRow}+$arExtendedPrice{$nInvoice}
				$anSampleQuantity{$nCurrentRow}:=$anSampleQuantity{$nCurrentRow}+$anQuantity{$nInvoice}
				
			End if   //Done calculation
			
		End for   //Done invoice
		
		$nNumberOfSamples:=Size of array:C274($atSampleCustomer)
		
		MULTI SORT ARRAY:C718($atSampleCustomer; >; $atSampleLine; >; $anSampleYear; >; $arSampleExtendedPrice; $anSampleQuantity)
	End if   //Done 2
	
	If (True:C214)  //3
		
		For ($nSample; 1; $nNumberOfSamples)  //Samples
			
			Case of   //$cRowValue
					
				: ($nSample=1)  //First sample
					
					$cRowValue.clear()
					
					$cRowValue.push(CorektBlank; CorektBlank)  //Pre fill collection
					
					For ($nYearRange; $nStartYear; $nEndYear)
						$cRowValue.push(0; 0)
					End for 
					
					$cRowValue[0]:=$atSampleCustomer{$nSample}
					$cRowValue[1]:=$atSampleLine{$nSample}
					
					$nPosition:=(2*(Find in array:C230($anYearRange; $anSampleYear{$nSample})))
					
					$cRowValue[$nPosition]:=$arSampleExtendedPrice{$nSample}
					$cRowValue[$nPosition+1]:=$anSampleQuantity{$nSample}
					
					//Customer Total
					$cCustomerTotal.clear()
					$cCustomerTotal.push(CorektBlank; CorektBlank)  //Pre fill collection
					
					For ($nYearRange; $nStartYear; $nEndYear)
						$cCustomerTotal.push(0; 0)
					End for 
					
					$cCustomerTotal[$nPosition]:=$arSampleExtendedPrice{$nSample}
					$cCustomerTotal[$nPosition+1]:=$anSampleQuantity{$nSample}
					
					//Grand Total
					$cGrandTotal.clear()
					$cGrandTotal.push(CorektBlank; "TOTAL")  //Pre fill collection
					
					For ($nYearRange; $nStartYear; $nEndYear)
						$cGrandTotal.push(0; 0)
					End for 
					
					$cGrandTotal[$nPosition]:=$arSampleExtendedPrice{$nSample}
					$cGrandTotal[$nPosition+1]:=$anSampleQuantity{$nSample}
					
					$tCustomer:=$atSampleCustomer{$nSample}
					$tLine:=$atSampleLine{$nSample}
					
				: (($tCustomer=$atSampleCustomer{$nSample}) & \
					($tLine=$atSampleLine{$nSample}))  //Same customer, same line
					
					$nPosition:=(2*(Find in array:C230($anYearRange; $anSampleYear{$nSample})))
					
					$cRowValue[$nPosition]:=$arSampleExtendedPrice{$nSample}
					$cRowValue[$nPosition+1]:=$anSampleQuantity{$nSample}
					
					$cCustomerTotal[$nPosition]:=$cCustomerTotal[$nPosition]+$arSampleExtendedPrice{$nSample}
					$cCustomerTotal[$nPosition+1]:=$cCustomerTotal[$nPosition+1]+$anSampleQuantity{$nSample}
					
					$cGrandTotal[$nPosition]:=$cGrandTotal[$nPosition]+$arSampleExtendedPrice{$nSample}
					$cGrandTotal[$nPosition+1]:=$cGrandTotal[$nPosition+1]+$anSampleQuantity{$nSample}
					
				: (($tCustomer=$atSampleCustomer{$nSample}) & \
					($tLine#$atSampleLine{$nSample}))  //Same customer, new line
					
					Core_Cltn_Replace($cRowValue; 0; CorektDash)
					$cRowsValue.push($cRowValue.copy())
					
					$cRowValue.clear()
					
					$cRowValue.push(CorektBlank; CorektBlank)  //Pre fill collection
					
					For ($nYearRange; $nStartYear; $nEndYear)
						$cRowValue.push(0; 0)
					End for 
					
					$cRowValue[1]:=$atSampleLine{$nSample}
					
					$nPosition:=(2*(Find in array:C230($anYearRange; $anSampleYear{$nSample})))
					
					$cRowValue[$nPosition]:=$arSampleExtendedPrice{$nSample}
					$cRowValue[$nPosition+1]:=$anSampleQuantity{$nSample}
					
					$cCustomerTotal[$nPosition]:=$cCustomerTotal[$nPosition]+$arSampleExtendedPrice{$nSample}
					$cCustomerTotal[$nPosition+1]:=$cCustomerTotal[$nPosition+1]+$anSampleQuantity{$nSample}
					
					$cGrandTotal[$nPosition]:=$cGrandTotal[$nPosition]+$arSampleExtendedPrice{$nSample}
					$cGrandTotal[$nPosition+1]:=$cGrandTotal[$nPosition+1]+$anSampleQuantity{$nSample}
					
					$tLine:=$atSampleLine{$nSample}
					
				: (($tCustomer#$atSampleCustomer{$nSample}) & \
					($tLine#$atSampleLine{$nSample}))  //New customer, new line
					
					Core_Cltn_Replace($cRowValue; 0; CorektDash)
					
					$cRowsValue.push($cRowValue.copy())
					
					If ($cRowValue[0]=CorektBlank)
						
						Core_Cltn_Replace($cCustomerTotal; 0; CorektDash)
						$cRowsValue.push($cCustomerTotal.copy())
						
					End if 
					
					$cRowsValue.push($cBlankLine.copy())
					
					$cRowValue.clear()
					$cCustomerTotal.clear()
					
					$cRowValue.push(CorektBlank; CorektBlank)  //Pre fill collection
					$cCustomerTotal.push(CorektBlank; CorektBlank)
					
					For ($nYearRange; $nStartYear; $nEndYear)
						$cRowValue.push(0; 0)
						$cCustomerTotal.push(0; 0)
					End for 
					
					$cRowValue[0]:=$atSampleCustomer{$nSample}
					$cRowValue[1]:=$atSampleLine{$nSample}
					
					$nPosition:=(2*(Find in array:C230($anYearRange; $anSampleYear{$nSample})))
					
					$cRowValue[$nPosition]:=$arSampleExtendedPrice{$nSample}
					$cRowValue[$nPosition+1]:=$anSampleQuantity{$nSample}
					
					$cCustomerTotal[$nPosition]:=$cCustomerTotal[$nPosition]+$arSampleExtendedPrice{$nSample}
					$cCustomerTotal[$nPosition+1]:=$cCustomerTotal[$nPosition+1]+$anSampleQuantity{$nSample}
					
					$cGrandTotal[$nPosition]:=$cGrandTotal[$nPosition]+$arSampleExtendedPrice{$nSample}
					$cGrandTotal[$nPosition+1]:=$cGrandTotal[$nPosition+1]+$anSampleQuantity{$nSample}
					
					$tCustomer:=$atSampleCustomer{$nSample}
					$tLine:=$atSampleLine{$nSample}
					
			End case   //Done $cRowValue
			
		End for   //Done samples
		
	End if   //Done 3
	
End if   //Done array

Core_Cltn_Replace($cRowValue; 0; CorektDash)
$cRowsValue.push($cRowValue.copy())

$cRowValue.clear()

Core_Cltn_Replace($cCustomerTotal; 0; CorektDash)
$cRowsValue.push($cCustomerTotal.copy())

$cRowsValue.push($cBlankLine.copy())

Core_Cltn_Replace($cGrandTotal; 0; CorektDash)
$cRowsValue.push($cGrandTotal.copy())

VP NEW DOCUMENT("ViewProArea")

$cColumnHeader.push("CUSTOMER"; "LINE")

For ($nYear; $nStartYear; $nEndYear)
	
	$cColumnHeader.push(String:C10($nYear)+CorektSpace+"Sales")
	$cColumnHeader.push(String:C10($nYear)+CorektSpace+"Quantity")
	
End for 

$cTitle.push($cColumnHeader)

VP SET VALUES(VP Cell("ViewProArea"; 0; 0); $cTitle)
VP SET VALUES(VP Cell("ViewProArea"; 0; 1); $cBlankLine)
VP SET VALUES(VP Cell("ViewproArea"; 0; 2); $cRowsValue)

VwPr_Title($oTitle)  //Title

//$nLastRow
//$nLastColumn

//$oBorderStyle:=New object("color";"Grey";"style";vk line style thin)
//$oBorderPosition:=New object("outline";True)

//VP SET BORDER(VP Cells("ViewProArea";1;1;3;3);$oBorder;$option)

//VP COLUMN AUTOFIT(VP Get selection ("ViewProArea"))  // v19 option

//VP SET FROZEN PANES // v19 option to set the header to always display at top

//
