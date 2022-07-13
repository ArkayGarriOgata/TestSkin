//%attributes = {"publishedWeb":true}
//(p) rBasicVenSum called by rnewvensum
//part of a rewrite of the ven sum reports
//this replaces a print selection with a print layout and arrays
//differnt layout formats, changes in displayed units
//• 1/6/98 cs created
//• 2/25/98 cs modified document (to disk) handling, file was not closed
//   also set creator & file type
//• 7/6/98 cs Jim got a runtime error while runnning from MES  `I think that this 
//- BUT I can not replicate
//•100198  MLB  range check error

C_LONGINT:C283($Max; $CurComm; $i; $ToPrint; $Pixels; $NewRptIndex; $Find)
C_LONGINT:C283($ThisDol; $ThisQty; $PrevDol; $PrevQty; $Comm; $Grand; $YrDol; $YrQty)  //indexes into 2 dim arrays
C_TEXT:C284($CurVend)
C_BOOLEAN:C305($Exit)
C_TEXT:C284($File)
ARRAY REAL:C219($aMonth; 2; 4)  //current commodity (this & last) , grand totals
ARRAY REAL:C219($aQuarter; 2; 4)
ARRAY REAL:C219($aYear; 2; 4)
ARRAY REAL:C219($aPrevYear; 2; 2)

$Comm:=1  //commodity subtotal line
$Grand:=2  //grand total line
$ThisDol:=1
$ThisQty:=2
$PrevDol:=3
$PrevQty:=4
$YrDol:=1
$YrQty:=2
$Exit:=False:C215
$Max:=890
$Pixels:=0
$i:=1
$ToPrint:=Size of array:C274(aDate)

