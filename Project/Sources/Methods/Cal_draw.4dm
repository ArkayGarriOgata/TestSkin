//%attributes = {"publishedWeb":true}
//METHOD Cal_draw
//Written by: Georgios Bizas/ODENSOFT
//Written date: 07/09/1999
//Last Modified: 07/12/1999
// SetObjectProperties, Mark Zinke (5/16/13)

//Description:
//"draws" the Calendar to be displayed

C_LONGINT:C283($i; $vl_offset)
C_POINTER:C301($vp_var)
C_DATE:C307($vd_thisMonthStarts)

SetObjectProperties("Rectangle@"; -><>NULL; False:C215)
SetObjectProperties("CalVar@"; -><>NULL; True:C214)

vs_title:=<>as_monthNames{vl_currentMonth}+", "+String:C10(vl_currentYear)

//create the date for the first day of target month
$vd_thisMonthStarts:=Cal_getFormatedDate(vl_currentYear; vl_currentMonth; 1)

//what day is it? (ask jeeves)
vl_firstDayOfThisMonth:=Day number:C114($vd_thisMonthStarts)

//is week starting with day other than 1(Sunday)?
//in that case we have to align the starting cell

//figure out how the following code takes care of that !!!!!
vl_firstDayOfThisMonth:=vl_firstDayOfThisMonth-<>vl_startWeekWith+1

//carefull that the first day isn't outside the displayed scope
//that can happen if (vl_firstDayOfThisMonth<1)
//in this case we put some six empty cells before we begin drawing days

If (vl_firstDayOfThisMonth<1)
	vl_firstDayOfThisMonth:=vl_firstDayOfThisMonth+7
End if 

//draw the empty cells
//before the first day of the month (from cell 1 to vl_firstDayOfThisMonth-1)

For ($i; 1; vl_firstDayOfThisMonth-1)
	$vp_var:=Get pointer:C304("CalVar"+String:C10($i))
	$vp_var->:=0
	OBJECT SET VISIBLE:C603($vp_var->; False:C215)
	SetObjectProperties("Rectangle"+String:C10($i); -><>NULL; True:C214)
End for 

$vl_offset:=vl_firstDayOfThisMonth-1

//roll out the first 28 days /all months have at least that many
For ($i; 1; 28)
	$vp_var:=Get pointer:C304("CalVar"+String:C10($i+$vl_offset))
	$vp_var->:=$i
End for 

//take care of the remaining day of the month
//and the unused cells after the last day

//for finding out how many days the target month has
//we monitor the $vd_EndOfMonthFlag variable.

vd_EndOfMonthFlag:=$vd_thisMonthStarts+28

For ($i; 29; 42-$vl_offset)
	$vp_var:=Get pointer:C304("CalVar"+String:C10($i+$vl_offset))
	If (Month of:C24(vd_endOfMonthFlag)=vl_currentMonth)
		$vp_var->:=$i
		vd_endOfMonthFlag:=vd_endOfMonthFlag+1
	Else 
		$vp_var->:=0
		OBJECT SET VISIBLE:C603($vp_var->; False:C215)
		SetObjectProperties("Rectangle"+String:C10($i+$vl_offset); -><>NULL; True:C214)
	End if 
End for 