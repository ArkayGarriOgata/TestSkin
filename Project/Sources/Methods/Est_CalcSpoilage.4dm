//%attributes = {"publishedWeb":true}
//PM:  Est_CalcSpoilage  9/13/99  MLB
//formerly  `fEstAddSpoilage ->boolean
//called by sRunEstimate to factor in additional spoilage
//see upr 1045 create 3/28/94
//mod 9/22/94 allow net override feature to work
//upr 164 1/6/94 net override problems continue
//upr 1463 3/29/95
//•061395  MLB  UPR 1634 add checks for outside service flag
//•060696  MLB  add gluers and stampers
//• mlb - 6/3/02  10:25 remove colorStdshts
// • mel (9/11/03, 15:47:55) used sheeter and coater constants

C_REAL:C285($origSpoil_p; $origSpoil; $addSpoil; $newSpoil; $newAmt)
C_LONGINT:C283($gross; $i; $length; $numberup; $1; $2; $gross; $0; $cartonWaste; $3; $4)
C_POINTER:C301($5; $6)  //$grossWin and $qrossCoat
C_TEXT:C284($cartonUOM)

$NumberUp:=$1
$length:=$2
$netCartons:=$3
$yldcartons:=$4
$cartonUOM:="501 502 491 585 486 "+<>GLUERS  //•060696  MLB  
$lastcartons:=0  //this is at the net level of sheets
$gross:=0  //this is at the yield level of sheets
$cartonWaste:=0  //  to be added to the yield cartons so enough (this is cumulative,just like life)
//               sheets are produced to obtain the yeild qty if required
$origSpoil_p:=[Estimates_DifferentialsForms:47]Spoilage_Pct:28  //calculated
//• mlb - 6/3/02  10:25 remove colorStdshts
$origSpoil:=([Estimates_DifferentialsForms:47]SheetsQtyGross:19-[Estimates_DifferentialsForms:47]ColorStdSheets:34)-[Estimates_DifferentialsForms:47]NumberSheets:4
$addSpoil:=Round:C94([Estimates_DifferentialsForms:47]Addl_Spoilage:29; 5)  //user entered
$newSpoil:=$origSpoil_p+$addSpoil  //new spoilage amt desired by user
$newAmt:=((1+($newSpoil/100))*[Estimates_DifferentialsForms:47]NumberSheets:4)-[Estimates_DifferentialsForms:47]NumberSheets:4  //this amt must be spread over all sequences

Est_LogIt(" adding additional "+String:C10($addSpoil; "##0.##")+"% spoilage   ")  //
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; <)
	FIRST RECORD:C50([Estimates_Machines:20])  //start at the glue line (last operation)`recalc good imprss required, prime gross
	
Else 
	
	ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; <)
	// see previous line
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

