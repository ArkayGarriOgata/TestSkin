//%attributes = {"publishedWeb":true}
//PM:  RM_AllocationRpt {Commodity_Key};{Raw_Matl_Code})  082402  mlb
//formerly  `(P) mRptRMAlloc: Raw MAterial Allocation Report
//upr 73
//upr1206 9/6/94
//upr 1256 10/13/94
//upr 1342 12/5/94
//•031897  MLB  major overhaul
//061407 tag items have inventory over 90 days
// Modified by: Mel Bohince (2/13/15) allow for multiple releases on blanket POs
// Modified by: MelvinBohince (2/23/22) chg ARRAY REAL($aAlloc;0) ARRAY REAL($aIssued;0) to real

C_TEXT:C284($1; $2)
C_TEXT:C284($JobOrPOnum)
C_TEXT:C284($activity)
C_TEXT:C284($uom)
C_LONGINT:C283($i; $j; $allocation; $poitem; $numAllocs; $numPOs; $hitBin; $newSize; $hitPO; $hitAL; $line; $maxLines; $element)
C_LONGINT:C283($OpenPurch; $OnHandInv; $TotPurch; $TotAlloc; $OpenAlloc)
C_TEXT:C284(tText)
C_TEXT:C284($blankLine; $solidLine; $formatLine; $deepSix)
C_DATE:C307(dDate; $EventDate; $dateLimit)
C_TIME:C306(tTime)
C_BOOLEAN:C305($print; $continue; $showPOI)

$blankLine:=(" "*120)+Char:C90(13)
$solidLine:=("_"*120)+Char:C90(13)
$bottomLine:=(" "*63)+("="*55)+Char:C90(13)
$deepSix:="Z"*20  //drop it to the bottom of the sort
$showPOI:=False:C215  // turn it on w/ chkbx in dialog below
$continue:=True:C214

util_PAGE_SETUP(->[Raw_Materials:21]; "RMAllocHdr2")  //[JobMasterLog]

Case of 
	: (Count parameters:C259=1)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2=$1)
		$dateLimit:=!00-00-00!
		
	: (Count parameters:C259=2)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$2)
		$dateLimit:=!00-00-00!
		
	Else 
		SET PRINT OPTION:C733(Orientation option:K47:2; 2)  // Modified by: Mel Bohince (10/11/18) 
		PRINT SETTINGS:C106
		If (OK=1)
			$continue:=True:C214
			$dateLimit:=!00-00-00!
			//*Offer to specify R|Ms of interest
			CenterWindow(290; 230; Modal dialog box:K34:2; "Print Selection")  // Added by: Mark Zinke (9/26/13) Replaces CONFIRM
			DIALOG:C40([Raw_Materials:21]; "RMSelection")
			CLOSE WINDOW:C154
			
			If (bOK=1)  // Added by: Mark Zinke (9/26/13)
				Case of 
					: (rbBoard=1)
						QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2="01@"; *)  //Board
						QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="20@")  // Modified by: Mel Bohince (5/25/16) include plastic substrate
						xReptTitle:="B&P Allocation/Procurement Report"
						
					: (rbSensors=1)
						QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2="12@")  //Sensors
						xReptTitle:="Sensor Allocation/Procurement Report"
						
					: (rbColdFoil=1)
						RM_ColdFoilQuery  // Added by: Mark Zinke (1/23/14) Replaced line below  //Cold Foil
						//QUERY([Raw_Materials];[Raw_Materials]Commodity_Key="09@")
						xReptTitle:="ColdFoil Allocation/Procurement Report"
				End case 
				
				If (cb1=1)  // Added by: Mark Zinke (2/3/14) 
					$showPOI:=True:C214
				Else 
					$showPOI:=False:C215
				End if 
				
				$convert:=(cb2=1)  // Modified by: Mel Bohince (2/14/17) change LF of allocation to Sht* if rm is in sheets
				
			Else 
				$continue:=False:C215
			End if 
			
		End if 
