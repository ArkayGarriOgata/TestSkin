//%attributes = {"publishedWeb":true}
//Procedure: path:=uCreateFolder(foldername)  090998  MLB

//create a folder in the default directory

$path:=util_DocumentPath
$path:=$path+$1
$Error:=NewFolder($path)
$path:=$path+":"
$0:=$path
If ($Error#0)
	If ($Error=-48)
		//ALERT("A folder named: "+Char(13)+"'"+$Path+"'"+"   already exists.")
		
	Else 
		ALERT:C41("Disk access error: "+String:C10($Error)+Char:C90(13)+"Trying to create folder.")
	End if 
End if 
//