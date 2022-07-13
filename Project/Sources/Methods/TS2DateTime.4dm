//%attributes = {"publishedWeb":true}
//Procedure: TS2DateTime(timeStamp;»date;»time)  073196  MLB
//convert longint  time stamp back to date and time
//see(P) TSTimeStamp and TN 29
C_LONGINT:C283($1)
C_POINTER:C301($2; $3)
$2->:=!1995-04-17!+($1\86400)  //24*60*60
$3->:=Time:C179(Time string:C180($1%86400))
//