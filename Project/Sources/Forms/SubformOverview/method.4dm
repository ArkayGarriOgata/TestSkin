// -------
// Form Method: SubformOverview   ( ) ->
// By: Mel Bohince @ 05/11/18, 16:27:45
// Description
// 
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Load:K2:1)
		iHeader0:=""
		
		$numSubforms:=Size of array:C274(aSubForm)
		$numOperations:=Size of array:C274(aSeq)
		
		LISTBOX INSERT COLUMN:C829(iListBox1; 1; "aSubForm"; aSubForm; "iHeader0"; iHeader0)
		OBJECT SET TITLE:C194(iHeader0; "Seq\\SF#")
		OBJECT SET FONT:C164(*; "aSubForm"; "Monaco")
		LISTBOX SET COLUMN WIDTH:C833(*; "aSubForm"; 30; 5; 30)
		OBJECT SET FONT:C164(*; "iH@"; "Monaco")
		//OBJECT SET TEXT ORIENTATION(iHeader0;Orientation 90° left )
		
		ARRAY LONGINT:C221(aiHeaderTracker; 0)  //so when cell is clicked we can get the seq# directly
		ARRAY LONGINT:C221(aiHeaderTracker; (1+(2*$numOperations)))
		
		$col:=1  //offset by the subform number column
		aiHeaderTracker{$col}:=0
		
		For ($i; 1; $numOperations)  //maximum of 9 operations
			
			$col:=$col+1
			$column:=Get pointer:C304("bColumn"+String:C10($i))
			$header:=Get pointer:C304("iHeader"+String:C10($i))
			$footer:=Get pointer:C304("iFooter"+String:C10($i))
			$footer->:=0
			LISTBOX INSERT COLUMN:C829(iListBox1; $col; "bColumn"+String:C10($i); $column->; "iHeader"+String:C10($i); $header->; "iFooter"+String:C10($i); $footer->)
			OBJECT SET TITLE:C194($header->; String:C10(aSeq{$i}; "000")+"\\"+aCC{$i})
			OBJECT SET ENTERABLE:C238(*; "bColumn"+String:C10($i); False:C215)
			LISTBOX SET FOOTER CALCULATION:C1140($footer->; lk footer sum:K70:4)
			aiHeaderTracker{$col}:=aSeq{$i}
			
			$col:=$col+1
			$column:=Get pointer:C304("aColumn"+String:C10($i))
			$header:=Get pointer:C304("iaHeader"+String:C10($i))
			$footer:=Get pointer:C304("iaFooter"+String:C10($i))
			$footer->:=0
			LISTBOX INSERT COLUMN:C829(iListBox1; $col; "aColumn"+String:C10($i+1); $column->; "iaHeader"+String:C10($i+1); $header->; "iaFooter"+String:C10($i); $footer->)
			OBJECT SET TITLE:C194($header->; String:C10(aSeq{$i}; "000")+"\\"+" actual")
			LISTBOX SET FOOTER CALCULATION:C1140(*; "iaFooter"+String:C10($i); lk footer sum:K70:4)
			aiHeaderTracker{$col}:=aSeq{$i}
		End for 
		
		OBJECT SET FORMAT:C236(*; "bCol@"; "#,###,##0")
		OBJECT SET FORMAT:C236(*; "aCol@"; "#,###,##0")
		OBJECT SET FORMAT:C236(*; "iF@"; "###,###,##0")
		OBJECT SET FORMAT:C236(*; "iaF@"; "###,###,##0")
		OBJECT SET FONT:C164(*; "bCol@"; "Monaco")
		OBJECT SET FONT:C164(*; "aCol@"; "Monaco")
		LISTBOX SET COLUMN WIDTH:C833(*; "bCol@"; 75; 5; 90)
		LISTBOX SET COLUMN WIDTH:C833(*; "aCol@"; 55; 5; 90)
		
		//shrink column if actuals are all zeros
		$altColor:=-(256*192)
		$goColor:=-(Green:K11:9+(256*White:K11:1))
		$noGoColor:=-(Red:K11:4+(256*White:K11:1))
		Core_ObjectSetColor("*"; "Mytext"; -(Yellow:K11:2+(256*Red:K11:4)))
		
		For ($seq; 1; $numOperations)  //traversing across the columns
			$allZeros:=True:C214  //assume no actuals
			$columnActualPtr:=Get pointer:C304("aColumn"+String:C10($seq))
			$columnBudgetPtr:=Get pointer:C304("bColumn"+String:C10($seq))
			
			For ($sf; 1; $numSubforms)  //test each subform for an actual
				If ($columnActualPtr->{$sf}>0)  //actual found
					$allZeros:=False:C215  //don't shrink
					//$sf:=$sf+$numSubforms  //break
				End if 
				
				
				//If ($columnActualPtr->{$sf}<$columnBudgetPtr->{$sf})
				//LISTBOX SET ROW COLOR(iListBox1;$sf;0x00FF0000)
				//OBJECT SET COLOR($columnActualPtr->{$sf};$noGoColor;$altColor)  //red
				//OBJECT SET COLOR($columnBudgetPtr->{$sf};$noGoColor;$altColor)  //red
				//Else 
				//LISTBOX SET ROW COLOR(iListBox1;$sf;0x000000FF)
				//OBJECT SET COLOR($columnActualPtr->{$sf};$goColor;$altColor)  //green
				//OBJECT SET COLOR($columnBudgetPtr->{$sf};$goColor;$altColor)  //green
				//End if 
				
			End for   //subform
			
			If ($allZeros)
				LISTBOX SET COLUMN WIDTH:C833($columnActualPtr->; 3; 3; 90)
			End if 
			
		End for   //column
		
		jfm_header1:="seq"
		jfm_header2:="com"
		jfm_header3:="rm"
		jfm_header4:="rot"
		jfm_header5:="sf"
		LISTBOX INSERT COLUMN:C829(iListBox2; 1; "aJFM_seq"; aJFM_seq; "jfm_header1"; jfm_header1)  //;"imFooter"+String($i);$footer->)
		LISTBOX INSERT COLUMN:C829(iListBox2; 2; "aJFM_comm"; aJFM_comm; "jfm_header2"; jfm_header2)
		LISTBOX INSERT COLUMN:C829(iListBox2; 3; "aJFM_RM"; aJFM_RM; "jfm_header3"; jfm_header3)
		LISTBOX INSERT COLUMN:C829(iListBox2; 4; "aJFM_rotation"; aJFM_rotation; "jfm_header4"; jfm_header4)
		LISTBOX INSERT COLUMN:C829(iListBox2; 5; "aJFM_SF"; aJFM_SF; "jfm_header5"; jfm_header5)
		LISTBOX SET COLUMN WIDTH:C833(*; "jfm_header1"; 40; 5; 180)
		LISTBOX SET COLUMN WIDTH:C833(*; "jfm_header2"; 130; 5; 180)
		LISTBOX SET COLUMN WIDTH:C833(*; "jfm_header3"; 110; 5; 180)
		LISTBOX SET COLUMN WIDTH:C833(*; "jfm_header4"; 40; 5; 180)
		LISTBOX SET COLUMN WIDTH:C833(*; "jfm_header5"; 110; 5; 180)
		OBJECT SET FORMAT:C236(*; "aJFM_seq"; "000")
		OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "aJFM_seq"; Align center:K42:3)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "aJFM_rotation"; Align center:K42:3)
		OBJECT SET TITLE:C194(jfm_header1; "SEQ")
		OBJECT SET TITLE:C194(jfm_header2; "COMMODITY")
		OBJECT SET TITLE:C194(jfm_header3; "R/M CODE")
		OBJECT SET TITLE:C194(jfm_header4; "ROT")
		OBJECT SET TITLE:C194(jfm_header5; "SF")
		
		jmi_header1:="item"
		jmi_header2:="cpn"
		jmi_header3:="sf"
		jmi_header4:="hrd"
		jmi_header5:="rel"
		LISTBOX INSERT COLUMN:C829(iListBox3; 1; "aJMI_item"; aJMI_item; "jmi_header1"; jmi_header1)  //;"iiFooter"+String($i);$footer->)
		LISTBOX INSERT COLUMN:C829(iListBox3; 2; "aJMI_SF"; aJMI_SF; "jmi_header3"; jmi_header3)
		LISTBOX INSERT COLUMN:C829(iListBox3; 3; "aJMI_HRD"; aJMI_HRD; "jmi_header4"; jmi_header4)
		LISTBOX INSERT COLUMN:C829(iListBox3; 5; "aJMI_CPN"; aJMI_CPN; "jmi_header2"; jmi_header2)
		LISTBOX INSERT COLUMN:C829(iListBox3; 4; "aJMI_REL"; aJMI_REL; "jmi_header5"; jmi_header5)
		LISTBOX SET COLUMN WIDTH:C833(*; "aJMI_item"; 40; 5; 180)
		LISTBOX SET COLUMN WIDTH:C833(*; "aJMI_CPN"; 130; 5; 180)
		LISTBOX SET COLUMN WIDTH:C833(*; "aJMI_SF"; 40; 5; 180)
		LISTBOX SET COLUMN WIDTH:C833(*; "aJMI_HRD"; 60; 5; 180)
		LISTBOX SET COLUMN WIDTH:C833(*; "aJMI_REL"; 60; 5; 180)
		
		OBJECT SET TITLE:C194(jmi_header1; "ITEM")
		OBJECT SET TITLE:C194(jmi_header2; "PRODUCT CODE")
		OBJECT SET TITLE:C194(jmi_header3; "SF")
		OBJECT SET TITLE:C194(jmi_header4; "HRD")
		OBJECT SET TITLE:C194(jmi_header5; "REL")
		OBJECT SET FORMAT:C236(*; "aJMI_item"; "00")
		
		OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "aJMI_item"; Align center:K42:3)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "aJMI_SF"; Align center:K42:3)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "aJMI_HRD"; Align center:K42:3)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "aJMI_REL"; Align center:K42:3)
		//OBJECT SET FORMAT(*;"aJMI_HRD";Internal date short special)
		
End case 
