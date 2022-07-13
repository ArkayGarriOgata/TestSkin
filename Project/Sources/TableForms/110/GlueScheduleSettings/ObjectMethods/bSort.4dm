// ----------------------------------------------------
// Method: [ProductionSchedules].GlueSchedule.bSort
// ----------------------------------------------------

PSG_Sort  // Modified by: Mark Zinke (8/27/13) Replaces code below.

//sort_option:=""
//sort_option:=Request("Which Option";"1=gluer|prior|jobit;2=cust|rel|prior;col#'s 1,2,3")
//
//$comma:=Position(",";sort_option)
//
//If ($comma>0)  //like 1,2,3
//$col1:=Num(Substring(sort_option;1;$comma-1))
//sort_option:=Substring(sort_option;$comma+1)
//
//$comma:=Position(",";sort_option)
//$col2:=Num(Substring(sort_option;1;$comma-1))
//sort_option:=Substring(sort_option;$comma+1)
//
//$col3:=Num(sort_option)
//
//LISTBOX SORT COLUMNS(aGlueListBox;$col1;>;$col2;>;$col3;>)
//
//Else 
//Case of 
//: (sort_option="1")
//LISTBOX SORT COLUMNS(aGlueListBox;1;>;2;>;5;>)
//: (sort_option="2")
//LISTBOX SORT COLUMNS(aGlueListBox;3;>;8;>;2;>)
//
//End case 
//End if 