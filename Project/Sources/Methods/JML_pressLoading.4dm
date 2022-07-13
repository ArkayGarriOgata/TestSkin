//%attributes = {"publishedWeb":true}
//PM: JML_pressLoading() -> 
//@author mlb - 11/20/01  11:49

ARRAY LONGINT:C221($aHours; 120)
C_DATE:C307($today)

$today:=!2001-10-01!-1  //4D_Current_date

CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "hold")

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; Records in selection:C76([Job_Forms_Master_Schedule:67]))
		$day:=[Job_Forms_Master_Schedule:67]PressDate:25-$today
		If ($day>0) & ($day<=120)
			$aHours{$day}:=$aHours{$day}+[Job_Forms_Master_Schedule:67]DurationPrinting:37
		End if 
		NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
	End for 
	
Else 
	
	ARRAY DATE:C224($_PressDate; 0)
	ARRAY REAL:C219($_DurationPrinting; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]PressDate:25; $_PressDate; [Job_Forms_Master_Schedule:67]DurationPrinting:37; $_DurationPrinting)
	
	For ($i; 1; Size of array:C274($_PressDate); 1)
		$day:=$_PressDate{$i}-$today
		If ($day>0) & ($day<=120)
			$aHours{$day}:=$aHours{$day}+$_DurationPrinting{$i}
		End if 
	End for 
	
End if   // END 4D Professional Services : January 2019 query selection

$t:="   "+Char:C90(9)
$cr:=Char:C90(13)
xText:="Hours"+$t+"Press Date"+$cr

For ($i; 1; Size of array:C274($aHours))
	xText:=xText+String:C10($aHours{$i}; "^^^^^")+$t+String:C10($today+$i; Internal date short:K1:7)+$cr
End for 

utl_LogIt("init")
utl_LogIt(xText; 0)
utl_LogIt("show")

USE NAMED SELECTION:C332("hold")