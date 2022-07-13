//%attributes = {"publishedWeb":true}
//Procedure: TS2Date()  073196  MLB
//convert longint  time stamp back to date
//see(P) TSTimeStamp and TN 29
C_LONGINT:C283($1)
C_DATE:C307($0)
$0:=!1995-04-17!+($1\86400)  //24*60*60
//