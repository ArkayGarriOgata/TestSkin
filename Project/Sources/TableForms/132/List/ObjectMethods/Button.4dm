
C_LONGINT:C283($nHighlighted)

GET HIGHLIGHTED RECORDS:C902([Finished_Goods_SizeAndStyles:132]; "Highlighted")

$nHighlighted:=Records in set:C195("Highlighted")

Case of   //Highlighted
		
	: ($nHighlighted=0)
	: ($nHighlighted>1)
		
	: ($nHighlighted=1)  //Unique
		
		COPY NAMED SELECTION:C331([Finished_Goods_SizeAndStyles:132]; "Current")
		
		USE SET:C118("Highlighted")
		
		Arts_PlayVideo([Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
		
		CLEAR SET:C117("Highlighted")
		
		USE NAMED SELECTION:C332("Current")
		
		CLEAR NAMED SELECTION:C333("Current")
		
End case   //Done highlighted
