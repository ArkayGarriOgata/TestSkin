//%attributes = {"publishedWeb":true}
//fAddressArrows(array;direction;»address foreign key field)->address text

C_POINTER:C301($1; $theArray)  //$1= "»aBilltos" | "»aShiptos"
C_LONGINT:C283($2)  //$2= -1 for up, +1 for down
C_POINTER:C301($3; $theField)  //$3=field pointer
C_TEXT:C284($0)

$theArray:=$1
$theField:=$3
$theArray->:=Find in array:C230($theArray->; $theField->)

Case of 
	: ($theArray->=-1)  //n/a or not valid
		If (Size of array:C274($theArray->)>0)  //just use the first element
			$theArray->:=1
			$theField->:=$theArray->{$theArray->}
			$0:=fGetAddressText($theArray->{$theArray->})
		Else   //address not defined for this customer
			BEEP:C151
			$theField->:="N/A"
			$0:="Create a "+Field name:C257($theField)+" on the customer layout."
		End if 
		
	: (($2=0) & ($theArray->>1))
		$theArray->:=$theArray->+$2  //move the array index towards 0
		$theField->:=$theArray->{$theArray->}  //set the field value equal to the array element
		$0:=fGetAddressText($theArray->{$theArray->})  //get the address text of the array element
		
	: (($2<0) & ($theArray->>1))
		$theArray->:=$theArray->+$2  //move the array index towards 0
		$theField->:=$theArray->{$theArray->}  //set the field value equal to the array element
		$0:=fGetAddressText($theArray->{$theArray->})  //get the address text of the array element
		
	: (($2>0) & ($theArray-><Size of array:C274($theArray->)))
		$theArray->:=$theArray->+$2  //move the array index away from 0
		$theField->:=$theArray->{$theArray->}  //set the field value equal to the array element
		$0:=fGetAddressText($theArray->{$theArray->})  //get the address text of the array element    
		
	Else   //you are already at the top or bottom of the array    
		BEEP:C151
		$theArray->:=$theArray->+0  //dont move the array index
		$theField->:=$theArray->{$theArray->}  //set the field value equal to the array element
		$0:=fGetAddressText($theArray->{$theArray->})  //get the address text of the array element   
End case 