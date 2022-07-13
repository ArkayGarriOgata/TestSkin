//(LP)[FG_Locations.CostAnalysisRpt
//mod 9/13/94 upr 120
//12/8/94
//1/20/95
//•072998  MLB  use actual ocst if job is closed
Case of 
	: (Form event code:C388=On Printing Break:K2:19)
		If (Level:C101=2)
			t3a:=""
			qryJMI([Finished_Goods_Locations:35]JobForm:19; 0; [Finished_Goods_Locations:35]ProductCode:1)
			
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]ItemNumber:7; $aitem; [Job_Forms_Items:44]FormClosed:5; $abClosed)
			For ($i; 1; Size of array:C274($aitem))
				t3a:=t3a+String:C10($aitem{$i}; "00")+" "
				If ($abClosed{$i}) & (<>UseActCost)  //•072998  MLB  
					t3a:=t3a+"Closed"+" "
				End if 
			End for 
			
			//QUERY([JobMakesItem];[JobMakesItem]ProductCode=[FG_Locations]ProductCode;*)
			//SEARCH([JobMakesItem]; & [JobMakesItem]CustId=[FG_Locations]CustID;*)
			//QUERY([JobMakesItem]; & ;[JobMakesItem]JobForm=[FG_Locations]JobForm)
			//While (Not(End selection([JobMakesItem])))
			//t3a:=t3a+String([JobMakesItem]ItemNumber;"00")+" "
			//If ([JobMakesItem]FormClosed) & (◊UseActCost)  `•072998  MLB  
			//t3a:=t3a+"Closed"+" "
			//End if 
			//NEXT RECORD([JobMakesItem])
			//End while 
		End if 
		//
		//: (In header)  `12/8/94
		//If (Level=2)
		//  `open demand calc'd before report is printed
		//End if 
		//
	: (Form event code:C388=On Display Detail:K2:22)  //each 
		real1:=[Finished_Goods_Locations:35]QtyOH:9
		real2:=0
		real3:=0
		real4:=0
		real5:=0
		real6:=0
		real7:=0  //prep
		real8:=0
		real9:=0
		If (([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Locations:35]ProductCode:1) | ([Job_Forms_Items:44]CustId:15#[Finished_Goods_Locations:35]CustID:16) | ([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19))
			qryJMI([Finished_Goods_Locations:35]JobForm:19; 0; [Finished_Goods_Locations:35]ProductCode:1)
		End if 
		
		C_LONGINT:C283($hit)
		$hit:=Find in array:C230(<>aOrdKey; ([Finished_Goods_Locations:35]CustID:16+":"+[Finished_Goods_Locations:35]ProductCode:1))  //aFGKey
		If ($hit>-1)
			openDemand:=<>aQty_Open{$hit}+<>aQty_ORun{$hit}  //aOpenDemand{$hit}
		Else 
			openDemand:=0
		End if 
		//  If (([JobMakesItem]ItemNumber>=50) & (Count parameters>5))  `old excess item 
		Case of 
			: (openDemand<=0)  //none of this bin is valued
				real2:=real2+[Finished_Goods_Locations:35]QtyOH:9
				openDemand:=openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			: (openDemand>=[Finished_Goods_Locations:35]QtyOH:9)  //all of this bin is valued
				real3:=real3+[Finished_Goods_Locations:35]QtyOH:9
				openDemand:=openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			: (openDemand<[Finished_Goods_Locations:35]QtyOH:9)  //some of this bin is valued          
				real3:=real3+openDemand
				real2:=real2+([Finished_Goods_Locations:35]QtyOH:9-openDemand)
				openDemand:=openDemand-[Finished_Goods_Locations:35]QtyOH:9
				
			Else 
				BEEP:C151
				ALERT:C41("Error called by (LP)CostAnalysisRpt, openDemand test failed.")
		End case 
		
		//aOpenDemand{$hit}:=openDemand  `1/20/95
		If ($hit>-1)
			<>aQty_Open{$hit}:=openDemand
			<>aQty_ORun{$hit}:=0
		End if 
		
		If ([Job_Forms_Items:44]FormClosed:5) & (<>UseActCost)  //•072998  MLB  
			real4:=real4+Round:C94(([Job_Forms_Items:44]Cost_Mat:12*(real3/1000)); 0)
			real5:=real5+Round:C94(([Job_Forms_Items:44]Cost_LAB:13*(real3/1000)); 0)
			real6:=real6+Round:C94(([Job_Forms_Items:44]Cost_Burd:14*(real3/1000)); 0)
			real9:=real9+Round:C94(([Job_Forms_Items:44]Cost_SE:16*(real3/1000)); 0)
		Else 
			real4:=real4+Round:C94(([Job_Forms_Items:44]PldCostMatl:17*(real3/1000)); 0)
			real5:=real5+Round:C94(([Job_Forms_Items:44]PldCostLab:18*(real3/1000)); 0)
			real6:=real6+Round:C94(([Job_Forms_Items:44]PldCostOvhd:19*(real3/1000)); 0)
			real9:=real9+Round:C94(([Job_Forms_Items:44]PldCostS_E:20*(real3/1000)); 0)
		End if 
		
		real8:=real4+real5+real6
End case 
//