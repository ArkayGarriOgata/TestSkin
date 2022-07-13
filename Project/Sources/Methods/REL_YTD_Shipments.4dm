//%attributes = {}
// -------
// Method: REL_YTD_Shipments   ( ) ->
// By: Mel Bohince @ 10/02/17, 13:31:12
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (10/4/17) don't bother the server so much
// -------
// based on: INV_SalesBySalesRep   ( ) ->
// ----------------------------------------------------
// Modified by: Garri Ogata (5/17/21) added and CustomerRefer not like 'Rtn:%' to remove Returns

C_TEXT:C284($1; $2; $distributionList)
C_DATE:C307(dDateBegin; dDateEnd; $To)
C_LONGINT:C283($hit)

Case of 
	: (Count parameters:C259=0)
		<>pid_:=New process:C317("REL_YTD_Shipments"; <>lMidMemPart; "REL_YTD_Shipments"; "ui")
		If (False:C215)
			REL_YTD_Shipments
		End if 
		
	: (Count parameters:C259=2) & ($1="init")
		$distributionList:=$2
		<>pid_:=New process:C317("REL_YTD_Shipments"; <>lMidMemPart; "REL_YTD_Shipments"; "batch"; $distributionList)
		
	Else 
		
		Case of 
			: ($1="ui")
				//Get YTD date range
				windowTitle:="Releases in date range"
				$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
				dDateBegin:=Date:C102(FiscalYear("start"; Current date:C33))
				$To:=UtilGetDate(Current date:C33; "ThisMonth"; ->dDateEnd)  //last day of month
				DIALOG:C40([zz_control:1]; "DateRange2")
				CLOSE WINDOW:C154($winRef)
				
			: ($1="batch")
				//batch mode, to be emailed
				dDateBegin:=Date:C102(FiscalYear("start"; Current date:C33))
				$To:=UtilGetDate(Current date:C33; "ThisMonth"; ->dDateEnd)  //last day of month
				$distributionList:=$2
				ok:=1
		End case 
		
		If (ok=1)
			ARRAY TEXT:C222($aCust; 0)
			ARRAY TEXT:C222($aLine; 0)
			ARRAY TEXT:C222($aShipto; 0)
			ARRAY TEXT:C222($aCPN; 0)
			ARRAY DATE:C224($aDate; 0)
			ARRAY LONGINT:C221($aQty; 0)
			ARRAY TEXT:C222($aOL; 0)
			ARRAY LONGINT:C221($aRel; 0)
			ARRAY DATE:C224($aSchDate; 0)
			ARRAY LONGINT:C221($aSchQty; 0)
			
			//SELECT CustID,CustomerLine,Shipto,ProductCode,Actual_Date,Actual_Qty
			//from Customers_ReleaseSchedules
			//where Actual_Date between '01/1/17' and '12/31/17' and PayU=0
			
			// Modified by: Garri Ogata (5/17/21) added and CustomerRefer not like 'Rtn:%'
			
			Begin SQL
				select CustID, CustomerLine, Shipto, ProductCode, Actual_Date, Actual_Qty, OrderLine, ReleaseNumber, Sched_Date, Sched_Qty
				from Customers_ReleaseSchedules
				where Actual_Date between :dDateBegin and :dDateEnd
				and CustomerRefer not like 'Rtn:%'
				into :$aCust, :$aLine, :$aShipto, :$aCPN, :$aDate, :$aQty, :$aOL, :$aRel, :$aSchDate, :$aSchQty
			End SQL
			
			ARRAY TEXT:C222($aAddID; 0)
			ARRAY TEXT:C222($aCity; 0)
			Begin SQL
				SELECT ID, City FROM Addresses WHERE City <> '' order by ID
				into :$aAddID, :$aCity
			End SQL
			
			ARRAY TEXT:C222($aFG_CPN; 0)
			ARRAY TEXT:C222($aFG_OUTLINE; 0)
			QUERY WITH ARRAY:C644([Finished_Goods:26]ProductCode:1; $aCPN)
			SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; $aFG_CPN; [Finished_Goods:26]OutLine_Num:4; $aFG_OUTLINE)
			SORT ARRAY:C229($aFG_CPN; $aFG_OUTLINE; >)
			
			C_LONGINT:C283($i; $numElements)
			$numElements:=Size of array:C274($aCust)
			ARRAY TEXT:C222($aName; $numElements)
			ARRAY TEXT:C222($aOutline; $numElements)
			ARRAY TEXT:C222($aDest; $numElements)
			ARRAY TEXT:C222($aPeriod; $numElements)
			
			C_TEXT:C284($text; $docName)
			C_TIME:C306($docRef)
			$text:="SHIPMENTS FROM: "+String:C10(dDateBegin; Internal date short special:K1:4)+" TO: "+String:C10(dDateEnd; Internal date short special:K1:4)+"\r\r"
			$text:=$text+"CUSTOMER\tLINE\tDESTINATION\tPRODUCT_CODE\tOUTLINE\tACT_DATE\tACT_QTY\tORDERLINE\tRELEASE\tSCH_DATE\tSCH_QTY\tPERIOD\r"
			$docName:="YTD_Shipments_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
			$docRef:=util_putFileName(->$docName)
			
			If ($docRef#?00:00:00?)
				
				uThermoInit($numElements; "Getting customer names...")
				For ($i; 1; $numElements)
					$aName{$i}:=CUST_getName($aCust{$i}; "el")
					$aPeriod{$i}:=fYYYYMM($aDate{$i})
					//$aOutline{$i}:=FG_getOutline ($aCPN{$i})
					$hit:=Find in array:C230($aFG_CPN; $aCPN{$i})  // Modified by: Mel Bohince (10/4/17) don't bother the server so much
					If ($hit>-1)
						$aOutline{$i}:=$aFG_OUTLINE{$hit}
					Else 
						$aOutline{$i}:="n/f"
					End if 
					//$aDest{$i}:=ADDR_getCity ($aShipto{$i})
					$hit:=Find in array:C230($aAddID; $aShipto{$i})  // Modified by: Mel Bohince (10/4/17) don't bother the server so much
					If ($hit>-1)
						$aDest{$i}:=$aCity{$hit}
					Else 
						$aDest{$i}:=$aShipto{$i}
					End if 
					$text:=$text+$aName{$i}+"\t"+$aLine{$i}+"\t"+$aDest{$i}+"\t"+$aCPN{$i}+"\t"+$aOutline{$i}+"\t"+String:C10($aDate{$i})+"\t"+String:C10($aQty{$i})+"\t"+$aOL{$i}+"\t"+String:C10($aRel{$i})+"\t"+String:C10($aSchDate{$i})+"\t"+String:C10($aSchQty{$i})+"\t"+$aPeriod{$i}+"\r"
					uThermoUpdate($i)
				End for 
				uThermoClose
				
				SEND PACKET:C103($docRef; $text)
				SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
				CLOSE DOCUMENT:C267($docRef)
				
				If (Count parameters:C259=2) & ($1="batch")
					EMAIL_Sender("YTD Shipments "+fYYMMDD(Current date:C33); ""; "Open attached with Excel"; $distributionList; $docName)
					util_deleteDocument($docName)
				Else 
					$err:=util_Launch_External_App($docName)
				End if 
			End if 
			
		End if   //ok
		
End case 
