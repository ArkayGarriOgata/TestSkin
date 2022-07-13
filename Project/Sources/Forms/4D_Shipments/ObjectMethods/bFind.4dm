$Evt:=Form event code:C388
Case of 
	: ($evt=On Clicked:K2:4)
		
		
		$ptr_Shipements_orderLine:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_orderLine")
		$ptr_Shipements_productCode:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_productCode")
		$ptr_Shipements_PO:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_po")
		$ptr_Shipements_Responsable:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_Responsable")
		$ptr_Shipements_quantite:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_quantite")
		$ptr_Shipements_billing:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_billing")
		$ptr_Shipements_dayvar:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_dayvar")
		$ptr_Shipements_actual:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_Actual")
		//$ptr_Shipements_lastrelease:=OBJECT Get pointer(Object named;"lb_Shipements_col_lastrelease")
		$ptr_Shipements_customer:=OBJECT Get pointer:C1124(Object named:K67:5; "lb_Shipements_col_customer")
		
		$ptr_Date_begin:=OBJECT Get pointer:C1124(Object named:K67:5; "Date_begin")
		$ptr_Date_end:=OBJECT Get pointer:C1124(Object named:K67:5; "Date_end")
		C_DATE:C307($ptr_Date_begin->; $ptr_Date_end->)
		//$ptr_Date_begin->:=!2016-09-15!  //Current date
		//$ptr_Date_end->:=$ptr_Date_begin->
		$Nb_lignes:=Size of array:C274($ptr_Shipements_orderLine->)
		If ($Nb_lignes>0)
			
			DELETE FROM ARRAY:C228($ptr_Shipements_orderLine->; 1; $Nb_lignes)
			DELETE FROM ARRAY:C228($ptr_Shipements_productCode->; 1; $Nb_lignes)
			DELETE FROM ARRAY:C228($ptr_Shipements_PO->; 1; $Nb_lignes)
			DELETE FROM ARRAY:C228($ptr_Shipements_Responsable->; 1; $Nb_lignes)
			DELETE FROM ARRAY:C228($ptr_Shipements_quantite->; 1; $Nb_lignes)
			DELETE FROM ARRAY:C228($ptr_Shipements_dayvar->; 1; $Nb_lignes)
			DELETE FROM ARRAY:C228($ptr_Shipements_actual->; 1; $Nb_lignes)
			//DELETE FROM ARRAY($ptr_Shipements_lastrelease->;1;$Nb_lignes)
			DELETE FROM ARRAY:C228($ptr_Shipements_customer->; 1; $Nb_lignes)
			
		End if 
		//%W-518.5
		ARRAY TEXT:C222($ptr_Shipements_orderLine->; 0)
		ARRAY TEXT:C222($ptr_Shipements_productCode->; 0)
		ARRAY TEXT:C222($ptr_Shipements_PO->; 0)
		ARRAY TEXT:C222($ptr_Shipements_Responsable->; 0)
		//ARRAY BOOLEAN($ptr_Shipements_lastrelease->;0)
		ARRAY TEXT:C222($ptr_Shipements_customer->; 0)
		ARRAY REAL:C219($ptr_Shipements_billing->; 0)
		//%W+518.5
		
		ARRAY DATE:C224($_Sched_Date; 0)
		ARRAY DATE:C224($_Actual_Date; 0)
		ARRAY LONGINT:C221($_Actual_Qty; 0)
		//ARRAY LONGINT($_OriginalRelQty;0)
		
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=$ptr_Date_begin->; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7<=$ptr_Date_end->)
		
		GET FIELD RELATION:C920([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
		SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; Automatic:K51:4; Do not modify:K51:1)
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustomerRefer:3; $ptr_Shipements_PO->; \
			[Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; \
			[Customers_ReleaseSchedules:46]Actual_Date:7; $_Actual_Date; \
			[Customers_ReleaseSchedules:46]Actual_Qty:8; $ptr_Shipements_quantite->; \
			[Customers_Order_Lines:41]CustomerName:24; $ptr_Shipements_customer->; \
			[Customers_ReleaseSchedules:46]OrderLine:4; $ptr_Shipements_orderLine->; \
			[Customers_ReleaseSchedules:46]ProductCode:11; $ptr_Shipements_productCode->; \
			[Customers_Order_Lines:41]SalesRep:34; $ptr_Shipements_Responsable->; \
			[Customers_Order_Lines:41]Price_Per_M:8; $_Unit_Price; \
			[Customers_ReleaseSchedules:46]Actual_Qty:8; $_Actual_Qty; \
			[Customers_ReleaseSchedules:46]Actual_Date:7; $ptr_Shipements_actual->)
		
		SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
		$Nb_lignes:=Size of array:C274($ptr_Shipements_Responsable->)
		ARRAY REAL:C219($ptr_Shipements_billing->; $Nb_lignes)
		ARRAY LONGINT:C221($ptr_Shipements_dayvar->; $Nb_lignes)
		
		For ($Iter; 1; $Nb_lignes; 1)
			
			$ptr_Shipements_dayvar->{$Iter}:=$_Sched_Date{$Iter}-$_Actual_Date{$Iter}
			$ptr_Shipements_billing->{$Iter}:=Round:C94($_Unit_Price{$Iter}*$_Actual_Qty{$Iter}/1000; 0)
			
		End for 
		
End case 