//%attributes = {"publishedWeb":true}
//PM: Batch_ForecastAnalysis({cpn}) -> 
//@author mlb - 4/23/01  13:41
//what is the net present value of the open releases and forecasts
//util_NPV(rate;->arrayOfRevenueStream) 
// Modified by: Mel Bohince (5/5/21) tiny optimizations with execute on server

C_LONGINT:C283($i; $relCursor; $numFCST)
C_DATE:C307($today)
C_TEXT:C284($1; $docName; xTitle; xText; $2)
C_TEXT:C284($t; $cr)

$today:=4D_Current_date
$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="Net Present Value of Releases"
xText:=""

READ WRITE:C146([Finished_Goods:26])
READ ONLY:C145([Customers_ReleaseSchedules:46])
//* Reset the results

If (Count parameters:C259=1)  //do them all
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FRCST_NumberOfReleases:69>0)  //get all open release
Else   //just one code
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FRCST_NumberOfReleases:69>0; *)
	QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]ProductCode:1=$2)
End if 

//initialize the target fields
ARRAY LONGINT:C221($aFGnumRELs; 0)
ARRAY REAL:C219($aFGnpv; 0)
ARRAY DATE:C224($aShip; 0)
ARRAY DATE:C224($aDock; 0)
$numFCST:=Records in selection:C76([Finished_Goods:26])
If ($numFCST>0)
	SELECTION TO ARRAY:C260([Finished_Goods:26]FRCST_NumberOfReleases:69; $aFGnumRELs; [Finished_Goods:26]FRCST_NPV:70; $aFGnpv; [Finished_Goods:26]DateShip:91; $aShip; [Finished_Goods:26]DateDockDelivery:90; $aDock)
	For ($i; 1; $numFCST)
		$aFGnumRELs{$i}:=0
		$aFGnpv{$i}:=0
		$aShip{$i}:=!00-00-00!
		$aDock{$i}:=!00-00-00!
		IDLE:C311
	End for 
	ARRAY TO SELECTION:C261($aFGnumRELs; [Finished_Goods:26]FRCST_NumberOfReleases:69; $aFGnpv; [Finished_Goods:26]FRCST_NPV:70; $aShip; [Finished_Goods:26]DateShip:91; $aDock; [Finished_Goods:26]DateDockDelivery:90)
	ARRAY LONGINT:C221($aFGnumRELs; 0)
	ARRAY REAL:C219($aFGnpv; 0)
	ARRAY DATE:C224($aShip; 0)
	ARRAY DATE:C224($aDock; 0)
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
End if 

ARRAY TEXT:C222($aRelKey; 0)
ARRAY LONGINT:C221($aRel_Open; 0)
ARRAY LONGINT:C221($aRelQty; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aRelCust; 0)
ARRAY DATE:C224($aDate; 0)

