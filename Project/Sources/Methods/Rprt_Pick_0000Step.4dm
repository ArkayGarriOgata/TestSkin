//%attributes = {}
//Method:  Rprt_Pick_0000Step(oParameter)
//Description:  This method is a template for a report

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nStep)
	
End if   //Done initialize

Case of   //Steps
		
	: ($nStep=1)  //Create the [Report] record and [Rprt_Criterion] record(s)
		
		//1.  Click on the new button when dialog comes up.
		
		//. [Report]
		
		//   Group        is the group or username that will have acces to this report
		//                   (Note: create multiple records if everyone in this group but also this user(s)
		//   Category     is the category of where this report falls into (folder in H-List)
		//   Name         is the name of the report that will show up on the list
		//   Method       is the name of the method that will execute
		//   Description  is the description of the report: what it does, why, what gets deduced from report
		//   CreatedOn    is the date it was created
		//   CreatedFor   is the user it was created for
		//   RunOn        is the date it was last run
		//   RunBy        is the user who last ran it
		//   RunCount     is the number of times the report was run since creation
		//   SampleRaw    is a saved version of the last run report
		
		//. [Rprt_Criterion]
		
		//   Title       is the title of the display
		//   Default     is the default value to display
		//   Format      allows us to know if this column is:
		//                 sorted: <,>
		//                 order of sort: 1...N, 
		//                 styled: B, P, I, U
		//                 summed: S
		//                 formated: $, ($), % or "###"
		
	: ($nStep=2)  //Create the Query 
		
		If (True:C214)  //Initialize
			
			C_OBJECT:C1216($1; $oParameter)
			
			$oParameter:=$1
			
			C_BOOLEAN:C305($bValid)
			
			C_OBJECT:C1216($oAlert)
			C_OBJECT:C1216($esCustomers_Orders)
			
			C_TEXT:C284($tAnd; tQuery)
			
			$bValid:=True:C214
			
			$oAlert:=New object:C1471()
			$oAlert.tMessage:="Please make sure all search criteria is filled in."
			
			$tAnd:=CorektSingleQuote+CorektRightParen+CorektSpace+"And"+CorektSpace
			
			$tQuery:=CorektBlank
			
		End if   //Done initialize
		
		For each ($tParameter; $oParameter) While ($bValid)  //Parameter
			
			$bValid:=Core_OB_IsValidB(->$oParameter; $tParameter)
			
			Case of   //Criterion
					
				: (Not:C34($bValid))
					
				: ($tParameter="Start Date")
					
					If (OB Is defined:C1231($oParameter; "End Date"))
						
						$tCriterion:="(Completed >= '"+String:C10(OB Get:C1224($oParameter; $tParameter; Is date:K8:7))+$tAnd
						
					Else 
						
						$tCriterion:="(Completed = '"+String:C10(OB Get:C1224($oParameter; $tParameter; Is date:K8:7))+$tAnd
						
					End if 
					
				: ($tParameter="End Date")
					
					$tCriterion:="(Completed >= '"+String:C10(OB Get:C1224($oParameter; $tParameter; Is date:K8:7))+$tAnd
					
				Else 
					
					$tCriterion:="(CustomerName = '"+(OB Get:C1224($oParameter; $tParameter; Is text:K8:3))+$tAnd
					
			End case   //Done criterion
			
			$tQuery:=$tQuery+$tCriterion
			
		End for each   //Done parameter
		
		If ($bValid)
			
			$tTableName:=Table name:C256(->[Customers_Orders:40])
			
			$tQuery:=Substring:C12($tQuery; 1; Length:C16($tQuery)-5)
			
			$esCustomers_Orders:=ds:C1482[$tTableName].query($tQuery)
			
		Else 
			
			Core_Dialog_Alert($oAlert)
			
		End if 
		
	: ($nStep=3)  //Create the Report
		
		//See method: OrLn_Rprt_VoyantCEIBooking
		
		If (True:C214)  //Initialize
			
			C_OBJECT:C1216($1; $esORDATable)
			
			C_BOOLEAN:C305($bTitle)
			
			C_COLLECTION:C1488($cAttribute)
			
			$esORDATable:=$1
			
			$bTitle:=True:C214
			
			$cAttribute:=New collection:C1472(\
				"OrderNumber"; \
				"CustID"; \
				"CustomerName"; \
				"defaultBillto"; \
				"DateOpened"; \
				"ORDER.EnteredBy"; \
				"ORDER.PONumber"; \
				"CustomerLine"; \
				"PRODUCT_CODE.ProductCode"; \
				"PRODUCT_CODE.CartonDesc"; \
				"Quantity"; \
				"Price_Per_M"; \
				"Price_Extended")  //Attributes of the esORDATable
			
		End if   //Done initialize
		
		VwPr_SetRow($tViewProArea; $cAttribute; $esORDATable; $bTitle)
		
End case   //Done steps
