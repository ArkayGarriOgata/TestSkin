//%attributes = {}
// -------
// Method: JMI_ProductionReport   ( ) ->
// By: Mel Bohince @ 01/17/19, 15:50:49
// Description
// show finsihing department output between date/time
// ----------------------------------------------------
// Modified by: Mel Bohince (10/29/19) don't use THC when looking for next release

C_TEXT:C284($to; $from; $now; $yesterday; $skid; $location; $delim)
C_LONGINT:C283($i; $numSkidTransactions; $numJobits)
$delim:="\t"
//for the fgx data
ARRAY TEXT:C222($aJobit; 0)
ARRAY TEXT:C222($aSkid; 0)
ARRAY TEXT:C222($aTransAt; 0)
ARRAY LONGINT:C221($aNumCases; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY TEXT:C222($aProductCode; 0)  // Modified by: Mel Bohince (10/22/19)
ARRAY DATE:C224($aReleaseDate; 0)  // Modified by: Mel Bohince (10/22/19)

//for the wms_ams_export data
ARRAY TEXT:C222($aWMS_Jobit; 0)
ARRAY TEXT:C222($aWMS_Skid; 0)
ARRAY TEXT:C222($aWMS_aTransAt; 0)
ARRAY LONGINT:C221($aWMS_NumCases; 0)
ARRAY LONGINT:C221($aWMS_Qty; 0)

//for the summary
ARRAY TEXT:C222($aJobitSum; 0)
ARRAY LONGINT:C221($aSkidCount; 0)
ARRAY LONGINT:C221($aCaseCount; 0)
ARRAY LONGINT:C221($aQtyTTl; 0)

$now:=TS2iso(TSTimeStamp(Current date:C33; ?23:59:59?))
$yesterday:=TS2iso(TSTimeStamp(Current date:C33; ?00:00:01?))

$from:=Request:C163("from:"; $yesterday; "Ok"; "Cancel")
If (ok=1)
	$to:=Request:C163("to:"; $now; "Ok"; "Cancel")
	If (ok=1)
		$from:=Replace string:C233($from; "/"; "-")
		$to:=Replace string:C233($to; "/"; "-")
		$isoDate:=Change string:C234($from; "T"; 11)  //1234-12-12 012:12:12
		$dDateFrom:=Date:C102($isoDate)
		$tTimeFrom:=Time:C179(Substring:C12($from; 12; 8))
		$tsFrom:=TSTimeStamp($dDateFrom; $tTimeFrom)  //for the MachineTicket search
		$isoDate:=Change string:C234($to; "T"; 11)  //1234-12-12 012:12:12
		$dDateTo:=Date:C102($isoDate)
		$tTimeTo:=Time:C179(Substring:C12($to; 12; 8))
		$tsTo:=TSTimeStamp($dDateTo; $tTimeTo)
		
		//get the detail
		//use the WMS_aMs_Exports solely for case counts, it will not have Revlon style supercase receipts
		Begin SQL
			select skid_number, number_of_cases
			from WMS_aMs_Exports
			where TypeCode=100 and transactionDateTime >= :$from and transactionDateTime <= :$to
			order by skid_number
			into :$aWMS_Skid, :$aWMS_NumCases
		End SQL
		//, actualQty, transactionDateTime
		//:$aWMS_Jobit, :$aWMS_Skid, :$aWMS_NumCases, :$aWMS_Qty, :$aWMS_aTransAt
		//jobit, transactionDateTime, 
		
		//grab all the glue receipts from the f/g transactions table in the range, then
		//  look up in wms where the skids are currently located and 
		//  populate the number of cases, also roll up the totals by jobit//SkidTicketNo
		Begin SQL
			select Jobit, ProductCode, Skid_number, qty, transactionDateTime
			from Finished_Goods_Transactions
			where XactionType='Receipt' and transactionDateTime >= :$from and transactionDateTime <= :$to
			order by jobit, transactionDateTime, Skid_number
			into :$aJobit, :$aProductCode, :$aSkid, :$aQty, :$aTransAt
		End SQL
		
		$numSkidTransactions:=Size of array:C274($aJobit)
		ARRAY LONGINT:C221($aNumCases; $numSkidTransactions)
		ARRAY TEXT:C222($aLocation; $numSkidTransactions)  //where are they now
		ARRAY DATE:C224($aReleaseDate; $numSkidTransactions)
		
		//////////////////// load some key/values pairs with rel dates, minimize the calls to REL_getNextRelease
		ARRAY TEXT:C222($aFGXproductCode; 0)
		ARRAY DATE:C224($aDistinctReleaseDate; 0)
		Begin SQL
			select distinct(ProductCode)
			from Finished_Goods_Transactions
			where XactionType='Receipt' and transactionDateTime >= :$from and transactionDateTime <= :$to
			into :$aFGXproductCode
		End SQL
		ARRAY DATE:C224($aDistinctReleaseDate; Size of array:C274($aFGXproductCode))
		//get the release date, once per item
		For ($i; 1; Size of array:C274($aFGXproductCode))
			$aDistinctReleaseDate{$i}:=REL_getNextRelease($aFGXproductCode{$i})  //;"";"useTHC")
			If ($aDistinctReleaseDate{$i}=!00-00-00!)
				$aDistinctReleaseDate{$i}:=<>MAGIC_DATE
			End if 
		End for 
		
		// now apply the dates that were found
		For ($i; 1; $numSkidTransactions)
			$hit:=Find in array:C230($aFGXproductCode; $aProductCode{$i})
			If ($hit>-1)
				$aReleaseDate{$i}:=$aDistinctReleaseDate{$hit}
			Else 
				$aReleaseDate{$i}:=<>MAGIC_DATE
			End if 
		End for 
		//  //clean up
		//ARRAY TEXT($aFGXproductCode;0)
		//ARRAY DATE($aDistinctReleaseDate;0)
		////////////////////
		
		
		//do WMS look ups on the skids
		WMS_API_LoginLookup  //make sure <>WMS variables are up to date.
		If (WMS_SQL_Login)  //WMS_API_4D_DoLogin 
			
			uThermoInit($numSkidTransactions; "Processing Array")
			For ($i; 1; $numSkidTransactions)
				ARRAY TEXT:C222($aBin_id; 0)
				$skid:=$aSkid{$i}
				
				//external db query into WMS:
				Begin SQL
					select bin_id from cases where skid_number = :$skid
					into :$aBin_id
				End SQL
				If (Size of array:C274($aBin_id)>0)
					$aLocation{$i}:=$aBin_id{1}
				Else 
					$aLocation{$i}:=""
				End if 
				
				$hit:=Find in array:C230($aWMS_Skid; $aSkid{$i})
				If ($hit>-1)
					$aNumCases{$i}:=$aWMS_NumCases{$hit}
				Else 
					$aNumCases{$i}:=0  //must be a supercase
				End if 
				
				
				//rollup the totals by jobit
				$hit:=Find in array:C230($aJobitSum; $aJobit{$i})
				If ($hit=-1)
					APPEND TO ARRAY:C911($aJobitSum; $aJobit{$i})
					APPEND TO ARRAY:C911($aSkidCount; 1)
					APPEND TO ARRAY:C911($aCaseCount; $aNumCases{$i})
					APPEND TO ARRAY:C911($aQtyTTl; $aQty{$i})
				Else 
					$aSkidCount{$hit}:=$aSkidCount{$hit}+1
					$aCaseCount{$hit}:=$aCaseCount{$hit}+$aNumCases{$i}
					$aQtyTTl{$hit}:=$aQtyTTl{$hit}+$aQty{$i}
				End if 
				
				uThermoUpdate($i)
			End for 
			uThermoClose
			
			SQL LOGOUT:C872
			
		Else 
			For ($i; 1; $numSkidTransactions)
				$aLocation{$i}:="No WMS Connection"
			End for 
		End if 
		
		//get a summary by job
		//Begin SQL
		//select Jobit, count(skid_number), sum(number_of_cases), sum(ActualQty)
		//from WMS_aMs_Exports
		//where TypeCode =100 and transactionDateTime >= :$from and transactionDateTime <= :$to
		//order by jobit
		//group by jobit
		//into :$aJobitSum, :$aSkidCount, :$aCaseCount, :$aQtyTTl
		//End SQL
		
		$numJobits:=Size of array:C274($aJobitSum)
		ARRAY LONGINT:C221($aMachTickQty; $numJobits)  //what did glue line say
		ARRAY LONGINT:C221($aMachTickAllQty; $numJobits)  //what did glue line say
		ARRAY LONGINT:C221($aTTLreceipts; $numJobits)  //not just in the datetime range
		ARRAY TEXT:C222($aCPN; $numJobits)
		
		For ($i; 1; $numJobits)
			$aCPN{$i}:=JMI_getCPN($aJobitSum{$i})
			$aMachTickQty{$i}:=MT_getGlueCount($aJobitSum{$i}; $tsFrom; $tsTo)
			$aMachTickAllQty{$i}:=MT_getGlueCount($aJobitSum{$i})  //;$tsFrom;$tsTo)
			$aTTLreceipts{$i}:=FGX_getReceipts($aJobitSum{$i})
		End for 
		
		
		C_TEXT:C284($title; $text; $docName; $millidiff)
		C_LONGINT:C283($millinow; $millithen)
		C_TIME:C306($docRef)
		
		$title:="Finishing Department from "+$from+" to "+$to
		$text:=""
		$docName:="FinishingReport"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
		
		
		$docRef:=util_putFileName(->$docName)
		
		If ($docRef#?00:00:00?)
			SEND PACKET:C103($docRef; $title+"\r\r")
			$text:=$text+"RECEIPTS BY SKID:\r"
			$text:=$text+"JOBIT"+"\t"+"SKID"+"\t"+"CASES"+"\t"+"QUANTITY"+"\t"+"WHEN_SCANNED"+"\t"+"WHERE_NOW"+"\t"+"WHEN_NEEDED"+"\t"+"PRODUCT_CODE"+"\r"
			$ttlCases:=0
			$ttlQty:=0
			$numSkids:=0
			$ttlReceiptQty:=0
			For ($i; 1; $numSkidTransactions)
				$ttlCases:=$ttlCases+$aNumCases{$i}
				$ttlQty:=$ttlQty+$aQty{$i}
				$numSkids:=$numSkids+1
				$text:=$text+$aJobit{$i}+"\t"+$aSkid{$i}+"\t"+String:C10($aNumCases{$i})+"\t"+String:C10($aQty{$i})+"\t"+$aTransAt{$i}+"\t"+$aLocation{$i}+"\t"+String:C10($aReleaseDate{$i}; Internal date short special:K1:4)+"\t"+$aProductCode{$i}+"\r"
			End for 
			$text:=$text+"\rTOTALS:"+"\t"+String:C10($numSkids)+"\t"+String:C10($ttlCases)+"\t"+String:C10($ttlQty)+"\t"+""+"\t"+""+"\r"
			
			$text:=$text+"\r\rRECEIPTS SUMMARY BY JOBIT:"+"\r"
			$text:=$text+"JOBIT"+"\t"+"PRODUCT_CODE"+"\t"+"CASES"+"\t"+"QUANTITY"+"\t"+"TTL_RECEIVED"+"\t"+"SKIDS"+"\t"+"MACH_TIC_QTY"+"\t"+"TTL_MACH_TIC_GOOD"+"\t"+"WHEN_NEEDED"+"\r"
			$ttlJobitCases:=0
			$ttlJobitSkids:=0
			$ttlJobitQty:=0
			$ttlReceiptQty:=0
			$ttlJobitMachtic:=0
			$ttlAllJobitMachtic:=0
			
			For ($i; 1; $numJobits)
				$ttlJobitCases:=$ttlJobitCases+$aCaseCount{$i}
				$ttlJobitSkids:=$ttlJobitSkids+$aSkidCount{$i}
				$ttlJobitQty:=$ttlJobitQty+$aQtyTTl{$i}
				$ttlReceiptQty:=$ttlReceiptQty+$aTTLreceipts{$i}
				$ttlJobitMachtic:=$ttlJobitMachtic+$aMachTickQty{$i}
				$ttlAllJobitMachtic:=$ttlAllJobitMachtic+$aMachTickAllQty{$i}
				$hit:=Find in array:C230($aFGXproductCode; $aCPN{$i})
				If ($hit>-1)
					$relDate:=$aDistinctReleaseDate{$hit}
				Else 
					$relDate:=<>MAGIC_DATE
				End if 
				$text:=$text+$aJobitSum{$i}+"\t"+$aCPN{$i}+"\t"+String:C10($aCaseCount{$i})+"\t"+String:C10($aQtyTTl{$i})+"\t"+String:C10($aTTLreceipts{$i})+"\t"+String:C10($aSkidCount{$i})+"\t"+String:C10($aMachTickQty{$i})+"\t"+String:C10($aMachTickAllQty{$i})+"\t"+String:C10($relDate; Internal date short special:K1:4)+"\r"
			End for 
			$text:=$text+"\rTOTALS"+"\t"+""+"\t"+String:C10($ttlJobitCases)+"\t"+String:C10($ttlJobitQty)+"\t"+String:C10($ttlReceiptQty)+"\t"+String:C10($ttlJobitSkids)+"\t"+String:C10($ttlJobitMachtic)+"\t"+String:C10($ttlAllJobitMachtic)+"\r"
			
			$text:=$text+"\r\rTRANSIT SUMMARY BY BOL:"+"\r"
			ARRAY TEXT:C222($aBin_id; 0)
			ARRAY LONGINT:C221($aSkidCount; 0)
			Begin SQL
				select BinId, count(Skid_number)
				from WMS_aMs_Exports
				where BinId like 'BOL%' and transactionDateTime >= :$from and transactionDateTime <= :$to
				group by BinId
				into :$aBin_id, :$aSkidCount
			End SQL
			
			$text:=$text+"BOL_NUMBER"+"\t"+"NUM_SKIDS"+"\r"
			$ttlJobitSkids:=0
			For ($i; 1; Size of array:C274($aBin_id))
				$ttlJobitSkids:=$ttlJobitSkids+$aSkidCount{$i}
				$text:=$text+$aBin_id{$i}+"\t"+String:C10($aSkidCount{$i})+"\r"
			End for 
			$text:=$text+"TOTALS"+"\t"+String:C10($ttlJobitSkids)+"\r"
			
			
			$text:=$text+"\r\rPUT-AWAY SUMMARY BY AREA:"+"\r"
			ARRAY TEXT:C222($aBin_id; 0)
			ARRAY TEXT:C222($aFromBin_id; 0)
			ARRAY LONGINT:C221($aSkidCount; 0)
			Begin SQL
				select from_Bin_Id, count(Skid_number)
				from WMS_aMs_Exports
				where BinId like '%-%' and from_Bin_Id not like '%-%' and transactionDateTime >= :$from and transactionDateTime <= :$to 
				group by from_Bin_Id
				into :$aBin_id, :$aSkidCount
			End SQL
			
			$text:=$text+"FROM_AREA"+"\t"+"NUM_SKIDS"+"\r"
			$ttlJobitSkids:=0
			For ($i; 1; Size of array:C274($aBin_id))
				$ttlJobitSkids:=$ttlJobitSkids+$aSkidCount{$i}
				$text:=$text+$aBin_id{$i}+"\t"+String:C10($aSkidCount{$i})+"\r"
			End for 
			$text:=$text+"TOTALS"+"\t"+String:C10($ttlJobitSkids)+"\r"
			
			$text:=$text+"\r\rSTAGED FOR SHIPPING:\r"
			ARRAY TEXT:C222($aSkid; 0)
			ARRAY TEXT:C222($aFromBin_id; 0)
			ARRAY LONGINT:C221($aNumCases; 0)
			ARRAY LONGINT:C221($aQty; 0)
			ARRAY TEXT:C222($aTransAt; 0)
			
			Begin SQL
				select skid_number, actualqty, number_of_cases, from_bin_id, transactionDateTime
				from WMS_aMs_Exports
				where upper(binid) like '%SHIP%' 
				and skid_number <> '' 
				and transactionDateTime >= :$from and transactionDateTime <= :$to
				order by from_bin_id, skid_number
				into :$aSkid, :$aQty, :$aNumCases, :$aFromBin_id, :$aTransAt
			End SQL
			
			
			$text:=$text+"SKID"+"\t"+"FROM_BIN"+"\t"+"CASES"+"\t"+"QUANTITY"+"\t"+"WHEN_SCANNED"+"\r"
			$ttlJobitCases:=0
			$ttlJobitSkids:=0
			$ttlJobitQty:=0
			For ($i; 1; Size of array:C274($aSkid))
				$ttlJobitCases:=$ttlJobitCases+$aNumCases{$i}
				$ttlJobitSkids:=$ttlJobitSkids+1
				$ttlJobitQty:=$ttlJobitQty+$aQty{$i}
				$text:=$text+$aSkid{$i}+"\t"+$aFromBin_id{$i}+"\t"+String:C10($aNumCases{$i})+"\t"+String:C10($aQty{$i})+"\t"+$aTransAt{$i}+"\r"
			End for 
			$text:=$text+"\rTOTALS\t"+String:C10($ttlJobitSkids)+"\t"+String:C10($ttlJobitCases)+"\t"+String:C10($ttlJobitQty)+"\r"
			
			WMS_API_LoginLookup  //make sure <>WMS variables are up to date.
			If (WMS_SQL_Login)  //WMS_API_4D_DoLogin 
				$text:=$text+"\r\rSTILL IN TRANSIT:"+"\r"
				ARRAY TEXT:C222($aBin_id; 0)
				Begin SQL
					select bin_id,  count(distinct(skid_number))
					from cases 
					where bin_id like 'BOL%'  
					and skid_number <> '' 
					group by bin_id
					into :$aBin_id, :$aSkidCount
				End SQL
				
				$text:=$text+"BOL"+"\t"+"NUM_SKIDS"+"\r"
				$ttlJobitSkids:=0
				For ($i; 1; Size of array:C274($aBin_id))
					$ttlJobitSkids:=$ttlJobitSkids+$aSkidCount{$i}
					$text:=$text+$aBin_id{$i}+"\t"+String:C10($aSkidCount{$i})+"\r"
				End for 
				$text:=$text+"TOTALS"+"\t"+String:C10($ttlJobitSkids)+"\r"
				
				$text:=$text+"\r\rSKIDS_ON_FLOOR: ("
				$text:=$text+"'BNVFG_1','BNVFG_2','BNVFG_3','BNVFG_4','BNVFG_5','BNVFG_6','BNRFG','BNRFG_A')\r"
				ARRAY TEXT:C222($aBin_id; 0)
				Begin SQL
					select bin_id,  count(distinct(skid_number))
					from cases 
					where bin_id in ('BNVFG_1','BNVFG_2','BNVFG_3','BNVFG_4','BNVFG_5','BNVFG_6','BNRFG','BNRFG_A')  
					and skid_number <> '' and case_status_code <> 300
					group by bin_id
					into :$aBin_id, :$aSkidCount
				End SQL
				$text:=$text+"AREA"+"\t"+"NUM_SKIDS"+"\r"
				$ttlJobitSkids:=0
				For ($i; 1; Size of array:C274($aBin_id))
					$ttlJobitSkids:=$ttlJobitSkids+$aSkidCount{$i}
					$text:=$text+$aBin_id{$i}+"\t"+String:C10($aSkidCount{$i})+"\r"
				End for 
				$text:=$text+"TOTALS"+"\t"+String:C10($ttlJobitSkids)+"\r"
				
				$text:=$text+"\r\rSKIDS_IN_RECERTIFICATION: \r"
				ARRAY TEXT:C222($aBin_id; 0)
				Begin SQL
					select bin_id,  count(distinct(skid_number))
					from cases 
					where bin_id like '%XC%' 
					and skid_number <> '' and case_status_code <> 300
					group by bin_id
					into :$aBin_id, :$aSkidCount
				End SQL
				$text:=$text+"AREA"+"\t"+"NUM_SKIDS"+"\r"
				$ttlJobitSkids:=0
				For ($i; 1; Size of array:C274($aBin_id))
					$ttlJobitSkids:=$ttlJobitSkids+$aSkidCount{$i}
					$text:=$text+$aBin_id{$i}+"\t"+String:C10($aSkidCount{$i})+"\r"
				End for 
				$text:=$text+"TOTALS"+"\t"+String:C10($ttlJobitSkids)+"\r"
				
				
				$text:=$text+"\r\rEMPTY_BINS: ("
				ARRAY TEXT:C222($aBin_id; 0)
				Begin SQL
					SELECT bin_id  
					FROM bins 
					WHERE rack_shelf > 0 
					AND bin_id not in 
					(select distinct(bin_id) from cases 
					where bin_id <> '' 
					and case_status_code<>300) 
					ORDER BY bin_id
					into :$aBin_id
				End SQL
				
				$text:=$text+String:C10(Size of array:C274($aBin_id))+")"+"\r"
				For ($i; 1; Size of array:C274($aBin_id))
					$text:=$text+$aBin_id{$i}+"\r"
				End for 
				
				
				
				SQL LOGOUT:C872
				
				
			Else 
				$text:=$text+"\rNO WMS CONNECTION"+"\r"
			End if 
			SEND PACKET:C103($docRef; $text)
			SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
			CLOSE DOCUMENT:C267($docRef)
			
			$err:=util_Launch_External_App($docName)
		End if 
		
	End if   //to
End if   //from

//
