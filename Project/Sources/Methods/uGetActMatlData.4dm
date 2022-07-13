//%attributes = {"publishedWeb":true}
//uGetActMatlData 10/26/94 upr1255
//12/6/94 paranoid about nulls creeping in
//•080596  MLB  add quick method
//•090297  MLB  go by sequence instead of by rm code, for unbudgeted itmes
//• 4/10/98 cs Nan Checking
//•051299  mlb  UPR 1921

C_LONGINT:C283($1)  //•080596  MLB 
If (Count parameters:C259=0)  //only one materialjob record selected
	READ ONLY:C145([Raw_Materials_Transactions:23])
	//•090297  MLB  go by sequence instead of by rm code, for unbudgeted itmes
	// SEARCH([RM_XFER];[RM_XFER]Raw_Matl_Code=[Material_Job]Raw_Matl_Code;*)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Sequence:13=[Job_Forms_Materials:55]Sequence:3; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms_Materials:55]JobForm:1; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]CommodityCode:24=Num:C11(Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2)); *)  //•051299  mlb  UPR 1921 don't cross mix
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)  //12/6/94
		[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck(Sum:C1([Raw_Materials_Transactions:23]Qty:6)*-1)
		[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck(Sum:C1([Raw_Materials_Transactions:23]ActExtCost:10)*-1)
	Else 
		[Job_Forms_Materials:55]Actual_Qty:14:=0
		[Job_Forms_Materials:55]Actual_Price:15:=0
	End if 
	
Else   //we  of the materialJob records
	//QUERY([Raw_Materials_Transactions]; & ;[Raw_Materials_Transactions]JobForm=[Job_Forms]JobFormID;*)
	//QUERY([Raw_Materials_Transactions]; & ;[Raw_Materials_Transactions]Xfer_Type="Issue")
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		ARRAY TEXT:C222($aComm; 0)
		ARRAY REAL:C219($aQty; 0)
		ARRAY REAL:C219($aCost; 0)
		ARRAY TEXT:C222($aRMcode; 0)
		C_LONGINT:C283($i; $hit)
		C_REAL:C285($qty; $cost)
		SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Commodity_Key:22; $aComm; [Raw_Materials_Transactions:23]Qty:6; $aQty; [Raw_Materials_Transactions:23]ActExtCost:10; $aCost; [Raw_Materials_Transactions:23]Sequence:13; $aSeq; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; $aRMcode)
		SORT ARRAY:C229($aComm; $aQty; $aCost; $aSeq; $aRMcode; >)
		ARRAY INTEGER:C220($aCounted; Size of array:C274($aComm))
		//*Distribute issues first by commoditykey
		FIRST RECORD:C50([Job_Forms_Materials:55])
		For ($i; 1; Records in selection:C76([Job_Forms_Materials:55]))
			$qty:=0
			$cost:=0
			$hit:=Find in array:C230($aComm; [Job_Forms_Materials:55]Commodity_Key:12)
			While ($hit#-1)
				If ($aCounted{$hit}#1)
					$qty:=$qty+$aQty{$hit}
					$cost:=$cost+$aCost{$hit}
					$aCounted{$hit}:=1
				End if 
				
				$hit:=Find in array:C230($aComm; [Job_Forms_Materials:55]Commodity_Key:12; ($hit+1))
			End while 
			[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck($qty*-1)
			[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck($cost*-1)
			SAVE RECORD:C53([Job_Forms_Materials:55])
			NEXT RECORD:C51([Job_Forms_Materials:55])
		End for 
		//*now get the issues which were not counted above
		SORT ARRAY:C229($aSeq; $aComm; $aQty; $aCost; $aCounted; $aRMcode; >)
		FIRST RECORD:C50([Job_Forms_Materials:55])
		For ($i; 1; Records in selection:C76([Job_Forms_Materials:55]))
			$qty:=0
			$cost:=0
			$hit:=Find in array:C230($aSeq; [Job_Forms_Materials:55]Sequence:3)
			While ($hit#-1)
				If ($aCounted{$hit}#1)
					$qty:=$qty+$aQty{$hit}
					$cost:=$cost+$aCost{$hit}
					$aCounted{$hit}:=1
				End if 
				
				$hit:=Find in array:C230($aSeq; [Job_Forms_Materials:55]Sequence:3; ($hit+1))
			End while 
			[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+($qty*-1))
			[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck([Job_Forms_Materials:55]Actual_Price:15+($cost*-1))
			SAVE RECORD:C53([Job_Forms_Materials:55])
			NEXT RECORD:C51([Job_Forms_Materials:55])
		End for 
		
		//•051299  mlb  UPR 1921, direct pur ink has no seq num on issue rec
		CREATE SET:C116([Job_Forms_Materials:55]; "lastchk")
		$hit:=Find in array:C230($aCounted; 0)
		If ($hit>-1)  //*now apply the last uncounted by rm code
			For ($i; 1; Size of array:C274($aSeq))
				If ($aCounted{$i}#1)
					USE SET:C118("lastchk")
					// ******* Verified  - 4D PS - January  2019 ********
					
					QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=$aRMcode{$i})
					
					// ******* Verified  - 4D PS - January 2019 (end) *********
					
					If (Records in selection:C76([Job_Forms_Materials:55])>0)
						[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+($aQty{$i}*-1))
						[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck([Job_Forms_Materials:55]Actual_Price:15+($aCost{$i}*-1))
						SAVE RECORD:C53([Job_Forms_Materials:55])
						$aCounted{$i}:=1
					End if 
				End if 
			End for 
		End if   //unapplied`•051299  mlb  UPR 1921      
		
		$hit:=Find in array:C230($aCounted; 0)
		If ($hit>-1)  //*now apply the last uncounted by com code
			For ($i; 1; Size of array:C274($aSeq))
				If ($aCounted{$i}#1)
					USE SET:C118("lastchk")
					// ******* Verified  - 4D PS - January  2019 ********
					
					QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=Substring:C12($aComm{$i}; 1; 2)+"@")
					
					// ******* Verified  - 4D PS - January 2019 (end) *********
					
					If (Records in selection:C76([Job_Forms_Materials:55])>0)
						[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+($aQty{$i}*-1))
						[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck([Job_Forms_Materials:55]Actual_Price:15+($aCost{$i}*-1))
						SAVE RECORD:C53([Job_Forms_Materials:55])
						$aCounted{$i}:=1
					End if 
				End if 
			End for 
			
		End if 
		USE SET:C118("lastchk")
		CLEAR SET:C117("lastchk")  //unapplied`•051299  mlb  UPR 1921
		
	End if   //issues
End if   //params  

//