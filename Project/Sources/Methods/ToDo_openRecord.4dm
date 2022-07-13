//%attributes = {"publishedWeb":true}
//PM: ToDo_openRecord() -> 
//@author mlb - 5/10/02  15:30

//based on EXPL_OpenRecord(element;mode;newwindow)  060299  mlb
C_LONGINT:C283($1; $winRef; $x; $y; $state)
GET MOUSE:C468($x; $y; $state; *)
$winRef:=OpenFormWindow(->[To_Do_Tasks:100]; "Input")  //;0;$x;$y-55)

READ WRITE:C146(filePtr->)
GOTO RECORD:C242(filePtr->; aRecNum{$1})

MODIFY RECORD:C57(filePtr->; *)
Case of 
	: (ok=1)
		ToDo_collection("save"; $1)
	: (bDelete=1)
		ToDo_collection("delete"; $1)
End case 
REDUCE SELECTION:C351(filePtr->; 0)

CLOSE WINDOW:C154($winRef)