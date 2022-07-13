//%attributes = {"publishedWeb":true}
//Procedure: fSelectBy()  
//•090195  MLB 
//• 6/5/97 cs upr 1872 added ability to select array to display number

C_LONGINT:C283($0; $1)  //records in selection:=fSelectBy()  
ARRAY INTEGER:C220($aFieldNums; 0)  //•090195  MLB  

//• 6/5/97 cs start upr 1872 - added ability to select specific array
If (Count parameters:C259=1)  //if there is an array refernece number passed use it instead of file number
	COPY ARRAY:C226(<>aSlctFF{$1}; $aFieldNums)  //aSlctField  
Else 
	COPY ARRAY:C226(<>aSlctFF{Table:C252(filePtr)}; $aFieldNums)  //aSlctField
End if 
//• 6/5/97 cs end

ARRAY POINTER:C280(aSlctField; 0)
ARRAY POINTER:C280(aSlctField; 5)  // for backward compatiblity
For ($i; 1; Size of array:C274($aFieldNums))
	If ($aFieldNums{$i}>0)
		aSlctField{$i}:=Field:C253(fileNum; $aFieldNums{$i})
	Else 
		aSlctField{$i}:=<>NIL_PTR
	End if 
End for 
//end •090195  MLB  
HelpCode:=0  //iHelpSearch
tMessage1:="Find records in the "+sFile+" table where "  //send the filename to the dialog box
NumRecs1:=Records in selection:C76(filePtr->)
$0:=NumRecs1


DIALOG:C40([zz_control:1]; "Select_dio")
ERASE WINDOW:C160
$0:=NumRecs1