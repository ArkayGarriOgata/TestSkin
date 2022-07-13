//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/24/10, 11:32:21
// ----------------------------------------------------
// Method: FG_dupInks
// Description
// copy the subtable data from orig to duplicate
// since duplicate of subrecords depreciated from v11
//mlb - 11/23/10 - change to normal table
// Parameters
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($ink; $2)

Case of 
	: ($1="copy")
		ARRAY LONGINT:C221(aInk_foreignkey; 0)
		ARRAY TEXT:C222(aInk_control_number; 0)
		ARRAY INTEGER:C220(aInk_rot; 0)
		ARRAY TEXT:C222(aInk_side; 0)
		ARRAY TEXT:C222(aInk_ink; 0)
		ARRAY TEXT:C222(aInk_color; 0)
		ARRAY TEXT:C222(aInk_op; 0)
		RELATE MANY:C262([Finished_Goods_Specifications:98]Ink:24)
		SELECTION TO ARRAY:C260([Finished_Goods_Specs_Inks:188]Rotation:1; aInk_rot; [Finished_Goods_Specs_Inks:188]Side:2; aInk_side; [Finished_Goods_Specs_Inks:188]InkNumber:3; aInk_ink; [Finished_Goods_Specs_Inks:188]Color:4; aInk_color; [Finished_Goods_Specs_Inks:188]Operation:5; aInk_op)
		ARRAY LONGINT:C221(aInk_foreignkey; Size of array:C274(aInk_rot))
		ARRAY TEXT:C222(aInk_control_number; Size of array:C274(aInk_rot))
		
	: ($1="paste")
		REDUCE SELECTION:C351([Finished_Goods_Specs_Inks:188]; 0)
		$fg_control_number:=[Finished_Goods_Specifications:98]ControlNumber:2
		$fg_ink_foreignkey:=[Finished_Goods_Specifications:98]Ink:24
		For ($ink; 1; Size of array:C274(aInk_rot))
			aInk_foreignkey{$ink}:=$fg_ink_foreignkey
			aInk_control_number{$ink}:=$fg_control_number
		End for 
		ARRAY TO SELECTION:C261(aInk_control_number; [Finished_Goods_Specs_Inks:188]ControlNumber:6; aInk_foreignkey; [Finished_Goods_Specs_Inks:188]id_added_by_converter:7; aInk_rot; [Finished_Goods_Specs_Inks:188]Rotation:1; aInk_side; [Finished_Goods_Specs_Inks:188]Side:2; aInk_ink; [Finished_Goods_Specs_Inks:188]InkNumber:3; aInk_color; [Finished_Goods_Specs_Inks:188]Color:4; aInk_op; [Finished_Goods_Specs_Inks:188]Operation:5)
		ARRAY LONGINT:C221(aInk_foreignkey; 0)
		ARRAY INTEGER:C220(aInk_rot; 0)
		ARRAY TEXT:C222(aInk_side; 0)
		ARRAY TEXT:C222(aInk_ink; 0)
		ARRAY TEXT:C222(aInk_color; 0)
		ARRAY TEXT:C222(aInk_op; 0)
End case 