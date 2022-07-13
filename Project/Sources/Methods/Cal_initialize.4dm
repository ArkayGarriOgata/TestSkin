//%attributes = {"publishedWeb":true}
//METHOD Cal_initialize 
//Written by: Georgios Bizas/ODENSOFT
//Written date: 07/09/1999
//Last Modified: 07/12/1999
//Description:
//Initializes the PopUp Calendar
//The preferable approach if the calendar is to be used often 
//would be to do that only once; OnStartup. Some vars would then need
//to be IP
//here we load the day/month names from a resc file but
//they can also be loaded from a list or be hard coded

C_LONGINT:C283($i)
C_TIME:C306($vh_docRef)
C_POINTER:C301($vp_var)

//$vh_docRef:=Open resource file("Calendar_Resourses";"rsrc")

//Load Month Names
ARRAY TEXT:C222(<>as_monthNames; 12)
<>as_monthNames{1}:="Jan"
<>as_monthNames{2}:="Feb"
<>as_monthNames{3}:="Mar"
<>as_monthNames{4}:="Apr"
<>as_monthNames{5}:="May"
<>as_monthNames{6}:="Jun"
<>as_monthNames{7}:="Jul"
<>as_monthNames{8}:="Aug"
<>as_monthNames{9}:="Sep"
<>as_monthNames{10}:="Oct"
<>as_monthNames{11}:="Nov"
<>as_monthNames{12}:="Dec"
//STRING LIST TO ARRAY(15000;◊as_monthNames;$vh_docRef)

//Load Day Names
ARRAY TEXT:C222(<>as_dayNames; 7)
<>as_dayNames{1}:="Sun"
<>as_dayNames{2}:="Mon"
<>as_dayNames{3}:="Tue"
<>as_dayNames{4}:="Wed"
<>as_dayNames{5}:="Thu"
<>as_dayNames{6}:="Fri"
<>as_dayNames{7}:="Sat"
//STRING LIST TO ARRAY(15001;◊as_dayNames;$vh_docRef)

For ($i; 1; 7)
	$vp_var:=Get pointer:C304("◊DayVar"+String:C10($i))
	$vp_var->:=<>as_dayNames{$i}
End for 

<>vl_startWeekWith:=1  //Week starts with Sunday
<>as_dayNames:=<>vl_startWeekWith