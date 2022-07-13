//%attributes = {"publishedWeb":true}
//PM:  FG_PrepServiceManditoriesSet  2/07/01  mlb
//make sure all the required fields have been set
$cool:=True:C214
//test the sliders
If (Length:C16([Finished_Goods_Specifications:98]SizeAndStyleApproved:12)>0)
	If (Length:C16([Finished_Goods_Specifications:98]OriginalItem:13)>0)
		If (Length:C16([Finished_Goods_Specifications:98]MakePasteUp:25)>0)
			If (Length:C16([Finished_Goods_Specifications:98]Stamps:16)>0)
				If (Length:C16([Finished_Goods_Specifications:98]Embosses:17)>0)
					If (Length:C16([Finished_Goods_Specifications:98]Omit_Window_BS:75)>0)  // (Length([FG_Specification]Omits)>0)
						If (Length:C16([Finished_Goods_Specifications:98]Coated:26)>0)
							If (Length:C16([Finished_Goods_Specifications:98]CoatingMethod:27)>0)
								If (Length:C16([Finished_Goods_Specifications:98]CoatingOmit:28)>0)
									If (Length:C16([Finished_Goods_Specifications:98]GraphicsCommon:29)>0)
										If (Length:C16([Finished_Goods_Specifications:98]CodeNeeded:31)>0)
											If (Length:C16([Finished_Goods_Specifications:98]ItemWith:33)>0)
												If ([Finished_Goods_Specifications:98]Size_n_style:79#!00-00-00!)
													If ([Finished_Goods_Specifications:98]Colors:80#!00-00-00!)
														$cool:=True:C214
													Else 
														$cool:=False:C215
														zwStatusMsg("MANDITORIES"; "[FG_Specification]Color")
													End if 
												Else 
													$cool:=False:C215
													zwStatusMsg("MANDITORIES"; "[FG_Specification]S&S")
												End if 
											Else 
												$cool:=False:C215
												zwStatusMsg("MANDITORIES"; "[FG_Specification]ItemWith")
											End if 
										Else 
											$cool:=False:C215
											zwStatusMsg("MANDITORIES"; "[FG_Specification]CodeNeeded")
										End if 
									Else 
										$cool:=False:C215
										zwStatusMsg("MANDITORIES"; "[FG_Specification]GraphicsCommon")
									End if 
								Else 
									$cool:=False:C215
									zwStatusMsg("MANDITORIES"; "[FG_Specification]CoatingOmit")
								End if 
							Else 
								$cool:=False:C215
								zwStatusMsg("MANDITORIES"; "[FG_Specification]CoatingMethod")
							End if 
						Else 
							$cool:=False:C215
							zwStatusMsg("MANDITORIES"; "[FG_Specification]Coated")
						End if 
					Else 
						$cool:=False:C215
						zwStatusMsg("MANDITORIES"; "[Finished_Goods_Specifications]Omit_Window_BS")
					End if 
				Else 
					$cool:=False:C215
					zwStatusMsg("MANDITORIES"; "[FG_Specification]Embosses")
				End if 
			Else 
				$cool:=False:C215
				zwStatusMsg("MANDITORIES"; "[FG_Specification]Stamps")
			End if 
		Else 
			$cool:=False:C215
			zwStatusMsg("MANDITORIES"; "[FG_Specification]MakePasteUp")
		End if 
	Else 
		$cool:=False:C215
		zwStatusMsg("MANDITORIES"; "[FG_Specification]OriginalItem")
	End if 
Else 
	$cool:=False:C215
	zwStatusMsg("MANDITORIES"; "[FG_Specification]SizeAndStyleApproved")
End if 

//test the 'If so:'s
If ($cool)
	If ([Finished_Goods_Specifications:98]CoatingOmit:28#"No")
		If (Length:C16([Finished_Goods_Specifications:98]CoatingOmitsWhere:34)=0)
			$cool:=False:C215
			zwStatusMsg("MANDITORIES"; "[FG_Specification]CoatingOmitsWhere")
		End if 
	End if 
End if 

If ($cool)
	If ([Finished_Goods_Specifications:98]GraphicsCommon:29="Yes")
		If (Length:C16([Finished_Goods_Specifications:98]GraphicLike:30)=0)
			$cool:=False:C215
			zwStatusMsg("MANDITORIES"; "[FG_Specification]GraphicLike")
		End if 
	End if 
End if 

If ($cool)
	If ([Finished_Goods_Specifications:98]CodeNeeded:31="Yes")
		If (Length:C16([Finished_Goods_Specifications:98]CodePosition:32)=0)
			$cool:=False:C215
			zwStatusMsg("MANDITORIES"; "[FG_Specification]CodePosition")
		End if 
	End if 
End if 

If ($cool)
	If (Length:C16([Finished_Goods_Specifications:98]ServiceRequested:54)>0)
		$cool:=True:C214
	Else 
		$cool:=False:C215
		zwStatusMsg("MANDITORIES"; "[FG_Specification]ServiceRequested")
	End if 
End if 

If ($cool)
	If (Length:C16([Finished_Goods_Specifications:98]GlueDirection:73)>0)
		$cool:=True:C214
	Else 
		[Finished_Goods_Specifications:98]GlueDirection:73:="ReGuLar"  // • mel (6/23/05, 10:01:16) default this
		//$cool:=False
		zwStatusMsg("MANDITORIES"; "[FG_Specification]GlueDirection")
	End if 
End if 

If ($cool)
	If ([Finished_Goods_Specifications:98]ProcessColors:81)
		If ([Finished_Goods_Specifications:98]MatchPrint:82#!00-00-00!) & ([Finished_Goods_Specifications:98]HiRez:83#!00-00-00!)
			$cool:=True:C214
		Else 
			$cool:=False:C215
			zwStatusMsg("MANDITORIES"; "ProcessColors need Match Print and HiRez file")
		End if 
	End if 
End if   //cool


If ($cool)
	zwStatusMsg("MANDITORIES"; "Submittal Accepted")
End if 

$0:=$cool