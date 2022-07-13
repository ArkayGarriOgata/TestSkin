$lastObj:=Focus object:C278
If (Type:C295($lastObj->)=Is date:K8:7)
	//BEEP
	If ($lastObj->=!00-00-00!)
		$lastObj->:=Current date:C33
	Else 
		$lastObj->:=$lastObj->-1
	End if 
End if 