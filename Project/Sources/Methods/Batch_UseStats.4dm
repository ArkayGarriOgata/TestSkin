//%attributes = {"publishedWeb":true}
//Procedure: Batch_UseStats()  012799  MLB

C_TEXT:C284($when)
C_TEXT:C284($t; $cr)

$when:=TSDateTime(4D_Current_date-7; 4d_Current_time)
$t:=Char:C90(9)
$cr:=Char:C90(13)

READ WRITE:C146([x_Usage_Stats:65])
QUERY:C277([x_Usage_Stats:65]; [x_Usage_Stats:65]who:2<$when)
DELETE SELECTION:C66([x_Usage_Stats:65])

$when:=TSDateTime(4D_Current_date; ?00:00:01?)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	QUERY:C277([x_Usage_Stats:65]; [x_Usage_Stats:65]who:2=$when)
	ORDER BY:C49([x_Usage_Stats:65]; [x_Usage_Stats:65]who:2; >)
	FIRST RECORD:C50([x_Usage_Stats:65])
	xTitle:="Usage Statistics for "+String:C10(4D_Current_date; <>MIDDATE)
	xText:="who"+$t+"when"+$t+"whichFile"+$t+"whichMode"+$t+"what"+$t+"theDate"+$t+"theTime"+$cr
	While (Not:C34(End selection:C36([x_Usage_Stats:65]))) & (Length:C16(xText)<32000)
		xText:=xText+String:C10([x_Usage_Stats:65]id:1)+$t+[x_Usage_Stats:65]who:2+$t+[x_Usage_Stats:65]when_:3+$t+[x_Usage_Stats:65]what:4+$t+[x_Usage_Stats:65]description:5+$t+Table name:C256([x_Usage_Stats:65]tablenumber:6)+$t+String:C10([x_Usage_Stats:65]recordnumber:7)+$cr
		NEXT RECORD:C51([x_Usage_Stats:65])
	End while 
	
Else 
	
	QUERY:C277([x_Usage_Stats:65]; [x_Usage_Stats:65]who:2=$when)
	ARRAY LONGINT:C221($_Id; 0)
	ARRAY TEXT:C222($_who; 0)
	ARRAY TEXT:C222($_when; 0)
	ARRAY TEXT:C222($_what; 0)
	ARRAY TEXT:C222($_description; 0)
	ARRAY LONGINT:C221($_tablenumber; 0)
	ARRAY LONGINT:C221($_recordnumber; 0)
	
	SELECTION TO ARRAY:C260([x_Usage_Stats:65]id:1; $_Id; [x_Usage_Stats:65]who:2; $_who; [x_Usage_Stats:65]when_:3; $_when; [x_Usage_Stats:65]what:4; $_what; [x_Usage_Stats:65]description:5; $_description; [x_Usage_Stats:65]tablenumber:6; $_tablenumber; [x_Usage_Stats:65]recordnumber:7; $_recordnumber)
	SORT ARRAY:C229($_who; $_Id; $_when; $_what; $_description; $_tablenumber; $_recordnumber; >)
	
	$Nb:=Size of array:C274($_description)+1
	$j:=1
	
	xTitle:="Usage Statistics for "+String:C10(4D_Current_date; <>MIDDATE)
	xText:="who"+$t+"when"+$t+"whichFile"+$t+"whichMode"+$t+"what"+$t+"theDate"+$t+"theTime"+$cr
	While ($j<$Nb) & (Length:C16(xText)<32000)
		
		xText:=xText+String:C10($_Id{$j})+$t+$_who{$j}+$t+$_when{$j}+$t+$_what{$j}+$t+$_description{$j}+$t+Table name:C256($_tablenumber{$j})+$t+String:C10($_recordnumber{$j})+$cr
		
		
	End while 
	
End if   // END 4D Professional Services : January 2019 First record


QM_Sender(xTitle; ""; xText; distributionList)