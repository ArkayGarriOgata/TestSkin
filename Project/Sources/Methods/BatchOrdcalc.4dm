//%attributes = {"publishedWeb":true}
//Procedure: BatchOrdCalc()  071696  MLB
//roll up the open orders to the cpn level
//•1/29/97 cs - added code so that this routine will run only
//•022097  MLB  close search
//  once per day on any given machine, suppressed sort thermometer

C_LONGINT:C283($i; $numOrds; $ordCursor; $1)
C_TEXT:C284($2)

MESSAGES OFF:C175  //•1/31/97 suppress sort dialogs
zCursorMgr("beachBallOff")
zCursorMgr("watch")
If (<>OrdBatchDat#Current date:C33)  //•1/29/97 if this routine has been run today, skip
	If (Count parameters:C259=1)
		ARRAY TEXT:C222(<>aOrdKey; $1)
		ARRAY LONGINT:C221(<>aQty_Open; $1)
		ARRAY LONGINT:C221(<>aQty_ORun; $1)
	Else 
		C_TIME:C306($timer)
		$timer:=Current time:C178
		//*Get all the open orders
		If (Count parameters:C259=2)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24=$2)
			qryOpenOrdLines("c"; "*")  //close the search selection
		Else 
			qryOpenOrdLines
		End if 
		
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4; >; [Customers_Order_Lines:41]ProductCode:5; >)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]CustID:4; $aCust; [Customers_Order_Lines:41]ProductCode:5; $aCPN; [Customers_Order_Lines:41]Quantity:6; $aOrdered; [Customers_Order_Lines:41]Qty_Open:11; $aQty; [Customers_Order_Lines:41]OverRun:25; $aORun)
		uClearSelection(->[Customers_Order_Lines:41])
		$numOrds:=Size of array:C274($aCust)
		//*Over allocate array sizes for now  
		ARRAY TEXT:C222(<>aOrdKey; 0)
		ARRAY LONGINT:C221(<>aQty_Open; 0)
		ARRAY LONGINT:C221(<>aQty_ORun; 0)
		ARRAY TEXT:C222(<>aOrdKey; $numOrds)
		ARRAY LONGINT:C221(<>aQty_Open; $numOrds)
		ARRAY LONGINT:C221(<>aQty_ORun; $numOrds)
		$ordCursor:=0  //track the use of above arrays
		//*Tally the orderline opens 
		// uThermoInit ($numOrds;"Batch Order Roll-up")•1/31/97 removed so that these pres
		For ($i; 1; $numOrds)
			//*     Set up a bucket  
			If (<>aOrdKey{$ordCursor}#($aCust{$i}+":"+$aCPN{$i}))
				$ordCursor:=$ordCursor+1
				<>aOrdKey{$ordCursor}:=$aCust{$i}+":"+$aCPN{$i}
			End if 
			//*    Tally based on bin type
			<>aQty_Open{$ordCursor}:=<>aQty_Open{$ordCursor}+$aQty{$i}
			<>aQty_ORun{$ordCursor}:=<>aQty_ORun{$ordCursor}+($aOrdered{$i}*($aORun{$i}/100))
			
			//  uThermoUpdate ($i)•1/31/97 removed so that these present no messages to user
		End for 
		// uThermoClose •1/31/97 removed so that these present no messages to user
		//*Shrink arrays to fit
		ARRAY TEXT:C222(<>aOrdKey; $ordCursor)
		ARRAY LONGINT:C221(<>aQty_Open; $ordCursor)
		ARRAY LONGINT:C221(<>aQty_ORun; $ordCursor)
		
		$timer:=Current time:C178-$timer
		<>OrdCalcDone:=True:C214
		<>OrdBatchDat:=Current date:C33
	End if 
Else   //•1/29/97 make sure completed flag is set on
	<>OrdCalcDone:=True:C214
End if 