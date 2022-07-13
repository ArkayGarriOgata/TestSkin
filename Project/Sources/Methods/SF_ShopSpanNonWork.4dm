//%attributes = {"publishedWeb":true}
//PM: SF_ShopSpanNonWork(start;end;wksat;wkSun) ->end 
//@author mlb - 12/5/01  16:05

C_DATE:C307($start; $1; $end; $2; $0; $midDate; $newDate)
C_BOOLEAN:C305($3; $4; $wkSat; $wkSun)
C_LONGINT:C283($dayStart; $dayEnd)

$start:=$1
$end:=$2
$wkSat:=$3
$wkSun:=$4

If (($end-$start)>1)  //spans more than 2 days
	$dayStart:=Day number:C114($start)
	$dayEnd:=Day number:C114($end)
	If ($dayStart#6) & ($dayEnd#2)  //its a week end in between
		$midDate:=$start+1
		$skip:=0
		While ($midDate<$end) & ($midDate#!00-00-00!)
			$newDate:=SF_ShopWeekend($midDate; $wkSat; $wkSun)
			$newDate:=SF_ShopHolidays($newDate)
			If ($newDate>$midDate)  //spanned a no work day
				$skip:=$skip+1
			End if 
			$midDate:=$midDate+1
		End while 
		
		If ($skip>0)
			$end:=$end+$skip
			$end:=SF_ShopWeekend($end; $wkSat; $wkSun)
			$end:=SF_ShopHolidays($end)
		End if 
	End if 
End if 

$0:=$end