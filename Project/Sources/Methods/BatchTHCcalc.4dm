//%attributes = {"publishedWeb":true}
//Procedure: BatchTHCcalc()  052096  MLB
//calculate forward quantities available for release
//based on inventory, production and prior releases.
//This should be able to do a Regen as well as a Net change
//Qty@tn=Qty@t0-Sum(Rel'd Qty)+Sum(Pln'd Qty)
//where Sums are from t0 to tn-1
//MESSAGES OFF
//•1/27/97 - allow acceptance of an optional parameter to suppress printing/saving
//  data, allows this routine to be used to populate the interproc arrays for
// other reports
//  also skip this routine if it has already run for the day
//•022497  MLB  sort by arrays
//•022597  MLB  make date sortable
//• 5/7/97 cs  removed alert at Jim's request
//•012898  MLB  make 1 = some inventory in exam
//•021699  MLB  force date to show century
//•091212  MLB  ignore PnG firms per Kris, due to the way the Portal works
// Added by: Mark Zinke (11/14/12) All user interface items removed so we can
//  run this on the server.
// Modified by: Mel Bohince (1/29/14) change to only firm and buffer and cayey
// Modified by: Mel Bohince (2/18/15) revert PnG to be like all other customers
// Modified by: Mel Bohince (2/19/15) undo last, PnG frcst only, everything for other customers
// Modified by: Mel Bohince (3/3/15) make sure any firm PnG are disqualified
// Modified by: Mel Bohince (8/18/17) dont include FG: Hold, Lost, Shipped as available inventory
// Modified by: Mel Bohince (3/26/21) Do include Shipped as available inventory, to support ASN process requiring inventory, see BatchFGinventor

utl_Logfile("thc.log"; "THC BATCH CALC STARTED ******************")
C_TEXT:C284($1)
//C_TEXT($TB;$CR)
//ARRAY TEXT($aText;0)
//$TB:=Char(9)
//$CR:=Char(13)

C_TIME:C306($duration)
C_LONGINT:C283($i; $numRels; $binCursor; $prior; $jobCursor; $needed; $page; $id)
C_BOOLEAN:C305($allStock; $hasStock; $hasMfg; $relCovered; <>InvCalcDone; <>JobCalcDone; $someExam)
C_TEXT:C284($currentCPN)
//C_TEXT($t;$cr)
C_DATE:C307($today)

$today:=4D_Current_date
$duration:=Current time:C178
//$page:=1
//ARRAY TEXT($aText;$page)

//see THC_decode
//$aText{$page}:="0 = met w/ finished goods"+$CR
//$aText{$page}:=$aText{$page}+"1 = met w/ F/G and Exam and CC"+$CR
//$aText{$page}:=$aText{$page}+"2 = met w/ Inventory & WIP"+$CR
//$aText{$page}:=$aText{$page}+"3 = met w/ WIP"+$CR
//$aText{$page}:=$aText{$page}+"4 = not met w/ Inventory & WIP"+$CR
//$aText{$page}:=$aText{$page}+"5 = not met w/ WIP (short)"+$CR
//  //$aText{$page}:=$aText{$page}+"6 = met w/  Mfg, no stock (art & oks?)"+$CR
//$aText{$page}:=$aText{$page}+"7 = not met not Planned, Inventory Short"+$CR
//$aText{$page}:=$aText{$page}+"8 = not met not Planned"+$CR
//$aText{$page}:=$aText{$page}+"9 = not analyzed"+$CR+$CR
//$aText{$page}:=$aText{$page}+"Rel No"+$TB+"Cust No"+$TB+"CPN"+$TB+"SchDate"+$TB+"SchQty"+$TB+"AvailQty"+$TB+"State"+$CR

//*Load the on-hand inventory in arrays.
<>InvCalcDone:=False:C215
$id:=New process:C317("BatchFGinventor"; 128000; "BatchFGinventor")
<>JobCalcDone:=False:C215
$id:=New process:C317("BatchJobcalc"; <>lMinMemPart; "BatchJobCalc")

