//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/11/12, 09:44:29
// ----------------------------------------------------
// Method: Rama_Show_DeliverySchd
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283(<>pid_RamaDS; $winRef; $rel; $numRel)

If (Count parameters:C259=0)
	If (<>pid_RamaDS=0)
		app_Log_Usage("log"; "RAMA"; "Rama_Show_DeliverySchd")
		<>pid_RamaDS:=New process:C317("Rama_Show_DeliverySchd"; <>lMinMemPart; "Rama Delivery Schedule"; "init")
		
	Else 
		SHOW PROCESS:C325(<>pid_RamaDS)
		BRING TO FRONT:C326(<>pid_RamaDS)
	End if 
	
Else 
	If (Rama_Find_CPNs("delivery")>0)
		$winRef:=Open form window:C675([Customers_ReleaseSchedules:46]; "SimplePick"; Plain form window:K39:10)
		SET WINDOW TITLE:C213("Rama/Cayey Delivery Schedule"; $winRef)
		MESSAGE:C88("Please Wait, Loading Delivery Schedule...")
		
		ARRAY LONGINT:C221(aRecNum; 0)
		ARRAY TEXT:C222(aGCAST; 0)
		ARRAY DATE:C224(aDateSched; 0)
		ARRAY LONGINT:C221(aQtySched; 0)
		ARRAY LONGINT:C221(aQtyAct; 0)
		ARRAY LONGINT:C221(aQtyShipable; 0)
		ARRAY TEXT:C222(aPO; 0)
		ARRAY LONGINT:C221(aInvoice; 0)
		ARRAY LONGINT:C221(aRelNum; 0)
		ARRAY TEXT:C222(aOL; 0)
		
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; aRecNum; [Customers_ReleaseSchedules:46]ProductCode:11; aGCAST; [Customers_ReleaseSchedules:46]Sched_Date:5; aDateSched; [Customers_ReleaseSchedules:46]Sched_Qty:6; aQtySched; [Customers_ReleaseSchedules:46]Actual_Qty:8; aQtyAct; [Customers_ReleaseSchedules:46]CustomerRefer:3; aPO; [Customers_ReleaseSchedules:46]InvoiceNumber:9; aInvoice; [Customers_ReleaseSchedules:46]OrderLine:4; aOL; [Customers_ReleaseSchedules:46]ReleaseNumber:1; aRelNum)
		MULTI SORT ARRAY:C718(aDateSched; >; aGCAST; >; aRecNum; aQtySched; aQtyAct; aPO; aInvoice; aOL; aRelNum)
		$numRel:=Size of array:C274(aRecNum)
		ARRAY LONGINT:C221(aQtyShipable; $numRel)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			Rama_Find_CPNs("inventory")
			CREATE SET:C116([Finished_Goods_Locations:35]; "inventory")
			
			For ($rel; 1; $numRel)
				USE SET:C118("inventory")
				QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=aGCAST{$rel})
				//QUERY SELECTION([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location="FG:AV=@")
				aQtyShipable{$rel}:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			End for 
			CLEAR SET:C117("inventory")
			
		Else 
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="XC@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]KillStatus:30#0)
			
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY LONGINT:C221($_QtyOH; 0)
			C_LONGINT:C283($Nb_record)
			
			
			SELECTION TO ARRAY:C260(\
				[Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; \
				[Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
			
			$Nb_record:=Size of array:C274($_QtyOH)
			C_LONGINT:C283($sum)
			For ($rel; 1; $numRel; 1)
				$sum:=0
				For ($j; 1; Size of array:C274($_QtyOH); 1)
					If ($_ProductCode{$j}=aGCAST{$rel})
						$sum:=$sum+$_QtyOH{$j}
					End if 
				End for 
				aQtyShipable{$rel}:=$sum
			End for 
		End if   // END 4D Professional Services : January 2019 query selection
		
		FORM SET INPUT:C55([Customers_ReleaseSchedules:46]; "SimplePick")
		ADD RECORD:C56([Customers_ReleaseSchedules:46]; *)
		CLOSE WINDOW:C154($winRef)
		FORM SET INPUT:C55([Customers_ReleaseSchedules:46]; "Input")
		
	Else 
		uConfirm("No deliveries scheduled."; "OK"; "Help")
	End if 
	
	<>pid_RamaDS:=0
End if 