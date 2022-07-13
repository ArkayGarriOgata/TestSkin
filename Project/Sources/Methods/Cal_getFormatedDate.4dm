//%attributes = {"publishedWeb":true}
//METHOD: Cal_getFormatedDate(L:YY;L:MM;L:DD)->Date:Date in righ format
//Written by: Georgios Bizas/ODENSOFT
//Written date: 07/11/1999
//Last Modified:
//Description
//since 4D doesn't provide any means to find
//out what date format the user have selected in the Contoll Panel 
//we have to do it ourselves
//The method detects YY-MM-DD, MM-DD-YY or DD-MM-YY
//and composes a date with the right format from its parameters

C_DATE:C307($0)
C_LONGINT:C283($1; $2; $3)
C_TEXT:C284($vs_currentDate)
C_TEXT:C284($vs_currentMonth; $vs_currentDay)
C_DATE:C307($vd_currentDate)

$vd_currentDate:=Current date:C33

//We have to take care of the case where day no = month no

Repeat 
	$vd_currentDate:=$vd_currentDate+1
	$vs_currentDate:=String:C10($vd_currentDate; 7)
	$vs_currentMonth:=String:C10(Month of:C24($vd_currentDate))
	$vs_currentDay:=String:C10(Day of:C23($vd_currentDate))
Until ($vs_currentMonth#$vs_currentDay)

If (Position:C15("-"; $vs_currentDate)=5)  //works for me; I run Swedish Format
	$0:=Date:C102(String:C10($1)+"-"+String:C10($2)+"-"+String:C10($3))
Else   //Let's take care of you
	If (Position:C15($vs_currentMonth; $vs_currentDate)<3)
		$0:=Date:C102(String:C10($2)+"-"+String:C10($3)+"-"+String:C10($1))  //"MM-DD-YY"
	Else 
		$0:=Date:C102(String:C10($3)+"-"+String:C10($2)+"-"+String:C10($1))  //"DD-MM-YY"
	End if 
End if 