//%attributes = {"publishedWeb":true}
//(P) gBuildD_E
//1/12/95
//1/13/95
//upr 1407 change rounding precision to 100ths

//------------------------------------------total matl
For ($j; 1; Size of array:C274(ayA1))
	ayD2{1}:=ayD2{1}+ayA2{$j}
	ayD3{1}:=ayD3{1}+ayA3{$j}
	ayD4{1}:=ayD4{1}+ayA4{$j}
	ayD5{1}:=ayD5{1}+ayA5{$j}
	ayD6{1}:=ayD6{1}+ayA6{$j}
	ayD7{1}:=ayD7{1}+ayA7{$j}
End for 
rD8_D1:=Round:C94((ayD6{1}/[Job_Forms:42]QtyActProduced:35)*1000; 2)
//------------------------------------------total mr
For ($j; 1; Size of array:C274(ayB1))
	ayD2{2}:=ayD2{2}+ayB2{$j}
	ayD3{2}:=ayD3{2}+ayB3{$j}
	ayD4{2}:=ayD4{2}+ayB4{$j}
	ayD5{2}:=ayD5{2}+ayB5{$j}
	ayD6{2}:=ayD6{2}+ayB6{$j}
	ayD7{2}:=ayD7{2}+ayB7{$j}
End for 
//------------------------------------------total run
For ($j; 1; Size of array:C274(ayC1))
	ayD2{3}:=ayD2{3}+ayC2{$j}
	ayD3{3}:=ayD3{3}+ayC3{$j}
	ayD4{3}:=ayD4{3}+ayC4{$j}
	ayD5{3}:=ayD5{3}+ayC5{$j}
	ayD6{3}:=ayD6{3}+ayC6{$j}
	ayD7{3}:=ayD7{3}+ayC7{$j}
End for 
//------------------------------------------total conv
ayD2{4}:=ayD2{2}+ayD2{3}
ayD3{4}:=ayD3{2}+ayD3{3}
ayD4{4}:=ayD4{2}+ayD4{3}
ayD5{4}:=ayD5{2}+ayD5{3}
ayD6{4}:=ayD6{2}+ayD6{3}
ayD7{4}:=ayD7{2}+ayD7{3}
rD8_D4:=Round:C94((ayD6{4}/[Job_Forms:42]QtyActProduced:35)*1000; 2)
//------------------------------------------total mfg
ayD2{5}:=ayD2{1}+ayD2{4}
ayD3{5}:=ayD3{1}+ayD3{4}
ayD4{5}:=ayD4{1}+ayD4{4}
ayD5{5}:=ayD5{1}+ayD5{4}
ayD6{5}:=ayD6{1}+ayD6{4}
ayD7{5}:=ayD7{1}+ayD7{4}
rD8_D5:=Round:C94((ayD6{5}/[Job_Forms:42]QtyActProduced:35)*1000; 2)
//------------------------------------------Outside & Others
ayD4{6}:=[Job_Forms:42]OutsideComm:43
ayD6{6}:=[Job_Forms:42]OutsideComm:43
//------------------------------------------Direct Cost
ayD4{7}:=ayD4{5}+ayD4{6}
ayD5{7}:=(([Job_Forms:42]QtyActProduced:35*[Job_Forms:42]EstCost_M:29)/1000)
ayD6{7}:=ayD6{5}+ayD6{6}
//------------------------------------------Sales Revenue
//ayD4{8}:=??? - this was Sales Revenue until the field was dropped by Keith
//ayD6{8}:=??? - this was Sales Revenue until the field was dropped by Keith
ayD4{8}:=(([Job_Forms:42]AvgSellPrice:42*[Job_Forms:42]QtyActProduced:35)/1000)
//ayD5{8}:=(([JobForm]ProducedQty*[JobForm]ActProducedQty)/1000)  `upr 1378
ayD5{8}:=(([Job_Forms:42]AvgSellPrice:42*[Job_Forms:42]QtyWant:22)/1000)  //1/13/95
ayD6{8}:=(([Job_Forms:42]AvgSellPrice:42*[Job_Forms:42]QtyActProduced:35)/1000)
//------------------------------------------Contribution 
ayD4{9}:=ayD4{8}-ayD4{7}
//ayD5{9}:=ayD5{8}-ayD2{5}  `ayD5{7} upr 1378
ayD5{9}:=ayD5{8}-((([Job_Forms:42]EstCost_M:29*[Job_Forms:42]QtyWant:22)/1000))  //1/13/95
ayD6{9}:=ayD6{8}-ayD6{7}
//------------------------------------------Contribution Factor
If (ayD4{8}#0)
	ayD4{10}:=Round:C94(ayD4{9}/ayD4{8}; 3)
Else 
	ayD4{10}:=0
End if 
If (ayD5{8}#0)
	ayD5{10}:=Round:C94(ayD5{9}/ayD5{8}; 3)
Else 
	ayD5{10}:=0
End if 
If (ayD6{8}#0)
	ayD6{10}:=Round:C94(ayD6{9}/ayD6{8}; 3)
Else 
	ayD6{10}:=0
End if 

gWasteForm