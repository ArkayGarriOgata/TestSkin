//%attributes = {"publishedWeb":true}
// -------
// Method: BatchFGinventor   ( ) ->
// By: Mel Bohince @ 052096  MLB
// Description
//  roll up the FG_location qty's to the FG level and 
//  separate by status (CC/XC/FG/EX/BH)
// ----------------------------------------------------
//•1/29/97 cs - added code so that this rouotine runs only once per
//  day per machine. suppressed sort thermometer
//•022497  MLB  sort by array rather than by selection
//091905 mlb add FX bins in with FG since they are certified
// Added by: Mark Zinke (11/14/12) All user interface items removed so we can
//   run this on the server.
// Modified by: Mel Bohince (8/18/17) dont include FG: Hold, Lost, Shipped as available inventory
//   see also THC_calc_one_item
// Modified by: Mel Bohince (4/11/18) mistakenly using field instead of $aBin{$i} when tallying
// Modified by: Mel Bohince (3/26/21) Do include Shipped as available inventory, to support ASN process requiring inventory

C_BOOLEAN:C305($fgShippedIsExamining_b)  // Modified by: Mel Bohince (3/26/21) Do include Shipped as available inventory, to support ASN process requiring inventory
$fgShippedIsExamining_b:=False:C215  // see also FG_Inventory_CanShip used by the CUSTPORT_ExportPortal method

C_LONGINT:C283($i; $numBins; $binCursor; $1; $3)
C_TEXT:C284($bintype)
C_TEXT:C284($2)

MESSAGES OFF:C175  //•1/31/97 suppress sort dialogs

//If (<>FgBatchDat#Current date)  //| (True)  `•1/29/97 skip execution of this routine if it has already run today
If (Count parameters:C259=1)
	ARRAY TEXT:C222(<>aFGKey; $1)
	ARRAY LONGINT:C221(<>aQty_CC; $1)  //•1/31/97 cs changed to interPrc
	ARRAY LONGINT:C221(<>aQty_FG; $1)  //•1/31/97 cs changed to interPrc
	ARRAY LONGINT:C221(<>aQty_EX; $1)  //•1/31/97 cs changed to interPrc
	ARRAY LONGINT:C221(<>aQty_BH; $1)  //•1/31/97 cs changed to interPrc
	ARRAY LONGINT:C221(<>aQty_OH; $1)
	ARRAY LONGINT:C221(<>aQty_PAYUSE; $1)
