Case of 
	: ([Job_Forms:42]Status:6="closed")
		Core_ObjectSetColor(->[Job_Forms:42]NeedDate:1; -(15+(256*0)); True:C214)  //blak  
		
	: ([Job_Forms:42]NeedDate:1=!00-00-00!)
		Core_ObjectSetColor(->[Job_Forms:42]NeedDate:1; -(0+(256*14)); True:C214)  //grey
		
	: ([Job_Forms:42]NeedDate:1=<>MAGIC_DATE)
		Core_ObjectSetColor(->[Job_Forms:42]NeedDate:1; -(0+(256*14)); True:C214)  //grey
		
	: ([Job_Forms:42]NeedDate:1>4D_Current_date)
		Core_ObjectSetColor(->[Job_Forms:42]NeedDate:1; -(5+(256*0)); True:C214)  //blue
		
	: ([Job_Forms:42]NeedDate:1<4D_Current_date)
		Core_ObjectSetColor(->[Job_Forms:42]NeedDate:1; -(9+(256*12)); True:C214)  //green  
		
	Else 
		Core_ObjectSetColor(->[Job_Forms:42]NeedDate:1; -(3+(256*0)); True:C214)  //red
End case 

//If (Self->=!00-00-00!)
//OBJECT SET COLOR(Self->;-(0+(256*0)))  //blak  
//Else 
//OBJECT SET COLOR(Self->;-(15+(256*0)))  //WHITE  
//End if 
