//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 01/25/11, 15:25:59
// ----------------------------------------------------
// Method: ELC_Suggest_Moves_To_Remote_Whs
// Description
// find items in inventory that ship to specific european locations that can be moved 
// forward for faster delivery
//
//select l.ProductCode, l.QtyOH, l.Location
//from Finished_Goods_Locations l
//where l.ProductCode in(SELECT   distinct r.ProductCode
//from Customers_ReleaseSchedules r
//where r.Shipto in('02651', '02852', '00190', '00073') and r.Actual_Qty=0 and r.Sched_Qty>0)
//order by l.ProductCode, l.Location
// ----------------------------------------------------

C_TEXT:C284($t; $r)
C_BOOLEAN:C305($report_all)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$r:=Char:C90(13)
uConfirm("Report only items with a spec pallet qty?"; "All"; "Spec")
If (OK=1)
	$report_all:=True:C214
Else   //hide items that don't have a full pallet in inventory
	$report_all:=False:C215
End if 
xTitle:="Candidates to Move to External Warehouse"
xText:=" considering shipto's: "
docName:="Move_Candidates_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$r+$r)
	
	C_DATE:C307($planning_fence)
	$planning_fence:=Add to date:C393(4D_Current_date; 0; 1; 0)
	C_TEXT:C284($ignor_location)
	$ignor_location:="BNR_External_Warehouse"
	ARRAY TEXT:C222($aShiptos; 15)
	$aShiptos{1}:="00073"
	$aShiptos{2}:="00190"
	$aShiptos{3}:="00566"
	$aShiptos{4}:="00853"
	$aShiptos{5}:="01713"
	$aShiptos{6}:="01797"
	$aShiptos{7}:="01953"
	$aShiptos{8}:="02005"
	$aShiptos{9}:="02136"
	$aShiptos{10}:="02298"
	$aShiptos{11}:="02304"
	$aShiptos{12}:="02679"
	$aShiptos{13}:="02764"
	$aShiptos{14}:="02808"
	$aShiptos{15}:="02852"
	For ($i; 1; Size of array:C274($aShiptos))
		xText:=xText+$aShiptos{$i}+" "
	End for 
	xText:=xText+$r
	xText:=xText+"* = full spec pallet, ** = targeted shipto"+$r
	QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]Shipto:10; $aShiptos)  //targeted shiptos
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //open releases
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>$planning_fence)  //not needed rite away
	DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $aCPNs)  //candidates based on releases
	
	QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $aCPNs)  //is there any inventory
	//QUERY SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]Location#$ignor_location)  `not already picked to go
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; $aCPNs)  // candidates with release and inventory
	
	C_LONGINT:C283($i; $numElements)
	$numElements:=Size of array:C274($aCPNs)
	xText:=xText+String:C10($numElements)+" product codes found"+$r
	uThermoInit($numElements; "Finding Candidates to Move to External Warehouse")
	For ($i; 1; $numElements)
		$outline:=FG_getOutline($aCPNs{$i})
		$cases:=PK_getCasesPerSkid($outline)
		$packed_at:=PK_getCaseCount($outline)
		$full_skid:=$cases*$packed_at
		$packing_spec:="full skid: "+String:C10($cases)+"x"+String:C10($packed_at)+"="+String:C10($full_skid)
		
		If (Length:C16(xText)>25000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
		
		//list the bins
		//xText:=xText+$t+"INVENTORY:"+$t+"QTY"+$t+"GLUED"+$t+"SSCC_ID"+$r
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$aCPNs{$i})
		//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location#$ignor_location)
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aBin; [Finished_Goods_Locations:35]QtyOH:9; $aOnHand; [Finished_Goods_Locations:35]skid_number:43; $aPallet; [Finished_Goods_Locations:35]Jobit:33; $aJobit)
		$numBins:=Size of array:C274($aBin)
		ARRAY INTEGER:C220($aFull; 0)
		ARRAY INTEGER:C220($aFull; $numBins)
		For ($bin; 1; $numBins)
			If ($aOnHand{$bin}=$full_skid)
				$aFull{$bin}:=1
			Else 
				$aFull{$bin}:=0
			End if 
		End for 
		MULTI SORT ARRAY:C718($aJobit; >; $aFull; >; $aBin; >; $aOnHand; $aPallet)
		//For ($bin;1;Size of array($aBin))
		//If ($aOnHand{$bin}=$full_skid)
		//$complete:="*"
		//Else 
		//$complete:=""
		//End if 
		//xText:=xText+$t+$aBin{$bin}+$t+String($aOnHand{$bin})+$t+String(JMI_getGlueDate ($aJobit{$bin});System date short )+$t+BarCode_HumanReadableSSCC ($aPallet{$bin})+$complete+$r
		//End for 
		
		//list the releases
		//xText:=xText+$r+$t+"RELEASES:"+$t+"QTY"+$t+"SHIPTO"+$t+"CITY"+$t+"REFER"+$t+"TOT_SKIDS"+$r
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$aCPNs{$i}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aSchd_date; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aSchd_Qty; [Customers_ReleaseSchedules:46]Shipto:10; $aSchd_Shipto; [Customers_ReleaseSchedules:46]CustomerRefer:3; $aRefer)
		SORT ARRAY:C229($aSchd_date; $aSchd_Qty; $aSchd_Shipto; $aRefer; >)
		$cummulative_counter:=0
		$numRels:=Size of array:C274($aSchd_Qty)
		//For ($rel;1;$numRels)
		//$hit:=Find in array($aShiptos;$aSchd_Shipto{$rel})
		//If ($hit>-1)`in scope shipto
		//$scope:="**"
		//Else 
		//$scope:=""
		//End if 
		//xText:=xText+$t+String($aSchd_date{$rel};System date short )+$t+String($aSchd_Qty{$rel})+$t+"["+$aSchd_Shipto{$rel}+"]"+$scope+$t+ADDR_getCity ($aSchd_Shipto{$rel})+$t+$aRefer{$rel}
		//$cummulative_counter:=$cummulative_counter+$aSchd_Qty{$rel}
		//$num_skids:=String(Round($cummulative_counter/$full_skid;2))
		//xText:=xText+$t+$num_skids+$r
		//End for 
		
		If ($report_all)
			$continue:=True:C214
		Else 
			$hit:=Find in array:C230($aFull; 1)
			If ($hit>-1)
				$continue:=True:C214
			Else 
				$continue:=False:C215
			End if 
		End if 
		
		If ($continue)
			xText:=xText+$r+$aCPNs{$i}+$t+$packing_spec+$r
			//print side by side
			If ($numRels>$numBins)
				$rows:=$numRels
			Else 
				$rows:=$numBins
			End if 
			xText:=xText+$t+"ITEM"+$t+"INVENTORY_BIN"+$t+"QTY"+$t+"GLUED"+$t+"SSCC_ID"+$t+"SPEC"+$t+"RELEASE_DATE"+$t+"QTY"+$t+"SHIPTO"+$t+"CITY"+$t+"REFER"+$t+"TOT_SKIDS"+$t+"ITEM"+$r
			For ($row; 1; $rows)
				
				If ($row<=$numBins)
					If ($aOnHand{$row}=$full_skid)
						$complete:="*"
					Else 
						$complete:=""
					End if 
					xText:=xText+$t+$aCPNs{$i}+$t+$aBin{$row}+$t+String:C10($aOnHand{$row})+$t+String:C10(JMI_getGlueDate($aJobit{$row}); System date short:K1:1)+$t+BarCode_HumanReadableSSCC($aPallet{$row})+$complete+$t+String:C10($aFull{$row})
				Else 
					xText:=xText+(6*$t)
				End if 
				
				If ($row<=$numRels)
					$hit:=Find in array:C230($aShiptos; $aSchd_Shipto{$row})
					If ($hit>-1)  //in scope shipto
						$scope:="**"
					Else 
						$scope:=""
					End if 
					xText:=xText+$t+String:C10($aSchd_date{$row}; System date short:K1:1)+$t+String:C10($aSchd_Qty{$row})+$t+"["+$aSchd_Shipto{$row}+"]"+$scope+$t+ADDR_getCity($aSchd_Shipto{$row})+$t+$aRefer{$row}
					$cummulative_counter:=$cummulative_counter+$aSchd_Qty{$row}
					$num_skids:=String:C10(Round:C94($cummulative_counter/$full_skid; 2))
					xText:=xText+$t+$num_skids+$t+$aCPNs{$i}
				End if 
				xText:=xText+$t+$r
			End for 
		End if   //continue
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	$err:=util_Launch_External_App(docName)
	
End if 