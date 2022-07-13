//%attributes = {}
// Method: addEntity
//posted by Ad K in hte discuss.4D.com

C_LONGINT:C283($1; $step_l)

If (Count parameters:C259>=1)
	$step_l:=$1
End if 

C_OBJECT:C1216($vo_record)

Case of 
	: (Form event code:C388=On Clicked:K2:4) & ($step_l=0)
		
		$vo_record:=ds:C1482.Customers.new()
		$vo_record.Name:="__New Record "+String:C10(Current time:C178)
		$vo_record.save()
		
		Form:C1466.selection:=Form:C1466.selection.add($vo_record)
		CALL FORM:C1391(Current form window:C827; Current method name:C684; 1)
		
	: ($step_l=1)
		LISTBOX SELECT ROW:C912(*; "listbox"; Form:C1466.selection.length)
		CALL FORM:C1391(Current form window:C827; Current method name:C684; 2)
		
	: ($step_l=2)
		LISTBOX SORT COLUMNS:C916(*; "listbox"; 1; >)
End case 