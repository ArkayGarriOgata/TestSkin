//%attributes = {"publishedWeb":true}
//CheckForBottom()
//032796 TJF
//042396  TJF added fix for height of next layout
//•100496  MLB  add totals report

C_LONGINT:C283($1)

iPixel:=iPixel+$1
If (iPixel>515)  //8.5" with margins
	iPixel:=60+$1  //header height+height of layout about to be printed
	iPage:=iPage+1
	PAGE BREAK:C6
	If (rb1=1)  //•100496  MLB  
		Print form:C5([Job_Forms_CloseoutSummaries:87]; "SumLay.H")
	Else 
		Print form:C5([Job_Forms_CloseoutSummaries:87]; "SumLay.H2")
	End if 
End if 