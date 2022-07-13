//%attributes = {}
// Method: Loreal_Optis_Export
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/13/13, 13:55:24
// ----------------------------------------------------
// Description:
// Calculate price breakdown as needed for Loreal RFQ spreadsheet
// ----------------------------------------------------
// Modified by: Mel Bohince (5/31/13) don't multiprint form headings and increment pricing row for multi forms
// Modified by: Mel Bohince (3/10/17) add the non-board RM and show the perM without materials

C_TEXT:C284($t; $r)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$r:=Char:C90(13)

docName:="Loreal_RFQ_"+[Estimates_Differentials:38]Id:1+"_"+String:C10(TSTimeStamp)+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	C_TEXT:C284(xTitle; xText; docName)
	xText:=""
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//Desc of which differenctial an offer for global markups
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//>>>>>>>>>>>>>>>>>>>>>>>>
	xTitle:=[Estimates_Differentials:38]Id:1+$t+$t+$t+"Markups:"+$t+"Material"+$t+"1"+$r
	xTitle:=xTitle+[Estimates_Differentials:38]PSpec_Qty_TAG:25+($t*4)+"MR"+$t+"1"+$r
	xTitle:=xTitle+[Estimates_Differentials:38]ProcessSpec:5+($t*4)+"Run"+$t+"1"
	
	FIRST RECORD:C50([Estimates_DifferentialsForms:47])
	FIRST RECORD:C50([Estimates_Carton_Specs:19])
	If (Length:C16([Estimates_DifferentialsForms:47]ProcessSpec:23)>0)
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_DifferentialsForms:47]ProcessSpec:23)  //assume 1 pspec /diff
	Else 
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_Differentials:38]ProcessSpec:5)  //assume 1 pspec /diff
	End if 
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//accumulate costs by form and print
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//>>>>>>>>>>>>>>>>>>>>>>>>
	$form_board:=0
	$form_ink:=0
	$form_varnish:=0
	$form_leaf:=0
	$form_window:=0
	$form_laminate:=0
	$form_other:=0
	$form_corrugate:=0
	
	$form_MR_printing:=0
	$form_MR_stamping:=0
	$form_MR_gluing:=0
	$form_MR_blanking:=0
	$form_MR_other:=0
	
	$form_RUN_printing:=0
	$form_RUN_stamping:=0
	$form_RUN_gluing:=0
	$form_RUN_blanking:=0
	$form_RUN_other:=0
	// Modified by: Mel Bohince (5/31/13) don't multiprint form headings and increment pricing row for multi forms
	xText:=xText+"form"+$t+"board"+$t+"ink"+$t+"varnish"+$t+"leaf"+$t+"window"+$t+"laminate"+$t+"other"+$t+"corrugate"
	xText:=xText+$t+"printingMR"+$t+"stampingMR"+$t+"gluingMR"+$t+"blankingMR"+$t+"otherMR"
	xText:=xText+$t+"printingRUN"+$t+"stampingRUN"+$t+"gluingRUN"+$t+"blankingRUN"+$t+"otherRUN"+$r
	$price_row:=5  //start at the column labels
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([Estimates_DifferentialsForms:47])
		
		
		While (Not:C34(End selection:C36([Estimates_DifferentialsForms:47])))
			$price_row:=$price_row+1  // Modified by: Mel Bohince (5/31/13) don't multiprint form headings and increment pricing row for multi forms
			$numfound:=Loreal_Optis_Machine_Cost("init"; [Estimates_DifferentialsForms:47]DiffFormId:3)  //load ttl costs into arrays by cc group
			$numfound:=Loreal_Optis_Material_Cost("init"; [Estimates_DifferentialsForms:47]DiffFormId:3)  //load ttl costs into arrays by rm commodity
			
			$sform_board:=Loreal_Optis_Material_Cost("get"; "board")
			$sform_ink:=Loreal_Optis_Material_Cost("get"; "ink")
			$sform_varnish:=Loreal_Optis_Material_Cost("get"; "varnish")
			$sform_leaf:=Loreal_Optis_Material_Cost("get"; "leaf")
			$sform_window:=Loreal_Optis_Material_Cost("get"; "window")
			$sform_laminate:=Loreal_Optis_Material_Cost("get"; "laminate")
			$sform_other:=0  // this would be plates and dies which are break-outs   :=Loreal_Optis_Material_Cost ("get";"other")
			$sform_corrugate:=Loreal_Optis_Material_Cost("get"; "corrugate")
			
			xText:=xText+[Estimates_DifferentialsForms:47]DiffFormId:3
			xText:=xText+$t+String:C10($sform_board)
			xText:=xText+$t+String:C10($sform_ink)
			xText:=xText+$t+String:C10($sform_varnish)
			xText:=xText+$t+String:C10($sform_leaf)
			xText:=xText+$t+String:C10($sform_window)
			xText:=xText+$t+String:C10($sform_laminate)
			xText:=xText+$t+String:C10($sform_other)
			xText:=xText+$t+String:C10($sform_corrugate)
			
			
			$sform_MR_printing:=Loreal_Optis_Machine_Cost("getMR"; "printing")
			$sform_MR_stamping:=Loreal_Optis_Machine_Cost("getMR"; "stamping")
			$sform_MR_gluing:=Loreal_Optis_Machine_Cost("getMR"; "gluing")
			$sform_MR_blanking:=Loreal_Optis_Machine_Cost("getMR"; "blanking")
			$sform_MR_other:=Loreal_Optis_Machine_Cost("getMR"; "other")
			
			$sform_RUN_printing:=Loreal_Optis_Machine_Cost("getRUN"; "printing")
			$sform_RUN_stamping:=Loreal_Optis_Machine_Cost("getRUN"; "stamping")
			$sform_RUN_gluing:=Loreal_Optis_Machine_Cost("getRUN"; "gluing")
			$sform_RUN_blanking:=Loreal_Optis_Machine_Cost("getRUN"; "blanking")
			$sform_RUN_other:=Loreal_Optis_Machine_Cost("getRUN"; "other")
			
			xText:=xText+$t+String:C10($sform_MR_printing)
			xText:=xText+$t+String:C10($sform_MR_stamping)
			xText:=xText+$t+String:C10($sform_MR_gluing)
			xText:=xText+$t+String:C10($sform_MR_blanking)
			xText:=xText+$t+String:C10($sform_MR_other)
			
			xText:=xText+$t+String:C10($sform_RUN_printing)
			xText:=xText+$t+String:C10($sform_RUN_stamping)
			xText:=xText+$t+String:C10($sform_RUN_gluing)
			xText:=xText+$t+String:C10($sform_RUN_blanking)
			xText:=xText+$t+String:C10($sform_RUN_other)
			xText:=xText+$r
			
			$form_board:=$form_board+$sform_board
			$form_ink:=$form_ink+$sform_ink
			$form_varnish:=$form_varnish+$sform_varnish
			$form_leaf:=$form_leaf+$sform_leaf
			$form_window:=$form_window+$sform_window
			$form_laminate:=$form_laminate+$sform_laminate
			$form_other:=$form_other+$sform_other
			$form_corrugate:=$form_corrugate+$sform_corrugate
			
			$form_MR_printing:=$form_MR_printing+$sform_MR_printing
			$form_MR_stamping:=$form_MR_stamping+$sform_MR_stamping
			$form_MR_gluing:=$form_MR_gluing+$sform_MR_gluing
			$form_MR_blanking:=$form_MR_blanking+$sform_MR_blanking
			$form_MR_other:=$form_MR_other+$sform_MR_other
			
			$form_RUN_printing:=$form_RUN_printing+$sform_RUN_printing
			$form_RUN_stamping:=$form_RUN_stamping+$sform_RUN_stamping
			$form_RUN_gluing:=$form_RUN_gluing+$sform_RUN_gluing
			$form_RUN_blanking:=$form_RUN_blanking+$sform_RUN_blanking
			$form_RUN_other:=$form_RUN_other+$sform_RUN_other
			
			NEXT RECORD:C51([Estimates_DifferentialsForms:47])
		End while 
		
		
		
	Else 
		
		// see line 32
		
		ARRAY TEXT:C222($_DiffFormId; 0)
		SELECTION TO ARRAY:C260([Estimates_DifferentialsForms:47]DiffFormId:3; $_DiffFormId)
		
		For ($Iter; 1; Size of array:C274($_DiffFormId); 1)
			$price_row:=$price_row+1  // Modified by: Mel Bohince (5/31/13) don't multiprint form headings and increment pricing row for multi forms
			$numfound:=Loreal_Optis_Machine_Cost("init"; $_DiffFormId{$Iter})  //load ttl costs into arrays by cc group
			$numfound:=Loreal_Optis_Material_Cost("init"; $_DiffFormId{$Iter})  //load ttl costs into arrays by rm commodity
			
			$sform_board:=Loreal_Optis_Material_Cost("get"; "board")
			$sform_ink:=Loreal_Optis_Material_Cost("get"; "ink")
			$sform_varnish:=Loreal_Optis_Material_Cost("get"; "varnish")
			$sform_leaf:=Loreal_Optis_Material_Cost("get"; "leaf")
			$sform_window:=Loreal_Optis_Material_Cost("get"; "window")
			$sform_laminate:=Loreal_Optis_Material_Cost("get"; "laminate")
			$sform_other:=0  // this would be plates and dies which are break-outs   :=Loreal_Optis_Material_Cost ("get";"other")
			$sform_corrugate:=Loreal_Optis_Material_Cost("get"; "corrugate")
			
			xText:=xText+$_DiffFormId{$Iter}
			xText:=xText+$t+String:C10($sform_board)
			xText:=xText+$t+String:C10($sform_ink)
			xText:=xText+$t+String:C10($sform_varnish)
			xText:=xText+$t+String:C10($sform_leaf)
			xText:=xText+$t+String:C10($sform_window)
			xText:=xText+$t+String:C10($sform_laminate)
			xText:=xText+$t+String:C10($sform_other)
			xText:=xText+$t+String:C10($sform_corrugate)
			
			
			$sform_MR_printing:=Loreal_Optis_Machine_Cost("getMR"; "printing")
			$sform_MR_stamping:=Loreal_Optis_Machine_Cost("getMR"; "stamping")
			$sform_MR_gluing:=Loreal_Optis_Machine_Cost("getMR"; "gluing")
			$sform_MR_blanking:=Loreal_Optis_Machine_Cost("getMR"; "blanking")
			$sform_MR_other:=Loreal_Optis_Machine_Cost("getMR"; "other")
			
			$sform_RUN_printing:=Loreal_Optis_Machine_Cost("getRUN"; "printing")
			$sform_RUN_stamping:=Loreal_Optis_Machine_Cost("getRUN"; "stamping")
			$sform_RUN_gluing:=Loreal_Optis_Machine_Cost("getRUN"; "gluing")
			$sform_RUN_blanking:=Loreal_Optis_Machine_Cost("getRUN"; "blanking")
			$sform_RUN_other:=Loreal_Optis_Machine_Cost("getRUN"; "other")
			
			xText:=xText+$t+String:C10($sform_MR_printing)
			xText:=xText+$t+String:C10($sform_MR_stamping)
			xText:=xText+$t+String:C10($sform_MR_gluing)
			xText:=xText+$t+String:C10($sform_MR_blanking)
			xText:=xText+$t+String:C10($sform_MR_other)
			
			xText:=xText+$t+String:C10($sform_RUN_printing)
			xText:=xText+$t+String:C10($sform_RUN_stamping)
			xText:=xText+$t+String:C10($sform_RUN_gluing)
			xText:=xText+$t+String:C10($sform_RUN_blanking)
			xText:=xText+$t+String:C10($sform_RUN_other)
			xText:=xText+$r
			
			$form_board:=$form_board+$sform_board
			$form_ink:=$form_ink+$sform_ink
			$form_varnish:=$form_varnish+$sform_varnish
			$form_leaf:=$form_leaf+$sform_leaf
			$form_window:=$form_window+$sform_window
			$form_laminate:=$form_laminate+$sform_laminate
			$form_other:=$form_other+$sform_other
			$form_corrugate:=$form_corrugate+$sform_corrugate
			
			$form_MR_printing:=$form_MR_printing+$sform_MR_printing
			$form_MR_stamping:=$form_MR_stamping+$sform_MR_stamping
			$form_MR_gluing:=$form_MR_gluing+$sform_MR_gluing
			$form_MR_blanking:=$form_MR_blanking+$sform_MR_blanking
			$form_MR_other:=$form_MR_other+$sform_MR_other
			
			$form_RUN_printing:=$form_RUN_printing+$sform_RUN_printing
			$form_RUN_stamping:=$form_RUN_stamping+$sform_RUN_stamping
			$form_RUN_gluing:=$form_RUN_gluing+$sform_RUN_gluing
			$form_RUN_blanking:=$form_RUN_blanking+$sform_RUN_blanking
			$form_RUN_other:=$form_RUN_other+$sform_RUN_other
		End for 
		
		
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//print the substotal for the forms
	//>>>>>>>>>>>>>>>>>>>>>>>>
	xText:=xText+"__________"+(($t+"__________")*18)+$r
	
	xText:=xText+"Total All Forms:"
	xText:=xText+$t+String:C10($form_board)
	xText:=xText+$t+String:C10($form_ink)
	xText:=xText+$t+String:C10($form_varnish)
	xText:=xText+$t+String:C10($form_leaf)
	xText:=xText+$t+String:C10($form_window)
	xText:=xText+$t+String:C10($form_laminate)
	xText:=xText+$t+String:C10($form_other)
	xText:=xText+$t+String:C10($form_corrugate)
	
	xText:=xText+$t+String:C10($form_MR_printing)
	xText:=xText+$t+String:C10($form_MR_stamping)
	xText:=xText+$t+String:C10($form_MR_gluing)
	xText:=xText+$t+String:C10($form_MR_blanking)
	xText:=xText+$t+String:C10($form_MR_other)
	
	xText:=xText+$t+String:C10($form_RUN_printing)
	xText:=xText+$t+String:C10($form_RUN_stamping)
	xText:=xText+$t+String:C10($form_RUN_gluing)
	xText:=xText+$t+String:C10($form_RUN_blanking)
	xText:=xText+$t+String:C10($form_RUN_other)
	xText:=xText+$r
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//print default markup supplied at the top of this method
	//>>>>>>>>>>>>>>>>>>>>>>>>
	xText:=xText+"MarkUp"
	xText:=xText+(($t+"=R1C6")*8)+(($t+"=R2C6")*5)+(($t+"=R3C6")*5)
	xText:=xText+$r
	xText:=xText+"=========="+(($t+"==========")*18)+$t+"TOTAL"+$r
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//print price as formula of cost/(1-markup)
	//>>>>>>>>>>>>>>>>>>>>>>>>
	xText:=xText+"Price"
	xText:=xText+(($t+"=R[-3]C/R[-2]C")*18)+$t+"=SUM(RC[-18]:RC[-1])"+$r
	xText:=xText+$r+$r
	
	$price_row:=$price_row+5
	$price_row_as_string:="=R"+String:C10($price_row)  // Modified by: Mel Bohince (5/31/13) don't multiprint form headings and increment pricing row for multi forms
	
	//some stuff for the "Technical definition" section
	//see gPresswork 
	$form_front_colors:=$t+String:C10([Process_Specs:18]ColorsNumLineOS:28+[Process_Specs:18]ColorsNumProcOS:30+[Process_Specs:18]ColorsNumScreen:34)
	$form_back_colors:=$t+String:C10([Process_Specs:18]iColorLL:56+[Process_Specs:18]iColorLP:57+[Process_Specs:18]iColorsSS:58)
	$form_coating:=$t+[Process_Specs:18]Coat1Type:13+"/"+[Process_Specs:18]Coat2Type:15+"/"+[Process_Specs:18]Varn1Gloss:32+"/"+[Process_Specs:18]Varn2Gloss:48
	$form_stamp:=$t+[Process_Specs:18]Stamp1:41
	$form_windowed:=$t+(Num:C11([Process_Specs:18]Windowed:50)*"YES")
	$form_embossed:=$t+(Num:C11([Process_Specs:18]Embossing:77)*"YES")
	$form_boardtype:=$t+[Process_Specs:18]Stock:7
	FIRST RECORD:C50([Estimates_DifferentialsForms:47])
	$form_dims:=$t+String:C10([Estimates_DifferentialsForms:47]Width:5)+" x "+String:C10([Estimates_DifferentialsForms:47]Lenth:6)
	$form_area:=$t+String:C10([Estimates_DifferentialsForms:47]Width:5*[Estimates_DifferentialsForms:47]Lenth:6; "#,###")
	If ([Estimates_DifferentialsForms:47]Caliper:32>0)
		$form_caliper:=$t+String:C10([Estimates_DifferentialsForms:47]Caliper:32)
	Else 
		$form_caliper:=$t+String:C10([Process_Specs:18]Caliper:8)
	End if 
	$form_up:=$t+String:C10([Estimates_DifferentialsForms:47]NumberUpOverrid:30)
	
	//now allocate cost from above to the cartons on a per thousand basis and print
	
	SEND PACKET:C103($docRef; xTitle+$r+$r)
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//print labels for item section
	//>>>>>>>>>>>>>>>>>>>>>>>>
	xText:=xText+"productcode"+$t+"allocation"+$t+"qty"+$t+"carton_dim"+$t+"sheet_dim"+$t+"sheet_surface"+$t+"board_type"+$t+"caliper"+$t+$t+"up"+$t+"front_colors"+$t+"back_colors"+$t+"windowed"+$t+"embossed"+$t+"stamped"+$t+"coating"
	xText:=xText+$t+"prnMR"+$t+"stampMR"+$t+"glueMR"+$t+"blankMR"+$t+"otherMR"  //+$t+"totalMR"  //"fixed cost section
	
	xText:=xText+$t+"board$"+$t+"ink$"+$t+"varnish$"+$t+"foil$"+$t+"window$"+$t+"laminate$"+$t+"other$"  //variable raw material section
	xText:=xText+$t+"prnRUN"+$t+"stampRUN"+$t+"glueRUN"+$t+"blankRUN"+$t+"otherRUN"+$t+"corrugate$"
	xText:=xText+$t+"Backtest"+$t+"PerM"
	xText:=xText+$t+"NotBoardRM"+$t+"OtherPricing"  // Modified by: Mel Bohince (3/10/17)
	xText:=xText+$r  //variable production costs section
	$count_of_items:=0
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//print distributed price for each item
	//>>>>>>>>>>>>>>>>>>>>>>>>
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		While (Not:C34(End selection:C36([Estimates_Carton_Specs:19])))
			If (Length:C16(xText)>25000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			$count_of_items:=$count_of_items+1
			C_TEXT:C284($dim_A; $dim_B; $dem_ht)
			$success:=FG_getDimensions(->$dim_A; ->$dim_B; ->$dem_ht; [Estimates_Carton_Specs:19]OutLineNumber:15; [Estimates_Carton_Specs:19]ProductCode:5)
			If ($success)
				$dims:=$t+$dim_A+" * "+$dim_B+" * "+$dem_ht
			Else 
				$dims:=$t+" *** dimensions unavailable *** "
			End if 
			xText:=xText+[Estimates_Carton_Specs:19]Item:1+") "+[Estimates_Carton_Specs:19]ProductCode:5+$t+String:C10([Estimates_Carton_Specs:19]AllocationPercent:58; "0.0000")+$t+String:C10([Estimates_Carton_Specs:19]Quantity_Want:27)+$dims+$form_dims+$form_area+$form_boardtype+$form_caliper+$t+$form_up+$form_front_colors+$form_back_colors+$form_windowed+$form_embossed+$form_stamp+$form_coating
			
			//Total SqIn=TSI:=Sum{(SqIn*Qty)}   already calc'd by estimate engine in [Estimates_Carton_Specs]AllocationPercent
			//
			//Allocation%=AP:=(thisSqIn*thisQty)/TSI  already calc'd by estimate engine in [Estimates_Carton_Specs]AllocationPercent
			//
			//Jobitem Distribution=JD:=AP*$ttl  see below
			//
			//perM:=JD/thisQty   see below
			
			//$wantM:=[Estimates_Carton_Specs]Quantity_Want/1000
			//$allocation:=[Estimates_Carton_Specs]AllocationPercent
			//xText:=xText+$t+String(Round($allocation*$form_MR_printing/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_MR_stamping/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_MR_gluing/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_MR_blanking/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_MR_other/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*($form_MR_printing+$form_MR_stamping+$form_MR_gluing+$form_MR_blanking+$form_MR_other)/$wantM;3))
			//
			//xText:=xText+$t+String(Round($allocation*$form_board/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_ink/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_varnish/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_leaf/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_window/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_laminate/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_other/$wantM;3))
			//
			//xText:=xText+$t+String(Round($allocation*$form_RUN_printing/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_RUN_stamping/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_RUN_blanking/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_RUN_gluing/$wantM;3))
			//xText:=xText+$t+String(Round($allocation*$form_RUN_other/$wantM;3))
			//
			//
			//xText:=xText+$t+String(Round($allocation*$form_corrugate/$wantM;3))
			//>>>>>>>>>>>>>>>>>>>>>>>>
			//print fixed (MakeReady) formulii !!! not in perM !!!
			//>>>>>>>>>>>>>>>>>>>>>>>>
			xText:=xText+$t+$price_row_as_string+"C10*RC2"  //like:  +"=R11C10*RC2"
			xText:=xText+$t+$price_row_as_string+"C11*RC2"  // /(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C12*RC2"  // /(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C13*RC2"  // /(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C14*RC2"  // /(RC3/1000)"
			//xText:=xText+$t+"=(R11C10+R11C11+R11C12+R11C13+R11C14)*RC2/(RC3/1000)"`don't need total MR, loreal sheet calcs this
			//>>>>>>>>>>>>>>>>>>>>>>>>
			//print material formulii
			//>>>>>>>>>>>>>>>>>>>>>>>>
			xText:=xText+$t+$price_row_as_string+"C2*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C3*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C4*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C5*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C6*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C7*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C8*RC2/(RC3/1000)"
			//>>>>>>>>>>>>>>>>>>>>>>>>
			//print variable production formulii
			//>>>>>>>>>>>>>>>>>>>>>>>>
			xText:=xText+$t+$price_row_as_string+"C15*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C16*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C17*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C18*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C19*RC2/(RC3/1000)"
			//>>>>>>>>>>>>>>>>>>>>>>>>
			//print corrugate formulii
			//>>>>>>>>>>>>>>>>>>>>>>>>
			xText:=xText+$t+$price_row_as_string+"C9*RC2/(RC3/1000)"
			//>>>>>>>>>>>>>>>>>>>>>>>>
			//print back test
			//>>>>>>>>>>>>>>>>>>>>>>>>
			xText:=xText+$t+"=(RC[-18]+RC[-17]+RC[-16]+RC[-15]+RC[-14])+((RC[-13]+RC[-12]+RC[-11]+RC[-10]+RC[-9]+RC[-8]+RC[-7]+RC[-6]+RC[-5]+RC[-4]+RC[-3]+RC[-2]+RC[-1])*(RC[-32]/1000))"
			xText:=xText+$t+"=RC[-1]/(RC[-33]/1000)"
			xText:=xText+$t+"=RC23+RC24+RC25+RC26+RC27+RC28"+$t+"=RC36-(RC22+RC37)"  // Modified by: Mel Bohince (3/10/17) 
			//xText:=xText+$t+"=RC[-1]*RC[-33]/1000"
			
			xText:=xText+$r
			NEXT RECORD:C51([Estimates_Carton_Specs:19])
		End while 
		
		
	Else 
		
		ARRAY TEXT:C222($_OutLineNumber; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_Item; 0)
		ARRAY REAL:C219($_AllocationPercent; 0)
		ARRAY LONGINT:C221($_Quantity_Want; 0)
		
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]OutLineNumber:15; $_OutLineNumber; \
			[Estimates_Carton_Specs:19]ProductCode:5; $_ProductCode; \
			[Estimates_Carton_Specs:19]Item:1; $_Item; \
			[Estimates_Carton_Specs:19]AllocationPercent:58; $_AllocationPercent; \
			[Estimates_Carton_Specs:19]Quantity_Want:27; $_Quantity_Want)
		
		$i:=1
		$n:=Size of array:C274($_Quantity_Want)
		$n:=$n+1
		
		While ($i<$n)
			If (Length:C16(xText)>25000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			$count_of_items:=$count_of_items+1
			C_TEXT:C284($dim_A; $dim_B; $dem_ht)
			$success:=FG_getDimensions(->$dim_A; ->$dim_B; ->$dem_ht; $_OutLineNumber{$i}; $_ProductCode{$i})
			If ($success)
				$dims:=$t+$dim_A+" * "+$dim_B+" * "+$dem_ht
			Else 
				$dims:=$t+" *** dimensions unavailable *** "
			End if 
			xText:=xText+$_Item{$i}+") "+$_ProductCode{$i}+$t+String:C10($_AllocationPercent{$i}; "0.0000")+$t+String:C10($_Quantity_Want{$i})+$dims+$form_dims+$form_area+$form_boardtype+$form_caliper+$t+$form_up+$form_front_colors+$form_back_colors+$form_windowed+$form_embossed+$form_stamp+$form_coating
			xText:=xText+$t+$price_row_as_string+"C10*RC2"  //like:  +"=R11C10*RC2"
			xText:=xText+$t+$price_row_as_string+"C11*RC2"  // /(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C12*RC2"  // /(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C13*RC2"  // /(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C14*RC2"  // /(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C2*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C3*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C4*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C5*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C6*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C7*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C8*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C15*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C16*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C17*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C18*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C19*RC2/(RC3/1000)"
			xText:=xText+$t+$price_row_as_string+"C9*RC2/(RC3/1000)"
			xText:=xText+$t+"=(RC[-18]+RC[-17]+RC[-16]+RC[-15]+RC[-14])+((RC[-13]+RC[-12]+RC[-11]+RC[-10]+RC[-9]+RC[-8]+RC[-7]+RC[-6]+RC[-5]+RC[-4]+RC[-3]+RC[-2]+RC[-1])*(RC[-32]/1000))"
			xText:=xText+$t+"=RC[-1]/(RC[-33]/1000)"
			xText:=xText+$t+"=RC23+RC24+RC25+RC26+RC27+RC28"+$t+"=RC36-(RC22+RC37)"  // Modified by: Mel Bohince (3/10/17) 
			xText:=xText+$r
			
			$i:=$i+1
			
		End while 
		
		
	End if   // END 4D Professional Services : January 2019 
	xText:=xText+($t*34)+"=SUM(R[-"+String:C10($count_of_items)+"]C:R[-1]C)"
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
	$err:=util_Launch_External_App(docName)
	
Else 
	uConfirm("Couldn't create file "+docName; "OK"; "Help")
End if   //doc created