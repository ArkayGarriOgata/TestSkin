//%attributes = {"publishedWeb":true}
//PM:  Est_MaterialsCalc  091099  mlb
// formerly fCalcMaterials ($numMatl;$LastGross;$Width;$Length;»
//$caliper;$FilmLamGaug;»
//$FilmLamType;$grossWin;$netCartons;$grossCoat;$yldWin;$YldCartons)
//see also sSetGrpFlex
//called by sRunEstimate,
//mod 4/4/94 upr 1095
//mod 4/14/94 upr 1097, 1054
//mod 5/16 upr 1096
//10/4/94 upr 1211
//11/22/94 UPR 1324 tagged with `•
//12/13/94 chip UPR 1234 tagged with ••
//1/11/95 upr 1382
//2/8/95 upr 165 freight fix
//obsolete  `upr 1429, 1443 3/13/95
//upr 1456 3/21/95
//3/21/95 proc exceeds 32 K, so some fCalcComm99 were created
//3/23/95 add weight parameter
//3/30/95 check for INF cost
//•052395  MLB  UPR 1486 chg comm 8 uom from lf to lb
//•053095  MLB  UPR 1501
//•071195  MLB  UPR 1673 chg comm 8 basis uom from MSI to MSF
//•061995  MLB  reduce size of proc for compile purposes by creating more subrouti
//• 7/8/97 cs added test for a zero value as an attempt to stop Nan
//• 2/5/98 cs allow usage of coating to coverage to be set by user
//• 2/10/98 cs setup to handle inline coatings
//• 4/9/98 cs nan checking/removal
// Modified by: Mel Bohince (8/3/16) make roll stock double wide aware based on RM code's width
// Modified by: Mel Bohince (10/5/16) 1 or 2 sheets per cut 
// Modified by: MelvinBohince (2/15/22) fCalcComm09 corrected, but not used, going with 05 for compatibility
// Modified by: MelvinBohince (3/8/22) comm 9 disconnected from 5 ; more 'correct' cold foil calculation

C_LONGINT:C283($weight; $freightRec)  //2/8/95 upr 165
C_LONGINT:C283($period; $sheetsPerCut; $13)
C_TEXT:C284($transposed; $end; $origCOMM; $origUM)
C_LONGINT:C283($0; $1; $2; $8; $9; $10; $11; $comm; $i; $numMatl; $LFgross; $grossSheets; $grossWin; $netCartons; $matlError; $yldCartons; $12; $LamLG)
C_REAL:C285($3; $4; $5; $6; $caliper; $FormSqIn; $FormSqFt; $MSF)
C_REAL:C285($stdCost; $Flex2; $Flex3; $Flex4)
C_TEXT:C284($7; $FilmLamType; $subGroup; $stdUM)

READ ONLY:C145([Raw_Materials_Groups:22])
READ ONLY:C145([Raw_Materials:21])  // Modified by: Mel Bohince (8/3/16) loading record to find width of stock

$weight:=0
$freightRec:=0
$numMatl:=$1
$grossSheets:=uNANCheck($2)
$Width:=$3
$Length:=$4
$caliper:=$5
$FilmLamGaug:=$6
$FilmLamType:=$7
$grossWin:=$8
$yldWin:=$11
$netCartons:=$9
$yldCartons:=$12
$grossCoat:=$10
$sheetsPerCut:=$13  // Modified by: Mel Bohince (10/5/16) 1 or 2


