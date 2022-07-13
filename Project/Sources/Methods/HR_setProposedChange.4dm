//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/14/05, 16:55:02
//mlb use longer aServiceName array for holding changes
// ----------------------------------------------------
// Method: HR_setProposedChange
// ----------------------------------------------------

C_TEXT:C284($0; $buffer; $2)
C_LONGINT:C283($1)
C_BOOLEAN:C305($3; $buildBuffer)
C_TEXT:C284($r)

$buildBuffer:=True:C214
$r:=Char:C90(13)

Case of 
	: (Count parameters:C259=0)
		ARRAY TEXT:C222(aCPN; 9)
		aCPN{1}:="Job Title     : "
		aCPN{2}:="Department    : "
		aCPN{3}:="Classification: "
		aCPN{4}:="Grade         : "
		aCPN{5}:="Shift         : "
		aCPN{6}:="Hours         : "
		aCPN{7}:="Salary        : "
		aCPN{8}:="Reason for chg: "
		aCPN{9}:="Nature of Chg : "
		ARRAY TEXT:C222(aServiceName; 9)
		For ($i; 1; 9)
			aServiceName{$i}:=""
		End for 
		
	: (Count parameters:C259=1)
		ARRAY TEXT:C222(aCPN; 9)
		aCPN{1}:="Job Title     : "
		aCPN{2}:="Department    : "
		aCPN{3}:="Classification: "
		aCPN{4}:="Grade         : "
		aCPN{5}:="Shift         : "
		aCPN{6}:="Hours         : "
		aCPN{7}:="Salary        : "
		aCPN{8}:="Reason for chg: "
		aCPN{9}:="Nature of Chg : "
		ARRAY TEXT:C222(aServiceName; 9)
		aServiceName{1}:=""
		aServiceName{2}:=""
		aServiceName{3}:=""
		aServiceName{4}:=""
		aServiceName{5}:=""
		aServiceName{6}:=""
		aServiceName{7}:=""
		aServiceName{8}:=""
		aServiceName{9}:=""
		
	: (Count parameters:C259=2)
		aServiceName{$1}:=$2
		
	Else 
		//revert fields because these changes are in [USER]ProposedChange and
		//this is a change of status
		$buildBuffer:=False:C215
		If (Not:C34($3))  //not fCanChange
			[Users:5]BusTitle:5:=Old:C35([Users:5]BusTitle:5)
			[Users:5]Dept:31:=Old:C35([Users:5]Dept:31)
			[Users:5]Classification:49:=Old:C35([Users:5]Classification:49)
			[Users:5]Grade:51:=Old:C35([Users:5]Grade:51)
			[Users:5]Shift:52:=Old:C35([Users:5]Shift:52)
			[Users:5]HrPerWeek:50:=Old:C35([Users:5]HrPerWeek:50)
			[Users:5]Salary:53:=Old:C35([Users:5]Salary:53)
			[Users:5]SalaryUnit:54:=Old:C35([Users:5]SalaryUnit:54)
			[Users:5]ReasonForChange:55:=Old:C35([Users:5]ReasonForChange:55)
			[Users:5]NatureOfChange:48:=Old:C35([Users:5]NatureOfChange:48)
		End if 
End case 

If ($buildBuffer)
	$buffer:=":::::::: PROPOSED CHANGE ::::::::"+$r
	For ($i; 1; Size of array:C274(aServiceName))
		If (Length:C16(aServiceName{$i})>0)
			$buffer:=$buffer+aCPN{$i}+aServiceName{$i}+$r
		End if 
	End for 
Else 
	$buffer:=""
End if 

$0:=$buffer