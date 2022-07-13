//%attributes = {"publishedWeb":true}
//Procedure: TSTimeStamp({theDate};{theTime})  073196  MLB
//convert date and time to longint  see TN 29
//see (P) TS2DateTime for conversion back
//this will fail in May of 2063, wont be my problem

C_LONGINT:C283($0; $pc)
C_DATE:C307($1; $date)
C_TIME:C306($2; $time)

$pc:=Count parameters:C259

Case of 
	: ($pc=0)
		$date:=4D_Current_date
		$time:=4d_Current_time
		
	: ($pc=1)
		If ($1=!00-00-00!)
			$Date:=!1995-04-17!  // my date of hire
		Else 
			$date:=$1
		End if 
		$time:=4d_Current_time
		
	: ($pc=2)
		If ($1=!00-00-00!)
			$Date:=!1995-04-17!
		Else 
			$date:=$1
		End if 
		$time:=$2
		
End case 

$0:=(($date-!1995-04-17!)*86400)+($time*1)  //24*60*60
