If (rReal3<(1/16))
	rReal3:=1/16
End if 
$points:=Int:C8(rReal3*72)
OBJECT SET FONT SIZE:C165(sDesc; $points)
rReal13:=Round:C94(rReal3*(12/15); 2)