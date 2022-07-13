//%attributes = {"publishedWeb":true}
//fPickList(»keyField;»nameField;»descField) 
//returns the record number of picked record or -1 if canceled
//•080596  MLB  
//• 6/25/97 cs added confirm if user is about to display all RMs
ARRAY LONGINT:C221(alRecNo; 0)
ARRAY TEXT:C222(asPrimKey; 0)  //•080596  MLB  make larger, was A10
ARRAY TEXT:C222(asDesc1; 0)
ARRAY TEXT:C222(asDesc2; 0)
C_POINTER:C301($1; $2; $3; $filePtr)
C_TEXT:C284($4; $fileName)
C_LONGINT:C283($0; $recs)

$filePtr:=Table:C252(Table:C252($1))
$fileName:=Table name:C256($filePtr)
//NewWindow (510;290;6;5;"Pick "+$fileName)  `• 6/5/97 cs made window larger
$windowTitle:=Get window title:C450
$winRef:=OpenSheetWindow(->[zz_control:1]; "PickList_dio"; "Pick "+$fileName)
If (Count parameters:C259=4)
	If ($fileName#"RAW_MATERIALS")
		QUERY:C277($filePtr->; $2->=$4)
	Else 
		QUERY:C277($filePtr->; $2->=$4; *)
		QUERY:C277([Raw_Materials:21];  & ; [Raw_Materials:21]Status:25="Active")
	End if 
	
Else 
	If ($fileName#"RAW_MATERIALS")
		ALL RECORDS:C47($filePtr->)
	Else 
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Status:25="Active")
	End if 
	
End if 

If (Records in selection:C76($filePtr->)>0)
	tMessage1:="To select, click on the "+$fileName+" name below."
	sHead1:=Field name:C257($1)
	sHead2:=Field name:C257($2)
	sHead3:=Field name:C257($3)
	
	SELECTION TO ARRAY:C260($filePtr->; alRecNo; $1->; asPrimKey; $2->; asDesc1; $3->; asDesc2)
	
	SORT ARRAY:C229(asDesc1; alRecNo; asPrimKey; asDesc2; >)
	//ERASE WINDOW
	DIALOG:C40([zz_control:1]; "PickList_dio")
	CLOSE WINDOW:C154  //($winRef)
	SET WINDOW TITLE:C213($windowTitle)
	
	Case of 
		: (bPick=1)
			$0:=alRecNo{asPrimKey}
			
		: (bNoPick=1)
			$0:=-1
			
		: (bNewPick=1)  //BUTTON NOT IMPLEMENTED, deal with from calling proc
			<>plsHold:=True:C214
			<>lastNew:=-3
			ViewSetter(1; $filePtr)
			Repeat 
				IDLE:C311
				DELAY PROCESS:C323(Current process:C322; 720)
			Until (Not:C34(<>plsHold))
			$0:=<>lastNew
			UNLOAD RECORD:C212($filePtr->)
			
		Else 
			$0:=-1
	End case 
	
	ARRAY LONGINT:C221(alRecNo; 0)
	ARRAY TEXT:C222(asPrimKey; 0)
	ARRAY TEXT:C222(asDesc1; 0)
	ARRAY TEXT:C222(asDesc2; 0)
	
Else 
	BEEP:C151
	ALERT:C41("There are no qualifing records to pick from.")
	$0:=-1
End if 
//