//*Get the current state
If (Count parameters:C259=1)  //do them all
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)  //get all open release
Else   //just one code
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$2)
End if 

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12; >; [Customers_ReleaseSchedules:46]ProductCode:11; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $aRelCust; [Customers_ReleaseSchedules:46]ProductCode:11; $aCPN; [Customers_ReleaseSchedules:46]OpenQty:16; $aRelQty; [Customers_ReleaseSchedules:46]Sched_Date:5; $aDate; [Customers_ReleaseSchedules:46]OrderLine:4; $aOrderline; [Customers_ReleaseSchedules:46]Promise_Date:32; $aDock)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	//zCursorMgr ("beachBallOff")
	//zCursorMgr ("watch")
	ARRAY TEXT:C222($aRelKey; Size of array:C274($aRelCust))
	ARRAY LONGINT:C221($aRel_Open; Size of array:C274($aRelCust))
	ARRAY LONGINT:C221($aRel_Count; Size of array:C274($aRelCust))
	$relCursor:=0  //track the use of above arrays
	C_DATE:C307($dateFirst; $dateDock)
	$dateFirst:=<>MAGIC_DATE  //$aDate
	$dateDock:=<>MAGIC_DATE  //$aDock
	//*Tally the orderline opens 
	uThermoInit(Size of array:C274($aRelCust); "Analyzing Releases")
	
	For ($i; 1; Size of array:C274($aRelCust))  //each open release or forecast
		//*     Set up a bucket  
		uThermoUpdate($i)
		If ($aRelKey{$relCursor}#($aRelCust{$i}+":"+$aCPN{$i}))
			If ($relCursor>0)
				$numFG:=qryFinishedGood("#KEY"; $aRelKey{$relCursor})
				If ($numFG>0)
					[Finished_Goods:26]FRCST_NumberOfReleases:69:=$aRel_Count{$relCursor}
					[Finished_Goods:26]FRCST_NPV:70:=Rel_RevenueStream("npv")
					[Finished_Goods:26]DateShip:91:=$dateFirst
					[Finished_Goods:26]DateDockDelivery:90:=$dateDock
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
					[Finished_Goods:26]DateClosing:92:=[Finished_Goods:26]DateShip:91-(7*[Customers:16]DefaultLeadTime:56)
					SAVE RECORD:C53([Finished_Goods:26])
				End if 
			End if 
			
			$relCursor:=$relCursor+1
			$aRelKey{$relCursor}:=$aRelCust{$i}+":"+$aCPN{$i}
			$numFCST:=Rel_RevenueStream("init"; $today; 12)
			$dateFirst:=<>MAGIC_DATE
			$dateDock:=<>MAGIC_DATE
		End if 
		//If (($aRelKey{$relCursor}="00121:11PQ-00-0110") | 
		//«($aRelKey{$relCursor}="00121:0442-01-8110"))
		//TRACE
		//End if 
		//*Tally the qty
		$aRel_Open{$relCursor}:=$aRel_Open{$relCursor}+$aRelQty{$i}
		$aRel_Count{$relCursor}:=$aRel_Count{$relCursor}+1
		If ($aDate{$i}<$dateFirst)
			$dateFirst:=$aDate{$i}
		End if 
		
		If ($aDock{$i}<$dateDock)
			$dateDock:=$aDock{$i}
		End if 
		
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aOrderline{$i})
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			$price:=[Customers_Order_Lines:41]Price_Per_M:8
		Else 
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=($aRelCust{$i}+":"+$aCPN{$i}))
			If (Records in selection:C76([Finished_Goods:26])>0)
				$price:=[Finished_Goods:26]RKContractPrice:49
			Else 
				$price:=0
			End if 
		End if 
		SET QUERY LIMIT:C395(0)
		
		$value:=Round:C94(($aRelQty{$i}/1000)*$price; 0)
		$numFCST:=Rel_RevenueStream("set"; $aDate{$i}; $aRelQty{$i}; $value)
	End for   ////each open release or forecast
	
	If ($relCursor>0)  //get the last one
		$numFG:=qryFinishedGood("#KEY"; $aRelKey{$relCursor})
		If ($numFG>0)
			[Finished_Goods:26]FRCST_NumberOfReleases:69:=$aRel_Count{$relCursor}
			[Finished_Goods:26]FRCST_NPV:70:=Rel_RevenueStream("npv")
			[Finished_Goods:26]DateShip:91:=$dateFirst
			[Finished_Goods:26]DateDockDelivery:90:=$dateDock
			//see fg_setClosingDeadline
			//QUERY([CUSTOMER];[CUSTOMER]ID=[Finished_Goods]CustID)
			//[Finished_Goods]DateClosing:=[Finished_Goods]DateShip-(7*[CUSTOMER]DefaultLeadTime)
			SAVE RECORD:C53([Finished_Goods:26])
		End if 
	End if 
	
	$numFCST:=Rel_RevenueStream("init"; $today; 0)
	ARRAY LONGINT:C221($aRelQty; 0)
	ARRAY TEXT:C222($aRelCust; 0)
	ARRAY TEXT:C222($aRelKey; $relCursor)
	ARRAY LONGINT:C221($aRel_Open; $relCursor)
	
End if 


//send the results in email
If (False:C215)
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FRCST_NumberOfReleases:69>0; *)
	QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]ProductCode:1="22ml-01-0111")
Else 
	If (Count parameters:C259=1)  //do them all
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FRCST_NumberOfReleases:69>0)  //get all open release
	Else   //just one code
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FRCST_NumberOfReleases:69>0; *)
		QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]ProductCode:1=$2)
	End if 
End if 

SELECTION TO ARRAY:C260([Finished_Goods:26]CustID:2; $aCust; [Finished_Goods:26]FRCST_NumberOfReleases:69; $aNumRel; [Finished_Goods:26]FRCST_NPV:70; $aNPV)
SORT ARRAY:C229($aCust; $aNumRel; $aNPV; >)
$forecastDol:=0
$forecastQty:=0
$lastCust:=""
$countRels:=0
$npv:=0
xText:="Customer"+$t+"numRels"+$t+"NPV"+$cr
For ($i; 1; Size of array:C274($aCust))
	If ($lastCust#$aCust{$i})
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$lastCust)
		xText:=xText+[Customers:16]Name:2+$t+String:C10($countRels)+$t+String:C10($npv)+$cr
		$lastCust:=$aCust{$i}
		$countRels:=0
		$npv:=0
	End if 
	$countRels:=$countRels+$aNumRel{$i}
	$npv:=$npv+$aNPV{$i}
	
	$forecastQty:=$forecastQty+$aNumRel{$i}
	$forecastDol:=$forecastDol+$aNPV{$i}
End for 
xText:=xText+$lastCust+$t+String:C10($countRels)+$t+String:C10($npv)+$cr

uThermoClose

xText:=xText+"      TOTAL    "+$t+String:C10($forecastQty)+$t+String:C10($forecastDol)+$cr
xText:=xText+$cr+"_______________ END OF REPORT ______________"

QM_Sender(String:C10($forecastDol; "$##,###,##0")+"=NetPresentValue of Releases"; ""; xText; distributionList)
//rPrintText ("_.LOG")

//do some housekeeping, these really don't belong here!
FG_setInventoryNow  // Modified by: Mel Bohince (5/5/21) tiny optimizations with execute on server

fg_setClosingDeadline  // Modified by: Mel Bohince (5/5/21) tiny optimizations with execute on server

BEEP:C151