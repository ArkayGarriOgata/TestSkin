//%attributes = {}
// _______
// Method: Est_getFGKEYfromClipboard   ( ) ->
// By: Mel Bohince @ 10/26/21, 08:11:53
// Description
// read the clipboard and parse to an array
// and mimic results of sAddCart2Est( )
// ----------------------------------------------------

C_COLLECTION:C1488($fg_c; $columns_c)

C_TEXT:C284($row; $po; $clipboard_t; $beginsWith; $delimitorRow; $delimitorColumn; $custId)
$delimitorRow:="\r\n"
$delimitorColumn:="\t"


C_BOOLEAN:C305($continue)
C_OBJECT:C1216($fg_e; $cartonSpec_e; $status_o)

$clipboard_t:=Get text from pasteboard:C524  //copied from excel, columns delimited by <tabs>, rows by <return+newline>

$fg_c:=New collection:C1472
$fg_c:=Split string:C1554($clipboard_t; $delimitorRow; sk ignore empty strings:K86:1+sk trim spaces:K86:2)

//subtract 1 to collection starting at 0, assuming cut from THC report
$columnWithCustID:=1-1
$columnWithCPN:=5-1
$columnWithQty:=11-1

uConfirm("Expecting Custid in column 1, ProductCode in column 5, and Qty in column 11."; "Ok"; "Change")
If (ok=0)
	$columnWithCustID:=Num:C11(Request:C163("Custid column: "; String:C10($columnWithCustID+1); "Ok"; "Abort"))-1
	If (ok=1)
		$columnWithCPN:=Num:C11(Request:C163("ProductCode column: "; String:C10($columnWithCPN+1); "Ok"; "Abort"))-1
		If (ok=1)
			$columnWithQty:=Num:C11(Request:C163("Quantity column: "; String:C10($columnWithQty+1); "Ok"; "Abort"))-1
		End if 
	End if 
End if 