Rel_ReleasesOnCloseOrders

READ WRITE:C146([Customers_ReleaseSchedules:46])
If (True:C214)
	//•021915  MLB  ignore PnG firms per Kris, due to the way the Portal works, frcst remain until receipt
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="01666"; *)  //cayeay
		QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10="02439"; *)  //brown summit
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //open
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31=0; *)  //not payuse
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3="<@")  //only forecasts
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "PnG_Releases")
		
		// this is all other customers
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //open
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31=0; *)  // payuse releases do not consume inventory, just move it.
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"01666"; *)  //no Cayey
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"02439")  //no Brown Summit
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "All_custs_Releases")
		//
		UNION:C120("PnG_Releases"; "All_custs_Releases"; "All_custs_Releases")
		USE SET:C118("All_custs_Releases")
		CLEAR SET:C117("PnG_Releases")
		CLEAR SET:C117("All_custs_Releases")
		
	Else 
		QUERY BY FORMULA:C48([Customers_ReleaseSchedules:46]; \
			(\
			([Customers_ReleaseSchedules:46]Shipto:10="01666")\
			 | ([Customers_ReleaseSchedules:46]Shipto:10="02439")\
			 & ([Customers_ReleaseSchedules:46]OpenQty:16>0)\
			 & ([Customers_ReleaseSchedules:46]PayU:31=0)\
			 & ([Customers_ReleaseSchedules:46]CustomerRefer:3="<@")\
			)\
			 | \
			(\
			([Customers_ReleaseSchedules:46]OpenQty:16>0)\
			 & ([Customers_ReleaseSchedules:46]PayU:31=0)\
			 & ([Customers_ReleaseSchedules:46]Shipto:10#"01666")\
			 & ([Customers_ReleaseSchedules:46]Shipto:10#"02439")\
			)\
			)
		
	End if   // END 4D Professional Services : January 2019 
	
	
	//•091212  MLB  ignore PnG firms per Kris, due to the way the Portal works
	//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]OpenQty>0;*)  //open
	//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]PayU=0;*)  //not payuse
	//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]CustID="00199";*)  //only png
	//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]CustomerRefer="<@")  //only forecasts
	//CREATE SET([Customers_ReleaseSchedules];"PnG_Releases")
	
	// Modified by: Mel Bohince (1/29/14) change to only firm and buffer and cayey
	//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]CustomerRefer#"<f@";*)  //firm and buffers
	//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]OpenQty>0;*)  //open
	//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]PayU=0;*)  //not payuse
	//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]CustID="00199")  //only PnG
	//CREATE SET([Customers_ReleaseSchedules];"PnG_Releases")
	
	// this is all other customers
	//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]OpenQty>0;*)  //open
	//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]PayU=0;*)  // payuse releases do not consume inventory, just move it.
	//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]CustID#"00199")  //no PnG
	//CREATE SET([Customers_ReleaseSchedules];"All_custs_Releases")
	
Else   // used one day only, cause PnG doesn't remove frcst until shipment is received, there by doubling demand if firm+frcst is used
	//Modified by: Mel Bohince (2/18/15) revert PnG to be like all other customers
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //open
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31=0)  // payuse releases do not consume inventory, just move it.
End if 

ARRAY LONGINT:C221($RelRecNo; 0)
ARRAY LONGINT:C221($aRelid; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aCust; 0)
ARRAY DATE:C224($aDate; 0)
SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; $RelRecNo; [Customers_ReleaseSchedules:46]CustID:12; $aCust; [Customers_ReleaseSchedules:46]ProductCode:11; $aCPN; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aQty; [Customers_ReleaseSchedules:46]Sched_Date:5; $aDate; [Customers_ReleaseSchedules:46]ReleaseNumber:1; $aRelid)
uClearSelection(->[Customers_ReleaseSchedules:46])
$numRels:=Size of array:C274($aCust)

