Case of 
	: (Form event code:C388=On Load:K2:1)
		
		ARRAY TEXT:C222(axFiles; 0)
		ARRAY INTEGER:C220(axFileNums; 0)
		C_BOOLEAN:C305(local_db)
		
		ams_get_tables
		COPY ARRAY:C226(<>axFiles; axFiles)
		COPY ARRAY:C226(<>axFileNums; axFileNums)
		
		CONFIRM:C162("aMs or WMS?"; "aMs"; "WMS")
		If (ok=1)
			local_db:=True:C214
			tText:="SELECT f.productcode AS Item, \r"
			tText:=tText+"            c.name AS Customer, \r"
			tText:=tText+"            f.bill_and_hold_qty AS BnH, \r"
			tText:=tText+"            (f.Bill_and_Hold_Qty-f.InventoryNow) as Short \r"
			tText:=tText+"   FROM finished_goods f, customers c \r"
			tText:=tText+"   WHERE c.id=f.custid \r"
			tText:=tText+"   AND f.bill_and_hold_qty>0 \r"
			ARRAY BOOLEAN:C223(Box1; 0)
			SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")  //current user
			
		Else 
			local_db:=False:C215  // will log out each time
			WMS_API_LoginLookup  //make sure <>WMS variables are up to date.
			If (WMS_SQL_Login)  //WMS_API_4D_DoLogin 
				
				
				Begin SQL
					select table_name, table_id 
					from _user_tables 
					where rest_available = true
					order by table_name 
					into :axFiles, :axFileNums
				End SQL
				//
				SQL LOGOUT:C872
				
				tText:="SELECT bin_id, qty  \r"
				tText:=tText+"   FROM bins \r"
				tText:=tText+"   WHERE rack_shelf > 0 \r"
				tText:=tText+"   AND bin_id not in \r"
				tText:=tText+"       (select distinct(bin_id) from cases \r"
				tText:=tText+"        where bin_id <> '' \r"
				tText:=tText+"        and case_status_code<>300) \r"
				tText:=tText+"   ORDER BY bin_id"
				// jobit = '999800650' \r"
			Else 
				tText:="Could not log into WMS, \rclose window and try again."
			End if 
		End if 
		ARRAY BOOLEAN:C223(Box4; Size of array:C274(axFiles))
		
	: (Form event code:C388=On Unload:K2:2)
		If (local_db)
			SQL LOGOUT:C872
		End if 
		
End case 