If (ok=1)
	$continue:=True:C214  //option to abort if invalid fgkey read
	
	//set the item counter to next higher number
	SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]Item:1; $_Item)  //should be the work sheet cartons
	If (Size of array:C274($_Item)>0)
		SORT ARRAY:C229($_Item; <)
		$itemCounter:=Num:C11($_Item{1})+1
		If ($itemCounter>99)
			ALERT:C41("Item Counter will exceed 99, you'll need to edit.")
		End if 
		
	Else 
		$itemCounter:=1
	End if 
	
	For each ($row; $fg_c) While ($continue)
		
		$columns_c:=Split string:C1554($row; $delimitorColumn; sk trim spaces:K86:2)  //sk ignore empty strings+
		If ($columns_c.length>0)
			$custId:=String:C10(Num:C11($columns_c[$columnWithCustID]); "00000")  //excel may have stripped the leading 0's
			$fgKey:=$custId+":"+$columns_c[$columnWithCPN]
			$qty:=$columns_c[$columnWithQty]
			//test if valid before adding to the collection
			$fg_e:=ds:C1482.Finished_Goods.query("FG_KEY = :1"; $fgKey).first()
			If ($fg_e#Null:C1517)
				$cartonSpec_e:=ds:C1482.Estimates_Carton_Specs.new()
				$cartonSpec_e.Estimate_No:=[Estimates:17]EstimateNo:1
				$cartonSpec_e.diffNum:="00"  //◊sQtyWorksht  `defined in 00CompileString()  indicates records go to Qty-Worksheet
				$cartonSpec_e.Item:=String:C10($itemCounter; "00")
				$cartonSpec_e.CartonSpecKey:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
				$cartonSpec_e.CustID:=[Estimates:17]Cust_ID:2
				$cartonSpec_e.ProductCode:=Substring:C12($fgKey; 7)
				$cartonSpec_e.OriginalOrRepeat:="Repeat"
				$cartonSpec_e.PONumber:=[Estimates:17]POnumber:18
				$cartonSpec_e.zCount:=1
				$cartonSpec_e.Quantity_Want:=$qty
				$cartonSpec_e.Qty1Temp:=$qty
				
				//do the FG_CspecLikeFG thing with the fg object
				$cartonSpec_e.CustID:=$fg_e.CustID  // • 1/8/97 multiple customers on one job
				$cartonSpec_e.ProductCode:=$fg_e.ProductCode
				$cartonSpec_e.Description:=$fg_e.CartonDesc
				$cartonSpec_e.OutLineNumber:=$fg_e.OutLine_Num
				$cartonSpec_e.SquareInches:=$fg_e.SquareInch
				$cartonSpec_e.Width:=$fg_e.Width
				$cartonSpec_e.Depth:=$fg_e.Depth
				$cartonSpec_e.Height:=$fg_e.Height
				$cartonSpec_e.Width_Dec:=$fg_e.Width_Dec
				$cartonSpec_e.Depth_Dec:=$fg_e.Depth_Dec
				$cartonSpec_e.Height_Dec:=$fg_e.Height_Dec
				$cartonSpec_e.Style:=$fg_e.Style
				$cartonSpec_e.ProcessSpec:=$fg_e.ProcessSpec
				$cartonSpec_e.StripHoles:=$fg_e.StripHoles
				$cartonSpec_e.WindowMatl:=$fg_e.WindowMatl
				$cartonSpec_e.WindowGauge:=$fg_e.WindowGauge
				$cartonSpec_e.WindowWth:=$fg_e.WindowWth
				$cartonSpec_e.WindowHth:=$fg_e.WindowHth
				$cartonSpec_e.GlueType:=$fg_e.GlueType
				$cartonSpec_e.GlueInspect:=$fg_e.GlueInspect
				$cartonSpec_e.SecurityLabels:=$fg_e.SecurityLabels
				$cartonSpec_e.DieCutOptions:=$fg_e.DieCutOptions
				$cartonSpec_e.UPC:=$fg_e.UPC  //Not(($fg_e.UPC="") | ($fg_e.UPC="N/A"))
				$cartonSpec_e.z_ArtReceived:=String:C10($fg_e.DateArtApproved; System date short:K1:1)
				$cartonSpec_e.PackingQty:=$fg_e.PackingQty
				$cartonSpec_e.Classification:=$fg_e.ClassOrType
				$cartonSpec_e.CartonComment:=$fg_e.Notes  //•011696  MLB  to hold glue speed
				$cartonSpec_e.OrderType:=$fg_e.OrderType  //• 5/23/97 cs upr 1857
				$cartonSpec_e.OriginalOrRepeat:=$fg_e.OriginalOrRepeat
				
				If ($fg_e.RKContractPrice#0)  //•081999  mlb  
					$cartonSpec_e.PriceWant_Per_M:=$fg_e.RKContractPrice
					$cartonSpec_e.PriceYield_PerM:=$fg_e.RKContractPrice
				End if 
				
				$cartonSpec_e.Leaf_Information:=$fg_e.Leaf_Information
				
				$status_o:=$cartonSpec_e.save(dk auto merge:K85:24)
				If ($status_o.success)
					zwStatusMsg("SUCCESS"; "Finished Good "+$cartonSpec_e.ProductCode+" has been added to "+$cartonSpec_e.Estimate_No)
					$itemCounter:=$itemCounter+1
				Else 
					BEEP:C151
					zwStatusMsg("FAIL"; "Finished Good "+$cartonSpec_e.ProductCode+" not added to "+$cartonSpec_e.Estimate_No)
				End if 
				
			Else 
				uConfirm("' "+$fgKey+" ' is not a valid FG_KEY, Continue?"; "Continue"; "Abort")
				If (ok=0)
					$continue:=False:C215
				End if 
			End if 
			
		End if 
		
	End for each 
	
End if   //clipboad split
