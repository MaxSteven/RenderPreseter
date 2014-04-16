/*
----------------------------------------------------------------------------------------------------------------------
::
::    Description: This MaxScript is for set render presets
::
----------------------------------------------------------------------------------------------------------------------
:: LICENSE ----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
::    Copyright (C) 2014 Jonathan Baecker (jb_alvarado)
::
::    This program is free software: you can redistribute it and/or modify
::    it under the terms of the GNU General Public License as published by
::    the Free Software Foundation, either version 3 of the License, or
::    (at your option) any later version.
::
::    This program is distributed in the hope that it will be useful,
::    but WITHOUT ANY WARRANTY; without even the implied warranty of
::    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
::    GNU General Public License for more details.
::
::    You should have received a copy of the GNU General Public License
::    along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
:: History --------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
:: This is version 0.5. Last bigger modification was on 2014-04-11
:: 2014-04-04: build the script
:: 2014-04-06: add render elements to the preset list. maybe the first working version
:: 2014-04-08: add and remove presets to scene rootnode
:: 2014-04-09: begin to write and read values from renderer
:: 2014-04-10: renderer presets works
:: 2014-04-11: first full functional version: saves frame settings, renderer and rendersettings and render elements
:: 2014-04-15: now add and remove presets works correct, hopefully
:: 2014-04-16: next step to environment settings
::
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
--
--  Script Name: Search Materials And Maps
--
--	Author:   Jonathan Baecker (jb_alvardo) www.pixelcrusher.de | blog.pixelcrusher.de
--
----------------------------------------------------------------------------------------------------------------------

TODO:

- preset name to presets - we don't need that
- add background, effects and atmosphers - 50% done
- better map check
*/
(
clearlistener()

try ( destroyDialog RenderPreseter ) catch ( )
	
rollout RenderPreseter "Render Preseter" width:150 height:25 (

	local bgCol = ( ( colorman.getColor #background )*255 ) as color
	local fgCol = ( ( colorman.getColor #text )*255 ) as color
	local presetsName = #()
	local engSet = #()
	local setVal = #()
	local rendDiag = "closed"
	local presetsFrame = #()
	local presetsEng = #()
	local presetsEngine = #()
	local element = #()
	local rElement = #()
	local rElementN = #()
	local rElementS = #()
	local rElementA = #()
	local presetsEle = #()
	local presetsElement = #()
	local presetsEnvironment = #()
	local eName = ""
	local ePath = undefined
	local eEnabled= true
	local eFilterOn = true
	local sShadowOn = true
	local eElementName = ""
	local matMap = #()
	local name_values = #()
	local frame_values = #()
	local render_values = #()
	local element_values = #()
	local environment_values = #()
	local nodeIDNam = 55555500
	local nodeIDFra = 66666600
	local nodeIDRen = 77777700
	local nodeIDEle = 88888800
	local nodeIDEnv = 99999900
	local strStreamName = StringStream""
	local strStreamFrame = StringStream""
	local strStreamRender = StringStream""
	local strStreamElement = StringStream""
	local strStreamEnvironment = StringStream""
	local matsInScene = #()
	local meditMats = #()
		
	dotnetcontrol ddlPresets "System.Windows.Forms.ComboBox" pos:[2,2] width:100 height:20
	button btnSet "+" pos:[103,2] width:15 height:20
	button btnRun ">" pos:[118,2] width:15 height:20
	button btnDel "x" pos:[133,2] width:14 height:20
	
	fn comboText = (
		ddlPresets.text = "Render Preset"
		ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB \
		( if fgCol.r < 50 then 127 else 0 ) ( if fgCol.g < 50 then 127 else 0 ) ( if fgCol.b < 50 then 127 else 0 )
		)
			
	fn replaceString str = (
		tStr = ""
		for i=1 to str.count do (
			if str[i] == "\\" then tStr += "\\\\"
			else tStr += str[i] 
			)
		tStr
		)
		
	fn GetBitmapOrMaterial matsInScene classN = (
		matMap = #()
		for m in matsInScene do (
			join matMap ( getClassInstances classN asTrackViewPick:off )
			)
		makeUniqueArray matMap
		)
		
	fn setPresets presetsName presetsFrame presetsEngine presetsElement presetsEnvironment id = (
		strStreamName = StringStream""
		strStreamFrame = StringStream""
		strStreamRender = StringStream""
		strStreamElement = StringStream""
		strStreamEnvironment = StringStream""

		idN = nodeIDNam + id
		idF = nodeIDFra + id
		idR = nodeIDRen + id
		idE = nodeIDEle + id
		idV = nodeIDEnv + id

		presetsFrame = #( presetsFrame )
		presetsEngine = #( presetsEngine )
		presetsElement = #( presetsElement )
		presetsEnvironment = #( presetsEnvironment )
		
		print presetsName to:strStreamName
			setAppData rootnode idN strStreamName

		for f in presetsFrame do print f to:strStreamFrame
			setAppData rootnode idF strStreamFrame

		for r in presetsEngine do print r to:strStreamRender
			setAppData rootnode idR strStreamRender
		
		for m in presetsElement do print m to:strStreamElement
			setAppData rootnode idE strStreamElement
		
		for v in presetsEnvironment do print v to:strStreamEnvironment
			setAppData rootnode idV strStreamEnvironment

		) -- setPresets end	
		
	 on RenderPreseter open do (
		ddlPresets.items.clear()
		ddlPresets.text = "Render Preset"
		ddlPresets.BackColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( bgCol.r + 20 ) ( bgCol.g + 20 ) ( bgCol.b + 20 )
		comboText()
		name_values = #()
		
		for n = 55555500 to 55555599 do (	
			if getAppData rootnode n != undefined do (
				nn = StringStream ( getAppData rootnode n )
				while not eof nn do append name_values ( readvalue nn )
				)
			)
			
		if name_values.count > 0 do (
			for nm in name_values do append presetsName nm
			
			ddlPresets.items.addrange presetsName
			ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
			ddlPresets.SelectedIndex = presetsName.count - 1
			)
	
		for f = 66666600 to 66666699 do (	
			if getAppData rootnode f != undefined do (
				ff = StringStream ( getAppData rootnode f )
				frame_values = #()
				while not eof ff do append frame_values ( readvalue ff )
				append presetsFrame frame_values
				)
			)
			
		for r = 77777700 to 77777799 do (
			if getAppData rootnode r != undefined do (
				rr = StringStream ( getAppData rootnode r )
				render_values = #()
				while not eof rr do append render_values ( readvalue rr )
				append presetsEngine render_values
				)
			)
			
		for l = 88888800 to 88888899 do (
			if getAppData rootnode l != undefined do (
				ee = StringStream ( getAppData rootnode l )
				element_values = #()
				while not eof ee do append element_values ( readvalue ee )
				append presetsElement element_values
				)
			)
			
		for v = 99999900 to 99999999 do (
			if getAppData rootnode v != undefined do (
				vv = StringStream ( getAppData rootnode v )
				environment_values = #()
				while not eof vv do append environment_values ( readvalue vv )
				append presetsEnvironment environment_values
				)
			)	

		for i in presetsEnvironment do print i
		--print presetsName
		--print presetsFrame
		--print presetsEnvironment
		)
		
	on ddlPresets MouseClick arg do (
		ddlPresets.text = ""
		ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
		)
		
	on ddlPresets lostFocus arg do (
		if ddlPresets.text == "" AND presetsName.count == 0 then ( 
			comboText()
			) else if presetsName.count > 0 AND ddlPresets.SelectedIndex == -1 AND ddlPresets.text == "" then (
				comboText()
				)
		)
		
	on btnSet pressed do (
		ddlPresets.items.clear()
		strStreamName = StringStream""
		strStreamFrame = StringStream""
		strStreamRender = StringStream""
		strStreamElement = StringStream""
		strStreamEnvironment = StringStream""
		propN = GetPropNames renderers.current
		rM = maxOps.GetCurRenderElementMgr()
		setVal = #()
		engSet = #()
		element = #()
		rElement = #()
		rElementN = #()
		rElementS = #()
		rElementA = #()
		atmo = #()
		atmos = #()
		atmospherics = #()
		fx = #()
		fxS = #()
		effects = #()
		presetsEnvironment = #()
		
		matsInScene = for mIS in scenematerials collect mIS
		meditMats = for mM in meditmaterials collect mM

		for mA in meditMats do appendIfUnique matsInScene mA

		if ddlPresets.text != "Render Preset" AND ddlPresets.text != "" then (
			
			if findItem presetsName ddlPresets.text > 0 then (
				messagebox "Please use a unique name!" title:"Render Preseter"
				ddlPresets.items.addrange presetsName
				ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
				ddlPresets.SelectedIndex = ddlPresets.items.count - 1
				return false 
				) else (
					append presetsName ddlPresets.text
					ddlPresets.items.addrange presetsName
					ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
					ddlPresets.SelectedIndex = ddlPresets.items.count - 1
					)
			) else (
				messagebox "Please add a preset name first!" title:"Render Preseter"
				)
				
		if renderSceneDialog.isOpen() then rendDiag = "open" else rendDiag = "closed"
		if rendDiag == "open" do renderSceneDialog.close()
	
		-- get framesettings
		presetsFra = #( rendTimeType, rendNThFrame, rendStart, rendEnd, rendFileNumberBase, rendPickupFrames, \
			getRenderType(), renderWidth, renderHeight, renderPixelAspect, getRendApertureWidth(), \
			rendAtmosphere, renderEffects, renderDisplacements, rendColorCheck, rendFieldRender, rendHidden, \
			rendSimplifyAreaLights, rendForce2Side, rendSuperBlack, rendSaveFile, replaceString rendOutputFilename , rendUseDevice, \
			rendShowVFB, skipRenderedFrames, usePreRendScript, replaceString preRendScript, usePostRendScript, replaceString postRendScript )

		append presetsFrame presetsFra
			
		-- get rendersettings
		join engSet #( setVal = #( classof renderers.current ) )

		for rS in propN do (
			prp = getproperty renderers.current rS
			
			case rS of (
				
				#antiAliasFilter: (
					join engSet #( setVal = #( rS, classof prp ) )	
					)
					
				#filter_kernel: (
					join engSet #( setVal = #( rS, classof prp ) )	
					)	
				
				#EnableContours: (
					if prp == true do messagebox "You use contours shader, take in mind that this shaders get NOT saved!" title:"Render Preseter"
					)
					
				#Camera_Lens_Shader: (
					if renderers.current.Enable_Camera_Lens_Shader AND prp != undefined then (
						matIsInScene = "n"
						for mA in matsInScene do (
							if mA == prp do matIsInScene = "y"
							)
						
						if matIsInScene == "n" do (
							messagebox "You use a lens shader, make sure that you put them in the materials editor before saving a new preset!" title:"Render Preseter"
							)
						
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInScene = "n"	
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)
					
				#Camera_Output_Shader: (
					if renderers.current.Enable_Camera_Output_Shader == true AND prp != undefined then (
						matIsInScene = "n"
						for mA in matsInScene do (
							if mA == prp do matIsInScene = "y"
							)
						
						if matIsInScene == "n" do (
							messagebox "You use a output shader, make sure that you put them in the materials editor before saving a new preset!" title:"Render Preseter"
							)
						
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInScene = "n"		
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)
				
				#Camera_Volume_Shader: (
					if renderers.current.Enable_Camera_Volume_Shader == true AND prp != undefined then (
						matIsInScene = "n"
						
						for mA in matsInScene do (
							if mA == prp do matIsInScene = "y"
							)
						
						if matIsInScene == "n" do (
							messagebox "You use a volume shader, make sure that you put them in the materials editor before saving a new preset!" title:"Render Preseter"
							)
						
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInScene = "n"		
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)

				#Override_Material: (
					if renderers.current.Enable_Material_Override == true AND prp != undefined then (
						matIsInScene = "n"
						
						for mA in matsInScene do (
							if mA == prp do matIsInScene = "y"
							)
						
						if matIsInScene == "n" do (
							messagebox "You use a override material, make sure that you put this in the materials editor before saving a new preset!" title:"Render Preseter"
							)
							
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInScene = "n"
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)
					
				#options_overrideMtl_mtl: (
					if renderers.current.options_overrideMtl_on == true AND prp != undefined then (
						matIsInScene = "n"
						
						for mA in matsInScene do (
							if mA == prp do matIsInScene = "y"
							)
						
						if matIsInScene == "n" do (
							messagebox "You use a override material, make sure that you put this in the materials editor before saving a new preset!" title:"Render Preseter"
							)
							
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInScene = "n"
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)
					
				#V_Ray_settings:(
					join engSet #( setVal = #( rS, classof prp ) )
					)

				default: (
					if superclassof prp == textureMap OR superclassof prp == material then (
						join engSet #( setVal = #( rS, classof prp, prp.name ) )
						) else if classof prp == string then (
							join engSet #( setVal = #( rS, replaceString prp ) )
							) else (						
								join engSet #( setVal = #( rS, prp ) )
								)
					)
				
				)
			)
		append presetsEngine engSet
			
		-- get renderelements 
		for i = 0 to rM.numrenderelements() do (
			if ( classof ( rM.GetRenderElement i ) ) != UndefinedClass do (
				join rElement #( element = #( rM.GetRenderElement i, rM.GetRenderElementFilename i ) )
				)
			)
			
		for r = 1 to rElement.count do (
			rElementN = #()
			rElementS = #()
			join rElementS #( rElementN = #( classof rElement[r][1] ) )
			
			if classof rElement[r][2] == string then (
				join rElementS #( rElementN = #( replaceString rElement[r][2] ) )
				) else (
					join rElementS #( rElementN = #( rElement[r][2] ) )
					)
			
			propNames = getPropNames rElement[r][1]
			
			for p in propNames where p != #bitmap do (
				ele = getProperty rElement[r][1] p
				if superclassof ele == material then (
					matIsInScene = "n"
						
						for mA in matsInScene do (
							if mA == ele do matIsInScene = "y"
							)
						
						if matIsInScene == "n" do (
							messagebox ( "You use: \"" + ele as string + "\" in your render elements, make sure that you put them in the materials editor before saving a new preset!" ) title:"Render Preseter"
							)
					join rElementS #( rElementN = #( p, classof ele, ele.name ) )
					matIsInScene == "n"
					) else if superclassof ele == textureMap then (
						messagebox ( "You use: \"" + ele as string + "\" in your render elements, make sure that you put them in the materials editor before saving a new preset!" ) title:"Render Preseter"
						join rElementS #( rElementN = #( p, classof ele, ele.name ) )
						) else if classof ele == string then (
							join rElementS #( rElementN = #( p, replaceString ele ) )
							) else (
								join rElementS #( rElementN = #( p, ele ) )
								)
				)
			append rElementA rElementS
			)
		append presetsElement rElementA
			
		-- presetsEnvironment	
		envSet = #( backgroundColor, useEnvironmentMap, lightTintColor, lightLevel, ambientColor, if environmentMap != undefined then ( classof environmentMap ) else undefined, if environmentMap != undefined do environmentMap.name )

		-- get exposure
		expo = SceneExposureControl.exposureControl
		if expo != undefined do (
			exposS = #()
			exposure = #()
			
			join exposure #( classof expo )

			expS = GetPropNames expo
			for exS in expS do (
				exSprop = getproperty expo exS
				
				if superclassof exSprop != RenderElement AND exS != #shader_mode AND exS != #gammaOnOff AND exS != #gamma AND exS != #WhitePoint do (
					join exposure #( exposS = #( exS, exSprop ) )
					)
				)
			)

		-- get atmospherics
		for a = 1 to numAtmospherics do (
			join atmo #( getAtmospheric a )	
			)

		if atmo.count > 0 do 
			messagebox ( "You use atmospherics in your environment, only the active/deactive state will save. Don't delete the atmosphere!" ) title:"Render Preseter"	
		
		for t = 1 to atmo.count do (
			atmos = #()
			join atmos #( classof atmo[t], isActive ( getAtmospheric t ) )
			append atmospherics atmos
			)

		-- get effects
		for b in 1 to numeffects do (
			join fx #( getEffect b )
			)
			
		for x in 1 to fx.count do (
			fxS = #()
			join fxS #( classof fx[x], isActive ( getEffect x ) )
			append effects fxS
			)
			
		-- merge presetsEnvironment and effects
		envAndFx = #( envSet, exposure, atmospherics, effects )
		append presetsEnvironment envAndFx	
			
		setPresets ddlPresets.text presetsFra engSet rElementA envAndFx presetsName.count

		if rendDiag == "open" do (
			renderSceneDialog.commit()
			renderSceneDialog.open()
			)
		) --bntSet end
		
	on btnRun pressed do (
		rM = maxOps.GetCurRenderElementMgr()
		matsInScene = for mIS in scenematerials collect mIS
		meditMats = for mM in meditmaterials collect mM

		for mA in meditMats do append matsInScene mA

		if ddlPresets.items.count == 0 then (
			messagebox "Please set a preset first!" title:"Render Preseter"
			) else (
				sL = ddlPresets.SelectedIndex + 1
				if ddlPresets.items.count > 0 AND sL > 0 AND presetsFrame[sL] != undefined do (
					if renderSceneDialog.isOpen() then rendDiag = "open" else rendDiag = "closed"
					if rendDiag == "open" do renderSceneDialog.close()

					rendTimeType = presetsFrame[sL][1]
					rendNThFrame = presetsFrame[sL][2]
					rendStart = presetsFrame[sL][3]
					rendEnd = presetsFrame[sL][4]
					rendFileNumberBase = presetsFrame[sL][5]
					rendPickupFrames = presetsFrame[sL][6]
					setRenderType presetsFrame[sL][7]
					renderWidth = presetsFrame[sL][8]
					renderHeight = presetsFrame[sL][9]
					renderPixelAspect = presetsFrame[sL][10]
					setRendApertureWidth presetsFrame[sL][11]
					rendAtmosphere = presetsFrame[sL][12]
					renderEffects = presetsFrame[sL][13]
					renderDisplacements = presetsFrame[sL][14]
					rendColorCheck = presetsFrame[sL][15]
					rendFieldRender = presetsFrame[sL][16]
					rendHidden = presetsFrame[sL][17]
					rendSimplifyAreaLights = presetsFrame[sL][18]
					rendForce2Side = presetsFrame[sL][19]
					rendSuperBlack = presetsFrame[sL][20]
					rendSaveFile = presetsFrame[sL][21]
					rendOutputFilename = presetsFrame[sL][22]
					rendUseDevice = presetsFrame[sL][23]
					rendShowVFB = presetsFrame[sL][24]
					skipRenderedFrames = presetsFrame[sL][25]
					usePreRendScript = presetsFrame[sL][26]
					preRendScript = presetsFrame[sL][27]
					usePostRendScript = presetsFrame[sL][28]
					postRendScript = presetsFrame[sL][29]

					if classof renderers.current != presetsEngine[sL][1][1] do renderers.current = presetsEngine[sL][1][1] ()
					
					cR = renderers.current
						
					for i = 2 to presetsEngine[sL].count do (
						pEV = presetsEngine[sL][i]
						
						case pEV[1] of (
							
							#antiAliasFilter: (
								cR.antiAliasFilter = pEV[2] ()
								)
							
							#Camera_Lens_Shader: (
								if pEV[2] == undefined then (
									cR.Camera_Lens_Shader = undefined
									) else (
										for mA in matsInScene do (
											if classof mA == pEV[2] AND mA.name == pEV[3] do (
												cR.Camera_Lens_Shader = mA
												)
											)
										)
								)
								
							#Camera_Output_Shader: (
								if pEV[2] == undefined then (
									cR.Camera_Output_Shader = undefined
									) else (
										for mA in matsInScene do (
											if classof mA == pEV[2] AND mA.name == pEV[3] do (
												cR.Camera_Output_Shader = mA
												)
											)
										)
								)
								
							#Camera_Volume_Shader: (
								if pEV[2] == undefined then (
									cR.Camera_Volume_Shader = undefined
									) else ( 
										for mA in matsInScene do (
											if classof mA == pEV[2] AND mA.name == pEV[3] do (
												cR.Camera_Volume_Shader = mA
												)
											)
										)
								)

							#Override_Material: (
								if pEV[2] == undefined then (
									cR.Override_Material = undefined
									) else ( 
										for mA in matsInScene do (
											if classof mA == pEV[2] AND mA.name == pEV[3] do (
												cR.Override_Material = mA
												)
											)
										)
								)
								
							#options_overrideMtl_mtl: (
								if pEV[2] == undefined then (
									cR.options_overrideMtl_mtl = undefined
									) else ( 
										for mA in matsInScene do (
											if classof mA == pEV[2] AND mA.name == pEV[3] do (
												cR.Override_Material = mA
												)
											)
										)
								)	
								
							default: (
								if pEV[3] != undefined then (
									for mA in matsInScene do (
										if classof mA == pEV[2] AND mA.name == pEV[3] do (
											cR.Override_Material = mA
											)
										)
									) else (
										try ( setProperty cR pEV[1] pEV[2] ) catch ()
										)
								)
							)
						)

					rM.removeallrenderelements()
						
					for p = 1 to presetsElement[sL].count do (
						eName = presetsElement[sL][p][1][1]
						if presetsElement[sL][p][2][1] != undefined do ePath = presetsElement[sL][p][2][1]
						
						for r = 1 to presetsElement[sL][p].count do (
							if presetsElement[sL][p][r][1] == #elementName do eElementName = presetsElement[sL][p][r][2]
							)
						rM.AddRenderElement ( ( eName ) elementName:eElementName )
						
						if ePath != undefined do rM.SetRenderElementFilename (p-1) ePath
						)
					
					for r = 0 to rM.numRenderElements() do (
						if ( classof ( rM.GetRenderElement r ) ) != UndefinedClass do (
							re = rM.getRenderElement r
							
							for t = 3 to presetsElement[sL][r+1].count do (
								if presetsElement[sL][r+1][t][1] != #elementName AND presetsElement[sL][r+1][t][2] != undefined do (
									if classof presetsElement[sL][r+1][t][2] == material then (
										for mA in matsInScene do (
											if classof mA == presetsElement[sL][r+1][t][2] AND mA.name == presetsElement[sL][r+1][t][3] then (												
												setProperty re presetsElement[sL][r+1][t][1] mA
												) else (
													messagebox ( presetsElement[sL][r+1][t][3] as string + "\" is not longer in your scene, render element material can not set!" ) title:"Render Preseter"
													)
											)
										) else if classof presetsElement[sL][r+1][t][2] == textureMap then (
											matMap = ( GetBitmapOrMaterial matsInScene presetsElement[sL][r+1][t][2] )
											if matMap.count == 0 do messagebox ( presetsElement[sL][r+1][t][3] as string + "\" is not longer in your scene, render element shader can not set!" ) title:"Render Preseter"
											for mA in matMap do (
												if mA.name == presetsElement[sL][r+1][t][3] then (
													setProperty re presetsElement[sL][r+1][t][1] mA
													) else (
														messagebox ( presetsElement[sL][r+1][t][3] as string + "\" is not longer in your scene, render element shader can not set!" ) title:"Render Preseter"
														)
												)
											) else (
												setProperty re presetsElement[sL][r+1][t][1] presetsElement[sL][r+1][t][2]
												)
									) 
								) 
							)
						)
						
					if rendDiag == "open" do (
						renderSceneDialog.commit()
						renderSceneDialog.open()
						)
					)
				)
		) -- btnRun end

		on btnDel pressed do (
			if presetsName.count > 0 AND ddlPresets.SelectedIndex >= 0 then (
				sL = ddlPresets.SelectedIndex + 1
				ddlPresets.items.clear()
								
				for i = 1 to 99 do (
					deleteAppData rootnode ( nodeIDNam + i )
					deleteAppData rootnode ( nodeIDFra + i )
					deleteAppData rootnode ( nodeIDRen + i )
					deleteAppData rootnode ( nodeIDEle + i )
					deleteAppData rootnode ( nodeIDEnv + i )
					)
					
				deleteItem presetsName sL
				deleteItem presetsFrame sL
				deleteItem presetsEngine sL
				deleteItem presetsElement sL
				deleteItem presetsEnvironment sL

				for j = 1 to presetsName.count do (
					setPresets presetsName[j] presetsFrame[j] presetsEngine[j] presetsElement[j] presetsEnvironment[j] j
					)

				ddlPresets.items.addrange presetsName
				ddlPresets.SelectedIndex = presetsName.count - 1
				
				if presetsName.count == 0 do comboText()
				) else ( comboText() )
			)
	) -- rollout end

createDialog RenderPreseter
cui.RegisterDialogBar RenderPreseter minSize:[150, 25] maxSize:[151, 25] style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
)

