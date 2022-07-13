//%attributes = {"publishedWeb":true}
//Procedure: UPRs2HTML()  120797  MLB
//save them all as HTML files
C_TEXT:C284($1)
C_LONGINT:C283($i)
C_TIME:C306($docRef)
//$docRef:=Open document("")  `to set the folder path
//CLOSE DOCUMENT($docRef)
C_TEXT:C284($quote; $cr; $space)
$quote:=Char:C90(34)
$cr:=Char:C90(13)
$br:="<BR>"
$space:="&nbsp;"
C_TEXT:C284($head; $navigate; $tail)
If (Count parameters:C259=0)
	$criterian:=Num:C11(Request:C163("Enter UPR number or '0' for All:"))
Else 
	$criterian:=Num:C11($1)
	ok:=1
End if 

If (ok=1)
	$head:="<HTML><HEAD>"+$cr+"<TITLE>Untitled</TITLE>"+$cr
	$head:=$head+"<link rel=stylesheet type="+$quote+"text/css"+$quote+" href="+$quote+"AUPRSTYLE.html"+$quote+">"+$cr
	$head:=$head+"</HEAD>"+$cr+"<BODY>"+$cr
	
	$navigate:="<a href="+$quote+"UPRXXXXX.html"+$quote+">Previous UPR</a>-|-<a href="+$quote+"UPRYYYYY.html"+$quote+">Next UPR</a>-|-<a href="+$quote+"index.html"+$quote+">Return to Index</a>"+$br+$cr
	$navigate:=$navigate+"<IMG SRC="+$quote+"ALINE.GIF"+$quote+" WIDTH="+$quote+"620"+$quote+" HEIGHT="+$quote+"8"+$quote+">"+$br+$cr
	
	$tail:="</BODY>"+$cr+"</HTML>"
	
	If ($criterian#0)
		QUERY:C277([Usage_Problem_Reports:84]; [Usage_Problem_Reports:84]Id:1=$criterian)
	Else 
		ALL RECORDS:C47([Usage_Problem_Reports:84])
	End if 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		ORDER BY:C49([Usage_Problem_Reports:84]Id:1; <)
		
		ARRAY LONGINT:C221($aupr; 0)
		ARRAY TEXT:C222($aSubsys; 0)
		ARRAY TEXT:C222($aModule; 0)
		ARRAY TEXT:C222($aStatus; 0)
		ARRAY TEXT:C222($aSubject; 0)
		SELECTION TO ARRAY:C260([Usage_Problem_Reports:84]Id:1; $aupr; [Usage_Problem_Reports:84]Subsystem:10; $aSubsys; [Usage_Problem_Reports:84]Module:11; $aModule; [Usage_Problem_Reports:84]Subject:12; $aSubject; [Usage_Problem_Reports:84]Status:20; $aStatus)
		FIRST RECORD:C50([Usage_Problem_Reports:84])
		For ($i; 1; Size of array:C274($aupr))
			$upr:="UPR"+String:C10([Usage_Problem_Reports:84]Id:1)
			
			$body:=""
			$body:=$body+"<TABLE BORDER CELLSPACING=3 CELLPADDING=5>"+$cr
			$body:=$body+"<TR VALIGN=Center><TD COLSPAN = 2><H2>"+[Usage_Problem_Reports:84]Subject:12+"</H2></TD> <TD></TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><B><EM>"+$upr+"</EM></B></TD> <TD><B>"+[Usage_Problem_Reports:84]Status:20+"</TD></B></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>Subsys/Module</EM></TD> <TD><B>"+[Usage_Problem_Reports:84]Subsystem:10+($space*3)+[Usage_Problem_Reports:84]Module:11+"</TD></B></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"Description"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr([Usage_Problem_Reports:84]Description:13)+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"Example"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr([Usage_Problem_Reports:84]Example:14)+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"New Design"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr([Usage_Problem_Reports:84]NewDesign:15)+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"Usage Info"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr([Usage_Problem_Reports:84]UsageInfo:16)+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"Changes"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr([Usage_Problem_Reports:84]Changes:17)+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"aMs Version"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+[Usage_Problem_Reports:84]VersionRelease:24+"</TD></TR>"+$cr
			
			$body:=$body+"</TABLE>"+$cr
			
			$naviTemp:=$navigate
			If ($i>1)
				$naviTemp:=Replace string:C233($naviTemp; "XXXXX"; String:C10($aupr{$i-1}))
			Else 
				$naviTemp:=Replace string:C233($naviTemp; "UPRXXXXX"; "index")
			End if 
			If ($i<(Size of array:C274($aupr)))
				$naviTemp:=Replace string:C233($naviTemp; "YYYYY"; String:C10($aupr{$i+1}))
			Else 
				$naviTemp:=Replace string:C233($naviTemp; "UPRYYYYY"; "index")
			End if 
			
			$headTemp:=Replace string:C233($head; "Untitled"; $upr)
			$body:=$headTemp+$naviTemp+$body+$tail
			
			$docRef:=Create document:C266($upr+".html")
			SEND PACKET:C103($docRef; $body)  //
			CLOSE DOCUMENT:C267($docRef)
			
			NEXT RECORD:C51([Usage_Problem_Reports:84])
		End for 
		
	Else 
		
		
		ARRAY LONGINT:C221($aupr; 0)
		ARRAY TEXT:C222($aSubsys; 0)
		ARRAY TEXT:C222($aModule; 0)
		ARRAY TEXT:C222($aStatus; 0)
		ARRAY TEXT:C222($aSubject; 0)
		ARRAY TEXT:C222($_Description; 0)
		ARRAY TEXT:C222($_Example; 0)
		ARRAY TEXT:C222($_NewDesign; 0)
		ARRAY TEXT:C222($_UsageInfo; 0)
		ARRAY TEXT:C222($_Changes; 0)
		ARRAY TEXT:C222($_VersionRelease; 0)
		
		SELECTION TO ARRAY:C260([Usage_Problem_Reports:84]Id:1; $aupr; [Usage_Problem_Reports:84]Subsystem:10; $aSubsys; [Usage_Problem_Reports:84]Module:11; $aModule; [Usage_Problem_Reports:84]Subject:12; $aSubject; [Usage_Problem_Reports:84]Status:20; $aStatus; [Usage_Problem_Reports:84]Description:13; $_Description; [Usage_Problem_Reports:84]Example:14; $_Example; [Usage_Problem_Reports:84]NewDesign:15; $_NewDesign; [Usage_Problem_Reports:84]UsageInfo:16; $_UsageInfo; [Usage_Problem_Reports:84]Changes:17; $_Changes; [Usage_Problem_Reports:84]VersionRelease:24; $_VersionRelease)
		
		SORT ARRAY:C229($aupr; $aSubsys; $aModule; $aSubject; $aStatus; $_Description; $_Example; $_NewDesign; $_UsageInfo; $_Changes; $_VersionRelease; <)
		
		For ($i; 1; Size of array:C274($aupr); 1)
			$upr:="UPR"+String:C10($aupr{$i})
			
			$body:=""
			$body:=$body+"<TABLE BORDER CELLSPACING=3 CELLPADDING=5>"+$cr
			$body:=$body+"<TR VALIGN=Center><TD COLSPAN = 2><H2>"+$aSubject{$i}+"</H2></TD> <TD></TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><B><EM>"+$upr+"</EM></B></TD> <TD><B>"+$aStatus{$i}+"</TD></B></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>Subsys/Module</EM></TD> <TD><B>"+$aSubsys{$i}+($space*3)+$aModule{$i}+"</TD></B></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"Description"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr($_Description{$i})+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"Example"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr($_Example{$i})+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"New Design"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr($_NewDesign{$i})+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"Usage Info"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr($_UsageInfo{$i})+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"Changes"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+fInsertBr($_Changes{$i})+"</TD></TR>"+$cr
			$body:=$body+"<TR VALIGN=Top><TD><EM>"+"aMs Version"+"</EM></TD>"+$cr
			$body:=$body+"<TD>"+$_VersionRelease{$i}+"</TD></TR>"+$cr
			
			$body:=$body+"</TABLE>"+$cr
			
			$naviTemp:=$navigate
			If ($i>1)
				$naviTemp:=Replace string:C233($naviTemp; "XXXXX"; String:C10($aupr{$i-1}))
			Else 
				$naviTemp:=Replace string:C233($naviTemp; "UPRXXXXX"; "index")
			End if 
			If ($i<(Size of array:C274($aupr)))
				$naviTemp:=Replace string:C233($naviTemp; "YYYYY"; String:C10($aupr{$i+1}))
			Else 
				$naviTemp:=Replace string:C233($naviTemp; "UPRYYYYY"; "index")
			End if 
			
			$headTemp:=Replace string:C233($head; "Untitled"; $upr)
			$body:=$headTemp+$naviTemp+$body+$tail
			
			$docRef:=Create document:C266($upr+".html")
			SEND PACKET:C103($docRef; $body)  //
			CLOSE DOCUMENT:C267($docRef)
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	$head:="<HTML><HEAD>"+$cr+"<TITLE>Useage Problem Report Index</TITLE>"+$cr
	$head:=$head+"<link rel=stylesheet type="+$quote+"text/css"+$quote+" href="+$quote+"AUPRSTYLE.html"+$quote+">"+$cr
	$head:=$head+"</HEAD>"+$cr+"<BODY>"+$cr+"<TABLE BORDER CELLSPACING=3 CELLPADDING=5>"+$cr
	$tail:="</TABLE>"+$cr+"</BODY>"+$cr+"</HTML>"
	$body:=""
	
	
	$docRef:=Create document:C266("index.html")
	SEND PACKET:C103($docRef; $head)  //  
	
	For ($i; 1; Size of array:C274($aupr))
		$body:=$body+"<TR VALIGN=Center><TD>"+"<a href="+$quote+"UPR"+String:C10($aupr{$i})+".html"+$quote+">UPR"+String:C10($aupr{$i})+"</a>"+"</TD>"+$cr
		$body:=$body+"<TD>"+$aSubject{$i}+"</TD>"
		$body:=$body+"<TD>"+$aSubsys{$i}+"</TD>"
		$body:=$body+"<TD>"+$aModule{$i}+"</TD>"
		$body:=$body+"<TD>"+$aStatus{$i}+"</TD>"
		$body:=$body+"</TR>"+$cr
		If (Length:C16($body)>15000)
			BEEP:C151
			SEND PACKET:C103($docRef; $body)  //
			$body:=""
		End if 
	End for 
	
	SEND PACKET:C103($docRef; ($body+$tail))  //  
	
	CLOSE DOCUMENT:C267($docRef)
End if 

//