//(s) sMatLabel1 [materialjob]JBN_07.h
//• 11/26/97 cs create
If ([Job_Forms_Materials:55]Commodity_Key:12="07-Emboss@")
	Self:C308->:="% Embossed"
	sMatLabel2:=""
	sQtyTitle:=""
Else 
	Self:C308->:="# of Cartons"
	sMatLabel2:="# @ Yield"
	sQtyTitle2:=String:C10([Job_Forms_Materials:55]Real2:18; "|Qty.Format")
End if 
//