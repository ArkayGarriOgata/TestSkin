//Script: aStat() 

$old_status:=[Estimates:17]Status:30
util_PopUpDropDownAction(->aStat; ->[Estimates:17]Status:30)

If ($old_status="New") & ([Estimates:17]Status:30="RFQ")
	$can_advance_status:=True:C214
	$bad_a_number:=""
	//verify that A#'s are approved
	
	//get a list of a#'s used
	gEstimateLDWkSh("Both")
	ARRAY TEXT:C222($aA_number; 0)
	DISTINCT VALUES:C339([Estimates_Carton_Specs:19]OutLineNumber:15; $aA_number)
	
	//check status on each, stop when nogo found
	C_LONGINT:C283($i; $numElements)
	$numElements:=Size of array:C274($aA_number)
	READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
	SET QUERY LIMIT:C395(1)
	uThermoInit($numElements; "Checking Size & Style status...")
	For ($i; 1; $numElements)
		If (Length:C16($aA_number{$i})>0)
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$aA_number{$i})
			If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
				If (Length:C16([Finished_Goods_SizeAndStyles:132]GlueAppvNumber:53)=0) & ([Finished_Goods_SizeAndStyles:132]DateSubmitted:5>!2010-09-03!)
					$can_advance_status:=False:C215
					$bad_a_number:=$bad_a_number+$aA_number{$i}+","
					//$i:=1+$numElements
				End if 
				
			Else   //bad reference
				$can_advance_status:=False:C215
				$bad_a_number:=$bad_a_number+$aA_number{$i}+" MIA,"
				//$i:=1+$numElements
			End if 
			
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
	SET QUERY LIMIT:C395(0)
	
	//warn if fail
	If (Not:C34($can_advance_status))
		If (User in group:C338(Current user:C182; "SalesManager"))
			uConfirm("Warning: Not all A#'s have a GA#. ("+$bad_a_number+")."; "Continue"; "I Rule")
		Else 
			uConfirm("Not all A#'s have a GA#, status not changed.("+$bad_a_number+"),"; "OK"; "Darn")
			[Estimates:17]Status:30:=$old_status
			util_ComboBoxSetup(->astat; [Estimates:17]Status:30)
		End if 
	End if 
	
	gEstimateLDWkSh("Wksht")
End if 