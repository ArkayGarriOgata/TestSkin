If (Length:C16([Job_Forms_Items:44]GlueStyle:51)>0)
	t7:=[Job_Forms_Items:44]GlueStyle:51
Else 
	t7:=FG_getStyle([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
End if 