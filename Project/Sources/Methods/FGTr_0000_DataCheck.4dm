//%attributes = {}
//Method:  FGTr_0000_DataCheck
//Description:  This method imports missing [Finished_Goods_Transactions]

//Step 1:  Create duplicate document from current datafile
//Step 2:  Export missing data using source datafile

//PreImport:  Open in Numbers delete the duplicate columns and save as csv

//Step 3:  Import missing data into current datafile as csv
//    At the end change blob field to be pk_id and update trailers appropriately

//Remove this in the trigger for [Finished_Goods_Transactions]

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bFull50k)
	C_BOOLEAN:C305($bShipped)
	C_BOOLEAN:C305($bNotShipped)
	
	C_BOOLEAN:C305($bExport)
	
	C_BOOLEAN:C305($bSetFull50k)
	C_BOOLEAN:C305($bSetShipped)
	C_BOOLEAN:C305($bSetNotShipped)
	
	C_BOOLEAN:C305($bImport)
	
	C_TEXT:C284($tpk_id)
	
	ARRAY TEXT:C222($atpk_id; 0)
	ARRAY POINTER:C280($apColumn; 0)
	
	APPEND TO ARRAY:C911($apColumn; ->$atpk_id)
	
	$bDuplicate:=False:C215  //*** Step 1 current data file
	
	$bFull50k:=False:C215
	$bShipped:=False:C215
	$bNotShipped:=False:C215
	
	$bExport:=False:C215  //*** Step 2  source data file
	
	$bSetFull50k:=False:C215
	$bSetShipped:=False:C215
	$bSetNotShipped:=False:C215
	
	$bImport:=True:C214  //*** Step 3 current data file
	
End if   //Done initialize

Case of   //Step
		
	: ($bDuplicate)  //Duplicate
		
		Case of   //Data
				
			: ($bFull50k)  //Full 50k+
				
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=!2019-01-01!)
				
			: ($bShipped)  //pkIDs shipped from 01/01/2019
				
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=!2021-01-01!; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=!2021-03-21!; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
				
			: ($bNotShipped)  //Import not shipped from 04/01/2020
				
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=!2020-04-01!; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=Current date:C33(*); *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
				
		End case   //Done data
		
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]pk_id:37; $atpk_id)
		
		$tpk_id:=Core_Array_ToTextT(->$atpk_id; CorektCR)
		
		TEXT TO DOCUMENT:C1237("Users:garriogata:Desktop:Duplicate.txt"; $tpk_id)  //Name document duplicate
		
	: ($bExport)  //Export missing data to import into production
		
		Case of   //Set
				
			: ($bSetFull50k)
				
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=!2019-01-01!)
				
			: ($bSetShipped)
				
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=!2019-01-01!; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=!2021-03-21!; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
				
			: ($bSetNotShipped)
				
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=!2020-04-01!; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=Current date:C33(*); *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
				
		End case   //Done set
		
		CREATE SET:C116([Finished_Goods_Transactions:33]; "Good")
		
		Core_Array_FromDocument(->$apColumn)
		
		QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Transactions:33]pk_id:37; $atpk_id)
		
		CREATE SET:C116([Finished_Goods_Transactions:33]; "Duplicate")
		
		DIFFERENCE:C122("Good"; "Duplicate"; "AddThese")
		
		USE SET:C118("AddThese")
		
		FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "Export")
		
		EXPORT DATA:C666(CorektBlank)
		
		FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "List")
		
	: ($bImport)  //Import
		
		FORM SET INPUT:C55([Finished_Goods_Transactions:33]; "Export")
		
		IMPORT DATA:C665(CorektBlank)
		
		FORM SET INPUT:C55([Finished_Goods_Transactions:33]; "Input")
		
End case   //Done step
