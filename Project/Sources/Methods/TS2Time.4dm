//%attributes = {"publishedWeb":true}
//Procedure: TS2Time()  073196  MLB
//convert longint  time stamp back to time
//see(P) TSTimeStamp and TN 29
C_LONGINT:C283($1)
C_TIME:C306($0)
$0:=Time:C179(Time string:C180($1%86400))
//