//%attributes = {"publishedWeb":true}
//PM: PS_EventOnLoad() -> 
//@author mlb - 6/7/02  12:00

C_TEXT:C284(makingReadyOn)

PS_setPageBasedOnAccess
makingReadyOn:=""

If (Read only state:C362([ProductionSchedules:110]))  //turn off scheduling features
	OBJECT SET ENABLED:C1123(*; "canSched@"; False:C215)
	SetObjectProperties("canSched@"; -><>NULL; False:C215; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
Else 
	OBJECT SET ENABLED:C1123(*; "canSched@"; True:C214)
	SetObjectProperties("canSched@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
End if 

OBJECT SET ENABLED:C1123(*; "canSee@"; True:C214)
SetObjectProperties("canSee@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)

Case of 
	: (sCriterion1="All")  //always goto page 2 when displaying all press view
		b8:=1  //start
		b4:=0
		b7:=0
		b6:=0
		b5:=0
		
	: (sCriterion1="D/C")  //always goto page 2 when displaying all dc view
		b8:=1
		b4:=0
		b7:=0
		b6:=0
		b5:=0
		
	Else   //`$settings:=JML_PresScheduleSettings ("reset")
		b8:=0
		b4:=1  //priority
		b7:=0
		b6:=0
		b5:=0
		$settings:=PS_Settings("get"; sCriterion1)
End case 

PS_setHeaderPictures
C_TIME:C306(MRhours)
MRhours:=?00:00:00?
SET TIMER:C645(60*60*2)  //chk every two minutes    

If (<>PHYSICAL_INVENORY_IN_PROGRESS)  // Modified by: Mel Bohince (1/2/20) 
	OBJECT SET ENABLED:C1123(*; "PlateUse"; False:C215)
End if 