//*.  Calc some common parameters
$LFgross:=uNANCheck($grossSheets*$Length/12)
$FormSqIn:=$Width*$Length
$FormSqFt:=($Width*$Length)/144
$MSF:=uNANCheck($grossSheets*$FormSqFt/1000)
//*. Display common parameters
Est_LogIt(<>sCR+"Estimating Materials with:"+<>sCR+"____________________"+<>sCR+"Number of Mat'l = "+String:C10($numMatl))
Est_LogIt("Gross Sheets = "+String:C10($grossSheets)+<>sCR+"Linear Feet = "+String:C10($LFgross; "#########")+<>sCR+"MSF = "+String:C10($MSF; "#########.####"))
Est_LogIt("Form Dim = "+String:C10($Width)+"'' x "+String:C10($Length)+"''")
Est_LogIt("Form SqIn = "+String:C10($FormSqIn; "#######.####"))
Est_LogIt("Form SqFt = "+String:C10($FormSqFt; "#######.####"))
Est_LogIt("Caliper Stock = "+String:C10($caliper; "0.0000"))
Est_LogIt("Film Gauge = "+String:C10($FilmLamGaug)+<>sCR+"Film Type = "+$FilmLamType)
Est_LogIt("Gross Coated = "+String:C10($grossCoat))
Est_LogIt("#Windowed = "+String:C10($grossWin)+<>sCR+"#Windowed Yld = "+String:C10($yldWin))
Est_LogIt("Net cartons = "+String:C10($netcartons)+<>sCR+"Yield cartons = "+String:C10($yldcartons)+<>sCR+"____________________")
//*Calc qty and cost of each material in this differencial
For ($i; 1; $numMatl)
	//*.  Init the calc'd fields on the current seq 
	[Estimates_Materials:29]Cost:11:=0
	[Estimates_Materials:29]Qty:9:=0
	[Estimates_Materials:29]CalcDetails:24:=""
	[Estimates_Materials:29]WorkDetails:25:=""
	[Estimates_Materials:29]Matl_YieldAdds:26:=0
	Est_LogIt([Estimates_Materials:29]Commodity_Key:6)
	If (<>fContinue)  //*.     Test for loop termination    
		//*.  Convert Comm 1's to MSF for calculation    
		If (Num:C11(Substring:C12([Estimates_Materials:29]Commodity_Key:6; 1; 2))=1) & (Not:C34([Estimates_Materials:29]FixedQty:30))  //upr 1211
			
			If ([Estimates_Materials:29]UOM:8#"MSF")  //convert it back to MSF
				qryRMgroup
				If ((Records in selection:C76([Raw_Materials_Groups:22])=0) | (Not:C34([Raw_Materials_Groups:22]UseForEst:12)))
					//$origCOMM:=[Material_Est]Commodity_Key  `01-sbs.18.22
					//$origUM:=[Material_Est]UOM  `                       LF
					$period:=Position:C15("."; [Estimates_Materials:29]Commodity_Key:6)
					$transposed:=Substring:C12([Estimates_Materials:29]Commodity_Key:6; 1; $period)  //01-sbs.
					$end:=Substring:C12([Estimates_Materials:29]Commodity_Key:6; (1+$period))  //18.22
					$period:=Position:C15("."; $end)
					$transposed:=$transposed+Substring:C12($end; 1; ($period-1))  //01-sbs.18
					[Estimates_Materials:29]Commodity_Key:6:=$transposed
					[Estimates_Materials:29]UOM:8:="MSF"
					qryRMgroup
				Else 
					[Estimates_Materials:29]UOM:8:=Replace string:C233([Raw_Materials_Groups:22]UOM:8; " "; "")
				End if   //lf standard not found
				
			Else 
				qryRMgroup
			End if   //lf um
			
		Else 
			qryRMgroup
		End if   //comm 1
		
		//*.  Load in the Standards
		If (Records in selection:C76([Raw_Materials_Groups:22])=1)
			sSetGrpFlex(Num:C11(Substring:C12([Estimates_Materials:29]Commodity_Key:6; 1; 2)))  //062800      
			$stdUM:=Replace string:C233([Raw_Materials_Groups:22]UOM:8; " "; "")
			$thisUM:=Replace string:C233([Estimates_Materials:29]UOM:8; " "; "")
			If ($stdUM=$thisUM)
				$comm:=Num:C11(Substring:C12([Estimates_Materials:29]Commodity_Key:6; 1; 2))
				$subGroup:=Substring:C12([Estimates_Materials:29]Commodity_Key:6; 4)
				$stdCost:=[Raw_Materials_Groups:22]Std_Cost:4
				$Flex2:=[Raw_Materials_Groups:22]Flex2:14  //see sSetGrpflex
				If ($Flex2=0)
					$Flex2:=1
				End if 
				$Flex3:=[Raw_Materials_Groups:22]Flex3:16
				If ($Flex3=0)
					$Flex3:=1
				End if 
				$Flex4:=[Raw_Materials_Groups:22]Flex4:17
				If ($Flex4=0)
					$Flex4:=1
				End if 
				
				[Estimates_Materials:29]Comments:13:=sFlex1+" "+String:C10($stdCost; "$###,##0.00##")+"/"+$stdUM+", "+String:C10([Raw_Materials_Groups:22]EffectivityDate:15; 1)+<>sCR+sFlex2+" "+String:C10($Flex2)+<>sCR+sFlex3+" "+String:C10($Flex3)+<>sCR+sFlex4+" "+String:C10($Flex4)
				
				//*.       Dispact to appropriate comm number
				Case of 
						//: ([Material_Est]FixedQty)
						// QUERY([RAW_MATERIALS];[RAW_MATERIALS]Raw_Matl_Code=[Material_Est]Raw_Matl_Code)
						// [Material_Est]Cost:=[Material_Est]Qty*[RAW_MATERIALS]ActCost
						// [Material_Est]Comments:=String([RAW_MATERIALS]ActCost;"$###,##0.00##")+"/"+$std
						
					: ($comm=1)
						
						Case of 
							: (Position:C15("LF"; [Estimates_Materials:29]UOM:8)#0)
								
								// Modified by: Mel Bohince (8/3/16) see if doublewide material is being used
								//$sheetsPerCut:=1  //default to single wide
								//If (Length([Estimates_Materials]Raw_Matl_Code)>0)  //check the width
								//QUERY([Raw_Materials];[Raw_Materials]Raw_Matl_Code=[Estimates_Materials]Raw_Matl_Code)
								//If (Records in selection([Raw_Materials])>0)
								//If ([Raw_Materials]Flex2>41)  //doublewide roll
								//$sheetsPerCut:=2
								//[Estimates_Materials]Comments:="2X-Wide, "+[Estimates_Materials]Comments
								//End if 
								//End if 
								//REDUCE SELECTION([Raw_Materials];0)
								//End if 
								
								If ($sheetsPerCut>1)  // Modified by: Mel Bohince (10/5/16) 
									[Estimates_Materials:29]Comments:13:="2X-Wide, "+[Estimates_Materials:29]Comments:13
								Else 
									[Estimates_Materials:29]Comments:13:=Replace string:C233([Estimates_Materials:29]Comments:13; "2X-Wide, "; "")
								End if 
								[Estimates_Materials:29]Qty:9:=$LFgross/$sheetsPerCut
								// Modified by: Mel Bohince (8/3/16) end
								
								[Estimates_Materials:29]Cost:11:=$LFgross*$stdCost*$Flex2
								[Estimates_Materials:29]CalcDetails:24:=" WT:  "+String:C10(Round:C94(([Estimates_Materials:29]Qty:9*[Raw_Materials_Groups:22]Flex3:16); 0); "###,###,##0 LBS")
								$weight:=$weight+(Round:C94(([Estimates_Materials:29]Qty:9*[Raw_Materials_Groups:22]Flex3:16); 0))
								
							: (Position:C15("MSF"; [Estimates_Materials:29]UOM:8)#0)
								If (Position:C15("Special"; $subGroup)=0)  //use standards
									[Estimates_Materials:29]Qty:9:=$MSF
									[Estimates_Materials:29]Cost:11:=$MSF*$stdCost*$Flex2
									[Estimates_Materials:29]CalcDetails:24:=" WT:  "+String:C10(Round:C94(([Estimates_Materials:29]Qty:9*[Raw_Materials_Groups:22]Flex3:16); 0); "###,###,##0 LBS")+"   "+String:C10($LFgross; "###,###,##0 LF")+"  "+String:C10($MSF; "###,###,##0.000 MSF")
									$weight:=$weight+(Round:C94(([Estimates_Materials:29]Qty:9*[Raw_Materials_Groups:22]Flex3:16); 0))
									
								Else   //spl b&P, use planner's entry
									[Estimates_Materials:29]Qty:9:=$MSF
									[Estimates_Materials:29]Cost:11:=$MSF*[Estimates_Materials:29]Real2:15*$Flex2
									[Estimates_Materials:29]CalcDetails:24:=" WT:  "+String:C10(Round:C94(([Estimates_Materials:29]Qty:9*[Estimates_Materials:29]Real1:14); 0); "###,###,##0 LBS")+"   "+String:C10($LFgross; "###,###,##0 LF")+"  "+String:C10($MSF; "###,###,##0.000 MSF")
									[Estimates_Materials:29]Comments:13:="••SPL••: "+String:C10([Estimates_Materials:29]Real2:15; "$###,##0.00##")+"/"+$stdUM+", "+String:C10([Raw_Materials_Groups:22]EffectivityDate:15; 1)+<>sCR
									$weight:=$weight+(Round:C94(([Estimates_Materials:29]Qty:9*[Estimates_Materials:29]Real1:14); 0))
								End if 
								
								//convert to LF upr1211,`• mlb - 6/28/01  add 428     
								If (Position:C15([Estimates_Materials:29]CostCtrID:2; <>SHEETERS)>0)  //(Position("426";[Material_Est]CostCtrID)#0) | (Position("427";[Material_Est]Cost
									//[Material_Est]Commodity_Key:=[Material_Est]Commodity_Key+"."+String($Width)
									[Estimates_Materials:29]UOM:8:="LF"
									// Modified by: Mel Bohince (8/3/16) see if doublewide material is being used
									//$sheetsPerCut:=1  //default to single wide
									//If (Length([Estimates_Materials]Raw_Matl_Code)>0)  //check the width
									//QUERY([Raw_Materials];[Raw_Materials]Raw_Matl_Code=[Estimates_Materials]Raw_Matl_Code)
									//If (Records in selection([Raw_Materials])>0)
									//If ([Raw_Materials]Flex2>41)  //doublewide roll
									//$sheetsPerCut:=2
									//[Estimates_Materials]Comments:="2X-Wide, "+[Estimates_Materials]Comments
									//End if 
									//End if 
									//REDUCE SELECTION([Raw_Materials];0)
									//End if 
									//[Estimates_Materials]Qty:=$LFgross/$sheetsPerCut
									If ($sheetsPerCut>1)  // Modified by: Mel Bohince (10/5/16) 
										[Estimates_Materials:29]Comments:13:="2X-Wide, "+[Estimates_Materials:29]Comments:13
									Else 
										[Estimates_Materials:29]Comments:13:=Replace string:C233([Estimates_Materials:29]Comments:13; "2X-Wide, "; "")
									End if 
									[Estimates_Materials:29]Qty:9:=$LFgross/$sheetsPerCut
									// Modified by: Mel Bohince (8/3/16) end
									
								Else 
									//[Material_Est]Commodity_Key:=[Material_Est]Commodity_Key+"."+String($Width)+"."
									//«+String($Length)
									[Estimates_Materials:29]UOM:8:="SHT"
									[Estimates_Materials:29]Qty:9:=$grossSheets
								End if 
								
							Else 
								$matlError:=-101
						End case 
						
					: ($comm=20)
						[Estimates_Materials:29]UOM:8:="SHT"
						[Estimates_Materials:29]Qty:9:=$grossSheets
						[Estimates_Materials:29]Cost:11:=$grossSheets*[Estimates_Materials:29]Real1:14
						
					: ($comm=2)
						If ($thisUM="LB")
							fCalcComm02($FormSqIn; $grossSheets; $Flex2; $Flex3; $Flex4; $stdCost)
						Else 
							$matlError:=-201
						End if 
						
					: ($comm=3)
						//• 2/10/98 cs setup to handle inline coatings            
						If ([Estimates_Materials:29]CostCtrID:2#"471") & ([Estimates_Materials:29]CostCtrID:2#"472")  //this means that this item is NOT off line coating, coating is inline
							$Temp:=$GrossSheets  //since thi sis in line use gross sheets as coverage
							$GrossCoat:=$GrossSheets
						End if 
						
						If ($thisUM="LB")
							//• 2/5/98 cs allow usage of coating coverage to be set by user
							If ([Estimates_Materials:29]Real1:14=0) | ([Estimates_Materials:29]Real1:14=100)  //• 2/5/98 cs default of 100% coverage for coating
								[Estimates_Materials:29]Qty:9:=uNANCheck(($FormSqFt*$grossCoat/1000*$Flex2)+$Flex3)  //note not = to total MSF
							Else   //users enteredsome other percent coverage`• 2/5/98 cs 
								[Estimates_Materials:29]Qty:9:=uNANCheck((($FormSqFt*$grossCoat/1000*$Flex2)*([Estimates_Materials:29]Real1:14/100))+$Flex3)  //Above calc * percent coverage requested `• 2/5/98 cs 
							End if 
							[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$stdCost
						Else 
							$matlError:=-301
						End if 
						
						//• 2/10/98 cs setup to handle inline coatings
						If ([Estimates_Materials:29]CostCtrID:2#"471") & ([Estimates_Materials:29]CostCtrID:2#"472")  //this means that this item is NOT off line coating, coating is inline
							$GrossCoat:=$Temp  //return original gross sheets for off line coating
						End if 
						
					: ($comm=4)
						If ($thisUM="EACH")
							fCalcComm04($stdCost; $Flex2; $Flex3)
						Else 
							$matlError:=-401
						End if 
						
					: ($comm=5)  // Modified by: MelvinBohince (3/8/22)  not 9 |($comm=9)
						If ($thisUM="ROLL")
							fCalcComm05($subGroup; $grossSheets; $stdCost; $stdUM; $Flex2; $Flex3; $Flex4)
						Else 
							$matlError:=-501
						End if 
						
					: ($comm=6)
						If ($thisUM="SHT")
							fCalcComm06($netCartons; $yldCartons; $stdCost; $Flex2; $Flex3)
						Else 
							$matlError:=-601
						End if 
						
					: ($comm=12)
						If ($thisUM="Each")
							fCalcComm12($netCartons; $yldCartons; $stdCost)
						Else 
							$matlError:=-1201
						End if 
						
					: ($comm=7)
						Case of 
							: (True:C214)
								[Estimates_Materials:29]UOM:8:="EACH"
								If ([Estimates_Materials:29]Real1:14<1)
									If ($Flex2>0)
										[Estimates_Materials:29]Real1:14:=$Flex2
									Else 
										[Estimates_Materials:29]Real1:14:=1
									End if 
								End if 
								If ([Estimates_Materials:29]Real2:15<1)
									[Estimates_Materials:29]Real2:15:=$stdCost
								End if 
								If ([Estimates_Materials:29]Real1:14<100)
									[Estimates_Materials:29]Qty:9:=[Estimates_Materials:29]Real1:14
									[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*[Estimates_Materials:29]Real2:15
									[Estimates_Materials:29]CalcDetails:24:="Number of Dies: "+String:C10([Estimates_Materials:29]Real1:14; "##0")+" Price per Die: $"+String:C10([Estimates_Materials:29]Real2:15)
									[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24
								Else 
									estCalcError:=True:C214
								End if 
								
							: ([Estimates_Materials:29]Commodity_Key:6="07-Embossing@")  //old 7  `upr 1429, 1443 3/13/93     
								If ([Estimates_Materials:29]Commodity_Key:6="07-Embossing")
									[Estimates_Materials:29]Commodity_Key:6:="07-Embossing Dies"
								End if 
								//[Material_Est]Comments:="Stds: "+String($stdCost;"$###,##0.00##")+"/SqIn, "+Stri
								If ($thisUM#"EACH")  //upr 1456 3/21/95 chg uom's on 7 and 13laser
									[Estimates_Materials:29]UOM:8:="EACH"  //•053095  MLB  UPR 1501
									$thisUM:="EACH"
								End if 
								
								fCalcComm07ED($FormSqIn; $Flex2; $stdCost)
								
							: ([Estimates_Materials:29]Commodity_Key:6="07-Stamping Dies")  //old 51  `upr 1429, 1443 3/13/93
								If ($thisUM#"EACH")  //•053095  MLB  UPR 1501
									[Estimates_Materials:29]UOM:8:="EACH"
									$thisUM:="EACH"
								End if 
								
								If ($thisUM="EACH")  //upr 1456 3/21/95 chg uom's on 7 and 13laser
									fCalcComm07SD($stdCost; $Flex2; $netCartons; $yldCartons)
								Else 
									$matlError:=-702
								End if 
								
							: ([Estimates_Materials:29]Commodity_Key:6="07-MarkAndy")  //no details availble
								If ($thisUM#"EACH")
									[Estimates_Materials:29]UOM:8:="EACH"
									$thisUM:="EACH"
								End if 
								
								If ($thisUM="EACH")
									fCalcComm07MA($stdCost)
								Else 
									$matlError:=-702
								End if 
								
							Else 
								$matlError:=-703
						End case 
						
					: ($comm=8)
						If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
							
							COPY NAMED SELECTION:C331([Estimates_Machines:20]; "mach")
							qryMachEst
							If (Records in selection:C76([Estimates_Machines:20])=1)
								$LamLG:=[Estimates_Machines:20]Qty_Gross:22
							Else 
								$LamLG:=0
								$matlError:=-802
							End if 
							USE NAMED SELECTION:C332("mach")
							CLEAR NAMED SELECTION:C333("mach")
							
						Else 
							
							ARRAY LONGINT:C221($_mach; 0)
							LONGINT ARRAY FROM SELECTION:C647([Estimates_Machines:20]; $_mach)
							qryMachEst
							If (Records in selection:C76([Estimates_Machines:20])=1)
								$LamLG:=[Estimates_Machines:20]Qty_Gross:22
							Else 
								$LamLG:=0
								$matlError:=-802
							End if 
							CREATE SELECTION FROM ARRAY:C640([Estimates_Machines:20]; $_mach)
							
							
						End if   // END 4D Professional Services : January 2019 
						
						Case of   //•071195  MLB  UPR 1673
							: ($thisUM="LB")  //•052395  MLB  UPR 1486 
								C_REAL:C285($MSF_Lam; $LB_Adh)
								If ($LamLG#0)  //• 7/8/97 cs try to stop Nan
									$MSF_Lam:=$FormSqIn/144*$LamLG/1000  //•071195  MLB  UPR 1673 chg to MSF fro MSI
								Else 
									$MSF_Lam:=0
								End if 
								[Estimates_Materials:29]Qty:9:=uNANCheck($MSF_Lam*$Flex2)  //flex2 is the usage LBS/MSF of lam
								$LB_Adh:=$MSF_Lam*$Flex4  //flex4 is the usage LBS/MSF of adhesive
								If (Position:C15("Special"; $subGroup)=0)
									[Estimates_Materials:29]Cost:11:=uNANCheck(([Estimates_Materials:29]Qty:9*$stdCost)+($LB_Adh*$Flex3))  //flex3 is the $/lb for adhesive
								Else 
									$stdCost:=[Estimates_Materials:29]Real1:14
									[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$stdCost
									[Estimates_Materials:29]Comments:13:="Over ride: "+String:C10($stdCost; "$###,##0.00##")+"/"+$stdUM+<>sCR
								End if 
								[Estimates_Materials:29]CalcDetails:24:=String:C10(Round:C94($MSF_Lam; 0))+" MSF  "+String:C10($Flex2)+" LBS/MSF (Lam)  "+String:C10($Flex3)+" $/LB (Adh)  "+String:C10($Flex4)+" LBS/MSF (Adh)  "
								[Estimates_Materials:29]WorkDetails:25:=String:C10(Round:C94($LamLG; 0))+" SHTS  "+String:C10(Round:C94([Estimates_Materials:29]Qty:9; 2))+" LBS of Laminate  "+String:C10(Round:C94($LB_Adh; 2))+"  LBS of Adhesive"
								
							: ($thisUM="LF")
								If ($Length>$Width)
									$LamLG:=$LamLG*$Length/12
								Else 
									$LamLG:=$LamLG*$Width/12
								End if 
								
								[Estimates_Materials:29]Qty:9:=uNANCheck($LamLG*$Flex2)  //flex2 is for possible waste
								If (Position:C15("Special"; $subGroup)=0)
									[Estimates_Materials:29]Cost:11:=uNANCheck([Estimates_Materials:29]Qty:9*($stdCost+$Flex3))  //flex3 is the $/lf for adhesive
								Else 
									$stdCost:=[Estimates_Materials:29]Real1:14
									[Estimates_Materials:29]Cost:11:=uNANCheck([Estimates_Materials:29]Qty:9*$stdCost)
									[Estimates_Materials:29]Comments:13:="Over ride: "+String:C10($stdCost; "$###,##0.00##")+"/"+$stdUM+<>sCR
								End if 
								[Estimates_Materials:29]CalcDetails:24:=String:C10(Round:C94($LamLG; 2))+" LF  "+String:C10($Flex2)+" Waste factor  "+String:C10($Flex3)+" Adhesive $/LF  "
								[Estimates_Materials:29]WorkDetails:25:=String:C10(Round:C94($LamLG; 2))+" LF  "
								
							Else 
								$matlError:=-801
						End case 
						
					: ($comm=9)  //cold foil // Modified by: MelvinBohince (3/9/22) more 'correct' cold foil calculation
						If (True:C214)  //original way of acting like it is hot foil
							If ($thisUM="ROLL")
								fCalcComm05($subGroup; $grossSheets; $stdCost; $stdUM; $Flex2; $Flex3; $Flex4)
							Else   //wrong uom
								$matlError:=-901
							End if 
							
						Else   // Modified by: MelvinBohince (3/9/22) more 'correct' cold foil calculation
							$stdFtPerRoll:=$Flex2
							$wasteFactor:=$Flex4
							$splCostPerRoll:=Num:C11([Estimates_Materials:29]alpha20_2:18)
							If (Position:C15("x"; [Estimates_Materials:29]alpha20_3:19)>0)  //split the len from the width
								$estRollDimensions_c:=Split string:C1554(Lowercase:C14([Estimates_Materials:29]alpha20_3:19); "x")  //like 30000X40
								$estFtPerRoll:=Num:C11($estRollDimensions_c[0])
							Else 
								$estFtPerRoll:=Num:C11([Estimates_Materials:29]alpha20_3:19)
							End if 
							$matlError:=fCalcComm09($LFgross; $estFtPerRoll; $splCostPerRoll; $stdFtPerRoll; $stdCost; $wasteFactor)  // Modified by: MelvinBohince (3/8/22) argv chg'd
						End if   //new or old
						
					: ($comm=13)
						Case of 
							: ([Estimates_Materials:29]Commodity_Key:6="13-Freight")  //••
								$freightRec:=Record number:C243([Estimates_Materials:29])  // can't caluculate until all the weight has been totaled
								
							: ([Estimates_Materials:29]Commodity_Key:6="13-Laser Dies")  // make like com 71 upr 1429, 1443 3/13/93     
								If ($thisUM#"EACH")  //•053095  MLB  UPR 1501
									[Estimates_Materials:29]UOM:8:="EACH"
									$thisUM:="EACH"
								End if 
								
								If ($thisUM="EACH")  //upr 1456 3/21/95 chg uom's on 7 and 13laser    
									fCalcComm13LD($stdCost; $Flex2; $Flex3; $Flex4; $FormSqIn)
								Else 
									$matlError:=-1301
								End if 
								
							Else 
								[Estimates_Materials:29]Qty:9:=[Estimates_Materials:29]Real2:15
								[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Real1:14*[Estimates_Materials:29]Real2:15
						End case 
						
					: ($comm=17)
						$matlError:=fCalcComm17($thisUM; $Flex2; $grossWin; $Flex3; $stdCost; $yldWin)
						
					: ($comm=51)  //obsolete  `upr 1429, 1443 3/13/95
						$matlError:=fCalcComm51($thisUM; $netCartons; $yldCartons; $Flex2; $stdCost)
						
					: ($comm=71)  //obsolete  `upr 1429, 1443 3/13/95
						$matlError:=fCalcComm71($thisUM; $FormSqIn; $stdCost; $Flex4; $Flex2; $Flex3)
						
					: ($comm=33)  //fg subcomponent
						<>USE_SUBCOMPONENT:=True:C214
						QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)  //find Estimate Qty worksheet
						QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=[Estimates_Differentials:38]diffNum:3)
						ARRAY LONGINT:C221($aItemNumber; 0)
						ARRAY TEXT:C222($aItemAlpha; 0)
						ARRAY LONGINT:C221($aCartons_produced; 0)
						SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]Item:1; $aItemAlpha; [Estimates_Carton_Specs:19]itemNumber:74; $aItemNumber; [Estimates_Carton_Specs:19]Quantity_Want:27; $aCartons_produced)
						For ($item; 1; Size of array:C274($aItemAlpha))
							$aItemNumber{$item}:=Num:C11($aItemAlpha{$item})
						End for 
						If (Size of array:C274($aCartons_produced)=1)
							$hit:=1
						Else 
							$hit:=Find in array:C230($aItemNumber; [Estimates_Materials:29]Real2:15)
						End if 
						If ($hit>-1)
							[Estimates_Materials:29]Qty:9:=$aCartons_produced{$hit}*[Estimates_Materials:29]Real1:14
						End if 
						[Estimates_Materials:29]Cost:11:=Job_price_component([Estimates_Materials:29]Raw_Matl_Code:4; "planned"; [Estimates_Materials:29]Qty:9)
						[Estimates_Materials:29]CalcDetails:24:="Component Cost: $"+String:C10([Estimates_Materials:29]Cost:11*1000/[Estimates_Materials:29]Qty:9; "#,##0.00")+"/M"
						[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24
						[Estimates_Materials:29]Comments:13:=[Estimates_Materials:29]CalcDetails:24
						
					Else 
						BEEP:C151
						ALERT:C41("What the heck is "+[Estimates_Materials:29]Commodity_Key:6+"?")
						$matlError:=-9902
				End case   //
				
				[Estimates_Materials:29]Cost:11:=Round:C94([Estimates_Materials:29]Cost:11; 0)
				
				If ($comm#9)  // Modified by: MelvinBohince (3/8/22) rounds up to a half roll
					[Estimates_Materials:29]Qty:9:=Round:C94([Estimates_Materials:29]Qty:9; 0)
				Else 
					[Estimates_Materials:29]Qty:9:=Round:C94([Estimates_Materials:29]Qty:9; 1)
				End if 
				
			Else   //not std um
				$comm:=0
				$subGroup:=""
				$stdUM:=""
				$stdCost:=0
				$stdFactor:=0
				$matlError:=-9901
			End if 
		Else   //cant find the standards
			$comm:=0
			$subGroup:=""
			$stdUM:=""
			$stdCost:=0
			$stdFactor:=0
			BEEP:C151
			ALERT:C41("Where the heck is the "+[Estimates_Materials:29]Commodity_Key:6+" standards?"; "Dagnabbit")
			$matlError:=-9900
			// End if 
		End if 
		//*.       Rpt any errors
		If ($matlError<0)
			BEEP:C151
			Est_LogIt("Mat'l Calc Error: type "+String:C10($matlError)+" during mat'l seq: "+String:C10([Estimates_Materials:29]Sequence:12))
			[Estimates_Materials:29]Comments:13:="• "+String:C10($matlError)+" •"+Char:C90(13)+[Estimates_Materials:29]Comments:13
			<>fContinue:=False:C215
			estCalcError:=True:C214
		End if 
		
		[Estimates_Materials:29]Effectivity:27:=[Estimates_Materials:29]UseStdDated:28  //•
		SAVE RECORD:C53([Estimates_Materials:29])
		If ([Estimates_Materials:29]Cost:11=0) & ([Estimates_Materials:29]Commodity_Key:6#"13-Freight")
			BEEP:C151
			BEEP:C151
			Est_LogIt(<>sCr+"Mat'l Calc Error: Comm: "+[Estimates_Materials:29]Commodity_Key:6+" zero cost!")
			//DELAY PROCESS(Current process;60)  `delay for 1 sec for user to see
			estCalcError:=True:C214
		End if 
		
		If (Position:C15("INF"; String:C10([Estimates_Materials:29]Cost:11))#0)  //3/30/95
			BEEP:C151
			BEEP:C151
			Est_LogIt(<>sCr+"Mat'l Calc Error: Comm "+[Estimates_Materials:29]Commodity_Key:6+" has a division by zero!"+<>sCr+"Calculation aborted.")
			//DELAY PROCESS(Current process;60)  `delay for 1 sec for user to see
			<>fContinue:=False:C215
			estCalcError:=True:C214
			BEEP:C151
		End if 
		//*.   Get the material record    
		NEXT RECORD:C51([Estimates_Materials:29])
		
	Else 
		$i:=$numMatl+1  //terminate loop
	End if   //failed
End for 
//*Calc the freight charges
If ($freightRec#0) & (<>fContinue)  //upr 165 2/8/95
	fCalcFreight($freightRec; $weight)  //3/23/95 add weight parameter
End if 

$0:=$matlError