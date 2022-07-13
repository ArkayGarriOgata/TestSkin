//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/04/06, 09:06:19
// ----------------------------------------------------
// Method: FG_DelforComparison
// Description
// rewrite the Delfor Comparison report with 3 extra columns showing
// inventory, wip, and if uptick
// ----------------------------------------------------

READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])
MESSAGES OFF:C175

C_TEXT:C284($line)
C_TEXT:C284($r; $t)
C_TIME:C306($docIn; $docOut)

$r:=Char:C90(13)
$t:=Char:C90(9)
//open the current delfor document

$docIn:=Open document:C264("")
If (OK=1)
	$elements:=Num:C11(util_TextParser(1; document; Character code:C91(":"); Character code:C91(":")))
	$docName:=util_TextParser($elements)
	$path:=Replace string:C233(document; $docName; "")
	//open a doc to save results too
	$newDoc:=$path+"_"+$docName
	util_deleteDocument($newDoc)
	
	$docOut:=Create document:C266($newDoc)
	If (OK=1)
		//grab each line in the do
		RECEIVE PACKET:C104($docIn; $line; $r)
		If (OK=1)
			SEND PACKET:C103($docOut; $line+$t+"qtyOH"+$t+"qtyWIP"+$t+"UpTick"+$r)
		End if 
		RECEIVE PACKET:C104($docIn; $line; $r)
		$i:=0
		
		uThermoInit(1000; "Processing "+$docName+"; Saving to "+"_"+$docName)
		
		While (OK=1)
			$i:=$i+1
			//add some stuff and save to new document
			$qtyOH:=0
			$qtyWIP:=0
			$uptick:=""
			$elements:=Num:C11(util_TextParser(8; $line))
			$cpn:=util_TextParser(1)
			
			//============Look for inventory
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$cpn)
			//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location#"BH@")
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				$qtyOH:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			End if 
			
			//============Look for open production
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$cpn; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				ARRAY LONGINT:C221($aQty; 0)
				ARRAY LONGINT:C221($aActQty; 0)
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Yield:9; $aQty; [Job_Forms_Items:44]Qty_Actual:11; $aActQty)
				For ($jobit; 1; Size of array:C274($aQty))
					$openProduction:=$aQty{$jobit}-$aActQty{$jobit}
					If ($openProduction<0)  //excess
						$openProduction:=0
					End if 
					$qtyWIP:=$qtyWIP+$openProduction
				End for 
				ARRAY LONGINT:C221($aQty; 0)
				ARRAY LONGINT:C221($aActQty; 0)
			End if 
			
			//============Determine if this is an uptick
			If (Length:C16($cpn)>4)
				$family:=Substring:C12($cpn; 1; 4)+"@"
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$family)
				If (Records in selection:C76([Finished_Goods:26])>1)
					$uptick:="!!!"
				End if 
			End if 
			
			//============Save it to the new document
			SEND PACKET:C103($docOut; $line+$t+String:C10($qtyOH)+$t+String:C10($qtyWIP)+$t+$uptick+$r)
			
			RECEIVE PACKET:C104($docIn; $line; $r)
			uThermoUpdate($i)
			
		End while 
		uThermoClose
		CLOSE DOCUMENT:C267($docOut)
		
	End if 
	CLOSE DOCUMENT:C267($docIn)
	
End if 

util_TextParser