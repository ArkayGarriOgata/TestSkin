//(s) [user]maint'badd
//• 1/16/98 cs allow 'All + departments
ARRAY TEXT:C222(aBullet; 0)  //clear array
ARRAY TEXT:C222(aBullet; Size of array:C274(aDepartment))

uDialog("SelectDept"; 200; 250)
If (OK=1)
	$Start:=1
	[Users:5]WorksInDept:15:=""
	While ($Start<Size of array:C274(aBullet)) & ($Start>0)
		$Start:=Find in array:C230(aBullet; "√"; $Start)
		
		Case of 
			: ($Start=1)  //this is the 'All' choice        
				[Users:5]WorksInDept:15:=[Users:5]WorksInDept:15+Substring:C12(aDepartment{$Start}; 1; 4)
				$Start:=$Start+1
				
			: ($Start>0)
				If (Length:C16([Users:5]WorksInDept:15)>0)
					[Users:5]WorksInDept:15:=[Users:5]WorksInDept:15+"•"
				End if 
				[Users:5]WorksInDept:15:=[Users:5]WorksInDept:15+Substring:C12(aDepartment{$Start}; 1; 4)
				$Start:=$Start+1
		End case 
	End while 
End if 
ARRAY TEXT:C222(aBullet; 0)
//