End case 

If ($continue)
	SET WINDOW TITLE:C213("Allocation Report - Press ESCape to cancel")  //upr 1342 12/5/94
	If (Records in selection:C76([Raw_Materials:21])>0)
		<>fContinue:=True:C214  //upr 1342 12/5/94
		ON EVENT CALL:C190("eCancelPrint")  //upr 1342 12/5/94
		If (False:C215)
			eCancelPrint
		End if 
		//*Set up the header of the report
		MESSAGES OFF:C175
		
		$OpenPurch:=0
		$OpenAlloc:=0
		$OnHandInv:=0
		$TotPurch:=0
		$TotAlloc:=0
		
		//----------SET UP MAIN HEADER----------
		//xReptTitle:="B&P Allocation/Procurement Report"
		xComment:="Sorted by R/M code, then by Event Date."
		xComment:=xComment+Char:C90(13)+"Note: A bullet(•) indicates no receipts/issues for that line."
		If ($dateLimit#!00-00-00!)
			xComment:=xComment+Char:C90(13)+"Report is of PO's and Allocations through "+String:C10($dateLimit; 1)+"."
		End if 
		//xComment:=xComment+Char(13)+"This report will only print Commodity '1' materials."
		dDate:=4D_Current_date
		tTime:=4d_Current_time
		
		//*Get the corrisponding bins, POs, and allocations
		
		//*Load the R|M's into arrays
		ARRAY TEXT:C222($aRMcode; 0)
		ARRAY TEXT:C222($aRMdesc; 0)
		ARRAY TEXT:C222($aRMuom; 0)  // Modified by: Mel Bohince (2/14/17) 
		SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; $aRMcode; [Raw_Materials:21]Description:4; $aRMdesc; [Raw_Materials:21]IssueUOM:10; $aRMuom)
		SORT ARRAY:C229($aRMcode; $aRMdesc; $aRMuom; >)
		
		//*Load Bins into arrays
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Raw_Materials_Locations:25]Raw_Matl_Code:1; ->[Raw_Materials:21]Raw_Matl_Code:1; 1)
			
			
		Else 
			
			
			If (Records in selection:C76([Raw_Materials:21])>0)
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Raw_Materials_Locations:25])+" file. Please Wait...")
				RELATE MANY SELECTION:C340([Raw_Materials_Locations:25]Raw_Matl_Code:1)
				zwStatusMsg(""; "")
			End if 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		ARRAY TEXT:C222($aBINcode; 0)
		ARRAY REAL:C219($aQty; 0)
		ARRAY TEXT:C222($aBinPO; 0)
		ARRAY TEXT:C222($aBinLoc; 0)
		SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Raw_Matl_Code:1; $aBINcode; [Raw_Materials_Locations:25]QtyOH:9; $aQty; [Raw_Materials_Locations:25]POItemKey:19; $aBinPO; [Raw_Materials_Locations:25]Location:2; $aBinLoc)
		REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
		SORT ARRAY:C229($aBINcode; $aQty; $aBinPO; $aBinLoc; >)
		//*add the vendor
		ARRAY TEXT:C222($aBINvend; Size of array:C274($aBinPO))
		SET QUERY LIMIT:C395(1)
		For ($i; 1; Size of array:C274($aBinPO))
			$aBINvend{$i}:=Vend_getPrefixInitials($aBinPO{$i})
		End for 
		SET QUERY LIMIT:C395(0)
		
		//*Load Allocations into arrays
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Raw_Materials_Allocations:58]Raw_Matl_Code:1; ->[Raw_Materials:21]Raw_Matl_Code:1; 1)
			
		Else 
			If (Records in selection:C76([Raw_Materials:21])>0)
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Raw_Materials_Allocations:58])+" file. Please Wait...")
				RELATE MANY SELECTION:C340([Raw_Materials_Allocations:58]Raw_Matl_Code:1)
				zwStatusMsg(""; "")
			End if 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		If ($dateLimit#!00-00-00!)
			QUERY SELECTION:C341([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Date_Allocated:5<=$dateLimit)
		End if 
		ARRAY TEXT:C222($aALcode; 0)
		ARRAY TEXT:C222($aJF; 0)
		ARRAY REAL:C219($aAlloc; 0)  // Modified by: MelvinBohince (2/23/22) 
		ARRAY REAL:C219($aIssued; 0)  // Modified by: MelvinBohince (2/23/22) 
		ARRAY DATE:C224($aDateAlloc; 0)
		ARRAY TEXT:C222($aUOM; 0)
		SELECTION TO ARRAY:C260([Raw_Materials_Allocations:58]Raw_Matl_Code:1; $aALcode; [Raw_Materials_Allocations:58]JobForm:3; $aJF; [Raw_Materials_Allocations:58]Qty_Allocated:4; $aAlloc; [Raw_Materials_Allocations:58]Qty_Issued:6; $aIssued; [Raw_Materials_Allocations:58]Date_Allocated:5; $aDateAlloc; [Raw_Materials_Allocations:58]UOM:11; $aUOM)
		// hide the allocation that have been fully issued
		For ($i; 1; Size of array:C274($aALcode))
			If (($aAlloc{$i}-$aIssued{$i})<=0)  //already fully issued
				$aALcode{$i}:=$deepSix  //move to bottom of the sort
			End if 
		End for 
		SORT ARRAY:C229($aALcode; $aDateAlloc; $aJF; $aAlloc; $aIssued; $aUOM; >)
		
		//*Load Jobform into arrays
		READ ONLY:C145([Job_Forms_Master_Schedule:67])
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Job_Forms_Master_Schedule:67]JobForm:4; ->[Raw_Materials_Allocations:58]JobForm:3; 1)
			
		Else 
			
			If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
				ARRAY TEXT:C222($_JobForm; 0)
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Master_Schedule:67])+" file. Please Wait...")
				DISTINCT VALUES:C339([Raw_Materials_Allocations:58]JobForm:3; $_JobForm)
				QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]JobForm:4; $_JobForm)
				zwStatusMsg(""; "")
			End if 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		REDUCE SELECTION:C351([Raw_Materials_Allocations:58]; 0)
		ARRAY TEXT:C222($aJMIform; 0)
		ARRAY TEXT:C222($aMFGat; 0)
		ARRAY TEXT:C222($aCustName; 0)
		ARRAY TEXT:C222($aCustLine; 0)
		SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJMIform; [Job_Forms_Master_Schedule:67]LocationOfMfg:30; $aMFGat; [Job_Forms_Master_Schedule:67]Customer:2; $aCustName; [Job_Forms_Master_Schedule:67]Line:5; $aCustLine)
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		
		//*Load POitems into arrays
		If ($showPOI)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				uRelateSelect(->[Purchase_Orders_Items:12]Raw_Matl_Code:15; ->[Raw_Materials:21]Raw_Matl_Code:1; 1)
				QUERY SELECTION:C341([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Qty_Open:27>0; *)
				
				
			Else 
				
				If (Records in selection:C76([Raw_Materials:21])>0)
					zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Purchase_Orders_Items:12])+" file. Please Wait...")
					RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]Raw_Matl_Code:15)
					QUERY SELECTION:C341([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Qty_Open:27>0; *)
					zwStatusMsg(""; "")
				End if 
				
			End if   // END 4D Professional Services : January 2019 query selection
			If ($dateLimit#!00-00-00!)
				QUERY SELECTION:C341([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]ReqdDate:8<=$dateLimit)  //[PO_Items]PromiseDate
			Else 
				QUERY SELECTION:C341([Purchase_Orders_Items:12])
			End if 
		Else   //dont show poi
			REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
		End if 
		ARRAY TEXT:C222($aPOcode; 0)
		ARRAY TEXT:C222($aPOitem; 0)  // Modified by: Mel Bohince (2/13/15) allow room for 3digit release
		ARRAY REAL:C219($aPOQty; 0)
		ARRAY REAL:C219($aNum; 0)
		ARRAY REAL:C219($aDenom; 0)
		ARRAY REAL:C219($aQtyRec; 0)
		ARRAY DATE:C224($aDateProm; 0)
		SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Raw_Matl_Code:15; $aPOcode; [Purchase_Orders_Items:12]POItemKey:1; $aPOitem; [Purchase_Orders_Items:12]Qty_Open:27; $aPOQty; [Purchase_Orders_Items:12]FactNship2cost:29; $aNum; [Purchase_Orders_Items:12]FactDship2cost:37; $aDenom; [Purchase_Orders_Items:12]Qty_Received:14; $aQtyRec; [Purchase_Orders_Items:12]ReqdDate:8; $aDateProm)  //[PO_ITEMS]ReqdDate
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
		SORT ARRAY:C229($aPOcode; $aDateProm; $aPOitem; $aPOQty; $aNum; $aDenom; $aQtyRec; >)
		
		// Modified by: Mel Bohince (2/13/15) 
		// if a po has releases, substitute that tuple for the single po so old code still works
		QUERY WITH ARRAY:C644([Purchase_Orders_Releases:79]POitemKey:1; $aPOitem)
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]Actual_Qty:6=0)
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		If (Records in selection:C76([Purchase_Orders_Releases:79])>0)
			ARRAY TEXT:C222($aPRpoi; 0)
			ARRAY TEXT:C222($aPRrel; 0)
			ARRAY DATE:C224($aPRschd; 0)
			ARRAY LONGINT:C221($aPRqty; 0)
			ARRAY LONGINT:C221($aPRQtyRec; 0)
			SELECTION TO ARRAY:C260([Purchase_Orders_Releases:79]POitemKey:1; $aPRpoi; [Purchase_Orders_Releases:79]RelNumber:4; $aPRrel; [Purchase_Orders_Releases:79]Schd_Date:3; $aPRschd; [Purchase_Orders_Releases:79]Schd_Qty:2; $aPRqty; [Purchase_Orders_Releases:79]Actual_Qty:6; $aPRQtyRec)
			MULTI SORT ARRAY:C718($aPRpoi; >; $aPRschd; >; $aPRrel; $aPRqty; $aPRQtyRec)
			$releaseNum:=1
			While ($releaseNum<=Size of array:C274($aPRpoi))
				$POindex:=Find in array:C230($aPOitem; $aPRpoi{$releaseNum})
				
				If ($POindex>-1)  //copy it and tag it
					$aDateProm{$POindex}:=<>MAGIC_DATE  // make it sink to bottom
					$aPOQty{$POindex}:=$aPOQty{$POindex}-$aPRqty{$releaseNum}
					APPEND TO ARRAY:C911($aPOcode; $aPOcode{$POindex})
					APPEND TO ARRAY:C911($aPOitem; $aPOitem{$POindex}+"."+$aPRrel{$releaseNum})  // Modified by: Mel Bohince (2/13/15) allow room for 3digit release
					APPEND TO ARRAY:C911($aPOQty; $aPRqty{$releaseNum})
					APPEND TO ARRAY:C911($aNum; 1)
					APPEND TO ARRAY:C911($aDenom; 1)
					APPEND TO ARRAY:C911($aQtyRec; $aPRQtyRec{$releaseNum})
					APPEND TO ARRAY:C911($aDateProm; $aPRschd{$releaseNum})
				End if 
				
				
				$releaseNum:=1+$releaseNum
			End while 
			
		End if 
		// end 2/13/15 modify
		
		REDUCE SELECTION:C351([Raw_Materials:21]; 0)
		$line:=100  //force a new page
		iPage:=0
		///////////////////
		///////////////////For each rm item that was interesting to the base query
		uThermoInit(Size of array:C274($aRMcode); "Analyzing Allocations")
		For ($i; 1; Size of array:C274($aRMcode))  //*For each selected R|M
			uThermoUpdate($i)
			If ($aRMcode{$i}="12pt APET22.25")
				
			End if 
			
			$hitBin:=Find in array:C230($aBINcode; $aRMcode{$i})  //*   is there any inventory
			$element:=0  //don't include mill inventory
			$vend:=""
			$onhandRoan:=0
			$onhandHaup:=0
			$onhandVist:=0  //• mlb - 1/24/03  14:44
			$onhandMill:=0
			$onhandOutside:=0
			//Location tally
			While ($hitBin>0)
				Case of 
					: ($aBinLoc{$hitBin}="Roanoke")
						$onhandRoan:=$onhandRoan+$aQty{$hitBin}
						$element:=$element+$aQty{$hitBin}
					: ($aBinLoc{$hitBin}="Vista")
						$onhandVist:=$onhandVist+$aQty{$hitBin}
						$element:=$element+$aQty{$hitBin}
					: ($aBinLoc{$hitBin}="FG@")  //for corrugate in fg bins
						$onhandVist:=$onhandVist+$aQty{$hitBin}
						$element:=$element+$aQty{$hitBin}
					: ($aBinLoc{$hitBin}="Hauppauge")
						$onhandHaup:=$onhandHaup+$aQty{$hitBin}
						$element:=$element+$aQty{$hitBin}
					: ($aBinLoc{$hitBin}="SheetingVendor")
						$onhandOutside:=$onhandOutside+$aQty{$hitBin}
						$element:=$element+$aQty{$hitBin}
					Else 
						$onhandMill:=$onhandMill+$aQty{$hitBin}
				End case 
				If (Position:C15($aBINvend{$hitBin}; $vend)=0)
					$vend:=$vend+$aBINvend{$hitBin}+" "
				End if 
				$hitBin:=Find in array:C230($aBINcode; $aRMcode{$i}; ($hitBin+1))
			End while 
			$OnHandInv:=$element
			
			//*   Declare sort array indexes
			//the four arrays below are used to sort the event dates, the "key" date
			//is loaded into an array and its element number is loaded into the "index" array
			//so that as we walk down those dates the "index" points to the element in the 
			//original arrays 
			ARRAY DATE:C224($aALdateKey; 0)
			ARRAY LONGINT:C221($aALindex; 0)
			ARRAY DATE:C224($aPOdateKey; 0)
			ARRAY LONGINT:C221($aPOindex; 0)
			
			$hitAL:=Find in array:C230($aALcode; $aRMcode{$i})  //are there any allocations
			$hitPO:=Find in array:C230($aPOcode; $aRMcode{$i})  //are there any open POs
			
			If (($OnHandInv>0) | ($hitAL>0) | ($hitPO>0))  //upr 1256
				$formatLine:=$blankLine  //*   Print the RM and its description
				$formatLine:=Change string:C234($formatLine; $aRMcode{$i}; 1)
				$oldShit:=RMB_ageOver90($aRMcode{$i})
				$aRMdesc{$i}:=$vend+" ["+$aRMuom{$i}+"];"+Replace string:C233($aRMdesc{$i}; Char:C90(13); " ")  // Modified by: Mel Bohince (2/13/17) 
				$formatLine:=Change string:C234($formatLine; Substring:C12($aRMdesc{$i}; 1; 48); 23)  //was Substring($aRMdesc{$i};1;82)
				$formatLine:=Change string:C234($formatLine; " Roan= "+String:C10($onhandRoan; "*,***,**0"); 89)
				If ($onhandVist>0)
					$formatLine:=Change string:C234($formatLine; " Vist= "+String:C10($onhandVist; "*,***,**0"); 73)
				End if 
				If ($onhandHaup>0)
					$formatLine:=Change string:C234($formatLine; "   Haup= "+String:C10($onhandHaup; "*,***,**0"); 55)
				End if 
				If ($onhandMill>0)
					$formatLine:=Change string:C234($formatLine; " MILL= "+String:C10($onhandMill; "*,***,**0"); 43)
				End if 
				If ($onhandOutside>0)
					$formatLine:=Change string:C234($formatLine; " SHTV= "+String:C10($onhandOutside; "*,***,**0"); 43)
				End if 
				$formatLine:=Change string:C234($formatLine; " = "+String:C10($OnHandInv; "^^^,^^^,^^0")+$oldShit; 106)  //was 108
				
				//tText:=tText+$solidLine+$formatLine    
				$line:=RM_AllocationRptNewPage($line)
				$line:=RM_AllocationRptPrintLine($line; $solidLine)
				$line:=RM_AllocationRptPrintLine($line; $formatLine)
				
				If ($hitAL>=0)  //*    create sort index by date for allocations      
					While ($hitAL>=0)
						$newSize:=Size of array:C274($aALdateKey)+1
						INSERT IN ARRAY:C227($aALdateKey; $newSize; 1)
						INSERT IN ARRAY:C227($aALindex; $newSize; 1)
						$aALdateKey{$newSize}:=$aDateAlloc{$hitAL}
						$aALindex{$newSize}:=$hitAL
						$hitAL:=Find in array:C230($aALcode; $aRMcode{$i}; ($hitAL+1))
					End while 
					$numAllocs:=Size of array:C274($aALindex)
					SORT ARRAY:C229($aALdateKey; $aALindex; >)  //order them by date
					
				Else 
					$numAllocs:=0
				End if 
				
				If ($hitPO>=0)  //*    create sort index by date for PO items    
					While ($hitPO>=0)
						$newSize:=Size of array:C274($aPOdateKey)+1
						INSERT IN ARRAY:C227($aPOdateKey; $newSize; 1)
						INSERT IN ARRAY:C227($aPOindex; $newSize; 1)
						$aPOdateKey{$newSize}:=$aDateProm{$hitPO}
						$aPOindex{$newSize}:=$hitPO
						$hitPO:=Find in array:C230($aPOcode; $aRMcode{$i}; ($hitPO+1))
					End while 
					$numPOs:=Size of array:C274($aPOindex)
					SORT ARRAY:C229($aPOdateKey; $aPOindex; >)  //order them by date
					
				Else 
					$numPOs:=0
				End if 
				
				$allocation:=1
				$poitem:=1
				$printDetail:=False:C215  //did we print any details
				$TotPurch:=0
				$TotAlloc:=0
				For ($j; 1; ($numAllocs+$numPOs))  //*    For each allocation and PO item
					$print:=False:C215
					$formatLine:=$blankLine
					$activity:=""
					$OpenAlloc:=0
					$OpenPurch:=0
					$EventDate:=!00-00-00!
					$uom:=""
					Case of 
						: (($allocation<=$numAllocs) & ($poitem<=$numPOs))  //both remaining
							$element:=$aPOindex{$poitem}
							If ($aALdateKey{$allocation}>$aPOdateKey{$poitem})
								// If ($aDateAlloc{$allocation}>$aDateProm{$poitem})
								$EventDate:=$aDateProm{$element}  // $element hold the element number in origanl arrays
								$JobOrPOnum:=Substring:C12($aPOitem{$element}; 1; 7)+"."+Substring:C12($aPOitem{$element}; 8; 2)+Substring:C12($aPOitem{$element}; 10)
								If ($aQtyRec{$element}=0)
									$activity:="•"
								End if 
								$OpenPurch:=$aPOQty{$element}*($aNum{$element}/$aDenom{$element})
								$OnHandInv:=$OnHandInv+$OpenPurch
								$TotPurch:=$TotPurch+$OpenPurch
								$print:=True:C214
								$poitem:=$poitem+1  //NEXT RECORD([PO_ITEMS])
								
							Else   //      SORT ARRAY($aDateAlloc;$aJF;$aAlloc;$aIssued;>)
								$element:=$aALindex{$allocation}
								If ($aAlloc{$element}>$aIssued{$element})  //$element
									$EventDate:=$aDateAlloc{$element}
									
									$hitJML:=Find in array:C230($aJMIform; $aJF{$element})
									If ($hitJML>-1)
										$mfg:=Substring:C12($aMFGat{$hitJML}; 1; 5)
										$cust:=Substring:C12($aCustName{$hitJML}; 1; 8)
										$brand:=Substring:C12($aCustLine{$hitJML}; 1; 8)
									Else 
										$mfg:=" "
										$cust:=" "
										$brand:=" "
									End if 
									
									$JobOrPOnum:=$aJF{$element}+" "+$mfg+" "+$cust+" "+$brand
									
									If ($aUOM{$element}#$aRMuom{$i}) & ($convert)
										$uom:="sht*"
										$aAlloc{$element}:=RM_LF_to_SHT($aJF{$element})
									Else 
										$uom:=$aUOM{$element}
									End if 
									
									$OpenAlloc:=$aAlloc{$element}-$aIssued{$element}
									If ($aIssued{$element}=0)
										$activity:="•"
									End if 
									If ($OpenAlloc>0)  // Modified by: Mel Bohince (2/14/17) don't treat over issues as a negative allocation
										$OnHandInv:=$OnHandInv-$OpenAlloc
										$TotAlloc:=$TotAlloc+$OpenAlloc
									End if 
									$print:=True:C214
									
									
								End if 
								
								$allocation:=$allocation+1
							End if 
							
						: ($allocation<=$numAllocs)  // (Not(End selection([RM_Allocations])))
							$element:=$aALindex{$allocation}
							If ($aAlloc{$element}>$aIssued{$element})
								$EventDate:=$aDateAlloc{$element}
								
								$hitJML:=Find in array:C230($aJMIform; $aJF{$element})
								If ($hitJML>-1)
									$mfg:=Substring:C12($aMFGat{$hitJML}; 1; 5)
									$cust:=Substring:C12($aCustName{$hitJML}; 1; 8)
									$brand:=Substring:C12($aCustLine{$hitJML}; 1; 8)
								Else 
									$mfg:=" "
									$cust:=" "
									$brand:=" "
								End if 
								$JobOrPOnum:=$aJF{$element}+" "+$mfg+" "+$cust+" "+$brand
								
								If ($aUOM{$element}#$aRMuom{$i}) & ($convert)
									$uom:="sht*"
									$aAlloc{$element}:=RM_LF_to_SHT($aJF{$element})
								Else 
									$uom:=$aUOM{$element}
								End if 
								$OpenAlloc:=$aAlloc{$element}-$aIssued{$element}
								If ($aIssued{$element}=0)
									$activity:="•"
								End if 
								If ($OpenAlloc>0)  // Modified by: Mel Bohince (2/14/17) don't treat over issues as a negative allocation
									$OnHandInv:=$OnHandInv-$OpenAlloc
									$TotAlloc:=$TotAlloc+$OpenAlloc
								End if 
								$print:=True:C214
							End if 
							
							$allocation:=$allocation+1
							
						: ($poitem<=$numPOs)  // (Not(End selection([PO_ITEMS])))
							$element:=$aPOindex{$poitem}
							$EventDate:=$aDateProm{$element}
							$JobOrPOnum:=Substring:C12($aPOitem{$element}; 1; 7)+"."+Substring:C12($aPOitem{$element}; 8; 2)+Substring:C12($aPOitem{$element}; 10)
							If ($aQtyRec{$element}=0)
								$activity:="•"
							End if 
							$OpenPurch:=$aPOQty{$element}*($aNum{$element}/$aDenom{$element})
							$OnHandInv:=$OnHandInv+$OpenPurch
							$TotPurch:=$TotPurch+$OpenPurch
							$print:=True:C214
							$poitem:=$poitem+1
					End case 
					
					If ($print)  //*       print the event
						$moveRite:=18
						$formatLine:=$blankLine
						//$formatLine:=Change string($formatLine;String($j);13)
						$formatLine:=Change string:C234($formatLine; $activity; 33)
						$formatLine:=Change string:C234($formatLine; String:C10($EventDate; <>MIDDATE); 35)
						$formatLine:=Change string:C234($formatLine; $JobOrPOnum; 47)
						$formatLine:=Change string:C234($formatLine; String:C10($OpenPurch; "^^^,^^^,^^0"); 62+$moveRite)
						$formatLine:=Change string:C234($formatLine; String:C10($OpenAlloc; "^^^,^^^,^^0"); 75+$moveRite)
						$formatLine:=Change string:C234($formatLine; $uom; 87+$moveRite)
						$formatLine:=Change string:C234($formatLine; String:C10($OnHandInv; "^^^,^^^,^^0"); 109)
						$line:=RM_AllocationRptNewPage($line; $aRMcode{$i}+" continued")
						$line:=RM_AllocationRptPrintLine($line; $formatLine)
					End if 
					
				End for   //each event
				
				If ($j>2)  //($printDetail)  `*    print a totals line if there were more than 1 entry
					$line:=RM_AllocationRptNewPage($line; $aRMcode{$i}+" continued")
					$line:=RM_AllocationRptPrintLine($line; $bottomLine)
					$formatLine:=$blankLine
					$formatLine:=Change string:C234($formatLine; "Totals for "+$aRMcode{$i}; 20)
					$formatLine:=Change string:C234($formatLine; String:C10($TotPurch; "^^^,^^^,^^0"); 62+$moveRite)
					$formatLine:=Change string:C234($formatLine; String:C10($TotAlloc; "^^^,^^^,^^0"); 75+$moveRite)
					$formatLine:=Change string:C234($formatLine; String:C10($OnHandInv; "^^^,^^^,^^0"); 109)
					$line:=RM_AllocationRptNewPage($line; $aRMcode{$i}+" continued")
					$line:=RM_AllocationRptPrintLine($line; $formatLine)
				End if 
				
			End if   //upr 1256
			
			If (Not:C34(<>fContinue))
				$i:=$i+Size of array:C274($aRMcode)
			End if 
			
		End for 
		uThermoClose
		PAGE BREAK:C6
		tText:=""
		ARRAY TEXT:C222($aRMcode; 0)
		ARRAY TEXT:C222($aRMdesc; 0)
		ARRAY TEXT:C222($aRMuom; 0)
		ARRAY TEXT:C222($aBINcode; 0)
		ARRAY REAL:C219($aQty; 0)
		ARRAY TEXT:C222($aALcode; 0)
		ARRAY TEXT:C222($aUOM; 0)
		ARRAY TEXT:C222($aJF; 0)
		ARRAY REAL:C219($aAlloc; 0)
		ARRAY REAL:C219($aIssued; 0)
		ARRAY DATE:C224($aDateAlloc; 0)
		ARRAY TEXT:C222($aPOcode; 0)
		ARRAY REAL:C219($aPOQty; 0)
		ARRAY REAL:C219($aNum; 0)
		ARRAY REAL:C219($aDenom; 0)
		ARRAY REAL:C219($aQtyRec; 0)
		ARRAY DATE:C224($aDateProm; 0)
		ARRAY DATE:C224($aALdateKey; 0)
		ARRAY LONGINT:C221($aALindex; 0)
		ARRAY DATE:C224($aPOdateKey; 0)
		ARRAY LONGINT:C221($aPOindex; 0)
		MESSAGES ON:C181
		ON ERR CALL:C155("")  //upr 1342 12/5/94
		
	End if 
End if 