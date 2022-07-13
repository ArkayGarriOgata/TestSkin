//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/14/05, 16:45:41
// ----------------------------------------------------
// Method: HR_setCurrentStatus
// ----------------------------------------------------

$r:=Char:C90(13)
$c:=":"
$theChange:=[Users:5]ProposedChange:46
$rtn:=Position:C15($r; $theChange)

While ($rtn>0)
	$line:=Substring:C12($theChange; 1; $rtn-1)
	$colon:=Position:C15($c; $line)
	$key:=Substring:C12($line; 1; $colon-1)
	$value:=txt_Trim(Substring:C12($line; $colon+1))
	
	Case of 
		: (Length:C16($value)=0)
			//skip
			
		: (Position:C15("Job Title"; $key)>0)
			[Users:5]BusTitle:5:=$value
			
		: (Position:C15("Department"; $key)>0)
			[Users:5]Dept:31:=$value
			
		: (Position:C15("Classification"; $key)>0)
			[Users:5]Classification:49:=$value
			
		: (Position:C15("Grade"; $key)>0)
			[Users:5]Grade:51:=$value
			
		: (Position:C15("Shift"; $key)>0)
			[Users:5]Shift:52:=$value
			
		: (Position:C15("Hours"; $key)>0)
			[Users:5]HrPerWeek:50:=Num:C11($value)
			
		: (Position:C15("Salary"; $key)>0)
			$slash:=Position:C15("/"; $value)
			If ($slash>0)
				[Users:5]Salary:53:=Num:C11(Substring:C12($value; 1; $slash-1))
				[Users:5]SalaryUnit:54:=Substring:C12($value; $slash+1)
			Else 
				[Users:5]Salary:53:=Num:C11($value)
			End if 
			
		: (Position:C15("Reason"; $key)>0)
			[Users:5]ReasonForChange:55:=$value
			
		: (Position:C15("Nature"; $key)>0)
			[Users:5]NatureOfChange:48:=$value
	End case 
	
	$theChange:=Substring:C12($theChange; $rtn+1)
	$rtn:=Position:C15($r; $theChange)
End while 

[Users:5]DateChgEffective:56:=4D_Current_date
[Users:5]LastApprovers:57:=[Users:5]ApprovedBy:45
[Users:5]History:47:=TS2String(TSTimeStamp)+Char:C90(13)+[Users:5]ProposedChange:46+Char:C90(13)+("_"*10)+Char:C90(13)+[Users:5]History:47
[Users:5]ProposedChange:46:=""
t3:=HR_getCurrentStatus

ALERT:C41("Review the changes before saving. Click 'Cancel' button if they look wrong.")
FORM GOTO PAGE:C247(1)