//%attributes = {"publishedWeb":true}
//PM: ams_DeleteUnusedProjects() -> 
//@author mlb - 7/3/02  10:58

C_TEXT:C284(pjtId)
C_LONGINT:C283($i; $numPjt; $hits)
C_BOOLEAN:C305($active)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	READ WRITE:C146([Customers_Projects:9])
	ALL RECORDS:C47([Customers_Projects:9])
	
	READ ONLY:C145([Finished_Goods_Specifications:98])
	READ ONLY:C145([Estimates:17])
	READ ONLY:C145([Customers_Order_Lines:41])
	READ ONLY:C145([Job_Forms:42])
	READ ONLY:C145([JPSI_Job_Physical_Support_Items:111])
	READ ONLY:C145([JTB_Job_Transfer_Bags:112])
	
	$numPjt:=Records in selection:C76([Customers_Projects:9])
	uThermoInit($numPjt; "Marking Inactive Projects")
	SET QUERY LIMIT:C395(1)
	$hits:=0  // Modified by: Mel Bohince (6/9/21) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $hits)
	For ($i; 1; $numPjt)
		pjtId:=[Customers_Projects:9]id:1
		$active:=False:C215
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProjectNumber:82=pjtId)
		If ($hits=0)
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]ProjectNumber:2=pjtId)
			If ($hits=0)
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProjectNumber:4=pjtId)
				If ($hits=0)
					QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=pjtId)
					If ($hits=0)
						QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50=pjtId)
						If ($hits=0)
							QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProjectNumber:56=pjtId)
							If ($hits=0)
								QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]PjtNumber:3=pjtId)
								If ($hits=0)
									QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]PjtNumber:2=pjtId)
									If ($hits>0)
										$active:=True:C214
									End if 
								Else 
									$active:=True:C214
								End if 
							Else 
								$active:=True:C214
							End if 
						Else 
							$active:=True:C214
						End if 
					Else 
						$active:=True:C214
					End if 
				Else 
					$active:=True:C214
				End if 
			Else 
				$active:=True:C214
			End if 
		Else 
			$active:=True:C214
		End if 
		
		[Customers_Projects:9]ActiveProject:26:=$active
		SAVE RECORD:C53([Customers_Projects:9])
		NEXT RECORD:C51([Customers_Projects:9])
		uThermoUpdate($i)
	End for 
	SET QUERY LIMIT:C395(0)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	uThermoClose
	
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]ActiveProject:26=False:C215)
	util_DeleteSelection(->[Customers_Projects:9])
Else 
	
	
	uThermoInit($numPjt; "Marking Inactive Projects")
	
	ALL RECORDS:C47([Customers_Projects:9])
	APPLY TO SELECTION:C70([Customers_Projects:9]; [Customers_Projects:9]ActiveProject:26:=False:C215)
	
	QUERY BY FORMULA:C48([Customers_Projects:9]; ([Finished_Goods:26]ProjectNumber:82=[Customers_Projects:9]id:1) | ([Finished_Goods_SizeAndStyles:132]ProjectNumber:2=[Customers_Projects:9]id:1) | ([Finished_Goods_Specifications:98]ProjectNumber:4=[Customers_Projects:9]id:1) | ([Estimates:17]ProjectNumber:63=[Customers_Projects:9]id:1) | ([Customers_Order_Lines:41]ProjectNumber:50=[Customers_Projects:9]id:1) | ([Job_Forms:42]ProjectNumber:56=[Customers_Projects:9]id:1) | ([JPSI_Job_Physical_Support_Items:111]PjtNumber:3=[Customers_Projects:9]id:1) | ([JTB_Job_Transfer_Bags:112]PjtNumber:2=[Customers_Projects:9]id:1))
	
	APPLY TO SELECTION:C70([Customers_Projects:9]; [Customers_Projects:9]ActiveProject:26:=True:C214)
	
	uThermoClose
	
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]ActiveProject:26=False:C215)
	$numSelected:=Records in selection:C76([Customers_Projects:9])
	Repeat   // Repeat for any locked records
		DELETE SELECTION:C66([Customers_Projects:9])
		If (Records in set:C195("LockedSet")#0)  // If there are locked records
			USE SET:C118("LockedSet")  // Select only the locked records
		End if 
	Until (Records in set:C195("LockedSet")=0)
	utl_Logfile("delete.log"; String:C10($numSelected)+" records deleted from "+Table name:C256(->[Customers_Projects:9]))
	
	
End if   // END 4D Professional Services : January 2019 next record
