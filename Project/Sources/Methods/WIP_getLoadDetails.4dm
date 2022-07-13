//%attributes = {}
// Method: WIP_getLoadDetails (jobfit | jobform) -> 
// ----------------------------------------------------
// by: mel: 07/27/05, 11:41:37
// ----------------------------------------------------
// Description:
// 
// Updates:

// ----------------------------------------------------
xText:=""
iUp:=0
ARRAY TEXT:C222(aJobit; 0)
ARRAY TEXT:C222(aCPN; 0)
ARRAY LONGINT:C221(aCartonUp; 0)
C_TEXT:C284(sPOnum2; sIssType; ibomUOM)

Case of 
	: (Length:C16($1)=11)
		sJobit:=$1
		sIssType:="GAYLORD"
		sJobform:=Substring:C12(sJobit; 1; 8)
		sPOnum2:=JMI_getPO(sJobform)
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=sJobit)
		Case of 
			: (Records in selection:C76([Job_Forms_Items:44])=1)
				ibomUOM:="CARTONS"
				sHead1:=sJobit
				xText:="SINGLE ITEM IN CONTAINER"
				iUp:=[Job_Forms_Items:44]NumberUp:8
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; aJobit; [Job_Forms_Items:44]ProductCode:3; aCPN; [Job_Forms_Items:44]NumberUp:8; aCartonUp)
				
			: (Records in selection:C76([Job_Forms_Items:44])>1)
				zwStatusMsg("ERROR"; "Jobit "+sJobit+" apparently has subforms.")
				BEEP:C151
				ALERT:C41("This item appears to have subform, try again without the item#, like "+Substring:C12(sJobit; 1; 8))
				sJobit:=Substring:C12(sJobit; 1; 8)
				GOTO OBJECT:C206(sJobit)
			Else 
				zwStatusMsg("ERROR"; "Jobit "+sJobit+" was not found.")
				BEEP:C151
				sJobit:=""
				GOTO OBJECT:C206(sJobit)
		End case 
		
		
	: (Length:C16($1)=8)
		sJobform:=$1
		sPOnum2:=JMI_getPO(sJobform)
		sJobit:=$1
		sIssType:="GAYLORD"
		
		$numSF:=JMI_getNumSubforms(sJobform)
		If ($numSF>1)
			BEEP:C151
			$item:=Num:C11(Request:C163("Which item number?"; "1"))
			$jobit:=JMI_makeJobIt(sJobform; $item)
			$sf:=Num:C11(Request:C163("Which subform? (1.."+String:C10($numSF)+")"))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$jobit; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]SubFormNumber:32=$sf)
		Else 
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=sJobform)
		End if 
		
		Case of 
			: (Records in selection:C76([Job_Forms_Items:44])=1)
				sJobit:=[Job_Forms_Items:44]Jobit:4
				//sPOnum2:=JMI_getPO (sJobit)
				ibomUOM:="CARTONS"
				sHead1:=sJobit
				xText:="SINGLE ITEM IN CONTAINER"
				iUp:=[Job_Forms_Items:44]NumberUp:8
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; aJobit; [Job_Forms_Items:44]ProductCode:3; aCPN; [Job_Forms_Items:44]NumberUp:8; aCartonUp)
				
			: (Records in selection:C76([Job_Forms_Items:44])>1)
				sIssType:="SHRINKWRAP"
				sJobit:="Combo"
				//sPOnum2:="see below"
				ibomUOM:="SHEETS"
				sHead1:="MIXED"
				xText:="                  LOT#      "+"P&G ITEM"+"   PO                "+"DESC"+Char:C90(13)
				ARRAY TEXT:C222(aJobit; 0)
				ARRAY TEXT:C222(aCPN; 0)
				ARRAY LONGINT:C221(aCartonUp; 0)
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; aJobit; [Job_Forms_Items:44]ProductCode:3; aCPN; [Job_Forms_Items:44]NumberUp:8; aCartonUp)
				SORT ARRAY:C229(aJobit; aCPN; aCartonUp; >)
				For ($i; 1; Size of array:C274(aJobit))
					qryFinishedGood("#CPN"; aCPN{$i})
					iUp:=iUp+aCartonUp{$i}
					xText:=xText+"~"+String:C10(aCartonUp{$i})+" UP  "+txt_Pad("%"+String:C10($i)+"%"; " "; -1; 5)+"  "+aJobit{$i}+"   "+aCPN{$i}+"   "+JMI_getPO(aJobit{$i})+" { "+Uppercase:C13(Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 25))+Char:C90(13)
				End for 
				
			Else 
				zwStatusMsg("ERROR"; "Jobits not found for form "+sJobform)
				BEEP:C151
				sJobit:=""
				sJobform:=""
				GOTO OBJECT:C206(sJobform)
		End case 
		
		
	Else 
		zwStatusMsg("ERROR"; "Please enter an 11 character jobit or 8 character jobform (like: 12345.12.12 or 1"+"2345.12)")
		BEEP:C151
		sJobit:=""
		sJobform:=""
		GOTO OBJECT:C206(sJobit)
End case 