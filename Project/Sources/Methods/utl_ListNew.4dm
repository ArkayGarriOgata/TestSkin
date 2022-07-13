//%attributes = {"publishedWeb":true}
//Method: utl_ListNew() -> listRef   050598  MLB
//use instead of "New List" so references don't get lost
//INIT THE ARRAY BEFORE TRYING TO USE
//CLEAR a list before getting a handle to a new list
//•3/24/00  mlb  create the stack as needed
//see also utl_ListClear
C_LONGINT:C283($0; $push; $table; $field)
If (Count parameters:C259=0)
	$0:=New list:C375
Else 
	$0:=Copy list:C626($1)
End if 
//TRACE
C_TEXT:C284($variableName)
//RESOLVE POINTER(->aListRefStack;$variableName;$table;$field)  `•3/24/00  mlb  cr
//If (Length($variableName)=0)
If (Type:C295(aListRefStack)#LongInt array:K8:19)
	ARRAY LONGINT:C221(aListRefStack; 0)
End if 
$push:=Size of array:C274(aListRefStack)+1
ARRAY LONGINT:C221(aListRefStack; $push)
aListRefStack{$push}:=$0
//