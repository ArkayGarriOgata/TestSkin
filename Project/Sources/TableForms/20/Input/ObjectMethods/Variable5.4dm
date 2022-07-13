//(S)PrtOrdAckn:
//• 7/23/98 cs new way to revise jobs to stop revising closed forms
//see sCreateBudget on Cust Order layout
$windowTitle:=Get window title:C450
$winRef:=OpenSheetWindow(->[zz_control:1]; "text_dio"; "Help Notes for Overrides")
t1:=""
t1:=t1+"† If this field is left at 00/00/00, then the latest standard will be used when t"+"he estimate is run; otherwise, the standard for the date entered will be used. In"+" either case, the field 'OOP Stds Effective' will indicate which date was used in"+" the calculation."+Char:C90(13)+Char:C90(13)
t1:=t1+"†† The number entered here will be divided by 100 then multiplied to the total wa"+"ste calculated for this sequence; therefore, entering 110 would increase waste at"+" this sequence by 10%. "+Char:C90(13)+Char:C90(13)
t1:=t1+"†††'Yes' will calculate Spoilage for this machine, as if done in-house,  but will"+" add NO OOP costs."

DIALOG:C40([zz_control:1]; "text_dio")
CLOSE WINDOW:C154
SET WINDOW TITLE:C213($windowTitle)