// _______
// Method: [WMS_InternalBOLs].InternalBOL_ui.ListBox1   ( ) ->
// By: Mel Bohince
// Description
// lb of the current list of internal BOL records
// ----------------------------------------------------
// Modified by: Mel Bohince (10/29/20) make sure the updated [WMS_InternalBOLs] record is displayed correctly and selected
// Modified by: Mel Bohince (11/5/20) fix iRow in LISTBOX SELECT ROW

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		//get selected row so it can be reselected
		C_LONGINT:C283(iRow; iColumn)
		LISTBOX GET CELL POSITION:C971(*; "ListBox1"; iColumn; iRow)  //so we can reselect the row clicked
		
		IBOL_IntraPlanTransfer("clear_skid_list")
		LOAD RECORD:C52([WMS_InternalBOLs:163])
		IBOL_IntraPlanTransfer("get_skid_list"; [WMS_InternalBOLs:163]bol_number:2)
		//restore selection
		LISTBOX SELECT ROW:C912(*; "ListBox1"; iRow; lk replace selection:K53:1)  //reselect row clicked
		
		Case of 
			: (Records in set:C195("$ListboxSet")=1)
				OBJECT SET ENABLED:C1123(*; "PrintBOL"; True:C214)
				OBJECT SET ENABLED:C1123(*; "ShowSkid"; True:C214)
				
			: (Records in set:C195("$ListboxSet")>1)
				OBJECT SET ENABLED:C1123(*; "PrintBOL"; True:C214)
				OBJECT SET ENABLED:C1123(*; "ShowSkid"; False:C215)
				
			Else 
				OBJECT SET ENABLED:C1123(*; "PrintBOL"; False:C215)
				OBJECT SET ENABLED:C1123(*; "ShowSkid"; False:C215)
		End case 
		
End case 

