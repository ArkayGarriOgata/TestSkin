//(LP)[Jobform].ProductionClose  1/23/95 upr 167
//5/2/95 upr 1493 chip
//• 5/23/97 cs upr 1870
//• 12/5/97 cs added messages to allow user to see ewomething is happpening during
//  load of layout
Case of 
	: (Form event code:C388=On Load:K2:1)
		MESSAGES OFF:C175
		zwStatusMsg("CLOSEOUT"; "Calculating variances")
		//v1.0.3-JJG (03/28/17) - obsolete and unused to boot //C_GRAPH(ggGraph)
		ARRAY TEXT:C222(aCharts; 5)
		aCharts{1}:="Pick a Chart"
		aCharts{2}:="MR Var"
		aCharts{3}:="Run Var"
		aCharts{4}:="Total Var"
		aCharts{5}:="Sht Qty Var"
		aCharts:=1
		ARRAY TEXT:C222(ayD1; 1)  //used also in mRptCloseout
		ARRAY REAL:C219(ayD2; 1)  //used also in mRptCloseout
		ayD1{1}:="Pick a Chart"
		ayD2{1}:=0
		//GRAPH(ggGraph;1;ayD1;ayD2)  //5/2/95, initializes graph, should stop crashing on selecting graph 
		//GRAPH SETTINGS(ggGraph;0;0;0;10;False;False;False;"")  //5/2/95
		
		OBJECT SET ENABLED:C1123(bDummy; False:C215)
		OBJECT SET ENABLED:C1123(bValidate; False:C215)
		
		ARRAY TEXT:C222(ayA1; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayB2; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayB3; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayB4; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayB5; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayC2; 0)
		ARRAY REAL:C219(ayC3; 0)
		ARRAY REAL:C219(ayC4; 0)
		ARRAY REAL:C219(ayC5; 0)
		//MESSAGE("Gathering Machine data..."+Char(13))  `• 12/5/97 cs 
		
		
		Jobform_load_related
		
		ARRAY TEXT:C222($aTitle; 12)
		$aTitle{1}:=txt_Pad("Board$"; " "; -1; 15)  //+Char(13)
		$aTitle{2}:=txt_Pad("Ink$"; " "; -1; 15)  //+Char(13)
		$aTitle{3}:=txt_Pad("Coating$"; " "; -1; 15)  //+Char(13)
		$aTitle{4}:=txt_Pad("Plate$"; " "; -1; 15)  //+Char(13)
		$aTitle{5}:=txt_Pad("Leaf$"; " "; -1; 15)  //+Char(13)
		$aTitle{6}:=txt_Pad("Corrugate$"; " "; -1; 15)  //+Char(13)
		$aTitle{7}:=txt_Pad("Stamping$"; " "; -1; 15)  //+Char(13)
		$aTitle{8}:=txt_Pad("Lamination$"; " "; -1; 15)  //+Char(13)
		$aTitle{9}:=txt_Pad("Laser$"; " "; -1; 15)  //+Char(13)
		$aTitle{10}:=txt_Pad("OtherMatl$"; " "; -1; 15)  //+Char(13)
		$aTitle{11}:=txt_Pad("Security"; " "; -1; 15)  //+Char(13)
		$aTitle{12}:=txt_Pad("Total$"; " "; -1; 15)  //+Char(13)
		
		$real:=Job_MaterialSummary("init")
		xText:=""
		For ($i; 1; 12; 2)
			xText:=xText+$aTitle{$i}
			xText:=xText+String:C10(Job_MaterialSummary("get"; $i; 1); "^^^,^^0 ;(^^,^^0);     *  ")+"  "
			xText:=xText+String:C10(Job_MaterialSummary("get"; $i; 2); "^^^,^^0 ;(^^,^^0);     *  ")+"  "
			xText:=xText+String:C10(Job_MaterialSummary("get"; $i; 3); "^^^,^^0U;^^^,^^0F;     *  ")+" "
			xText:=xText+String:C10(Job_MaterialSummary("get"; $i; 4); "^^^,^^0U;^^^,^^0F;     *  ")+" "  //+Char(13)
			
			xText:=xText+$aTitle{$i+1}
			xText:=xText+String:C10(Job_MaterialSummary("get"; $i+1; 1); "^^^,^^0 ;(^^,^^0);     *  ")+"  "
			xText:=xText+String:C10(Job_MaterialSummary("get"; $i+1; 2); "^^^,^^0 ;(^^,^^0);     *  ")+"  "
			xText:=xText+String:C10(Job_MaterialSummary("get"; $i+1; 3); "^^^,^^0U;^^^,^^0F;     *  ")+" "
			xText:=xText+String:C10(Job_MaterialSummary("get"; $i+1; 4); "^^^,^^0U;^^^,^^0F;     *  ")+Char:C90(13)
		End for 
		//xText:=xText+$aTitle{11}
		//xText:=xText+String(Job_MaterialSummary ("get";11;1);"^^^,^^0 ;(^^,^^0);     *  ")+"  "
		//xText:=xText+String(Job_MaterialSummary ("get";11;2);"^^^,^^0 ;(^^,^^0);     *  ")+"  "
		//xText:=xText+String(Job_MaterialSummary ("get";11;3);"^^^,^^0U;^^^,^^0F;     *  ")+" "
		//xText:=xText+String(Job_MaterialSummary ("get";11;4);"^^^,^^0U;^^^,^^0F;     *  ")+Char(13)
		
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7; >)
		
		//JOB_RollupActuals 
		zwStatusMsg("Get Actuals"; "Please Wait...")
		wWindowTitle("Push"; "Jobform {actuals} Calculating "+[Job_Forms:42]JobFormID:5+" Please Wait...")
		jobform:=[Job_Forms:42]JobFormID:5
		Job_ExecuteOnServer("client-prep"; "get-actuals"; jobform)
		zwStatusMsg("SERVER REQUEST"; "Waiting for "+jobform)
		fCalcAlloc:=Job_ExecuteOnServer("exchange")
		wWindowTitle("Pop")
		zwStatusMsg("Allocate Actuals"; "Finished.")
		
		
		RELATE MANY:C262([Job_Forms:42]JobFormID:5)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
			FIRST RECORD:C50([Job_Forms_Machines:43])
			
		Else 
			
			ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
			
		End if   // END 4D Professional Services : January 2019 First record
		
		//• mlb - 9/27/01  15:54 Get totals
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; ayA1; [Job_Forms_Machines:43]Planned_MR_Hrs:15; ayB2; [Job_Forms_Machines:43]Actual_MR_Hrs:24; ayC2; [Job_Forms_Machines:43]Planned_RunHrs:37; ayB3; [Job_Forms_Machines:43]Actual_RunHrs:40; ayC3; [Job_Forms_Machines:43]Planned_Qty:10; ayB5; [Job_Forms_Machines:43]Actual_Qty:19; ayC5)
		ARRAY REAL:C219(ayB4; Size of array:C274(ayB2))
		ARRAY REAL:C219(ayC4; Size of array:C274(ayB2))
		real5:=0
		real6:=0
		real7:=0
		real8:=0
		For ($i; 1; Size of array:C274(ayB2))
			real5:=real5+ayB2{$i}
			real6:=real6+ayB3{$i}
			real7:=real7+ayC2{$i}
			real8:=real8+ayC3{$i}
			ayB4{$i}:=ayB2{$i}+ayB3{$i}
			ayC4{$i}:=ayC2{$i}+ayC3{$i}
		End for 
		real9:=real7-real5
		real10:=real8-real6
		
		//• 5/23/97 cs upr 1870
		Case of   //this insures that there is NO problem with data entry order (length v width)
			: ([Job_Forms:42]ShortGrain:48)  //if these are the same size pick one
				$length:=[Job_Forms:42]Width:23
			Else   //if this is NORMAL grain, use the LARGEST entered measurement
				$Length:=[Job_Forms:42]Lenth:24
		End case 
		$Length:=$Length/12
		
		//MESSAGE("Gathering Issues..."+Char(13))  `• 12/5/97 cs 
		r2a:=[Job_Forms:42]EstGrossSheets:27*$length
		r1:=Round:C94(([Job_Forms:42]EstWasteSheets:34/[Job_Forms:42]EstNetSheets:28*100); 0)
		
		READ ONLY:C145([Raw_Materials_Transactions:23])
		READ ONLY:C145([Raw_Materials:21])
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]CommodityCode:24=1; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5)
		ARRAY TEXT:C222($aRMcode; 0)
		ARRAY REAL:C219(arQuantity; 0)
		SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Qty:6; arQuantity; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; $aRMcode)
		REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
		r2:=0
		For ($i; 1; Size of array:C274(arQuantity))
			r2:=r2+(arQuantity{$i}*-1)
		End for 
		
		If (r2#0)
			SORT ARRAY:C229(arQuantity; $aRMcode; >)
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$aRMcode{1})
			If ([Raw_Materials:21]IssueUOM:10="SHT")
				r2:=r2*$length
			End if 
			REDUCE SELECTION:C351([Raw_Materials:21]; 0)
		End if 
		
		ARRAY TEXT:C222($aRMcode; 0)
		ARRAY REAL:C219(arQuantity; 0)
		ARRAY LONGINT:C221(aXferQty; 0)
		
		$numberGlued:=0
		$numberGood:=0
		
		$numberGlued:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
		
		$numberGood:=Sum:C1([Job_Forms_Items:44]Qty_Good:10)
		
		r4:=0  //actual spoilage
		$actGoodShts:=($numberGood/[Job_Forms:42]NumberUp:26)*$length
		r4:=Round:C94(((r2-$actGoodShts)/$actGoodShts)*100; 0)
		r3:=0  //gross spoilage
		$actGoodShts:=($numberGlued/[Job_Forms:42]NumberUp:26)*$length
		r3:=Round:C94(((r2-$actGoodShts)/$actGoodShts)*100; 0)
		
	: (Form event code:C388=On Unload:K2:2)
		aCharts:=1
		//GRAPH(ggGraph;1;ayD1;ayD2)
		//GRAPH SETTINGS(ggGraph;0;0;0;10;False;False;False;"")
		
		ARRAY TEXT:C222(ayA1; 0)  //used also in mRptCloseout
		ARRAY TEXT:C222(ayD1; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayD2; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayB2; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayB3; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayB4; 0)  //used also in mRptCloseout
		ARRAY REAL:C219(ayB5; 0)  //used also in mRptCloseout
		//ARRAY REAL(ayB6;0)
		//ARRAY REAL(ayB7;0)
		ARRAY REAL:C219(ayC2; 0)
		ARRAY REAL:C219(ayC3; 0)
		ARRAY REAL:C219(ayC4; 0)
		ARRAY REAL:C219(ayC5; 0)
		//ARRAY REAL(ayC6;0)
		//ARRAY REAL(ayC7;0)  `
End case 
//