// -------
// Method: 4D_Shipments   ( ) ->
// By: 4D-PS @ 03/06/19, 07:41:08
// Description
// 
// ----------------------------------------------------

$Event:=Form event code:C388
C_POINTER:C301($nil)
Case of 
	: ($Event=On Load:K2:1)
		
		If (LISTBOX Get number of columns:C831(*; "lb_Shipements")=0)
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_orderLine"; $nil; "lb_Shipements_ent_orderLine"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_orderLine"; "OrderLine")
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "lb_Shipements_col_orderLine"; Align left:K42:2)
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_productCode"; $nil; "lb_Shipements_ent_productCode"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_productCode"; "Product Code")
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "lb_Shipements_col_productCode"; Align left:K42:2)
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_po"; $nil; "lb_Shipements_ent_po"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_po"; "PO")
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_Responsable"; $nil; "lb_Shipements_ent_responsable"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_responsable"; "Rep")
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "lb_Shipements_col_Responsable"; Align center:K42:3)
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_quantite"; $nil; "lb_Shipements_ent_quantite"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_quantite"; "Quantity")
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_billing"; $nil; "lb_Shipements_ent_billing"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_billing"; "Billing")
			OBJECT SET FORMAT:C236(*; "lb_Shipements_col_billing"; "###,###,##0;(###,###,##0);")
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_Actual"; $nil; "lb_Shipements_ent_Actual"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_Actual"; "Actual")
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "lb_Shipements_col_Actual"; Align right:K42:4)
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_dayvar"; $nil; "lb_Shipements_ent_dayvar"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_dayvar"; "On time")
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "lb_Shipements_col_dayvar"; Align center:K42:3)
			
			//LISTBOX INSERT COLUMN(*;"lb_Shipements";1000;"lb_Shipements_col_lastrelease";$nil;"lb_Shipements_ent_lastrelease";$nil)
			//OBJECT SET TITLE(*;"lb_Shipements_ent_lastrelease";"Last")
			//OBJECT SET HORIZONTAL ALIGNMENT(*;"lb_Shipements_col_lastrelease";Align center)
			
			LISTBOX INSERT COLUMN:C829(*; "lb_Shipements"; 1000; "lb_Shipements_col_customer"; $nil; "lb_Shipements_ent_customer"; $nil)
			OBJECT SET TITLE:C194(*; "lb_Shipements_ent_customer"; "Customer")
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "lb_Shipements_col_customer"; Align left:K42:2)
			
			OBJECT SET ENTERABLE:C238(*; "lb_Shipements_col_@"; False:C215)
			
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
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=Add to date:C393(Current date:C33; 0; 0; -7))  //get a small range
			$ptr_Date_begin->:=Min:C4([Customers_ReleaseSchedules:46]Actual_Date:7)
			$ptr_Date_end->:=Max:C3([Customers_ReleaseSchedules:46]Actual_Date:7)
			
			$Pt_show:=OBJECT Get pointer:C1124(Object named:K67:5; "show")
			C_LONGINT:C283($Pt_courant->)
			$Pt_show->:=1
			//%W-518.5
			ARRAY TEXT:C222($ptr_Shipements_orderLine->; 0)
			ARRAY TEXT:C222($ptr_Shipements_productCode->; 0)
			ARRAY TEXT:C222($ptr_Shipements_PO->; 0)
			ARRAY TEXT:C222($ptr_Shipements_Responsable->; 0)
			ARRAY DATE:C224($ptr_Shipements_actual->; 0)
			//ARRAY BOOLEAN($ptr_Shipements_lastrelease->;0)
			ARRAY TEXT:C222($ptr_Shipements_customer->; 0)
			ARRAY REAL:C219($ptr_Shipements_billing->; 0)
			//%W+518.5
			
			ARRAY DATE:C224($_Sched_Date; 0)
			ARRAY DATE:C224($_Actual_Date; 0)
			ARRAY LONGINT:C221($_Actual_Qty; 0)
			//ARRAY LONGINT($_OriginalRelQty;0)
			ARRAY REAL:C219($_Unit_Price; 0)
			
			
			//C_DATE($Date_begin;$Date_end)
			//$Date_begin:=$ptr_Date_begin->
			//$Date_end:=$ptr_Date_end->
			
			
			//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]Actual_Date>=$ptr_Date_begin->;*)
			//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]Actual_Date<=$ptr_Date_end->)
			
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
			
			//[Customers_ReleaseSchedules]OriginalRelQty;$_OriginalRelQty;\
				
			SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
			$Nb_lignes:=Size of array:C274($ptr_Shipements_Responsable->)
			ARRAY REAL:C219($ptr_Shipements_billing->; $Nb_lignes)
			ARRAY LONGINT:C221($ptr_Shipements_dayvar->; $Nb_lignes)
			
			For ($Iter; 1; $Nb_lignes; 1)
				
				$ptr_Shipements_dayvar->{$Iter}:=$_Sched_Date{$Iter}-$_Actual_Date{$Iter}
				$ptr_Shipements_billing->{$Iter}:=Round:C94($_Unit_Price{$Iter}*$_Actual_Qty{$Iter}/1000; 0)
				
			End for 
			
			
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_orderLine"; 70)
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_productCode"; 100)
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_po"; 100)
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_Responsable"; 40)
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_dayvar"; 60)
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_quantite"; 75)
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_billing"; 75)
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_Actual"; 75)
			//LISTBOX SET COLUMN WIDTH(*;"lb_Shipements_col_lastrelease";50)//
			LISTBOX SET COLUMN WIDTH:C833(*; "lb_Shipements_col_customer"; 150)
		End if 
		
End case 