//%attributes = {}
// _______
// Method: RM_AlloctionStillNeeded   ( ) ->
// By: MelvinBohince @ 01/31/22, 11:48:27
// Description
// test if cold foil has been recorded on the alloction record
// ----------------------------------------------------

//assumes only one allocation of commodity to a jobform

C_OBJECT:C1216($alloc_es; $alloc_e; $jml_e)
//C_COLLECTION($presses_c) //$presses_c:=New collection("418";"419";"420";"421") //if testing scheduled

$alloc_es:=ds:C1482.Raw_Materials_Allocations.query("commdityKey = :1"; "09@")
For each ($alloc_e; $alloc_es)
	
	$jml_e:=ds:C1482.Job_Forms_Master_Schedule.query("JobForm = :1"; $alloc_e.JobForm).first()
	If ($jml_e#Null:C1517)
		If ($jml_e.Printed#!00-00-00!)  //already printed, so check the issues
			
			$rmx_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Commodity_Key = :2 and Xfer_Type = :3"; $alloc_e.JobForm; "09@"; "issue")
			If ($rmx_es.length>0)
				
				$issued:=$rmx_es.sum("Qty")*-1  //flip sign to be comparible to allocation
				
				If ($alloc_e.Qty_Allocated<=$issued)  //amt or more that required issued
					$alloc_e.Qty_Issued:=$issued
					$alloc_e.Date_Issued:=Current date:C33
					$alloc_e.ModWho:="mel"
					$alloc_e.save()
				End if 
				
			End if   //rmx's 
			
		End if   //printed
	End if 
	
End for each   //alloc
