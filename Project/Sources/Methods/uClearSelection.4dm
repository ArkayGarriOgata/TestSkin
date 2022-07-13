//%attributes = {"publishedWeb":true}
// (GP) uClearSelection: clears selection from file pointer in $1
C_POINTER:C301($1)  //pointeer to file to clear
//If (True)  `•080195  MLB
REDUCE SELECTION:C351($1->; 0)

//Else 
//CREATE EMPTY SET($1->;"NullSet")
//USE SET("NullSet")
//CLEAR SET("NullSet")
//End if 

// EOP