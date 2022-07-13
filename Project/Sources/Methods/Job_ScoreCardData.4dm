//%attributes = {}
// Method: Job_ScoreCardData
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 09/29/15, 15:06:00
// ----------------------------------------------------
// Description
// idk, bullshit that the wheels thinks is important
// ----------------------------------------------------
// Modified by: Mel Bohince (2/11/16) add O/S inventory
// Modified by: Mel Bohince (5/20/16) add outside printing, in fact any 13-O/S
// Modified by: MelvinBohince (4/6/22) chg to csv

C_DATE:C307(dDateBegin; $1; $2; dDateEnd)
C_TEXT:C284($customer; $t; $r)
C_TEXT:C284(docName; $docShortName; $3; $distributionList)
$t:=","  //Char(9)
$r:=Char:C90(13)

If (Count parameters:C259>2)
	dDateBegin:=$1
	dDateEnd:=$2
	$distributionList:=$3
	OK:=1
	bSearch:=0
	
Else 
	dDateBegin:=!00-00-00!
	dDateEnd:=!00-00-00!
	DIALOG:C40([zz_control:1]; "DateRange2")
	$distributionList:="mel.bohince@arkay.com"
End if 

//dDateBegin:=!09/20/2015!
//dDateEnd:=!09/26/2015!
//$distributionList:="mel.bohince@arkay.com"

