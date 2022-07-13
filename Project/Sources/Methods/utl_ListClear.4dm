//%attributes = {"publishedWeb":true}
//Method: utl_ListClear()  050598  MLB
//clear lists that are still in memory
//see also utl_ListNew

//utl_Trace 
For ($i; Size of array:C274(aListRefStack); 1; -1)
	If (Is a list:C621(aListRefStack{$i}))
		CLEAR LIST:C377(aListRefStack{$i}; *)
	End if 
End for 
ARRAY LONGINT:C221(aListRefStack; 0)
//