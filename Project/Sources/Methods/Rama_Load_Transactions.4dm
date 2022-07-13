//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/03/12, 10:23:16
// Modified by: Mel Bohince (11/5/12) change totalling method
// ----------------------------------------------------
// Method: Rama_Load_Transactions
// ----------------------------------------------------
// Modified by: Mel Bohince (1/13/15) change to [Finished_Goods_Transactions] shipped perspective

C_LONGINT:C283($tran; $numTrans)
ARRAY BOOLEAN:C223(InvListBox; 0)
ARRAY LONGINT:C221(aRecNo; 0)
ARRAY TEXT:C222(aJobform; 0)
ARRAY LONGINT:C221(aiQty; 0)
ARRAY REAL:C219(aCost; 0)
ARRAY TEXT:C222(aRMcode; 0)
ARRAY TEXT:C222(aCPN; 0)
ARRAY DATE:C224(aDateIncurred; 0)
ARRAY DATE:C224(aDateInvoiced; 0)
ARRAY DATE:C224(aDatePaid; 0)
ARRAY TEXT:C222(aPallet; 0)
ARRAY TEXT:C222(aBOL; 0)

//SELECTION TO ARRAY([Raw_Materials_Transactions];aRecNo;[Raw_Materials_Transactions]JobForm;aJobform;[Raw_Materials_Transactions]Qty;asQty;[Raw_Materials_Transactions]ActExtCost;aCost;[Raw_Materials_Transactions]Raw_Matl_Code;aRMcode;[Raw_Materials_Transactions]Reason;aCPN;[Raw_Materials_Transactions]XferDate;aDateIncurred;[Raw_Materials_Transactions]Invoiced;aDateInvoiced;[Raw_Materials_Transactions]Paid;aDatePaid;[Raw_Materials_Transactions]ReferenceNo;aPallet;[Raw_Materials_Transactions]ReceivingNum;aBOL)
SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]; aRecNo; [Finished_Goods_Transactions:33]JobForm:5; aJobform; [Finished_Goods_Transactions:33]Qty:6; aiQty; [Finished_Goods_Transactions:33]CoGSExtended:8; aCost; [Finished_Goods_Transactions:33]OrderItem:16; aRMcode; [Finished_Goods_Transactions:33]ProductCode:1; aCPN; [Finished_Goods_Transactions:33]XactionDate:3; aDateIncurred; [Finished_Goods_Transactions:33]Invoiced:38; aDateInvoiced; [Finished_Goods_Transactions:33]Paid:39; aDatePaid; [Finished_Goods_Transactions:33]Skid_number:29; aPallet; [Finished_Goods_Transactions:33]ActionTaken:27; aBOL)
$numTrans:=Size of array:C274(aRecNo)
ARRAY BOOLEAN:C223(InvListBox; $numTrans)

For ($tran; 1; $numTrans)  //flip sign on transactions so they don't look negative (because they are issues)
	//aiQty{$tran}:=aiQty{$tran}*-1
	aCost{$tran}:=0.024*aiQty{$tran}
End for 

Rama_A_P_Button("Total")  // Modified by: Mel Bohince (11/5/12) change totalling method

MULTI SORT ARRAY:C718(aBOL; >; aRMcode; >; aDateIncurred; aCPN; aRecNo; aJobform; aiQty; aCost; aDateInvoiced; aDatePaid; aPallet)