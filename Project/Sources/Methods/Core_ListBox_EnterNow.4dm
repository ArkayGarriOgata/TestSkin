//%attributes = {"invisible":true,"shared":true}
// Method:  Core_ListBox_EnterNow(pColumn)
//Description:  This method will cause the cursor to go into a cell in a listbox for editing immediately
//   rather than the delay usually encountered.

// Example of useage

// Case of 
//   : (Form event=On Clicked)

//      Case of 

//         : (Right click)
//            Do some menu thing
//         Else 
//            Core_ListBox_EnterNow (OBJECT Get pointer)
//      End case 

// End case 

C_POINTER:C301($1; $pColumn)

$pColumn:=$1

Case of 
	: (Shift down:C543 | Macintosh command down:C546)
		
	: (Is a variable:C294($pColumn))
		
		EDIT ITEM:C870($pColumn->; $pColumn->)
		
	Else 
		
		EDIT ITEM:C870($pColumn->)
		
End case 