Else 
	Case of 
		: (Count parameters:C259=2)
			If ([Customers:16]Name:2#$2) | (Length:C16($2)=1)
				QUERY:C277([Customers:16]; [Customers:16]Name:2=$2)
			End if 
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				SELECTION TO ARRAY:C260([Customers:16]ID:1; $aCustid)
				CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "bins")
				For ($i; 1; Size of array:C274($aCustid))
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=$aCustid{$i})
					CREATE SET:C116([Finished_Goods_Locations:35]; "someBins")
					UNION:C120("bins"; "someBins"; "bins")
				End for 
				USE SET:C118("bins")
				CLEAR SET:C117("bins")
				CLEAR SET:C117("someBins")
				
			Else 
				
				//correct bug last release 03-28-2019
				RELATE MANY SELECTION:C340([Finished_Goods_Locations:35]CustID:16)
				
			End if   // END 4D Professional Services : January 2019 
			
		: (Count parameters:C259=3)
			//use current selection
		Else 
			ALL RECORDS:C47([Finished_Goods_Locations:35])
	End case 
	
	//SORT SELECTION([FG_Locations];[FG_Locations]CustID;>;[FG_Locations]ProductCode;>
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY TEXT:C222($aBin; 0)
	ARRAY LONGINT:C221($aQtyOH; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]CustID:16; $aCust; [Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]Location:2; $aBin; [Finished_Goods_Locations:35]QtyOH:9; $aQtyOH)
	uClearSelection(->[Finished_Goods_Locations:35])
	$numBins:=Size of array:C274($aCust)
	//*Over allocate array sizes for now
	ARRAY TEXT:C222($aFGKey; 0)
	ARRAY TEXT:C222($aFGKey; $numBins)
	For ($i; 1; $numBins)  //•022497  MLB  build sort key
		$aFGKey{$i}:=$aCust{$i}+":"+$aCPN{$i}
	End for 
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aCPN; 0)
	SORT ARRAY:C229($aFGKey; $aBin; $aQtyOH; >)
	
	ARRAY TEXT:C222(<>aFGKey; 0)
	ARRAY LONGINT:C221(<>aQty_CC; 0)
	ARRAY LONGINT:C221(<>aQty_FG; 0)
	ARRAY LONGINT:C221(<>aQty_EX; 0)
	ARRAY LONGINT:C221(<>aQty_BH; 0)
	ARRAY LONGINT:C221(<>aQty_OH; 0)
	ARRAY LONGINT:C221(<>aQty_PAYUSE; 0)
	ARRAY TEXT:C222(<>aFGKey; $numBins)
	ARRAY LONGINT:C221(<>aQty_CC; $numBins)
	ARRAY LONGINT:C221(<>aQty_FG; $numBins)
	ARRAY LONGINT:C221(<>aQty_EX; $numBins)
	ARRAY LONGINT:C221(<>aQty_BH; $numBins)
	ARRAY LONGINT:C221(<>aQty_OH; $numBins)
	ARRAY LONGINT:C221(<>aQty_PAYUSE; $numBins)
	$binCursor:=0  //track the use of above arrays
	//*Tally the inventory bins
	// uThermoInit ($numBins;"Batch Inventory Roll-up")`•1/31/97 rmoved
	For ($i; 1; $numBins)
		//*     Set up a bucket  
		If (<>aFGKey{$binCursor}#$aFGKey{$i})  //($aCust{$i}+":"+$aCPN{$i}))
			$binCursor:=$binCursor+1
			<>aFGKey{$binCursor}:=$aFGKey{$i}
			$numFG:=qryFinishedGood("#key"; <>aFGKey{$binCursor})
			If ($numFG>0)
				<>aQty_BH{$binCursor}:=[Finished_Goods:26]Bill_and_Hold_Qty:108
				<>aQty_OH{$binCursor}:=<>aQty_OH{$binCursor}-<>aQty_BH{$binCursor}  //start with negative if BH
			Else 
				<>aQty_BH{$binCursor}:=0
			End if 
		End if 
		//*    Tally based on bin type  
		$binType:=Substring:C12($aBin{$i}; 1; 2)  //$aBin{$i}≤1≥+$aBin{$i}≤2≥
		Case of 
			: ($binType="FG")  // | ($binType="FX")
				// Modified by: Mel Bohince (8/18/17) 
				Case of 
					: (Position:C15("hold"; $aBin{$i})>0)  // Modified by: Mel Bohince (4/11/18) 
						<>aQty_EX{$binCursor}:=<>aQty_EX{$binCursor}+$aQtyOH{$i}
						
					: (Position:C15("ship"; $aBin{$i})>0) & ($fgShippedIsExamining_b)  // Modified by: Mel Bohince (3/26/21) 
						<>aQty_EX{$binCursor}:=<>aQty_EX{$binCursor}+$aQtyOH{$i}
						
					: (Position:C15("lost"; $aBin{$i})>0)  //maybe expressed as LO:VST, picked up in the else below
						<>aQty_EX{$binCursor}:=<>aQty_EX{$binCursor}+$aQtyOH{$i}
						
					Else 
						<>aQty_FG{$binCursor}:=<>aQty_FG{$binCursor}+$aQtyOH{$i}
				End case 
				
				<>aQty_OH{$binCursor}:=<>aQty_OH{$binCursor}+$aQtyOH{$i}
				
				If (Substring:C12($aBin{$i}; 4; 2)="AV")
					<>aQty_PAYUSE{$binCursor}:=<>aQty_PAYUSE{$binCursor}+$aQtyOH{$i}
				End if 
			: ($binType="CC")
				<>aQty_CC{$binCursor}:=<>aQty_CC{$binCursor}+$aQtyOH{$i}
				<>aQty_OH{$binCursor}:=<>aQty_OH{$binCursor}+$aQtyOH{$i}
			: ($binType="XC")
				<>aQty_CC{$binCursor}:=<>aQty_CC{$binCursor}+$aQtyOH{$i}
				<>aQty_OH{$binCursor}:=<>aQty_OH{$binCursor}+$aQtyOH{$i}
				//: ($binType="BH")
				//◊aQty_BH{$binCursor}:=◊aQty_BH{$binCursor}+$aQtyOH{$i}
			Else   //treat as examining, LO:VST for instance
				<>aQty_EX{$binCursor}:=<>aQty_EX{$binCursor}+$aQtyOH{$i}
				<>aQty_OH{$binCursor}:=<>aQty_OH{$binCursor}+$aQtyOH{$i}
		End case 
		
		//uThermoUpdate ($i) `•1/31/97 removed
	End for 
	//    uThermoClose `•1/31/97 removed
	//*Shrink arrays to fit
	ARRAY TEXT:C222(<>aFGKey; $binCursor)
	ARRAY LONGINT:C221(<>aQty_CC; $binCursor)
	ARRAY LONGINT:C221(<>aQty_FG; $binCursor)
	ARRAY LONGINT:C221(<>aQty_EX; $binCursor)
	ARRAY LONGINT:C221(<>aQty_BH; $binCursor)
	ARRAY LONGINT:C221(<>aQty_OH; $binCursor)
	ARRAY LONGINT:C221(<>aQty_PAYUSE; $binCursor)
	//$timer:=Current time-$timer
	<>InvCalcDone:=True:C214
	<>FgBatchDat:=Current date:C33
End if 

//Else   //•1/29/97 make sure completed flag is set on
//<>InvCalcDone:=True
//End if 