If ($ToPrint>0)  //•100198  MLB 
	uClearSelection(->[Raw_Materials_Groups:22])
	$FiscalYrStr:=Month of:C24(fiscalStart)  //[CONTROL]FiscalYearStart  `adjust for fiscal year start month # 1  
	
	util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "VenSum.h")
	PDF_setUp(<>pdfFileName)
	iPage:=1
	
	//* print header
	If (fSave)
		VenSum2Disk("MH")
		uThermoInit($ToPrint; "Printing VenSum Report")
	Else 
		Print form:C5([Purchase_Orders_Items:12]; "VenSum.h")
	End if 
	
	$Pixels:=65
	
	Repeat 
		$CurComm:=aComCode{$i}
		iCommCode:=$CurComm
		//*  for each commodity
		If ([Raw_Materials_Groups:22]Commodity_Code:1#aComCode{$i})  //get RM_group record for description of commodity
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=aComCode{$i}; *)
			QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]SubGroup:10="")
		End if 
		
		If (fSave)
			VenSum2Disk("CH")
		Else 
			If ($Pixels+16<$Max)
				Print form:C5([Purchase_Orders_Items:12]; "VenSumComm.h")
				$Pixels:=$Pixels+16
			Else 
				PAGE BREAK:C6(>)
				iPage:=iPage+1
				Print form:C5([Purchase_Orders_Items:12]; "VenSum.h")
				$Pixels:=65
				Print form:C5([Purchase_Orders_Items:12]; "VenSumComm.h")
				$Pixels:=$Pixels+16
			End if 
		End if 
		REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
		VarsInitVenSum
		
		Repeat 
			$CurVend:=aVend{$i}
			//*   for each vendor 
			$NewRptIndex:=Find in array:C230(aCustId; $CurVend)  //• 2/24/98 cs locate this vendor for summing data 
			
			If ($NewRptIndex>-1)  //•100198  MLB  range chk err
				If (Length:C16(aDesc{$NewRptIndex})=0)  //don't do it more than once
					If (Length:C16($CurVend)=5)  //•100198  MLB  range chk err, is it a valid vendor number          
						If ([Vendors:7]ID:1#$CurVend)
							QUERY:C277([Vendors:7]; [Vendors:7]ID:1=$CurVend)
						End if   //need search
						aDesc{$NewRptIndex}:=[Vendors:7]Name:2
					Else 
						aDesc{$NewRptIndex}:="NOT AVAILABLE"
					End if   //valid id
				End if   //need desc
				
			Else 
				TRACE:C157
			End if   //found index
			
			Repeat 
				If ($i<=$ToPrint)  //there are still items to print
					If (aVend{$i}=$CurVend)  //item vender ID = vendor we are printing
						$Qty:=VenSumConvert(aComCode{$i}; aKey{$i}; aPOIQty{$i}; aUOM{$i}; aFlex3{$i}; aFlex2{$i}; aRmCode{$i})
						$POIMonth:=Month of:C24(aDate{$i})
						$dateOf1st:=Date:C102(String:C10($POIMonth)+"/01/"+String:C10(Year of:C25(aDate{$i})))
						If (aDate{$i}>=fiscalStart)
							$SameYear:=True:C214
						Else 
							$SameYear:=False:C215
						End if 
						
						If ($POIMonth<lMonth)  //current month (Jan->Mar)less than start of fiscal calendar, last quarter of prev
							$POIQuarter:=4
						Else   //determine which quarter it falls in ex Oct -> (10-4)/3 = 2 + 1 rem  == 3rd q
							$POIQuarter:=Int:C8($POIMonth/3)+(1*(Num:C11($POIMonth%3#0)))-1  //+ 1 if the month is not a quarter end
						End if 
						
						//*    sum qtys & costs
						If ($SameYear)  //the current item is in the current fiscal year
							If ($POIMonth=Month of:C24(dDateBegin))  //current year, current month
								real1:=real1+aCost{$i}
								real2:=real2+$Qty
								ayA2{$NewRptindex}:=ayA2{$NewRptindex}+aCost{$i}  //• 2/24/98 cs new report current month
							End if 
							
							If ($POIQuarter=lQuarter)  //current year current quarter
								real5:=real5+aCost{$i}  //add to this year quarter to date
								real6:=real6+$Qty
								ayA3{$NewRptindex}:=ayA3{$NewRptindex}+aCost{$i}  //• 2/24/98 cs new report current quarter
							End if 
							
							real9:=real9+aCost{$i}  // same year always add to year to date total
							real10:=real10+$Qty
							ayBx{$NewRptindex}:=ayBx{$NewRptindex}+aCost{$i}  //• 2/24/98 cs new report current year
							
						Else   //the current item is in the previous fiscal year
							If ($POIMonth=Month of:C24(dDateBegin))  //add to current month PREV year
								real3:=real3+aCost{$i}
								real4:=real4+$Qty
								ayA4{$NewRptindex}:=ayA4{$NewRptindex}+aCost{$i}  //• 2/24/98 cs new report current month, prev year
							End if 
							
							If ($POIQuarter=lQuarter)
								real7:=real7+aCost{$i}  //add to current quarter PREV Year
								real8:=real8+$Qty
								ayA5{$NewRptindex}:=ayA5{$NewRptindex}+aCost{$i}  //• 2/24/98 cs new report current quarter, prev year
							End if 
							
							If (aDate{$i}<=dLastEnd)  //Item is within the Fiscal year to date range
								real11:=real11+aCost{$i}  //add to PREV year to date
								real12:=real12+$Qty
								ayA6{$NewRptindex}:=ayA6{$NewRptindex}+aCost{$i}  //• 2/24/98 cs new report current month, prev year
							End if 
							
							real13:=real13+aCost{$i}  //always add to last year total
							real14:=real14+$Qty
							//NOT USED:
							ayA7{$NewRptindex}:=ayA7{$NewRptindex}+aCost{$i}  //• 2/24/98 cs new report  prev year total
						End if 
						$i:=$i+1
						
					Else 
						$Exit:=True:C214
					End if 
				Else 
					$Exit:=True:C214
				End if 
				//   uThermoUpdate ($i;100)  `update at intervvals of one hundred      
				
			Until ($Exit) | (Not:C34(<>fContinue))
			//*    print vendor line, and sum commodity totals      
			
			VenSumSetFlag
			
			If ($i>$ToPrint)  //• 7/6/98 cs 
				$Find:=$ToPrint
			Else 
				$Find:=$i
			End if 
			
			If ([Raw_Materials_Groups:22]Commodity_Code:1#aComCode{$Find})  //get RM_group record for description of commodity
				QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=aComCode{$Find}; *)
				QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]SubGroup:10="")
			End if 
			
			If (fsave)
				VenSum2Disk("VD")
				uThermoUpdate($i)
			Else 
				If ($Pixels+30<$Max)
					Print form:C5([Purchase_Orders_Items:12]; "VenSumVend.d")  //## print layout here  
					$Pixels:=$Pixels+30
				Else 
					PAGE BREAK:C6(>)
					iPage:=iPage+1
					Print form:C5([Purchase_Orders_Items:12]; "VenSum.h")
					$Pixels:=65
					Print form:C5([Purchase_Orders_Items:12]; "VenSumComm.h")
					$Pixels:=$Pixels+16
					Print form:C5([Purchase_Orders_Items:12]; "VenSumVend.d")  //## print layout here  
					$Pixels:=$Pixels+30
				End if 
			End if 
			uClearSelection(->[Raw_Materials_Groups:22])
			
			$aMonth{$Comm}{$ThisDol}:=real1+$aMonth{$Comm}{$ThisDol}  //totals for commodity for month to date
			$aMonth{$Comm}{$ThisQty}:=real2+$aMonth{$Comm}{$ThisQty}
			$aMonth{$Comm}{$PrevDol}:=real3+$aMonth{$Comm}{$PrevDol}
			$aMonth{$Comm}{$PrevQty}:=real4+$aMonth{$Comm}{$PrevQty}
			$aQuarter{$Comm}{$ThisDol}:=real5+$aQuarter{$Comm}{$ThisDol}  //totals for commodity for quarter to date
			$aQuarter{$Comm}{$ThisQty}:=real6+$aQuarter{$Comm}{$ThisQty}
			$aQuarter{$Comm}{$PrevDol}:=real7+$aQuarter{$Comm}{$PrevDol}
			$aQuarter{$Comm}{$PrevQty}:=real8+$aQuarter{$Comm}{$PrevQty}
			$aYear{$Comm}{$ThisDol}:=real9+$aYear{$Comm}{$ThisDol}  //totals for commodity for year to date
			$aYear{$Comm}{$ThisQty}:=real10+$aYear{$Comm}{$ThisQty}
			$aYear{$Comm}{$PrevDol}:=real11+$aYear{$Comm}{$PrevDol}
			$aYear{$Comm}{$PrevQty}:=real12+$aYear{$Comm}{$PrevQty}
			$aPrevYear{$Comm}{$YrDol}:=real13+$aPrevYear{$Comm}{$YrDol}  //totals for commodity for entire prev year
			$aPrevYear{$Comm}{$YrQty}:=real14+$aPrevYear{$Comm}{$YrQty}
			VarsInitVenSum  //clear vars for next vendor
			
			If ($i<=$ToPrint)
				$CurVend:=aVend{$i}  //start next vendor
				If ($CurComm#aComCode{$i})  //if this commodity is completed
					$Exit:=True:C214
					$CurComm:=aComCode{$i}
				Else 
					$Exit:=False:C215
				End if 
			Else 
				//exit already true - at end of printing  $i > number ot print
			End if 
		Until ($Exit) | (Not:C34(<>fContinue))
		//*  print total for commodity, do summation for grand total
		
		//  realxx used on layout for printing
		real1:=$aMonth{$Comm}{$ThisDol}  //totals for commodity for month to date
		real2:=$aMonth{$Comm}{$ThisQty}
		real3:=$aMonth{$Comm}{$PrevDol}
		real4:=$aMonth{$Comm}{$PrevQty}
		real5:=$aQuarter{$Comm}{$ThisDol}  //totals for commodity for quarter to date
		real6:=$aQuarter{$Comm}{$ThisQty}
		real7:=$aQuarter{$Comm}{$PrevDol}
		real8:=$aQuarter{$Comm}{$PrevQty}
		real9:=$aYear{$Comm}{$ThisDol}  //totals for commodity for year to date
		real10:=$aYear{$Comm}{$ThisQty}
		real11:=$aYear{$Comm}{$PrevDol}
		real12:=$aYear{$Comm}{$PrevQty}
		real13:=$aPrevYear{$Comm}{$YrDol}  //totals for commodity for entire prev year
		real14:=$aPrevYear{$Comm}{$YrQty}
		xText:=""  //clear 20% difference flag
		
		If ($i>$ToPrint)  //• 7/6/98 cs 
			$Find:=$ToPrint
		Else 
			$Find:=$i
		End if 
		
		If ([Raw_Materials_Groups:22]Commodity_Code:1#aComCode{$Find})  //get RM_group record for description of commodity
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=aComCode{$Find}; *)
			QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]SubGroup:10="")
		End if 
		
		If (fsave)
			VenSum2Disk("CD")
		Else 
			If ($Pixels+38<$Max)
				Print form:C5([Purchase_Orders_Items:12]; "VenSumComm.d")
				$Pixels:=$Pixels+38
			Else 
				PAGE BREAK:C6(>)
				iPage:=iPage+1
				Print form:C5([Purchase_Orders_Items:12]; "VenSum.h")
				$Pixels:=65
				Print form:C5([Purchase_Orders_Items:12]; "VenSumComm.h")
				$Pixels:=$Pixels+16
				Print form:C5([Purchase_Orders_Items:12]; "VenSumComm.d")
				$Pixels:=$Pixels+38
			End if 
		End if 
		uClearSelection(->[Raw_Materials_Groups:22])
		iCommCode:=$CurComm  //update next comm to print
		$aMonth{$Grand}{$ThisDol}:=$aMonth{$Comm}{$ThisDol}+$aMonth{$Grand}{$ThisDol}  //totals for month to date
		$aMonth{$Grand}{$ThisQty}:=$aMonth{$Comm}{$ThisQty}+$aMonth{$Grand}{$ThisQty}
		$aMonth{$Grand}{$PrevDol}:=$aMonth{$Comm}{$PrevDol}+$aMonth{$Grand}{$PrevDol}
		$aMonth{$Grand}{$PrevQty}:=$aMonth{$Comm}{$PrevQty}+$aMonth{$Grand}{$PrevQty}
		$aQuarter{$Grand}{$ThisDol}:=$aQuarter{$Comm}{$ThisDol}+$aQuarter{$Grand}{$ThisDol}  //totals for quarter to date
		$aQuarter{$Grand}{$ThisQty}:=$aQuarter{$Comm}{$ThisQty}+$aQuarter{$Grand}{$ThisQty}
		$aQuarter{$Grand}{$PrevDol}:=$aQuarter{$Comm}{$PrevDol}+$aQuarter{$Grand}{$PrevDol}
		$aQuarter{$Grand}{$PrevQty}:=$aQuarter{$Comm}{$PrevQty}+$aQuarter{$Grand}{$PrevQty}
		$aYear{$Grand}{$ThisDol}:=$aYear{$Comm}{$ThisDol}+$aYear{$Grand}{$ThisDol}  //totals for year to date
		$aYear{$Grand}{$ThisQty}:=$aYear{$Comm}{$ThisQty}+$aYear{$Grand}{$ThisQty}
		$aYear{$Grand}{$PrevDol}:=$aYear{$Comm}{$PrevDol}+$aYear{$Grand}{$PrevDol}
		$aYear{$Grand}{$PrevQty}:=$aYear{$Comm}{$PrevQty}+$aYear{$Grand}{$PrevQty}
		$aPrevYear{$Grand}{$YrDol}:=$aPrevYear{$Comm}{$YrDol}+$aPrevYear{$Grand}{$YrDol}  //totals for entire prev year
		$aPrevYear{$Grand}{$YrQty}:=$aPrevYear{$Comm}{$YrQty}+$aPrevYear{$Grand}{$YrQty}
		
		//clear commodity totals for next commodity
		$aMonth{$Comm}{$ThisDol}:=0  //totals for commodity for month to date
		$aMonth{$Comm}{$ThisQty}:=0
		$aMonth{$Comm}{$PrevDol}:=0
		$aMonth{$Comm}{$PrevQty}:=0
		$aQuarter{$Comm}{$ThisDol}:=0  //totals for commodity for quarter to date
		$aQuarter{$Comm}{$ThisQty}:=0
		$aQuarter{$Comm}{$PrevDol}:=0
		$aQuarter{$Comm}{$PrevQty}:=0
		$aYear{$Comm}{$ThisDol}:=0  //totals for commodity for year to date
		$aYear{$Comm}{$ThisQty}:=0
		$aYear{$Comm}{$PrevDol}:=0
		$aYear{$Comm}{$PrevQty}:=0
		$aPrevYear{$Comm}{$YrDol}:=0  //totals for commodity for entire prev year
		$aPrevYear{$Comm}{$YrQty}:=0
		
		//setup for next commodity
		$i:=$i+1
		
		If ($i<=$ToPrint)
			$CurComm:=aComCode{$i}
			$Exit:=False:C215
			
		End if 
	Until ($Exit) | (Not:C34(<>fContinue))
	//* print grand total line
	
	//  realxx used on layout for printing
	real1:=$aMonth{$Grand}{$ThisDol}  //totals for Grandodity for month to date
	real2:=$aMonth{$Grand}{$ThisQty}
	real3:=$aMonth{$Grand}{$PrevDol}
	real4:=$aMonth{$Grand}{$PrevQty}
	real5:=$aQuarter{$Grand}{$ThisDol}  //totals for Grandodity for quarter to date
	real6:=$aQuarter{$Grand}{$ThisQty}
	real7:=$aQuarter{$Grand}{$PrevDol}
	real8:=$aQuarter{$Grand}{$PrevQty}
	real9:=$aYear{$Grand}{$ThisDol}  //totals for Grandodity for year to date
	real10:=$aYear{$Grand}{$ThisQty}
	real11:=$aYear{$Grand}{$PrevDol}
	real12:=$aYear{$Grand}{$PrevQty}
	real13:=$aPrevYear{$Grand}{$YrDol}  //totals for Grandodity for entire prev year
	real14:=$aPrevYear{$Grand}{$YrQty}
	xText:=""  //clear 20% difference flag 
	
	If (fsave)
		VenSum2Disk("TD")
	Else 
		If ($Pixels+44<$Max)
			Print form:C5([Purchase_Orders_Items:12]; "VenSumTotals.d")
			$Pixels:=$Pixels+44
			PAGE BREAK:C6
		Else 
			PAGE BREAK:C6(>)
			iPage:=iPage+1
			Print form:C5([Purchase_Orders_Items:12]; "VenSum.h")
			$Pixels:=65
			Print form:C5([Purchase_Orders_Items:12]; "VenSumTotals.d")
			$Pixels:=$Pixels+44
			PAGE BREAK:C6
		End if 
	End if 
	
	If (fSave)
		$File:=Document  //save documents file path
		CLOSE WINDOW:C154
		uThermoClose
	End if 
End if   //the arrays are loaded  

ON EVENT CALL:C190("")