//TRACE
If (ok=1)
	docName:="ScoreCardMusings_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
	$docShortName:=docName  //capture before path is prepended
	C_TIME:C306($docRef)
	$docRef:=util_putFileName(->docName)
	xText:=""
	xTitle:="Weekly Scorecard Data for "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
	xText:=xTitle+"\r"
	//placeholder
	//xText:="We did pretty good this week, we made plenty and even billed some."+$r+xTitle+$r
	
	//Imaging/prep billing        AMS INVOICES
	$billing:=0
	Begin SQL
		SELECT sum(ExtendedPrice)
		from Customers_Invoices
		where upper(ProductCode) like 'PREP%' and Invoice_Date between :dDateBegin and :dDateEnd
		into :$billing
	End SQL
	xText:=xText+"PREPARATORY BILLINGS: "+$t+String:C10($billing)+$r
	
	
	//Sales$per Week(ship)INVOICED for week
	//Sales$per Week(Mfg)to review
	$billing:=0
	$cogs:=0
	$pv:=0
	Begin SQL
		SELECT sum(ExtendedPrice), sum(CoGS_FiFo)
		from Customers_Invoices
		where upper(ProductCode) not like 'PREP%' and Invoice_Date between :dDateBegin and :dDateEnd
		into :$billing, :$cogs
	End SQL
	$pv:=Round:C94(fProfitVariable("PV"; $cogs; $billing; $pv); 2)
	xText:=xText+"PRODUCT BILLINGS: "+$t+txt_quote(String:C10(Round:C94($billing; 0); "$##,###,##0"))+$t+" costing: "+$t+txt_quote(String:C10(Round:C94($cogs; 0); "$##,###,##0"))+$t+" realized PV: "+String:C10($pv)+$r
	
	$mfg_sales:=0
	Begin SQL
		SELECT sum(ExtendedPrice)
		from Finished_Goods_Transactions
		where XactionDate between :dDateBegin and :dDateEnd and XactionType='Receipt'
		into :$mfg_sales
	End SQL
	xText:=xText+"MANUFACTURING SALES: "+$t+txt_quote(String:C10(Round:C94($mfg_sales; 0); "$##,###,##0"))+$r
	//Printing                  WEEKLY PRODUCTION REPORT
	//Finishing(Gluing)-cartons   WEEKLY PRODUCTION REPORT'
	//Flat Packing  WEEKLY PRODUCTION REPORT
	//Lamination  WEEKLY PRODUCTION REPORT
	//Sheeter  WEEKLY PRODUCTION REPORT
	ARRAY TEXT:C222($aCCGroup; 0)
	Begin SQL
		SELECT distinct(cc_Group) from Cost_Centers order by cc_Group into :$aCCGroup
	End SQL
	
	For ($g; 1; Size of array:C274($aCCGroup))
		$group:=$aCCGroup{$g}
		ARRAY TEXT:C222($aCC; 0)  //'20.PRINTING'
		ARRAY LONGINT:C221($aGoodCC; 0)
		$numJS:=0
		$ttl_good:=0
		$aveSize:=0
		Begin SQL
			select CostCenterID, sum(Good_Units)
			from Job_Forms_Machine_Tickets 
			where DateEntered between :dDateBegin and :dDateEnd and Good_Units > 0 and CostCenterID in (SELECT distinct(ID) from Cost_Centers where cc_Group = :$group) 
			GROUP BY CostCenterID 
			order by CostCenterID
			into :$aCC, :$aGoodCC
		End SQL
		
		If (Size of array:C274($aCC)>0)
			If ($aGoodCC{1}>0)
				//Median Press Run Size      Believe from MelFlex
				Begin SQL
					select count(distinct JobFormSeq)
					from Job_Forms_Machine_Tickets 
					where DateEntered between :dDateBegin and :dDateEnd and Good_Units > 0 and CostCenterID in (SELECT distinct(ID) from Cost_Centers where cc_Group = :$group) 
					into :$numJS
				End SQL
				
				$ttl_good:=0
				Begin SQL
					select sum(Good_Units)
					from Job_Forms_Machine_Tickets 
					where DateEntered between :dDateBegin and :dDateEnd and Good_Units > 0 and CostCenterID in (SELECT distinct(ID) from Cost_Centers where cc_Group = :$group) 
					into :$ttl_good
				End SQL
				
				If ($numJS>0)
					$aveSize:=Round:C94(($ttl_good/$numJS); 0)
				End if 
				
				xText:=xText+$r+$r+$group+$t+"Average Size: "+$t+txt_quote(String:C10($aveSize; "##,###,##0"))+$r  // Modified by: MelvinBohince (4/6/22) chg to CSV
				
				For ($cc; 1; Size of array:C274($aCC))
					xText:=xText+$aCC{$cc}+$t+txt_quote(String:C10($aGoodCC{$cc}; "##,###,##0"))+$r
				End for 
				xText:=xText+"TTL"+$t+txt_quote(String:C10($ttl_good; "##,###,##0"))+$r
				
				If (Position:C15("PRINT"; $group)>0)  //count DT and MR
					//Press Downtime%Believe form MelFlex
					ARRAY TEXT:C222($aCC; 0)  //'20.PRINTING'
					ARRAY LONGINT:C221($aDown; 0)
					ARRAY REAL:C219($aHrs; 0)
					Begin SQL
						select CostCenterID, count(DownHrs), sum(DownHrs)
						from Job_Forms_Machine_Tickets 
						where DateEntered between :dDateBegin and :dDateEnd and DownHrs > 0 and CostCenterID in (SELECT distinct(ID) from Cost_Centers where cc_Group = :$group) 
						GROUP BY CostCenterID 
						/*order by CostCenterID */
						into :$aCC, :$aDown, :$aHrs
					End SQL
					
					xText:=xText+$r+$r+"PRINTING DOWNS: "+$t+$r
					$ttl_hrs:=0
					$ttl_instances:=0
					For ($cc; 1; Size of array:C274($aCC))
						xText:=xText+$aCC{$cc}+$t+String:C10($aDown{$cc})+" times "+$t+String:C10($aHrs{$cc})+" hrs"+$r
						$ttl_hrs:=$ttl_hrs+$aHrs{$cc}
						$ttl_instances:=$ttl_instances+$aDown{$cc}
					End for 
					xText:=xText+"TTL"+$t+String:C10($ttl_instances)+" times "+$t+String:C10($ttl_hrs)+" hrs"+$r
					//#of Make Readies            Believe from MelFlex
					ARRAY TEXT:C222($aCC; 0)  //'20.PRINTING'
					ARRAY LONGINT:C221($aMR; 0)
					ARRAY REAL:C219($aHrs; 0)
					Begin SQL
						select CostCenterID, count(MR_Act), sum(MR_Act)
						from Job_Forms_Machine_Tickets 
						where DateEntered between :dDateBegin and :dDateEnd and MR_Act > 0 and CostCenterID in (SELECT distinct(ID) from Cost_Centers where cc_Group = :$group) 
						GROUP BY CostCenterID 
						/*order by CostCenterID*/
						into :$aCC, :$aMR, :$aHrs
					End SQL
					
					xText:=xText+$r+$r+"PRINTING MAKE READIES: "+$t+$r
					$ttl_hrs:=0
					$ttl_instances:=0
					For ($cc; 1; Size of array:C274($aCC))
						xText:=xText+$aCC{$cc}+$t+String:C10($aMR{$cc})+" times "+$t+String:C10($aHrs{$cc})+" hrs"+$r
						$ttl_hrs:=$ttl_hrs+$aHrs{$cc}
						$ttl_instances:=$ttl_instances+$aMR{$cc}
					End for 
					xText:=xText+"TTL"+$t+String:C10($ttl_instances)+" times "+$t+String:C10($ttl_hrs)+" hrs"+$r
				End if 
				
			End if 
		End if 
		
	End for 
	
	//ARRAY TEXT($aJS;0)
	//ARRAY LONGINT($aGoodJS;0)
	//Begin SQL
	//select JobFormSeq, sum(Good_Units)
	//from Job_Forms_Machine_Tickets 
	//where DateEntered between :dDateBegin and :dDateEnd and Good_Units > 0 and CostCenterID in (SELECT distinct(ID) from Cost_Centers where cc_Group = '20.PRINTING') 
	//GROUP BY JobFormSeq
	//into :$aJS,:$aGoodJS
	//End SQL
	
	
	//[Job_Forms_Machine_Tickets]
	
	
	//Run Time Points Printing    Believe from MelFlex
	
	//Outside Glue    PO ' With Glu or Windowing recd in Qty
	//Outside Flatpacking   PO's with Flat recd in Qty
	//Outside Die Cut and Stamp  PO's with Die or Stamp recd in Qty
	//Outside Sheeting   Po's with sheeting recd in Qty
	// Modified by: Mel Bohince (5/20/16) add outside printing
	//(upper(Commodity_Key)like '13-O/S WIN%' or
	//upper(Commodity_Key)like '13-O/S GLU%' or
	//upper(Commodity_Key)like '13-O/S PRINT%' or
	//upper(Commodity_Key)like '13-O/S D%')
	ARRAY TEXT:C222($aRM; 0)
	ARRAY LONGINT:C221($aQty; 0)
	Begin SQL
		select Raw_Matl_Code, sum(Qty)
		from Raw_Materials_Transactions
		where
		upper(Commodity_Key) like '13-O/S%' and
		XferDate between :dDateBegin and :dDateEnd and
		upper(Xfer_Type) = 'RECEIPT'
		group by Raw_Matl_Code
		/*order by Raw_Matl_Code*/
		into :$aRM, :$aQty
	End SQL
	
	xText:=xText+$r+$r+"OUTSIDE SERVICES: "+$t+$r
	$ttl_instances:=0
	For ($cc; 1; Size of array:C274($aQty))
		xText:=xText+$aRM{$cc}+$t+txt_quote(String:C10($aQty{$cc}; "##,###,##0"))+$r
		$ttl_instances:=$ttl_instances+$aQty{$cc}
	End for 
	xText:=xText+"TTL"+$t+txt_quote(String:C10($ttl_instances; "##,###,##0"))+$r
	
	//Raw Material over 90 Days    Total to Aged RM Report over 90/120
	
	//Costed FG Cartons includes RAMA   FG Report
	//Non-Costed FG Cartons      FG REPORT
	
	xText:=xText+$r+$r+"CATAGORIZED INVENTORIES: "+$t+$r
	//Cartons @ RAMA       FG/CC/XC/EX Summary
	//$qtyOH:=0
	//Begin SQL
	//SELECT sum(QtyOH) from Finished_Goods_Locations where upper(Location) like '%RAMA%' into :$qtyOH
	//End SQL
	//xText:=xText+"RAMA:"+$t+String($qtyOH)+$r
	
	//  //Examining and XC      FG/CC/XC/EX Summary
	//$qtyOH:=0
	//Begin SQL
	//SELECT sum(QtyOH) from Finished_Goods_Locations where upper(Location) like 'XC%' into :$qtyOH
	//End SQL
	//xText:=xText+"RE-CERTIFICATION:"+$t+String($qtyOH)+$r
	
	//$qtyOH:=0
	//Begin SQL
	//SELECT sum(QtyOH) from Finished_Goods_Locations where upper(Location) like 'EX%' into :$qtyOH
	//End SQL
	//xText:=xText+"EXAMINING:"+$t+String($qtyOH)+$r
	//////////
	
	C_LONGINT:C283($i; $locs; $FG; $CC; $XC; $EX; $BH; $NA; $AV; $FX; $OS)
	READ ONLY:C145([Finished_Goods:26])
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	//$locs:=Records in selection([Finished_Goods_Locations])
	$FG:=0
	$CC:=0
	$XC:=0
	$EX:=0
	$BH:=0
	$NA:=0
	$AV:=0
	$OS:=0
	//$Vista:=0
	//$transit:=0
	$qtyOH:=0
	//$FX:=0
	//$PX:=0
	ARRAY TEXT:C222($aLocation; 0)
	ARRAY LONGINT:C221($aQty; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aLocation; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
	$locs:=Size of array:C274($aLocation)
	ARRAY TEXT:C222($badLocations; 0)
	
	//uThermoInit ($locs;"Tallying inventory")
	For ($i; 1; $locs)
		Case of 
				//: (Position("transit";$aLocation{$i})>0)
				//$transit:=$transit+$aQty{$i}
				
				//: ($aLocation{$i}="FG:V@")
				//$Vista:=$Vista+$aQty{$i}
				
			: (Position:C15("OS"; $aLocation{$i})>0)
				$OS:=$OS+$aQty{$i}
				
			: ($aLocation{$i}="FG:AV@")
				$AV:=$AV+$aQty{$i}
				
			: ($aLocation{$i}="FG@")
				$FG:=$FG+$aQty{$i}
				
			: ($aLocation{$i}="CC@")
				$CC:=$CC+$aQty{$i}
				
			: ($aLocation{$i}="XC@")
				$XC:=$XC+$aQty{$i}
				
			: ($aLocation{$i}="EX@")
				$EX:=$EX+$aQty{$i}
				
			Else 
				$NA:=$NA+$aQty{$i}
				APPEND TO ARRAY:C911($badLocations; $aLocation{$i})
		End case 
		
		//NEXT RECORD([Finished_Goods_Locations])
		//uThermoUpdate ($i)
	End for 
	//uThermoClose 
	
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Bill_and_Hold_Qty:108>0)
	If (Records in selection:C76([Finished_Goods:26])>0)
		$BH:=Sum:C1([Finished_Goods:26]Bill_and_Hold_Qty:108)
	End if 
	
	$qtyOH:=$AV+$FG+$CC+$XC+$EX+$BH+$NA
	
	$b:=""
	$e:=$r
	$table:=""
	
	$table:=$table+$b+"CONSIGN"+$t+txt_quote(String:C10($AV; "###,###,###,##0"))+$e
	$table:=$table+$b+"FG"+$t+txt_quote(String:C10($FG; "###,###,###,##0"))+$e
	$table:=$table+$b+"OS"+$t+txt_quote(String:C10($OS; "###,###,###,##0"))+$e
	$table:=$table+$b+"CC"+$t+txt_quote(String:C10($CC; "###,###,###,##0"))+$e
	$table:=$table+$b+"XC"+$t+txt_quote(String:C10($XC; "###,###,###,##0"))+$e
	$table:=$table+$b+"EX"+$t+txt_quote(String:C10($EX; "###,###,###,##0"))+$e
	$table:=$table+$b+"BH"+$t+txt_quote(String:C10($BH; "###,###,###,##0"))+$e
	$table:=$table+$b+"INVALID:"+$t+txt_quote(String:C10($NA; "###,###,###,##0"))+$e
	$table:=$table+$b+"TOTAL:"+$t+txt_quote(String:C10($qtyOH; "###,###,###,##0"))+$e
	For ($i; 1; Size of array:C274($badLocations))
		$table:=$table+$b+$badLocations{$i}+$t+" "+$e
	End for 
	
	xText:=xText+$table
	
	///////////
	
	xText:=xText+$r+$r+"SCRAPS: "+$t+$r
	//FG to Scrapped Qty       FG Transactions Scrapped
	$qtyOH:=0
	$ttl_instances:=0
	Begin SQL
		SELECT sum(Qty) from Finished_Goods_Transactions
		where  XactionDate between :dDateBegin and :dDateEnd and upper(Location) like 'SC%' and upper(viaLocation) like 'FG%'
		into :$qtyOH
	End SQL
	xText:=xText+"FG to SCRAP(NON-QA):"+$t+txt_quote(String:C10($qtyOH; "##,###,##0"))+$r
	$ttl_instances:=$ttl_instances+$qtyOH
	
	$qtyOH:=0
	Begin SQL
		SELECT sum(Qty) from Finished_Goods_Transactions
		where  XactionDate between :dDateBegin and :dDateEnd and upper(Location) like 'SC%' and upper(viaLocation) like 'XC%'
		into :$qtyOH
	End SQL
	xText:=xText+"XC to SCRAP:"+$t+txt_quote(String:C10($qtyOH; "##,###,##0"))+$r
	$ttl_instances:=$ttl_instances+$qtyOH
	
	$qtyOH:=0
	Begin SQL
		SELECT sum(Qty) from Finished_Goods_Transactions
		where  XactionDate between :dDateBegin and :dDateEnd and upper(Location) like 'SC%' and upper(viaLocation) like 'EX%'
		into :$qtyOH
	End SQL
	xText:=xText+"EX to SCRAP:"+$t+txt_quote(String:C10($qtyOH; "##,###,##0"))+$r
	$ttl_instances:=$ttl_instances+$qtyOH
	xText:=xText+"TTL"+$t+txt_quote(String:C10($ttl_instances; "##,###,##0"))+$r
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	$body:=Replace string:C233(xText; "\""; " ")
	
	If (Count parameters:C259>2)
		EMAIL_Sender(xTitle; ""; $body; $distributionList; docName)
		util_deleteDocument(docName)
	Else 
		EMAIL_Sender(xTitle; ""; $body; $distributionList; docName)
		$err:=util_Launch_External_App(docName)
	End if 
End if   //ok
