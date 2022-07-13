
//◊iLayout:=9932
//• 8/13/97 cs added support for typing first charater of file name

Case of 
	: (Form event code:C388=On Load:K2:1)
		ams_get_tables
		
		C_LONGINT:C283(<>hlFiles)
		<>hlFiles:=New list:C375
		For ($i; 1; Size of array:C274(<>axFiles))
			APPEND TO LIST:C376(<>hlFiles; <>axFiles{$i}; <>axFileNums{$i})
			
			//make italic
			If (Substring:C12(<>axFiles{$i}; 1; 1)="x") | (Substring:C12(<>axFiles{$i}; 1; 1)="y")
				SET LIST ITEM PROPERTIES:C386(<>hlFiles; 0; False:C215; 2; 0)
			End if 
			
			//make bold
			If (Position:C15(<>axFiles{$i}; " Customers Finished_Goods Raw_Materials Jobs Purchase_Orders ")>0)
				SET LIST ITEM PROPERTIES:C386(<>hlFiles; 0; False:C215; 1; 0)
			End if 
			If (Position:C15(<>axFiles{$i}; " Estimates Customers_Orders Job_Forms_Items  Process_Specs")>0)
				SET LIST ITEM PROPERTIES:C386(<>hlFiles; 0; False:C215; 1; 0)
			End if 
		End for 
		
		rbSearchEd:=1
		
		$itemPosition:=Selected list items:C379(<>hlFiles)
		$tableNumber:=0
		GET LIST ITEM:C378(<>hlFiles; $itemPosition; $tableNumber; $tableName)
		If ($tableNumber>0)
			zDefFilePtr:=Table:C252($tableNumber)  //•051496  MLB  
			<>FilePtr:=zDefFilePtr
			READ ONLY:C145(zDefFIleptr->)  //try to stop self record locking problem
			DEFAULT TABLE:C46(zDefFilePtr->)
			FORM SET OUTPUT:C54(zDefFilePtr->; "List")
		End if 
End case 
//EOLP