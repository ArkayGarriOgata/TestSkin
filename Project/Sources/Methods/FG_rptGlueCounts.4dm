//%attributes = {"publishedWeb":true}
//Procedure: FG_rptGlueCounts()  021898  MLB
//generate a report of gluing volumns.
//•030398  MLB  copy past error on accumulators, get friday
//•033098  MLB add names to cc list, shorten Title
//•061798  MLB  replace Mark Zupo with Debbie Siderine
//•100798  MLB  remove Debbie Siderine
//•121798  Systems replace walter with brian, add sales and contribution
//and weekend on mondays batch
//•021209  MLB  remove hauppauge and reformat, also no lobster
// Modified by: Mel Bohince (9/29/16) eliminate  components and o/s from counts

C_LONGINT:C283($numGlued; $i; $RoanD; $RoanN; $RoanL; $HaupD; $HaupN; $HaupL)
C_LONGINT:C283($day; $nite; $lobster; $RoanT; $HaupT; $DayT; $NiteT; $LobT; $Total)
C_DATE:C307($date; $1)
C_TEXT:C284(xText; xTitle; $line; $blank)

If (Count parameters:C259>0)
	$date:=$1
Else 
	$date:=4D_Current_date  //yesterday
	$date:=!2016-09-13!  //for testing
	//distributionList:="mel.bohince@arkay.com"
End if 

$blank:=(62*" ")
xText:=""
xTitle:="Glue Counts - "
$day:=?06:00:00?+0
$nite:=?14:45:00?+0
$lobster:=?23:59:59?+0

//*Get the CC receipts
READ ONLY:C145([Finished_Goods_Transactions:33])
//If (Day number($date)=2) & (False)  //monday, do friday and weekend, deact since auto batch mode
//$date:=$date-3
//xTitle:=xTitle+String($date;<>MIDDATE)+", plus the weekend"
//QUERY([Finished_Goods_Transactions];[Finished_Goods_Transactions]XactionDate>=$date;*)
//QUERY([Finished_Goods_Transactions]; & ;[Finished_Goods_Transactions]XactionDate<($date+3);*)
//Else 
$date:=$date  //-1  `do yesterday 
xTitle:=xTitle+String:C10($date; <>MIDDATE)
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=$date; *)
//End if 
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]ActionTaken:27="@scan@")  // Modified by: Mel Bohince (9/29/16) elim components and o/s from counts

$numGlued:=Records in selection:C76([Finished_Goods_Transactions:33])
If ($numGlued>0)
	//*    Load the data
	ARRAY LONGINT:C221($aQty; $numGlued)
	ARRAY REAL:C219($aSalesVal; $numGlued)
	ARRAY REAL:C219($aCost; $numGlued)
	ARRAY LONGINT:C221($aTime; $numGlued)
	ARRAY TEXT:C222($aLocation; $numGlued)
	ARRAY TEXT:C222($aJobit; $numGlued)
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Qty:6; $aQty; [Finished_Goods_Transactions:33]Location:9; $aLocation; [Finished_Goods_Transactions:33]XactionTime:13; $aTime; [Finished_Goods_Transactions:33]ExtendedPrice:20; $aSalesVal; [Finished_Goods_Transactions:33]CoGSExtended:8; $aCost; [Finished_Goods_Transactions:33]Jobit:31; $aJobit)
	REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
	
	//*Tally the counts
	$RoanD:=0
	$RoanN:=0
	$RoanL:=0
	$TotalGLued:=0
	$TotalCost:=0
	$TotalValue:=0
	$DayCost:=0
	$DayValue:=0
	$NiteCost:=0
	$NiteValue:=0
	$LobCost:=0
	$LobValue:=0
	
	For ($i; 1; $numGlued)
		Case of 
			: ($aTime{$i}<=$day)  //lobster
				//$RoanL:=$RoanL+$aQty{$i}
				//$LobCost:=$LobCost+$aCost{$i}
				//$LobValue:=$LobValue+$aSalesVal{$i}
				$RoanN:=$RoanN+$aQty{$i}  //morning entries of nite shift work?
				$NiteCost:=$NiteCost+$aCost{$i}
				$NiteValue:=$NiteValue+$aSalesVal{$i}
				
			: ($aTime{$i}<=$nite)  //day
				$RoanD:=$RoanD+$aQty{$i}
				$DayCost:=$DayCost+$aCost{$i}
				$DayValue:=$DayValue+$aSalesVal{$i}
				
			: ($aTime{$i}<=$lobster)  //nite
				$RoanN:=$RoanN+$aQty{$i}
				$NiteCost:=$NiteCost+$aCost{$i}
				$NiteValue:=$NiteValue+$aSalesVal{$i}
				
			Else   //next days lobster
				$RoanL:=$RoanL+$aQty{$i}
				$LobCost:=$LobCost+$aCost{$i}
				$LobValue:=$LobValue+$aSalesVal{$i}
		End case 
		
		$TotalGLued:=$TotalGLued+$aQty{$i}
		$TotalCost:=$TotalCost+$aCost{$i}
		$TotalValue:=$TotalValue+$aSalesVal{$i}
	End for 
	
	//*Write the results
	xText:=Uppercase:C13(xTitle)+Char:C90(13)+Char:C90(13)
	xTitle:=xTitle+" - "+String:C10($TotalGLued; "###,###,##0")
	xText:=xText+"Total Glued: "+String:C10($TotalGLued; "###,###,##0")+" Costing: "+String:C10($TotalCost; "$###,###,##0")+" Valued at: "+String:C10($TotalValue; "$###,###,##0")+Char:C90(13)
	xText:=xText+"For a Contribution of: "+String:C10(($TotalValue-$TotalCost); "$###,###,##0")+Char:C90(13)+Char:C90(13)
	xText:=xText+"======== DETAILS ========"+Char:C90(13)+Char:C90(13)
	If ($RoanD>0)
		xText:=xText+"Day Shift: "+String:C10($RoanD; "###,###,##0")+" cartons Costing: "+String:C10($DayCost; "$###,###,##0")+" Valued at : "+String:C10($DayValue; "$###,###,##0")+Char:C90(13)+Char:C90(13)
	End if 
	If ($RoanN>0)
		xText:=xText+"Night Shift: "+String:C10($RoanN; "###,###,##0")+" cartons Costing: "+String:C10($NiteCost; "$###,###,##0")+" Valued at : "+String:C10($NiteValue; "$###,###,##0")+Char:C90(13)+Char:C90(13)
	End if 
	If ($RoanL>0)
		xText:=xText+"Lobster Shift: "+String:C10($RoanL; "###,###,##0")+"cartons Costing: "+String:C10($LobCost; "$###,###,##0")+" Valued at : "+String:C10($LobValue; "$###,###,##0")+Char:C90(13)+Char:C90(13)
	End if 
	
Else 
	xText:="No Gluing activity found for "+String:C10($date; <>MIDDATE)
End if 
//*Email the results
QM_Sender(xTitle; ""; xText; distributionList)
//rPrintText ("GlueCounts"+fYYMMDD ($date)+"_"+Replace string(String(Current 
//«time(*);◊HHMM);":";""))
xText:=""
xTitle:=""