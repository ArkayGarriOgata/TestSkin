//%attributes = {"publishedWeb":true}
//gRptQuoteBody: Set up Body of Quote
//mod 3/24/94 upr 1085
//•10.12.94 upr 1136, 1134b
//•upr 1458 4.5.95
//•051195 upr 1483 doubling of qtys
//•051195 UPR 1476 add yld qty and price

C_LONGINT:C283($1; $j; $qtyWnt; $qtyYld; $2)
C_TEXT:C284($t; $item; $r)
C_BOOLEAN:C305($break)
C_TEXT:C284(sFinish)
C_TEXT:C284(sIntro)

$r:=Char:C90(13)
$j:=$1  //case index
$t:="   "
//*Get & sort the cartons of this differential
//MESSAGE(Char(13)+"          Finding carton specs ")
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=asCaseID{$j})
ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)

sIntro:=String:C10($j)+") "+(30*"-")+$r+"ESTIMATE: "+$t+[Estimates:17]EstimateNo:1+" Differential: "+asCaseID{$j}+$r+$r
sIntro:=sIntro+"PRICE DETAIL: "+[Estimates_Differentials:38]PriceDetails:29+$r+$r
If (Records in selection:C76([Estimates_Carton_Specs:19])>0) & (Records in selection:C76([Process_Specs:18])>0)
	sIntro:=sIntro+"DESCRIPTION:"+$t+[Estimates:17]Brand:3+$r+$r
	sIntro:=sIntro+"PRODUCT CODE"+$t+"SIZE"+$t+"STYLE"+$t+"QUANTITY"+$t+"PRICE"+$t  //•051195 UPR 1476
	sIntro:=sIntro+"YIELD"+$t+"PRICE"+Char:C90(13)  //•051195 UPR 1476
	//*For each carton selected 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([Estimates_Carton_Specs:19])
		
	Else 
		
		// see line 21
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	While (Not:C34(End selection:C36([Estimates_Carton_Specs:19])))
		//MESSAGE(Char(13)+"           "+[Estimates_Carton_Specs]Item+"  "+[Estimates_Carton_Specs]ProductCode)
		//*.     Test if there is obsolete inventory for "Changed" items
		If (([Estimates_Carton_Specs:19]OriginalOrRepeat:9="Change") & ([Estimates_Carton_Specs:19]ObsoleteCPN:63#""))
			//MESSAGE(Char(13)+"           "+"Checking for obsolete inventory.")
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Estimates_Carton_Specs:19]CustID:6+":"+[Estimates_Carton_Specs:19]ObsoleteCPN:63)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
			If (Records in selection:C76([Finished_Goods:26])=1)
				ALERT:C41(String:C10(Sum:C1([Finished_Goods_Locations:35]QtyOH:9); "###,###,##0")+" of obsolete "+[Finished_Goods:26]ProductCode:1+" is available for sale.")
			End if 
		End if   //obsolete should be entered  
		
		//*.      look forward for the same item, upr 1458 4.5.95
		//.                 because each item maybe on multiple forms
		$break:=False:C215  // in case we reach the eof
		$item:=[Estimates_Carton_Specs:19]Item:1  //compare item
		$qtyWnt:=[Estimates_Carton_Specs:19]Quantity_Want:27  //accum qty
		$qtyYld:=[Estimates_Carton_Specs:19]Quantity_Yield:29  //•051195 UPR 1476
		If (Not:C34(<>modification4D_13_02_19)) | (<>disable_4DPS_mod)  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			While ((Not:C34(End selection:C36([Estimates_Carton_Specs:19]))) & (Not:C34($break)))  //not the last one
				NEXT RECORD:C51([Estimates_Carton_Specs:19])  //look forward
				If (Not:C34(End selection:C36([Estimates_Carton_Specs:19])))
					
					If ($item#[Estimates_Carton_Specs:19]Item:1)
						PREVIOUS RECORD:C110([Estimates_Carton_Specs:19])  //go back
						$qtyWnt:=$qtyWnt-[Estimates_Carton_Specs:19]Quantity_Want:27  //don't want add it to itself
						$qtyYld:=$qtyYld-[Estimates_Carton_Specs:19]Quantity_Yield:29  //•051195 UPR 1476
						$break:=True:C214
					Else 
						$qtyWnt:=$qtyWnt+[Estimates_Carton_Specs:19]Quantity_Want:27
						$qtyYld:=$qtyYld+[Estimates_Carton_Specs:19]Quantity_Yield:29  //•051195 UPR 1476
					End if 
					
				Else   //oops, too far
					LAST RECORD:C200([Estimates_Carton_Specs:19])  //get back into the selection
					$qtyWnt:=$qtyWnt-[Estimates_Carton_Specs:19]Quantity_Want:27  //•051195 upe 1483 don't want add it to itself
					$qtyYld:=$qtyYld-[Estimates_Carton_Specs:19]Quantity_Yield:29  //•051195 UPR 1476
					$break:=True:C214
				End if 
			End while 
			
		Else 
			
			//correct bug last release 03-28-2019 
			//need more detail
			
			ARRAY LONGINT:C221($_Quantity_Want; 0)
			ARRAY LONGINT:C221($_Quantity_Yield; 0)
			ARRAY TEXT:C222($_Item; 0)
			
			SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]Quantity_Want:27; $_Quantity_Want; \
				[Estimates_Carton_Specs:19]Quantity_Yield:29; $_Quantity_Yield; \
				[Estimates_Carton_Specs:19]Item:1; $_Item)
			$n:=Size of array:C274($_Quantity_Want)+1
			$i:=0
			While (($i<$n) & (Not:C34($break)))  //not the last one
				
				$i:=$i+1
				
				If ($i<$n)
					
					If ($item#$_Item{$i})
						$i:=$i-1
						$qtyWnt:=$qtyWnt-$_Quantity_Want{$i}  //don't want add it to itself
						$qtyYld:=$qtyYld-$_Quantity_Yield{$i}  //•051195 UPR 1476
						$break:=True:C214
					Else 
						$qtyWnt:=$qtyWnt+$_Quantity_Want{$i}
						$qtyYld:=$qtyYld+$_Quantity_Yield{$i}  //•051195 UPR 1476
					End if 
					
				Else   //oops, too far
					$i:=$n-1
					$qtyWnt:=$qtyWnt-$_Quantity_Want{$i}  //•051195 upe 1483 don't want add it to itself
					$qtyYld:=$qtyYld-$_Quantity_Yield{$i}  //•051195 UPR 1476
					$break:=True:C214
				End if 
			End while 
			
		End if   // END 4D Professional Services : January 2019 
		
		sIntro:=sIntro+[Estimates_Carton_Specs:19]ProductCode:5
		
		C_TEXT:C284($dim_A; $dim_B; $dem_ht)
		$success:=FG_getDimensions(->$dim_A; ->$dim_B; ->$dem_ht; [Estimates_Carton_Specs:19]OutLineNumber:15; [Estimates_Carton_Specs:19]ProductCode:5)
		If ($success)
			$dims:=" "+$dim_A+" * "+$dim_B+" * "+$dem_ht
		Else 
			$dims:=" *** dimensions unavailable *** "
		End if 
		
		sIntro:=sIntro+$t+$dims  //String([Estimates_Carton_Specs]Width_Dec;"###0.0###")+" x "+String([Estimates_Carton_Specs]Depth_Dec;"###0.0###")+" x "+String([Estimates_Carton_Specs]Height_Dec;"###0.0###")
		sIntro:=sIntro+$t+" ("+[Estimates_Carton_Specs:19]Style:4
		If ([Estimates_Carton_Specs:19]OutLineNumber:15#"")
			sIntro:=sIntro+" #"+[Estimates_Carton_Specs:19]OutLineNumber:15+")"
		Else 
			sIntro:=sIntro+")"
		End if 
		
		sIntro:=sIntro+$t+String:C10(([Estimates_Carton_Specs:19]Quantity_Want:27+$qtyWnt); "###,###,###")+$t+"@ "+String:C10([Estimates_Carton_Specs:19]PriceWant_Per_M:28; "$###,##0.00")+"/M"
		If ([Estimates_Carton_Specs:19]PriceYield_PerM:30#0)  //•051195 UPR 1476
			sIntro:=sIntro+$t+String:C10(([Estimates_Carton_Specs:19]Quantity_Yield:29+$qtyYld); "###,###,###")+$t+"@ "+String:C10([Estimates_Carton_Specs:19]PriceYield_PerM:30; "$###,##0.00")+"/M"  //•051195 UPR 1476
		End if 
		sIntro:=sIntro+$r
		//
		sIntro:=sIntro+(10*" ")+[Estimates_Carton_Specs:19]Description:14+"; "+String:C10([Estimates_Carton_Specs:19]OverRun:47)+"% Over, "+String:C10([Estimates_Carton_Specs:19]UnderRun:48)+"% Under; "
		If ([Estimates_Carton_Specs:19]SecurityLabels:43)
			sIntro:=sIntro+" Security Labels Applied; "
		End if 
		
		If ([Estimates_Carton_Specs:19]StripHoles:46)
			sIntro:=sIntro+" Windowed; "
		End if 
		sIntro:=sIntro+$r+$r
		
		If (False:C215)  //•051195 upr 1476 cathy falk said they delete this stuff anyway
			sIntro:=sIntro+[Estimates_Carton_Specs:19]GlueType:41+" Glueing; "
			sIntro:=sIntro+[Estimates_Carton_Specs:19]DieCutOptions:49+" Die Cut; "
		End if   //false
		
		NEXT RECORD:C51([Estimates_Carton_Specs:19])
	End while 
	sIntro:=sIntro+$r
	
	//MESSAGE(Char(13)+"           "+"Plates, Dies, and/or Dupes")
	If ([Estimates_Differentials:38]BreakOutSpls:18)  //break out plates dies and dups
		//MESSAGE(Char(13)+"           "+"Plates, Dies, and/or Dupes")
		sIntro:=sIntro+"CUTTING & CREASING DIES"+$t+$t+$t+$t+String:C10([Estimates_Differentials:38]Prc_Dies:22; "$###,##0.00")+$r
		sIntro:=sIntro+"PLATES"+$t+$t+$t+$t+String:C10([Estimates_Differentials:38]Prc_Plates:23; "$###,##0.00")+$r
		sIntro:=sIntro+"DUPES"+$t+$t+$t+$t+String:C10([Estimates_Differentials:38]Prc_Dups:24; "$###,##0.00")+$r
	End if 
	
	//Warning:  This code assumes that there will be only 1 Process Spec
	//MESSAGE(Char(13)+"          Process specs ")
	sIntro:=sIntro+PSpec_DescriptionInText+$r+$r
	
	
	If (Count parameters:C259=1)
		sIntro:=sIntro+"PREPARATION:"+$t+"To be determined upon receipt of final art."+$r+$r
		sIntro:=sIntro+"PACKING:"+$t+"275lb Test Corrugated Cartons "+[Estimates_Carton_Specs:19]SpecialPacking:50+$r+$r
		sIntro:=sIntro+"TERMS:"+$t+[Estimates:17]Terms:7+$r+$r
		sIntro:=sIntro+xText2+$r+$r  //closing
		
		sIntro:=sIntro+"Respectfully,"+$r+$r+$r
		//MESSAGE(Char(13)+"       Closing ")
		QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=[Estimates:17]Sales_Rep:13)
		sIntro:=sIntro+[Salesmen:32]FirstName:3+" "+[Salesmen:32]MI:4+" "+[Salesmen:32]LastName:2
		If ([Salesmen:32]Title:6#"")
			sIntro:=sIntro+", "+[Salesmen:32]Title:6
		End if 
		sIntro:=sIntro+$r
		sIntro:=sIntro+[Salesmen:32]BusTitle:7+$r
	End if 
	
Else 
	ALERT:C41("Carton Detail or Process Spec does not exist for the Estimate.")
End if 