ARRAY TEXT:C222($sortKey; $numRels)  //•022497  MLB  sort by array
For ($i; 1; $numRels)  //•022497  MLB  sort by array
	$sortKey{$i}:=$aCust{$i}+":"+$aCPN{$i}+":"+fYYMMDD($aDate{$i}; 4)  //•022597  MLB  make date sortable`•021699  MLB  force date to show century
End for 
SORT ARRAY:C229($sortKey; $RelRecNo; $aCust; $aCPN; $aQty; $aDate; $aRelid; >)  //•022497  MLB  sort by array
ARRAY TEXT:C222($sortKey; 0)  //•022497  MLB  sort by array

ARRAY LONGINT:C221($aAvail; $numRels)
ARRAY LONGINT:C221($aState; $numRels)

$binCursor:=0
$jobCursor:=0
$currentCPN:=""

//*Wait till jobs and inventory are calculated
utl_Logfile("thc.log"; "THC BATCH CALC WAITING WIP & INV CALC ******************")
Repeat 
	DELAY PROCESS:C323(Current process:C322; 180)
Until (<>JobCalcDone & <>InvCalcDone)
utl_Logfile("thc.log"; "THC BATCH CALC PROCEEDING ******************")

For ($i; 1; $numRels)
	$hasStock:=False:C215
	$aAvail{$i}:=0
	$aState{$i}:=8
	If ($currentCPN#($aCust{$i}+":"+$aCPN{$i}))
		$prior:=0
		$currentCPN:=($aCust{$i}+":"+$aCPN{$i})
	Else 
		$prior:=$prior+1
	End if 
	
	$required:=$aQty{$i}
	//*Get the on-hand inventory.
	If (<>aFGKey{$binCursor}#$currentCPN)
		$binCursor:=Find in array:C230(<>aFGKey; $currentCPN)
	End if 
	
	If ($binCursor>0)
		$required:=RM_ConsumeBin(-><>aQty_FG{$binCursor}; $aQty{$i})
		If ($required=0)  //all
			$aState{$i}:=0  //all onhand
			
		Else 
			$required:=RM_ConsumeBin(-><>aQty_CC{$binCursor}; $required)
			$required:=RM_ConsumeBin(-><>aQty_EX{$binCursor}; $required)
			If ($required=0)  //were satisfied
				$aState{$i}:=1  //enough in onhand + qa
				
			Else   //will need to look in wip
				If ($required#$aQty{$i})
					$hasStock:=True:C214
				End if 
			End if   //enuff in qa
		End if   //enuff onhand      
	Else   //no bins ever    
		$binCursor:=0
	End if 
	
	If ($required>0)  //look for wip
		If (<>aJMIKey{$jobCursor}#$currentCPN)
			$jobCursor:=Find in array:C230(<>aJMIKey; $currentCPN)
		End if 
		If ($jobCursor>0)
			Case of 
				: (<>aQty_JMI{$jobCursor}>=$required)
					<>aQty_JMI{$jobCursor}:=<>aQty_JMI{$jobCursor}-$required
					$required:=0
					If ($hasStock)
						$aState{$i}:=2
					Else 
						$aState{$i}:=3
					End if 
					
				: (<>aQty_JMI{$jobCursor}>0)
					$required:=$required-<>aQty_JMI{$jobCursor}
					<>aQty_JMI{$jobCursor}:=0
					If ($hasStock)
						$aState{$i}:=4
					Else 
						$aState{$i}:=5
					End if 
					
				Else 
					If ($hasStock)
						$aState{$i}:=7
					Else 
						$aState{$i}:=8
					End if 
			End case 
			
		Else   //no planned production
			$jobCursor:=0
			If ($hasStock)
				$aState{$i}:=7
			Else 
				$aState{$i}:=8
			End if 
		End if   //planned production            
	End if   //wip required
	
	$aAvail{$i}:=$required
	
	//If (Length($aText{$page})>30000)
	//$page:=$page+1
	//ARRAY TEXT($aText;$page)
	//End if 
	//$aText{$page}:=$aText{$page}+String($aRelid{$i})+$TB+$aCust{$i}+$TB+$aCPN{$i}+$TB+String($aDate{$i};<>MIDDATE)+$TB+String($aQty{$i})+$TB+String($aAvail{$i})+$TB+String($aState{$i})+$CR
	
End for 

//$aText{$page}:=$aText{$page}+"•••• END OF REPORT ••••"+$CR
//zwStatusMsg ("SAVING";"THC to ReleaseSchedule records"

//* save to table
For ($i; 1; $numRels)
	GOTO RECORD:C242([Customers_ReleaseSchedules:46]; $RelRecNo{$i})
	[Customers_ReleaseSchedules:46]THC_Qty:37:=$aAvail{$i}
	[Customers_ReleaseSchedules:46]THC_State:39:=$aState{$i}
	[Customers_ReleaseSchedules:46]THC_Date:38:=$today
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])
End for 

//* reset flag on closed & payuse releases to negative so they don't display on layouts
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16<=0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#-1)
$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
ARRAY LONGINT:C221($aState; 0)
ARRAY LONGINT:C221($aState; $numRels)
For ($i; 1; $numRels)
	$aState{$i}:=-1
End for 
MESSAGE:C88(Char:C90(13)+"Resetting shipped releases")
ARRAY TO SELECTION:C261($aState; [Customers_ReleaseSchedules:46]THC_State:39)

//MESSAGE("Locating payuse releases")
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31#0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#-2)
$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
ARRAY LONGINT:C221($aState; 0)
ARRAY LONGINT:C221($aState; $numRels)
For ($i; 1; $numRels)
	$aState{$i}:=-2
End for 
//ARRAY TO SELECTION($aState;[Customers_ReleaseSchedules]THC_State)

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="01666"; *)  //cayeay
QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10="02439"; *)  //brown summit
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //open
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31=0; *)  //not payuse
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")  //firms
$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
ARRAY LONGINT:C221($aState; 0)
ARRAY LONGINT:C221($aState; $numRels)
For ($i; 1; $numRels)
	$aState{$i}:=-3
