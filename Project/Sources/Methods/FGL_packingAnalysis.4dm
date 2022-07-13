//%attributes = {"publishedWeb":true}
//PM: FGL_packing analysis() -> 
//@author Mel - 5/8/03  09:44
C_LONGINT:C283($i)
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Finished_Goods_PackingSpecs:91])
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="PackingAnalysis"
xText:="SKU"+$t+"BIN"+$t+"QTY"+$t+"PACK"+$t+"#CASES"+$t+"STD_PALLET"+$t+"PALLET_QTY"+$t+"#SKIDS"+$cr
QUERY:C277([Finished_Goods_Locations:35])
ORDER BY:C49([Finished_Goods_Locations:35])

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; Records in selection:C76([Finished_Goods_Locations:35]))
		qryFinishedGood([Finished_Goods_Locations:35]CustID:16; [Finished_Goods_Locations:35]ProductCode:1)
		QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)
		$numberOfCases:=0
		$numberOfSkids:=0
		$numberOfSkidCases:=0
		If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
			If ([Finished_Goods_PackingSpecs:91]CaseCount:2#0)
				$numberOfCases:=Round:C94([Finished_Goods_Locations:35]QtyOH:9/[Finished_Goods_PackingSpecs:91]CaseCount:2; 1)
			End if 
			If ([Finished_Goods_PackingSpecs:91]UnitsPerSkid:30#0)
				$numberOfSkids:=Round:C94([Finished_Goods_Locations:35]QtyOH:9/[Finished_Goods_PackingSpecs:91]UnitsPerSkid:30; 1)
			End if 
			$numberOfSkidCases:=[Finished_Goods_PackingSpecs:91]CasesPerSkid:29*$numberOfSkids
		End if 
		xText:=xText+[Finished_Goods_Locations:35]ProductCode:1+$t+[Finished_Goods_Locations:35]Location:2+$t+String:C10([Finished_Goods_Locations:35]QtyOH:9)+$t+String:C10([Finished_Goods_PackingSpecs:91]CaseCount:2)+$t+String:C10($numberOfCases)+$t+String:C10([Finished_Goods_PackingSpecs:91]CasesPerSkid:29)+$t+String:C10([Finished_Goods_PackingSpecs:91]UnitsPerSkid:30)+$t+String:C10($numberOfSkids)+$cr
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End for 
	
Else 
	
	ARRAY TEXT:C222($_CustID; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	ARRAY TEXT:C222($_Location; 0)
	
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]CustID:16; $_CustID; [Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH; [Finished_Goods_Locations:35]Location:2; $_Location)
	
	
	For ($i; 1; Size of array:C274($_CustID); 1)
		qryFinishedGood($_CustID{$i}; $_ProductCode{$i})
		QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)
		$numberOfCases:=0
		$numberOfSkids:=0
		$numberOfSkidCases:=0
		If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
			If ([Finished_Goods_PackingSpecs:91]CaseCount:2#0)
				$numberOfCases:=Round:C94($_QtyOH{$i}/[Finished_Goods_PackingSpecs:91]CaseCount:2; 1)
			End if 
			If ([Finished_Goods_PackingSpecs:91]UnitsPerSkid:30#0)
				$numberOfSkids:=Round:C94($_QtyOH{$i}/[Finished_Goods_PackingSpecs:91]UnitsPerSkid:30; 1)
			End if 
			$numberOfSkidCases:=[Finished_Goods_PackingSpecs:91]CasesPerSkid:29*$numberOfSkids
		End if 
		xText:=xText+$_ProductCode{$i}+$t+$_Location{$i}+$t+String:C10($_QtyOH{$i})+$t+String:C10([Finished_Goods_PackingSpecs:91]CaseCount:2)+$t+String:C10($numberOfCases)+$t+String:C10([Finished_Goods_PackingSpecs:91]CasesPerSkid:29)+$t+String:C10([Finished_Goods_PackingSpecs:91]UnitsPerSkid:30)+$t+String:C10($numberOfSkids)+$cr
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

rPrintText("PackingAnalysis.txt")

REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Finished_Goods_PackingSpecs:91]; 0)
//