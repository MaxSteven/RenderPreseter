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
:: This is version 0.4. Last bigger modification was on 2014-04-11
:: 2014-04-04: build the script
:: 2014-04-06: add render elements to the preset list. maybe the first working version
:: 2014-04-08: add and remove presets to scene rootnode
:: 2014-04-09: begin to write and read values from renderer
:: 2014-04-10: renderer presets works
:: 2014-04-11: first full functional version: saves frame settings, renderer and rendersettings and render elements
::
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
--
--  Script Name: Search Materials And Maps
--
--	Author:   Jonathan Baecker (jb_alvardo) www.pixelcrusher.de | blog.pixelcrusher.de
--
----------------------------------------------------------------------------------------------------------------------
*/

macroScript RenderPreseter
	category:"jb_scripts"
	ButtonText:"RenderPreseter"
	Tooltip:"RenderPreseter"
 
(
try ( destroyDialog RenderPreseter ) catch ( )
	
rollout RenderPreseter "Render Preseter" width:150 height:25 (

	local bgCol = ( ( colorman.getColor #background )*255 ) as color
	local fgCol = ( ( colorman.getColor #text )*255 ) as color
	local PreName = #()
	local propN = GetPropNames renderers.current	
	local engSet = #()
	local setVal = #()
	local rendDiag = "closed"
	local presetsFrame = #()
	local presetsEng = #()
	local presetsEngine = #()
	local rM = maxOps.GetCurRenderElementMgr()
	local element = #()
	local rElement = #()
	local rElementN = #()
	local rElementS = #()
	local rElementA = #()
	local presetsEle = #()
	local presetsElement = #()
	local eName = ""
	local ePath = undefined
	local eEnabled= true
	local eFilterOn = true
	local sShadowOn = true
	local eElementName = ""
	local matMap = #()
	local frame_values = #()
	local render_values = #()
	local element_values = #()
	local nodeIDNam = 55555501
	local nodeIDEnv = 66666601
	local nodeIDFra = 77777701
	local nodeIDRen = 88888801
	local nodeIDEle = 99999901
	local strStreamName = StringStream""
	local strStreamFrame = StringStream""
	local strStreamRender = StringStream""
	local strStreamElement = StringStream""
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
		
	fn GetBitmapOrMaterial place classN = (
		matMap = #()
		for m in place do (
			join matMap ( getClassInstances classN asTrackViewPick:off )
			)
			makeUniqueArray matMap
		)	
	
	 on RenderPreseter open do (
		ddlPresets.items.clear()
		ddlPresets.text = "Render Preset"
		ddlPresets.BackColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( bgCol.r + 20 ) ( bgCol.g + 20 ) ( bgCol.b + 20 )
		comboText()

		if getAppData rootnode nodeIDNam != undefined AND getAppData rootnode nodeIDNam != "" do (
			nn = StringStream ( getAppData rootnode nodeIDNam )
			while not eof nn do append PreName ( readvalue nn )
			
			ddlPresets.items.addrange PreName
			ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
			ddlPresets.SelectedIndex = PreName.count - 1
			)
		
		for f = 77777701 to 77777799 do (	
			if getAppData rootnode f != undefined do (
				ff = StringStream ( getAppData rootnode f )
				frame_values = #()
				while not eof ff do append frame_values ( readvalue ff )
				append presetsFrame frame_values
				)
			)
		
		for r = 88888801 to 88888899 do (
			if getAppData rootnode r != undefined do (
				rr = StringStream ( getAppData rootnode r )
				render_values = #()
				while not eof rr do append render_values ( readvalue rr )
				append presetsEngine render_values
				)
			)
			
		for l = 99999901 to 99999999 do (
			if getAppData rootnode l != undefined do (
				ee = StringStream ( getAppData rootnode l )
				element_values = #()
				while not eof ee do append element_values ( readvalue ee )
				append presetsElement element_values
				)
			)
		)
		
	on ddlPresets MouseClick arg do (
		ddlPresets.text = ""
		ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
		)
		
	on ddlPresets lostFocus arg do (
		if ddlPresets.text == "" AND PreName.count == 0 then ( 
			comboText()
			) else if PreName.count > 0 AND ddlPresets.SelectedIndex == -1 AND ddlPresets.text == "" then (
				comboText()
				)
		)
		
	on btnSet pressed do (
		ddlPresets.items.clear()
		strStreamName = StringStream""
		strStreamFrame = StringStream""
		strStreamRender = StringStream""
		strStreamElement = StringStream""
		propN = GetPropNames renderers.current
		rM = maxOps.GetCurRenderElementMgr()
		setVal = #()
		engSet = #()
		element = #()
		rElement = #()
		rElementN = #()
		rElementS = #()
		rElementA = #()
		
		matsInScene = for mIS in scenematerials collect mIS
		meditMats = for mM in meditmaterials collect mM

		for mA in meditMats do append matsInScene mA

		if ddlPresets.text != "Render Preset" AND ddlPresets.text != "" then (
			append PreName ddlPresets.text
			ddlPresets.items.addrange PreName
			ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
			ddlPresets.SelectedIndex = ddlPresets.items.count - 1
			) else (
				messagebox "Please add a preset name first!" title:"Render Preseter"
				)

		if renderSceneDialog.isOpen() then rendDiag = "open" else rendDiag = "closed"
		if rendDiag == "open" do renderSceneDialog.close()
	
		-- get framesettings
		renSet = #( rendTimeType, rendNThFrame, rendStart, rendEnd, rendFileNumberBase, rendPickupFrames, \
			getRenderType(), renderWidth, renderHeight, renderPixelAspect, getRendApertureWidth(), \
			rendAtmosphere, renderEffects, renderDisplacements, rendColorCheck, rendFieldRender, rendHidden, \
			rendSimplifyAreaLights, rendForce2Side, rendSuperBlack, rendSaveFile, replaceString rendOutputFilename , rendUseDevice, \
			rendShowVFB, skipRenderedFrames, usePreRendScript, replaceString preRendScript, usePostRendScript, replaceString postRendScript )

		append presetsFrame renSet
			
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
						matIsInEditor = "n"
						for mA in matsInScene do (
							if mA == prp do matIsInEditor = "y"
							)
						
						if matIsInEditor == "n" do (
							messagebox "You use a lens shader, make sure that you put them in the materials editor before saving a new preset!" title:"Render Preseter"
							)
						
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInEditor = "n"	
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)
					
				#Camera_Output_Shader: (
					if renderers.current.Enable_Camera_Output_Shader == true AND prp != undefined then (
						matIsInEditor = "n"
						for mA in matsInScene do (
							if mA == prp do matIsInEditor = "y"
							)
						
						if matIsInEditor == "n" do (
							messagebox "You use a output shader, make sure that you put them in the materials editor before saving a new preset!" title:"Render Preseter"
							)
						
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInEditor = "n"		
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)
				
				#Camera_Volume_Shader: (
					if renderers.current.Enable_Camera_Volume_Shader == true AND prp != undefined then (
						matIsInEditor = "n"
						
						for mA in matsInScene do (
							if mA == prp do matIsInEditor = "y"
							)
						
						if matIsInEditor == "n" do (
							messagebox "You use a volume shader, make sure that you put them in the materials editor before saving a new preset!" title:"Render Preseter"
							)
						
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInEditor = "n"		
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)

				#Override_Material: (
					if renderers.current.Enable_Material_Override == true AND prp != undefined then (
						matIsInEditor = "n"
						
						for mA in matsInScene do (
							if mA == prp do matIsInEditor = "y"
							)
						
						if matIsInEditor == "n" do (
							messagebox "You use a override material, make sure that you put this in the materials editor before saving a new preset!" title:"Render Preseter"
							)
							
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInEditor = "n"
						) else (
							join engSet #( setVal = #( rS, undefined ) )
							)
					)
					
				#options_overrideMtl_mtl: (
					if renderers.current.options_overrideMtl_on == true AND prp != undefined then (
						matIsInEditor = "n"
						
						for mA in matsInScene do (
							if mA == prp do matIsInEditor = "y"
							)
						
						if matIsInEditor == "n" do (
							messagebox "You use a override material, make sure that you put this in the materials editor before saving a new preset!" title:"Render Preseter"
							)
							
						join engSet #( setVal = #( rS, classof prp, prp.name ) )	
						matIsInEditor = "n"
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
			
		append presetsEng engSet
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
				if superclassof ele == textureMap OR superclassof ele == material then (
					matIsInEditor = "n"
						
						for mA in matsInScene do (
							if mA == ele do matIsInEditor = "y"
							)
						
						if matIsInEditor == "n" do (
							messagebox ( "You use: \"" + ele as string + "\" in your render elements, make sure that you put them in the materials editor before saving a new preset!" ) title:"Render Preseter"
							)
					join rElementS #( rElementN = #( p, classof ele, ele.name ) )
					matIsInEditor == "n"
					) else if classof ele == string then (
						join rElementS #( rElementN = #( p, replaceString ele ) )
						) else (
							join rElementS #( rElementN = #( p, ele ) )
							)
				)
			append rElementA rElementS
			)
		
		append presetsEle rElementA
		append presetsElement rElementA

		idF = nodeIDFra + ( PreName.count )
		idR = nodeIDRen + ( PreName.count )
		idE = nodeIDEle + ( PreName.count )
		
		for n in PreName do print n to:strStreamName
			setAppData rootnode nodeIDNam strStreamName

		for f in renSet do print f to:strStreamFrame
			setAppData rootnode idF strStreamFrame
		
		for r in presetsEng do print r to:strStreamRender
			setAppData rootnode idR strStreamRender
		
		for m in presetsEle do print m to:strStreamElement
			setAppData rootnode idE strStreamElement
		
		if rendDiag == "open" do (
			renderSceneDialog.commit()
			renderSceneDialog.open()
			)
		) --bntSet end
		
	on btnRun pressed do (
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
									if superclassof presetsElement[sL][r+1][t][2] == material then (
										for mA in matsInScene do (
											if classof mA == presetsElement[sL][r+1][t][2] AND mA.name == presetsElement[sL][r+1][t][3] do (
												
										
												setProperty re presetsElement[sL][r+1][t][1] mA
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
			if PreName.count > 0 AND ddlPresets.SelectedIndex >= 0 then (
				sL = ddlPresets.SelectedIndex + 1
				ddlPresets.items.clear()
				strStreamName = StringStream""
				deleteItem PreName sL
				deleteItem presetsFrame sL
				deleteItem presetsEngine sL
				--deleteItem presetsElement sL

				idF = nodeIDFra + sL
				idR = nodeIDRen + sL
				idE = nodeIDEle + sL

				deleteAppData rootnode nodeIDNam
				
				for n in PreName do print n to:strStreamName
					setAppData rootnode nodeIDNam strStreamName
				
				deleteAppData rootnode idF
				deleteAppData rootnode idR
				deleteAppData rootnode idE

				ddlPresets.items.addrange PreName
				ddlPresets.SelectedIndex = PreName.count - 1
				
				if PreName.count == 0 do comboText()
				) else ( comboText() )
			)
	) -- rollout end

createDialog RenderPreseter
cui.RegisterDialogBar RenderPreseter minSize:[150, 25] maxSize:[151, 25] style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
)
