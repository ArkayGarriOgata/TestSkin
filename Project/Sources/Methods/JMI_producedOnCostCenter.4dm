//%attributes = {}
// Method: JMI_producedOnCostCenter () -> 
// ----------------------------------------------------
// by: mel: 04/01/05, 16:53:14
// ----------------------------------------------------

C_DATE:C307($begin; $end)
C_TEXT:C284($cc)

READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Customers_ReleaseSchedules:46])

CONFIRM:C162("Hunt down jobits that used a specific gluer?")
If (OK=1)
	$cc:=Request:C163("Which C/C?")
	$begin:=Date:C102(Request:C163("Beginning on?"))
	$end:=Date:C102(Request:C163("Ending on?"))
	READ ONLY:C145([Job_Forms_Machine_Tickets:61])
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=$cc; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5>=$begin; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=$end)
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]JobForm:1; $jf; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; $item)
		ARRAY TEXT:C222($jobit; Size of array:C274($jf))
		For ($i; 1; Size of array:C274($jf))
			$jobit{$i}:=JMI_makeJobIt($jf{$i}; $item{$i})
		End for 
		QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]Jobit:33; $jobit)
		
		CONFIRM:C162("Just ELC?")
		If (OK=1)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
				
				CREATE SET:C116([Finished_Goods_Locations:35]; "gluedOnes")
				ELC_query(->[Finished_Goods_Locations:35]CustID:16)
				CREATE SET:C116([Finished_Goods_Locations:35]; "elcOnes")
				INTERSECTION:C121("gluedOnes"; "elcOnes"; "interestingOnes")
				USE SET:C118("interestingOnes")
				CLEAR SET:C117("interestingOnes")
				CLEAR SET:C117("gluedOnes")
				CLEAR SET:C117("elcOnes")
				
			Else 
				$criteria:=ELC_getName
				READ ONLY:C145([Finished_Goods_Locations:35])
				QUERY SELECTION BY FORMULA:C207([Finished_Goods_Locations:35]; \
					([Finished_Goods_Locations:35]CustID:16=[Customers:16]ID:1)\
					 & ([Customers:16]ParentCorp:19=$criteria)\
					)
				
			End if   // END 4D Professional Services : January 2019 ELC_query
			
		End if 
		
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			CONFIRM:C162("Find open releases for these items?")
			If (OK=1)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]ProductCode:1; $fg)
					QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; $fg)
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
					
				Else 
					
					$criteria:=ELC_getName
					
					QUERY BY FORMULA:C48([Customers_ReleaseSchedules:46]; \
						([Finished_Goods_Locations:35]CustID:16=[Customers:16]ID:1)\
						 & ([Customers:16]ParentCorp:19=$criteria)\
						 & ([Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods_Locations:35]ProductCode:1)\
						 & ([Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)\
						)
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				
			End if 
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("None found.")
	End if 
	
End if 