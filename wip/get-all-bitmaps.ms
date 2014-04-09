
(
	clearlistener()
	matMap = #()
	fn GetBitmapOrMaterial place classN = (
		matMap = #()
		for m in place do (
			join matMap ( getClassInstances classN asTrackViewPick:off )
			)
			makeUniqueArray matMap
		)
		
	matMap = ( GetBitmapOrMaterial meditmaterials Depth_of_Field___Bokeh )

	if matMap.count == 0 then (
		matMap = ( GetBitmapOrMaterial scenematerials Depth_of_Field___Bokeh )
		) 
	if matMap.count == 0 then (
		print "yes"
		) 	
		
	for mM in matMap do print ( mM )
	--OK
)