//%attributes = {"publishedWeb":true}
//(p) rPiFgBinCountRpt
//Created 2/28/97 cs upr 1858
//codifying a quick report Melissa usesd for Cycle count/Phys Inventory

C_TIME:C306(vDoc)

t2:=""
vDoc:=?00:00:00?

PiPrepReport  //§ get user selection of records to print

If (Records in selection:C76([Finished_Goods_Locations:35])>0)  //§  if records are found
	util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "PiFGAdjSummry")  //§   Display print dialogs
	PRINT SETTINGS:C106
	If (OK=1)  //user wants to contiue printing
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			uRelateSelect(->[Job_Forms_Items:44]JobForm:1; ->[Finished_Goods_Locations:35]JobForm:19)  //§  locate related record information
			CREATE SET:C116([Job_Forms_Items:44]; "Jobs")
			uRelateSelect(->[Job_Forms_Items:44]ProductCode:3; ->[Finished_Goods_Locations:35]ProductCode:1)
			CREATE SET:C116([Job_Forms_Items:44]; "Prod")
			INTERSECTION:C121("Jobs"; "Prod"; "Jobs")
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1)
			CREATE SET:C116([Finished_Goods:26]; "Products")
			
		Else 
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items:44])+" file. Please Wait...")
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY TEXT:C222($_JobForm; 0)
			SELECTION TO ARRAY:C260(\
				[Finished_Goods_Locations:35]JobForm:19; $_JobForm; \
				[Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
			
			QUERY WITH ARRAY:C644([Job_Forms_Items:44]JobForm:1; $_JobForm)
			CREATE SET:C116([Job_Forms_Items:44]; "Jobs")
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items:44])+" file. Please Wait...")
			QUERY WITH ARRAY:C644([Job_Forms_Items:44]ProductCode:3; $_ProductCode)
			CREATE SET:C116([Job_Forms_Items:44]; "Prod")
			INTERSECTION:C121("Jobs"; "Prod"; "Jobs")
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
			RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "Products")
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		USE SET:C118("Jobs")
		CLEAR SET:C117("Jobs")
		CLEAR SET:C117("Prod")
		$Count:=Records in selection:C76([Job_Forms_Items:44])  //§   Setup arrays for processing
		ARRAY TEXT:C222(aCpn; $Count)
		ARRAY REAL:C219(aActCost; $Count)
		ARRAY TEXT:C222(aJob2; $Count)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]JobForm:1; aJob2; [Job_Forms_Items:44]ProductCode:3; aCpn; [Job_Forms_Items:44]ActCost_M:27; aActCost)
		uClearSelection(->[Job_Forms_Items:44])
		USE SET:C118("Products")
		CLEAR SET:C117("Products")
		ARRAY TEXT:C222(aUOM; Records in selection:C76([Finished_Goods:26]))
		ARRAY TEXT:C222(aCPN2; Records in selection:C76([Finished_Goods:26]))
		SELECTION TO ARRAY:C260([Finished_Goods:26]Acctg_UOM:29; aUOM; [Finished_Goods:26]ProductCode:1; aCPN2)
		uClearSelection(->[Finished_Goods:26])
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2; >; [Finished_Goods_Locations:35]ProductCode:1; >)
		
		If (OK=1)  //user did not cancel sort
			t2:="F/G Phys Inv Adjust for '"+t2+"' "
			
			If (fSave)  //user wants to save to disk      
				vDoc:=Create document:C266("PiAdjSummry")
				SEND PACKET:C103(vDoc; t2+Char:C90(13))
				SEND PACKET:C103(vDoc; "Location"+Char:C90(9)+"Product Code"+Char:C90(9)+"JobForm"+Char:C90(9)+"Item"+Char:C90(9)+"Quantity OnHand"+Char:C90(9)+"ModWho"+Char:C90(13))
			Else 
				vDoc:=?00:00:00?
			End if 
			BREAK LEVEL:C302(1)
			ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9; [Finished_Goods_Locations:35]PiFreezeQty:28; rReal3; rReal4)
			FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "PiFGAdjSummry")
			PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
			FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "list")
		End if 
	End if 
	uClearSelection(->[Finished_Goods_Locations:35])
Else 
	ALERT:C41("No Bins currently exist for your request.")
End if 
If (vDoc#?00:00:00?)
	CLOSE DOCUMENT:C267(vDoc)
End if 

$Count:=0

ARRAY TEXT:C222(aUOM; $Count)
ARRAY TEXT:C222(aCPN2; $Count)
ARRAY TEXT:C222(aCpn; $Count)
ARRAY REAL:C219(aActCost; $Count)
ARRAY TEXT:C222(aJob2; $Count)