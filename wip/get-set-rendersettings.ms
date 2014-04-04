renSet = #( rendTimeType, rendNThFrame, rendStart, rendEnd, rendFileNumberBase, rendPickupFrames, \
	getRenderType(), renderWidth, renderHeight, renderPixelAspect, getRendApertureWidth(), \
	rendAtmosphere, renderEffects, renderDisplacements, rendColorCheck, rendFieldRender, rendHidden, \
	rendSimplifyAreaLights, rendForce2Side, rendSuperBlack, rendSaveFile, rendOutputFilename, rendUseDevice, \
	rendShowVFB, skipRenderedFrames, usePreRendScript, preRendScript, usePostRendScript, postRendScript )

	rendDiag = "closed"
	if renderSceneDialog.isOpen() do rendDiag = "open"
	if rendDiag == "open" do renderSceneDialog.close()

		rendTimeType = renSet[1]
		rendNThFrame = renSet[2]
		rendStart = renSet[3]
		rendEnd = renSet[4]
		rendFileNumberBase = renSet[5]
		rendPickupFrames = renSet[6]
		setRenderType renSet[7]
		renderWidth = renSet[8]
		renderHeight = renSet[9]
		renderPixelAspect = renSet[10]
		setRendApertureWidth renSet[11]
		rendAtmosphere = renSet[12]
		renderEffects = renSet[13]
		renderDisplacements = renSet[14]
		rendColorCheck = renSet[15]
		rendFieldRender = renSet[16]
		rendHidden = renSet[17]
		rendSimplifyAreaLights = renSet[18]
		rendForce2Side = renSet[19]
		rendSuperBlack = renSet[20]
		rendSaveFile = renSet[21]
		rendOutputFilename = renSet[22]
		rendUseDevice = renSet[23]
		rendShowVFB = renSet[24]
		skipRenderedFrames = renSet[25]
		usePreRendScript = renSet[26]
		preRendScript = renSet[27]
		usePostRendScript = renSet[28]
		postRendScript = renSet[29]
		
	if rendDiag == "open" do (
		renderSceneDialog.commit()
		renderSceneDialog.open()
		)