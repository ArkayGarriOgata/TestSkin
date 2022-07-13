//%attributes = {"publishedWeb":true}
//PM: JMI_getMAD() -> 
//@author mlb - 8/2/01  15:06

C_TEXT:C284($1; $cpn; $orderline; $2)
C_DATE:C307($0)
C_LONGINT:C283($i)

READ ONLY:C145([Job_Forms_Items:44])

If (Count parameters:C259=0)
	$cpn:=[Customers_ReleaseSchedules:46]ProductCode:11
	$orderline:=[Customers_ReleaseSchedules:46]OrderLine:4
Else 
	$cpn:=$1
	$orderline:=$2
End if 

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$cpn; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]OrderItem:2=$orderline)
Case of 
	: (Records in selection:C76([Job_Forms_Items:44])=1)
		$0:=[Job_Forms_Items:44]MAD:37
		
	: (Records in selection:C76([Job_Forms_Items:44])>1)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]; $aRecNo; [Job_Forms_Items:44]MAD:37; $aDates)
		SORT ARRAY:C229($aDates; >)
		For ($i; 1; Size of array:C274($aDates))
			If ($aDates{$i}#!00-00-00!)
				$0:=$aDates{$i}
				GOTO RECORD:C242([Job_Forms_Items:44]; $aRecNo{$i})
				$i:=$i+Size of array:C274($aDates)
			End if 
		End for 
		
	Else 
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$cpn; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
		$0:=!00-00-00!
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]; $aRecNo; [Job_Forms_Items:44]MAD:37; $aDates)
		SORT ARRAY:C229($aDates; >)
		For ($i; 1; Size of array:C274($aDates))
			If ($aDates{$i}#!00-00-00!)
				$0:=$aDates{$i}
				GOTO RECORD:C242([Job_Forms_Items:44]; $aRecNo{$i})
				$i:=$i+Size of array:C274($aDates)
			End if 
		End for 
End case 