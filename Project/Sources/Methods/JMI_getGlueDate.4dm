//%attributes = {}
// Method: JMI_getGlueDate ("12345.12.12") -> date
// ----------------------------------------------------
// by: mel: 02/10/04, 09:41:03
// ----------------------------------------------------
// Description:
// return the 1st glue date of a jobit
// ----------------------------------------------------

C_TEXT:C284($1; $2)
C_DATE:C307($0; $glueDate)

$glueDate:=!00-00-00!

If (Length:C16($1)=11)
	If ([Job_Forms_Items:44]Jobit:4#$1)
		MESSAGES OFF:C175
		READ ONLY:C145([Job_Forms_Items:44])
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$1)
		SET QUERY LIMIT:C395(0)
	End if 
	
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		$glueDate:=[Job_Forms_Items:44]Glued:33
		If ($glueDate=!00-00-00!)
			$glueDate:=[Job_Forms_Items:44]Completed:39
		End if 
	End if 
	
	If (Count parameters:C259=2) & ($glueDate=!00-00-00!)  //try harder
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$1; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
			SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aTransDate)
			SORT ARRAY:C229($aTransDate; >)
			$glueDate:=$aTransDate{1}
		End if 
	End if 
End if 

$0:=$glueDate