If (Position:C15([Estimates_Machines:20]CostCtrID:4; $cartonUOM)#0)  //convert car
	$factor:=([Estimates_Machines:20]Qty_Waste:23/$numberUp)/$origSpoil
	$cartonWaste:=Round:C94(($factor*$newAmt*$numberUp); 0)  //calc the new waste  
	
	[Estimates_Machines:20]Qty_Waste:23:=$cartonWaste
	$lastcartons:=$cartonWaste+$netCartons
	
	Case of   //9/22/94 and copy below
		: (Position:C15([Estimates_Machines:20]CostCtrID:4; "486")#0)  //3
			
			If ([Estimates_Machines:20]Flex_Field3:20=0)
				[Estimates_Machines:20]Qty_Gross:22:=$lastcartons
			Else 
				[Estimates_Machines:20]Qty_Gross:22:=[Estimates_Machines:20]Flex_Field3:20+$cartonWaste  //override net
				
			End if 
			$5->:=[Estimates_Machines:20]Qty_Gross:22  //upr 1463 3/29/95
			
		: (Position:C15([Estimates_Machines:20]CostCtrID:4; "585")#0)  //2
			If ([Estimates_Machines:20]Flex_Field2:19=0)
				[Estimates_Machines:20]Qty_Gross:22:=$lastcartons
			Else 
				[Estimates_Machines:20]Qty_Gross:22:=[Estimates_Machines:20]Flex_Field2:19+$cartonWaste  //override net
			End if 
		: (Position:C15([Estimates_Machines:20]CostCtrID:4; $cartonUOM)#0)  //1
			If ([Estimates_Machines:20]Flex_field1:18=0)
				[Estimates_Machines:20]Qty_Gross:22:=$lastcartons
			Else 
				[Estimates_Machines:20]Qty_Gross:22:=[Estimates_Machines:20]Flex_field1:18+$cartonWaste  //override net
			End if 
	End case 
	$gross:=Round:C94((($yldCartons+$cartonWaste)/$NumberUp); 0)
Else 
	$factor:=[Estimates_Machines:20]Qty_Waste:23/$origSpoil
	[Estimates_Machines:20]Qty_Waste:23:=Round:C94(($factor*$newAmt); 0)  //calc the new waste  
	
	$gross:=[Estimates_Machines:20]Qty_Net:24+[Estimates_Machines:20]Qty_Waste:23
	[Estimates_Machines:20]Qty_Gross:22:=$gross  //with new waste
	
	If (Position:C15([Estimates_Machines:20]CostCtrID:4; <>COATERS)#0)
		$6->:=[Estimates_Machines:20]Qty_Gross:22  //upr 1463 3/29/95
	End if 
End if 

RELATE ONE:C42([Estimates_Machines:20]CostCtrID:4)  //• need to change this line to the one below, because:  √√√

If (Position:C15([Estimates_Machines:20]CostCtrID:4; <>SHEETERS)=0)
	fCalcStdTotals([Estimates_Machines:20]Qty_Gross:22; [Estimates_Machines:20]Qty_Waste:23; [Estimates_Machines:20]Qty_Net:24)  //recalc on new gross
	
Else 
	fCalcStdTotals([Estimates_Machines:20]Qty_Gross:22; [Estimates_Machines:20]Qty_Waste:23; [Estimates_Machines:20]Qty_Net:24; ([Estimates_Machines:20]Qty_Gross:22*$length/12))  //recalc on new gross
	
End if 
//•061395  MLB  UPR 1634 added below this line

If ([Estimates_Machines:20]OutSideService:33)  //if this machine is for an outside service zero everything UPR 1148 chip 02/10/95
	
	[Estimates_Machines:20]CostLabor:13:=0
	[Estimates_Machines:20]CostOverhead:15:=0
	[Estimates_Machines:20]CostOOP:28:=0
	[Estimates_Machines:20]OOPStd:17:=0
	[Estimates_Machines:20]CostScrap:12:=0
	[Estimates_Machines:20]CostOvertime:41:=0
End if 
SAVE RECORD:C53([Estimates_Machines:20])
NEXT RECORD:C51([Estimates_Machines:20])

For ($i; 2; Records in selection:C76([Estimates_Machines:20]))
	Est_LogIt([Estimates_Machines:20]CostCtrID:4+" spoilage calc")
	If (Position:C15([Estimates_Machines:20]CostCtrID:4; $cartonUOM)#0)  //convert car
		$factor:=([Estimates_Machines:20]Qty_Waste:23/$numberUp)/$origSpoil
		[Estimates_Machines:20]Qty_Waste:23:=Round:C94(($factor*$newAmt*$numberUp); 0)  //calc the new waste  
		
		$cartonWaste:=$cartonWaste+[Estimates_Machines:20]Qty_Waste:23
		[Estimates_Machines:20]Qty_Net:24:=$lastCartons  //chg the net
		
		$lastCartons:=$lastCartons+[Estimates_Machines:20]Qty_Waste:23
		
		Case of 
			: (Position:C15([Estimates_Machines:20]CostCtrID:4; "486")#0)  //3
				If ([Estimates_Machines:20]Flex_Field3:20=0)
					// [Machine_Est]Qty_Gross:=$lastcartons`upr 164 1/6/94
					
					[Estimates_Machines:20]Qty_Net:24:=$lastcartons
				Else 
					//[Machine_Est]Qty_Gross:=[Machine_Est]Flex_Field3+$cartonWaste  `override net`upr
					
					[Estimates_Machines:20]Qty_Net:24:=[Estimates_Machines:20]Flex_Field3:20  //upr 164 1/6/94
					
				End if 
				$5->:=[Estimates_Machines:20]Qty_Gross:22  //upr 1463 3/29/95
				
			: (Position:C15([Estimates_Machines:20]CostCtrID:4; "585")#0)  //2
				If ([Estimates_Machines:20]Flex_Field2:19=0)
					// [Machine_Est]Qty_Gross:=$lastcartons`upr 164 1/6/94
					
					[Estimates_Machines:20]Qty_Net:24:=$lastcartons
				Else 
					// [Machine_Est]Qty_Gross:=[Machine_Est]Flex_Field2+$cartonWaste  `override net`up
					[Estimates_Machines:20]Qty_Net:24:=[Estimates_Machines:20]Flex_Field2:19  //upr 164 1/6/94
				End if 
				
			: (Position:C15([Estimates_Machines:20]CostCtrID:4; $cartonUOM)#0)  //1
				If ([Estimates_Machines:20]Flex_field1:18=0)
					// [Machine_Est]Qty_Gross:=$lastcartons  `upr 164 1/6/94
					[Estimates_Machines:20]Qty_Net:24:=$lastcartons
				Else 
					// [Machine_Est]Qty_Gross:=[Machine_Est]Flex_field1+$cartonWaste  `override net`up
					[Estimates_Machines:20]Qty_Net:24:=[Estimates_Machines:20]Flex_field1:18  //upr 164 1/6/94
				End if 
		End case 
		
		$gross:=$gross+Round:C94(([Estimates_Machines:20]Qty_Waste:23/$NumberUp); 0)
	Else 
		$factor:=[Estimates_Machines:20]Qty_Waste:23/$origSpoil
		[Estimates_Machines:20]Qty_Waste:23:=Round:C94(($factor*$newAmt); 0)
		[Estimates_Machines:20]Qty_Net:24:=$gross
		$gross:=$gross+[Estimates_Machines:20]Qty_Waste:23
	End if 
	[Estimates_Machines:20]Qty_Gross:22:=[Estimates_Machines:20]Qty_Waste:23+[Estimates_Machines:20]Qty_Net:24  //with new net
	
	If (Position:C15([Estimates_Machines:20]CostCtrID:4; <>COATERS)#0)  // | (Position([Machine_Est]CostCtrID;"471")#0))
		$6->:=[Estimates_Machines:20]Qty_Gross:22  //upr 1463 3/29/95
	End if 
	
	RELATE ONE:C42([Estimates_Machines:20]CostCtrID:4)  //• √√√√ see √ above
	
	If (Position:C15([Estimates_Machines:20]CostCtrID:4; <>SHEETERS)=0)
		fCalcStdTotals([Estimates_Machines:20]Qty_Gross:22; [Estimates_Machines:20]Qty_Waste:23; [Estimates_Machines:20]Qty_Net:24)  //recalc on new gross
		
	Else 
		fCalcStdTotals([Estimates_Machines:20]Qty_Gross:22; [Estimates_Machines:20]Qty_Waste:23; [Estimates_Machines:20]Qty_Net:24; ([Estimates_Machines:20]Qty_Gross:22*$length/12))  //recalc on new gross
		
	End if 
	//•061395  MLB  UPR 1634 added below this line  
	
	If ([Estimates_Machines:20]OutSideService:33)  //if this machine is for an outside service zero everything UPR 1148 chip 02/10/95
		Est_MachineInit("cost")
	End if 
	SAVE RECORD:C53([Estimates_Machines:20])
	NEXT RECORD:C51([Estimates_Machines:20])
End for 

//$3»:=$cartonWaste

$0:=$gross