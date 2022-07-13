//%attributes = {"publishedWeb":true}
//PM: Batch_ExpediterDaily() -> 
//@author mlb - 4/13/01  08:47

C_TEXT:C284($t; $cr)
C_TEXT:C284($1; $docName; xTitle; xText)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="The Expediters Daily"
xText:=""
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.**"; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.00")
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "scheduled")
	
	USE SET:C118("scheduled")
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25<(4D_Current_date+2); *)
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
	
Else 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "scheduled")
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.**"; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.00")
	
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4#"@.**"; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4#"@.00"; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25<(4D_Current_date+2); *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
	
End if   // END 4D Professional Services : January 2019 query selection

If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	ARRAY TEXT:C222($aJob; 0)
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aLine; 0)
	ARRAY DATE:C224($aArt; 0)
	ARRAY DATE:C224($aOKs; 0)
	ARRAY DATE:C224($aWant; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJob; [Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]Line:5; $aLine; [Job_Forms_Master_Schedule:67]DateStockDue:16; $aArt; [Job_Forms_Master_Schedule:67]FirstReleaseDat:13; $aOKs; [Job_Forms_Master_Schedule:67]PressDate:25; $aWant)
	SORT ARRAY:C229($aWant; $aJob; $aCust; $aLine; $aArt; $aOKs; >)
	xText:=xText+$cr+"The following jobs scheduled tomorrow need stock:"+$cr
	xText:=xText+"Jobform "+$t+"StockDue"+$t+"1st Rel "+$t+"Press   "+$t+"Customer    "+$t+"Line"+$cr
	For ($i; 1; Size of array:C274($aJob))
		xText:=xText+$aJob{$i}+$t+String:C10($aArt{$i}; <>MIDDATE)+$t+String:C10($aOKs{$i}; <>MIDDATE)+$t+String:C10($aWant{$i}; <>MIDDATE)+$t+$aCust{$i}+$t+$aLine{$i}+$cr
	End for 
	xText:=xText+$cr
	xText:=xText+$cr
End if 

If (False:C215)  //plates are the sequence level now
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		USE SET:C118("scheduled")
		QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25<(4D_Current_date+3); *)
		QUERY SELECTION:C341([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DatePlatesRecd:39=!00-00-00!)
		
	Else 
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.**"; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.00"; *)
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25<(4D_Current_date+3); *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DatePlatesRecd:39=!00-00-00!)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		ARRAY TEXT:C222($aJob; 0)
		ARRAY TEXT:C222($aCust; 0)
		ARRAY TEXT:C222($aLine; 0)
		ARRAY DATE:C224($aArt; 0)
		ARRAY DATE:C224($aOKs; 0)
		ARRAY DATE:C224($aWant; 0)
		SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJob; [Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]Line:5; $aLine; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12; $aArt; [Job_Forms_Master_Schedule:67]DateStockRecd:17; $aOKs; [Job_Forms_Master_Schedule:67]PressDate:25; $aWant)
		SORT ARRAY:C229($aWant; $aJob; $aCust; $aLine; $aArt; $aOKs; >)
		xText:=xText+$cr+"The following jobs scheduled in the next 2 days need plates:"+$cr
		xText:=xText+"Jobform "+$t+"Art     "+$t+"StkRec'd"+$t+"Press   "+$t+"Customer    "+$t+"Line"+$cr
		For ($i; 1; Size of array:C274($aJob))
			xText:=xText+$aJob{$i}+$t+String:C10($aArt{$i}; <>MIDDATE)+$t+String:C10($aOKs{$i}; <>MIDDATE)+$t+String:C10($aWant{$i}; <>MIDDATE)+$t+$aCust{$i}+$t+$aLine{$i}+$cr
		End for 
		xText:=xText+$cr
		xText:=xText+$cr
	End if 
End if 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	USE SET:C118("scheduled")
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25<(4D_Current_date+15); *)
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25>4D_Current_date; *)
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PlannerReleased:14=!00-00-00!)
	
Else 
	
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4#"@.**"; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4#"@.00"; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25<(4D_Current_date+15); *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25>4D_Current_date; *)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PlannerReleased:14=!00-00-00!)
	
End if   // END 4D Professional Services : January 2019 query selection

If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	ARRAY TEXT:C222($aJob; 0)
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aLine; 0)
	ARRAY DATE:C224($aArt; 0)
	ARRAY DATE:C224($aOKs; 0)
	ARRAY DATE:C224($aWant; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJob; [Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]Line:5; $aLine; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12; $aArt; [Job_Forms_Master_Schedule:67]DateFinalToolApproved:18; $aOKs; [Job_Forms_Master_Schedule:67]PressDate:25; $aWant)
	SORT ARRAY:C229($aWant; $aJob; $aCust; $aLine; $aArt; $aOKs; >)
	xText:=xText+Char:C90(13)+"The following jobs scheduled in the next 14 days need Planners' release:"+$cr
	xText:=xText+"Jobform "+$t+"Art     "+$t+"OK's    "+$t+"Press   "+$t+"Customer    "+$t+"Line"+$cr
	For ($i; 1; Size of array:C274($aJob))
		xText:=xText+$aJob{$i}+$t+String:C10($aArt{$i}; <>MIDDATE)+$t+String:C10($aOKs{$i}; <>MIDDATE)+$t+String:C10($aWant{$i}; <>MIDDATE)+$t+$aCust{$i}+$t+$aLine{$i}+$cr
	End for 
End if 

//USE SET("scheduled")
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]FirstReleaseDat:13<(4D_Current_date+5); *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]FirstReleaseDat:13>4D_Current_date; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.**"; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.00")
If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	ARRAY TEXT:C222($aJob; 0)
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aLine; 0)
	ARRAY DATE:C224($aArt; 0)
	ARRAY DATE:C224($aOKs; 0)
	ARRAY DATE:C224($aWant; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJob; [Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]Line:5; $aLine; [Job_Forms_Master_Schedule:67]Printed:32; $aArt; [Job_Forms_Master_Schedule:67]GlueReady:28; $aOKs; [Job_Forms_Master_Schedule:67]FirstReleaseDat:13; $aWant)
	SORT ARRAY:C229($aWant; $aJob; $aCust; $aLine; $aArt; $aOKs; >)
	xText:=xText+Char:C90(13)+"The following jobs scheduled to ship in the next 5 days need expedited:"+$cr
	xText:=xText+"Jobform "+$t+"Printed "+$t+"GluReady"+$t+"1st Rel "+$t+"Customer    "+$t+"Line"+$cr
	For ($i; 1; Size of array:C274($aJob))
		xText:=xText+$aJob{$i}+$t+String:C10($aArt{$i}; <>MIDDATE)+$t+String:C10($aOKs{$i}; <>MIDDATE)+$t+String:C10($aWant{$i}; <>MIDDATE)+$t+$aCust{$i}+$t+$aLine{$i}+$cr
	End for 
End if 
//rPrintText ("_.LOG")
If (Length:C16(xText)>0)
	xText:=xText+$cr+"_______________ END OF REPORT ______________"
	QM_Sender(xTitle; ""; xText; distributionList)
	
End if 

CLEAR SET:C117("scheduled")