End for 
ARRAY TO SELECTION:C261($aState; [Customers_ReleaseSchedules:46]THC_State:39)


ARRAY LONGINT:C221($RelRecNo; 0)
ARRAY LONGINT:C221($aRelid; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY LONGINT:C221($aAvail; 0)
ARRAY LONGINT:C221($aState; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aCust; 0)
ARRAY DATE:C224($aDate; 0)



//*Write results to a text file
//If (Count parameters=0)  //• 1/27/97 if there is a parameter suppress saving report data
//GOTO XY(1;6)

//C_TEXT(docName)
//C_TEXT($tContents)  // Added by: Mark Zinke (11/14/12) We're going to write this to a textvar and send that back to the client.
//  //***TODO mark's code will overflow $tContent

//docName:="TimeHorizonCalc-"+fYYMMDD ($today)+".xls"
//$tContents:=docName+$CR+$CR
//For ($i;1;Size of array($aText))
//$tContents:=$tContents+$aText{$i}
//End for 
//$tContents:=$tContents+$CR+$CR+"------ END OF FILE ------"
//EXECUTE ON CLIENT("BatchTHCCalc";"BatchTHCCalcExcel";$tContents)  // Added by: Mark Zinke (11/14/12)

//End if   //∂1/27/97 end suppress report

//*Clean up
//ARRAY TEXT($aText;0)
<>FgBatchDat:=!00-00-00!
<>JobBatchDat:=!00-00-00!
BatchFGinventor(0)
BatchJobcalc(0)
<>ThcBatchDat:=!00-00-00!  //Current date
<>ThcBatchDon:=False:C215

//see THC_request_update called by jmi trigger
READ WRITE:C146([Finished_Goods:26])
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]THC_update_required:115=True:C214)  // reset, just did the whole batch
If (Records in selection:C76([Finished_Goods:26])>0)
	APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]THC_update_required:115:=False:C215)
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
End if 

utl_Logfile("thc.log"; "THC BATCH CALC FINISHED ******************")