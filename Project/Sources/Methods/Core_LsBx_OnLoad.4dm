//%attributes = {}

C_OBJECT:C1216($oLsBx)

ARRAY OBJECT:C1221($aoColumn; 0; 0)

//$aoColumn:=New object()

//$aoColumn.Name:=
//$aoColumn.Variable
//$aoColumn.HeaderName
//$aoColumn.HeaderVar
//$aoColumn.FooterName
//$aoColumn.FooterName

$oLsBx:=New object:C1471()

$oLsBx.ID:="1"


//$aoColumn:=New object()

//$aoColumn.Name
//$aoColumn.Variable
//$aoColumn.HeaderName
//$aoColumn.HeaderVar
//$aoColumn.FooterName
//$aoColumn.FooterName

$oLsBx.Column:=$aoColumn

For ($nColumn; 1; $nNumberOfColumns)
	
	
	//LISTBOX INSERT COLUMN({*;}object;colPosition;colName;colVariable;headerName;headerVar{;footerName;footerVar})\
		
	//LISTBOX INSERT COLUMN(*;"Core_abListBox"+$oLsBx.ID;$nColumn;$oLsBx.Name;colVariable;headerName;headerVar{;footerName;footerVar})\
		
	//LISTBOX SET GRID({*;}object;horizontal;vertical)
	
	//LISTBOX SET ARRAY({*;}object;arrType;arrPtr)
	
	//LISTBOX SET AUTO ROW HEIGHT({*;}object;selector;value;unit)
	
End for 


//If ()  //“Data Source”
//  //.   property of the list box is either Current Selection, Named Selection, Collection or Entity Selection.

//LISTBOX SET COLUMN FORMULA({*;}object;formula;dataType)  //Formulas can only be used when the “Data Source”

//  //.   property of the list box is either Current Selection, Named Selection, or Collection or Entity Selection.

//LISTBOX INSERT COLUMN FORMULA({*;}object;colPosition;colName;formula;dataType;headerName;headerVar{;footerName;footerVar})

//End if 
