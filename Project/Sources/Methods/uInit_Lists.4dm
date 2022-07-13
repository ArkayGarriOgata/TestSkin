//%attributes = {"publishedWeb":true}
//Method: uInit_Lists()  
//update lists (once per day/by one person) all lists updated
//4/19/95 make terms array 35 char
//•6/24/97 cs
//• 10/27/97 cs added system to update department list
//• 10/30/97 cs added update for FG Class/type list - JB request
//•042699  MLB call the correct method for fgclasstype
// Modified by Mel Bohince on 2/23/07 at 17:05:22 : add downtime

C_LONGINT:C283($i)
C_DATE:C307($today)
C_BOOLEAN:C305($saveRequired)

$saveRequired:=False:C215
$today:=4D_Current_date

If (Not:C34(Semaphore:C143("UpdatingListDates")))
	READ WRITE:C146([zz_control:1])
	ALL RECORDS:C47([zz_control:1])
	If (([zz_control:1]DepartmentDate:37#$today) | ([zz_control:1]FGClassDate:38#$today) | ([zz_control:1]CommodityDate:43#$today) | ([zz_control:1]ExpenseDate:44#$today) | ([zz_control:1]DownTimeDate:56#$today))
		//UNLOAD RECORD([zz_control])
		//READ WRITE([zz_control])
		//LOAD RECORD([zz_control])
		
		If (Not:C34(Locked:C147([zz_control:1])))
			
			If ([zz_control:1]DepartmentDate:37#$today)  //the department lists have not been refereshed today
				[zz_control:1]DepartmentDate:37:=$today
				$saveRequired:=True:C214
				UpdateDeptList
			End if 
			
			If ([zz_control:1]FGClassDate:38#$today)  //the FG Class/type list have not been refereshed today
				[zz_control:1]FGClassDate:38:=$today
				$saveRequired:=True:C214
				FG_updateClassification  //was UpdateDeptList `•042699  MLB 
			End if 
			
			If ([zz_control:1]CommodityDate:43#$today)  //the FG Class/type list have not been refereshed today    
				[zz_control:1]CommodityDate:43:=$today
				$saveRequired:=True:C214
				UpdateCommodityList
			End if 
			
			If ([zz_control:1]ExpenseDate:44#$today)  //the FG Class/type list have not been refereshed today  
				[zz_control:1]ExpenseDate:44:=$today
				$saveRequired:=True:C214
				UpdateExpenseCodeList
			End if 
			
			If ([zz_control:1]DownTimeDate:56#$today)  //the FG Class/type list have not been refereshed today  
				[zz_control:1]DownTimeDate:56:=$today
				$saveRequired:=True:C214
				UpdateDownTimeCodeList
			End if 
			
			If ($saveRequired)
				SAVE RECORD:C53([zz_control:1])
			End if 
		End if 
		
		UNLOAD RECORD:C212([zz_control:1])
		READ ONLY:C145([zz_control:1])
		LOAD RECORD:C52([zz_control:1])
		
	End if 
	
	CLEAR SEMAPHORE:C144("UpdatingListDates")
End if 

ARRAY TEXT:C222(<>asBuyers; 0)  //set in po before phase
ARRAY TEXT:C222(<>asBuyerName; 0)
ARRAY TEXT:C222(<>aDepartment; 0)  //used for popup lists of department codes and for validatino of entered departmen
LIST TO ARRAY:C288("Departments"; <>aDepartment)

LIST TO ARRAY:C288("InkTypes"; asInkTypex)
$num:=Size of array:C274(asInkTypex)
ARRAY TEXT:C222(<>asInkType; $num)
ARRAY TEXT:C222(<>asInkDesc; $num)
For ($i; 1; $num)
	<>asInkType{$i}:=Substring:C12(asInkTypex{$i}; 1; 2)
	<>asInkDesc{$i}:=Substring:C12(asInkTypex{$i}; 5)
End for 
CLEAR VARIABLE:C89(asInkTypex)

LIST TO ARRAY:C288("PressTypes"; asPrsTypex)
$num:=Size of array:C274(asPrsTypex)
ARRAY TEXT:C222(<>asPressType; $num)
ARRAY TEXT:C222(<>asPressDesc; $num)
For ($i; 1; $num)
	<>asPressType{$i}:=Substring:C12(asPrsTypex{$i}; 1; 2)
	<>asPressDesc{$i}:=Substring:C12(asPrsTypex{$i}; 5)
End for 
CLEAR VARIABLE:C89(asPrsTypex)

ARRAY TEXT:C222(<>aUserPrefs; 0)  //•6/24/97 cs added for seting up user prefs/notifications
LIST TO ARRAY:C288("UserPrefs"; <>aUserPrefs)