//%attributes = {}
// Method: Estimate_AssignToProject
// Date and time: 05/22/06, 16:33:47
// ----------------------------------------------------
// Modified by: Mel Bohince (2/11/21) set custid on cartonspecs and chg to orda

C_TEXT:C284($pjtNum; $1)
$pjtNum:=$1

If (Length:C16($pjtNum)#0)
	
	C_OBJECT:C1216($pjt_e)
	$pjt_e:=ds:C1482.Customers_Projects.query("id = :1"; $pjtNum).first()
	If ($pjt_e#Null:C1517)
		[Estimates:17]ProjectNumber:63:=$pjtNum
		[Estimates:17]Cust_ID:2:=$pjt_e.Customerid
		[Estimates:17]CustomerName:47:=$pjt_e.CustomerName
		
		If (ds:C1482.Customers_Brand_Lines.query("CustID = :1 and LineNameOrBrand = ;2"; $pjt_e.Customerid; $pjt_e.Name).length>0)
			[Estimates:17]Brand:3:=$pjt_e.Name
		End if 
		
		C_OBJECT:C1216($cSpecs_es; $cSpec_e)
		$cSpecs_es:=ds:C1482.Estimates_Carton_Specs.query("Estimate_No = :1"; [Estimates:17]EstimateNo:1)
		If ($cSpecs_es.length>0)  //set their custid to match the project
			For each ($cSpec_e; $cSpecs_es)
				$cSpec_e.CustID:=$pjt_e.Customerid
				C_OBJECT:C1216($status_o)
				$status_o:=$cSpec_e.save(dk auto merge:K85:24)
				If ($status_o.success)
					zwStatusMsg("SUCCESS"; "customer id updated ")
				Else 
					zwStatusMsg("FAIL"; "customer id NOT saved")
				End if 
				
			End for each 
		End if 
		
	End if   //found the project
	
	
	//old way:
	
	//QUERY([Customers_Projects];[Customers_Projects]id=[Estimates]ProjectNumber)
	//If (Records in selection([Customers_Projects])=1)
	//[Estimates]Cust_ID:=[Customers_Projects]Customerid
	//[Estimates]CustomerName:=[Customers_Projects]CustomerName
	//  //see if project name matches a brand
	//C_LONGINT($numFound)
	//SET QUERY DESTINATION(Into variable;$numFound)
	//QUERY([Customers_Brand_Lines];[Customers_Brand_Lines]CustID=[Estimates]Cust_ID;*)
	//QUERY([Customers_Brand_Lines]; & ;[Customers_Brand_Lines]LineNameOrBrand=[Customers_Projects]Name)
	//SET QUERY DESTINATION(Into current selection)
	//If ($numFound>0)
	//[Estimates]Brand:=[Customers_Projects]Name
	//End if 
	//End if 
	
Else 
	uConfirm("' "+$pjtNum+" ' does not appear valid."; "Ok"; "Help")
End if 