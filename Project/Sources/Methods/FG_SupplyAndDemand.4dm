//%attributes = {"publishedWeb":true}
//PM: FG_SupplyAndDemand() -> 
//@author mlb - 7/31/02  11:36
C_TEXT:C284($0; $text; $format)
$format:="##,###,##0 ;(##,###,##0);-0-"
C_TEXT:C284($fgKey; $1)
C_LONGINT:C283($i; $onHand; $balance; $numEvents; $next)
CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "holdFGL")
CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "holdREL")
CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "holdJMI")
CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "holdJML")
$fgKey:=$1
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=$fgKey)
If (Records in selection:C76([Finished_Goods_Locations:35])>0)
	$onHand:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
Else 
	$onHand:=0
End if 

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=(Substring:C12($fgKey; 1; 5)); *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=(Substring:C12($fgKey; 7)); *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aRelDate; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aRelQty; [Customers_ReleaseSchedules:46]CustomerRefer:3; $aPO)
//SORT ARRAY($aRelDate;$aRelQty;$aPO;>)

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]CustId:15=(Substring:C12($fgKey; 1; 5)); *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=(Substring:C12($fgKey; 7)); *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11=0)
SELECTION TO ARRAY:C260([Job_Forms_Items:44]MAD:37; $aMfgDate; [Job_Forms_Items:44]Qty_Want:24; $aMfgQty; [Job_Forms_Items:44]JobForm:1; $aJF)
For ($i; 1; Size of array:C274($aMfgDate))
	If ($aMfgDate{$i}=!00-00-00!)
		$numJML:=qryJML($aJF{$i})
		If ($numJML>0)
			Case of 
				: ([Job_Forms_Master_Schedule:67]OrigRevDate:20#!00-00-00!)
					$aMfgDate{$i}:=[Job_Forms_Master_Schedule:67]OrigRevDate:20
				: ([Job_Forms_Master_Schedule:67]MAD:21#!00-00-00!)
					$aMfgDate{$i}:=[Job_Forms_Master_Schedule:67]MAD:21
				Else 
					$aMfgDate{$i}:=<>MAGIC_DATE
			End case 
			
		Else 
			$aMfgDate{$i}:=<>MAGIC_DATE
		End if 
	End if 
End for 
//SORT ARRAY($aMfgDate;$aMfgQty;$aJF;>)

$balance:=$onHand
$numEvents:=Size of array:C274($aRelDate)+Size of array:C274($aMfgDate)
ARRAY TEXT:C222($aRef; $numEvents)
ARRAY DATE:C224($aDate; $numEvents)
ARRAY LONGINT:C221($aQty; $numEvents)

For ($i; 1; Size of array:C274($aMfgDate))
	$aRef{$i}:="Jobform "+$aJF{$i}
	$aDate{$i}:=$aMfgDate{$i}
	$aQty{$i}:=$aMfgQty{$i}
End for 
$next:=$i

For ($i; 1; Size of array:C274($aRelDate))
	$aRef{$next}:=$aPO{$i}
	$aDate{$next}:=$aRelDate{$i}
	$aQty{$next}:=$aRelQty{$i}*(-1)
	$next:=$next+1
End for 

SORT ARRAY:C229($aDate; $aRef; $aQty; >)
//reference   date     qty         balance
$text:=Char:C90(13)+$fgKey+Char:C90(13)
$text:=$text+txt_Pad("Reference"; " "; 1; 35)+txt_Pad("Date"; " "; 1; 15)+txt_Pad("Qty"; " "; -1; 15)+txt_Pad("Balance "; " "; -1; 15)+String:C10($balance; $format)+Char:C90(13)

For ($i; 1; $numEvents)
	$balance:=$balance+$aQty{$i}
	$text:=$text+txt_Pad($aRef{$i}; " "; 1; 35)+txt_Pad(String:C10($aDate{$i}; Internal date short:K1:7); " "; 1; 15)+txt_Pad(String:C10($aQty{$i}; $format); " "; -1; 15)+txt_Pad(String:C10($balance; $format); " "; -1; 15)+Char:C90(13)
End for 

$0:=$text

USE NAMED SELECTION:C332("holdFGL")
USE NAMED SELECTION:C332("holdREL")
USE NAMED SELECTION:C332("holdJMI")
USE NAMED SELECTION:C332("holdJML")
