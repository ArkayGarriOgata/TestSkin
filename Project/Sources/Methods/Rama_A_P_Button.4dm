//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/03/12, 16:00:01
// Modified by: Mel Bohince (11/5/12) add totalling cases
// Modified by: Mel Bohince (3/5/13) init sleeve subtotal variables
// ----------------------------------------------------
// Method: Rama_A_P_Button
// ----------------------------------------------------
// Modified by: Mel Bohince (1/13/15) change to [Finished_Goods_Transactions] shipped perspective

$btn_func:=$1  //OBJECT Get title(bUpdate)

If (Position:C15("Total"; $btn_func)>0)
	$numTrans:=Size of array:C274(aRecNo)
	If ($btn_func="SubTotal")
		$only_selected:=True:C214
	Else 
		$only_selected:=False:C215
	End if 
	r1:=0
	r2:=0
	r3:=0
	r4:=0
	r5:=0
	r6:=0
	r7:=0
	r8:=0
	r9:=0
	Lvalue1:=0
	Lvalue2:=0
	Lvalue3:=0
	Lvalue4:=0
	Lvalue5:=0
	Lvalue6:=0
	Lvalue7:=0
	Lvalue8:=0
	Lvalue9:=0
	//                 Freight         Gluing
	//                  qty     cost    qty   cost
	//need invoice      Lvalue1 r1    Lvalue4 r4
	//need payed        Lvalue2 r2    Lvalue5 r5
	//total             Lvalue3 r3    Lvalue6 r6
	//
	
	For ($tran; 1; $numTrans)
		If (($only_selected) & (InvListBox{$tran})) | (Not:C34($only_selected))
			
			Case of 
				: (Position:C15("Freight"; aRMcode{$tran})>0) | (True:C214)  //everything is freight now
					Lvalue3:=Lvalue3+aiQty{$tran}
					r3:=r3+aCost{$tran}
					Case of 
						: (aDateInvoiced{$tran}=!00-00-00!) & (aDatePaid{$tran}=!00-00-00!)
							Lvalue1:=Lvalue1+aiQty{$tran}
							r1:=r1+aCost{$tran}
						: (aDateInvoiced{$tran}#!00-00-00!) & (aDatePaid{$tran}=!00-00-00!)
							Lvalue2:=Lvalue2+aiQty{$tran}
							r2:=r2+aCost{$tran}
					End case 
					
				: (Position:C15("Gluing"; aRMcode{$tran})>0)
					Lvalue6:=Lvalue6+aiQty{$tran}
					r6:=r6+aCost{$tran}
					Case of 
						: (aDateInvoiced{$tran}=!00-00-00!) & (aDatePaid{$tran}=!00-00-00!)
							Lvalue4:=Lvalue4+aiQty{$tran}
							r4:=r4+aCost{$tran}
						: (aDateInvoiced{$tran}#!00-00-00!) & (aDatePaid{$tran}=!00-00-00!)
							Lvalue5:=Lvalue5+aiQty{$tran}
							r5:=r5+aCost{$tran}
					End case 
					
				: (Position:C15("Sleeve"; aRMcode{$tran})>0)
					Lvalue9:=Lvalue9+aiQty{$tran}
					r9:=r9+aCost{$tran}
					Case of 
						: (aDateInvoiced{$tran}=!00-00-00!) & (aDatePaid{$tran}=!00-00-00!)
							Lvalue7:=Lvalue7+aiQty{$tran}
							r7:=r7+aCost{$tran}
						: (aDateInvoiced{$tran}#!00-00-00!) & (aDatePaid{$tran}=!00-00-00!)
							Lvalue8:=Lvalue8+aiQty{$tran}
							r8:=r8+aCost{$tran}
					End case 
			End case 
			
		End if   //$only_selected
	End for 
	
Else 
	uConfirm("Are you sure you want to "+$btn_func+" the selected transactions?"; $btn_func; "Cancel")
	If (ok=1)
		$today:=4D_Current_date
		$now:=4d_Current_time
		
		READ WRITE:C146([Finished_Goods_Transactions:33])
		
		For ($trans; 1; Size of array:C274(InvListBox))
			If (InvListBox{$trans})  //row selected, set the date
				GOTO RECORD:C242([Finished_Goods_Transactions:33]; aRecNo{$trans})
				If (fLockNLoad(->[Finished_Goods_Transactions:33]))
					
					Case of 
						: ($btn_func="Invoice")
							If (aDateInvoiced{$trans}=!00-00-00!)
								aDateInvoiced{$trans}:=4D_Current_date
							Else 
								aDateInvoiced{$trans}:=!00-00-00!
							End if 
							[Finished_Goods_Transactions:33]Invoiced:38:=aDateInvoiced{$trans}
							SAVE RECORD:C53([Finished_Goods_Transactions:33])
							If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
								
								UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
								
							Else 
								
								//you have goto record
								
							End if   // END 4D Professional Services : January 2019 
							
						: ($btn_func="Pay")
							If (aDatePaid{$trans}=!00-00-00!)
								aDatePaid{$trans}:=4D_Current_date
							Else 
								aDatePaid{$trans}:=!00-00-00!
							End if 
							[Finished_Goods_Transactions:33]Paid:39:=aDatePaid{$trans}
							SAVE RECORD:C53([Finished_Goods_Transactions:33])
							If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
								
								UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
							Else 
								
								//you have goto record
								
							End if   // END 4D Professional Services : January 2019 
							
							
						Else 
							BEEP:C151
					End case 
					
				Else 
					uConfirm("RECORD IN USE: Changes can not be made on "+aPallet{$trans}+", try again later."; "OK"; "Help")
				End if 
			End if 
		End for 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
		Else 
			
			UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
		End if   // END 4D Professional Services : January 2019 
		
		
		LISTBOX SELECT ROW:C912(InvListBox; InvListBox; 0)
		
	End if   //confirm action
	
End if   //not totalling