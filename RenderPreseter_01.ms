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
:: This is version 0.2. Last bigger modification was on 2014-04-04
:: 2014-04-24: build the script
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
(
clearlistener()
	
try ( destroyDialog RenderPreseter ) catch ( )
	
rollout RenderPreseter "Render Preseter" width:150 height:25 (

	local bgCol = ( ( colorman.getColor #background )*255 ) as color
	local fgCol = ( ( colorman.getColor #text )*255 ) as color
	local PreName = #()
	local propN = GetPropNames renderers.current	
	local setName = #()
	local setVal = #()
	local rendDiag = "closed"
	local presetsFrame = #()
	local presetsEngine = #()
	local rM = maxOps.GetCurRenderElementMgr()
	local element = #()
	local rElement = #()
	local rElementN = #()
	local rElementS = #()
	local rElementA = #()
	local presetsElement = #()
	local eName = ""
	local ePath = undefined
	local eEnabled= true
	local eFilterOn = true
	local sShadowOn = true
	local eElementName = ""
	local eMultiplier = 1.0
	local eLabel = ""
	local eShader = undefined
		
	dotnetcontrol ddlPresets "System.Windows.Forms.ComboBox" pos:[2,2] width:100 height:20
	button btnSet "+" pos:[103,2] width:15 height:20
	button btnRun ">" pos:[118,2] width:15 height:20
	button btnDel "x" pos:[133,2] width:15 height:20
	
	 on RenderPreseter open do (
		ddlPresets.text = "Render Preset"
		ddlPresets.BackColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( bgCol.r + 20 ) ( bgCol.g + 20 ) ( bgCol.b + 20 )
		ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB \
		( if fgCol.r < 50 then 127 else 0 ) ( if fgCol.g < 50 then 127 else 0 ) ( if fgCol.b < 50 then 127 else 0 )
		)

	on ddlPresets MouseClick arg do (
		ddlPresets.text = ""
		ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
		)
		
	on ddlPresets lostFocus arg do (
		if ddlPresets.text == "" AND PreName.count == 0 do ( 
			ddlPresets.text = "Render Preset"
			ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB \
			( if fgCol.r < 50 then 127 else 0 ) ( if fgCol.g < 50 then 127 else 0 ) ( if fgCol.b < 50 then 127 else 0 )
			)
		)
		
	on btnSet pressed do (
		ddlPresets.items.clear()
		propN = GetPropNames renderers.current
		setVal = #()
		setName = #()
		element = #()
		rElement = #()
		rElementN = #()
		rElementS = #()
		rElementA = #()

		
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
			rendSimplifyAreaLights, rendForce2Side, rendSuperBlack, rendSaveFile, rendOutputFilename, rendUseDevice, \
			rendShowVFB, skipRenderedFrames, usePreRendScript, preRendScript, usePostRendScript, postRendScript )

		append presetsFrame renSet
			
		-- get rendersettings
		join setName #( setVal = #( renderers.current ) )

		for rS in propN do (
			join setName #( setVal = #( rS, getproperty renderers.current rS ) )
			)
		append presetsEngine setName
			
		-- get renderelements 
		for i = 0 to rM.numrenderelements() do (
			if ( classof ( rM.GetRenderElement i ) ) != UndefinedClass do (
				join rElement #( element = #( rM.GetRenderElement i, rM.GetRenderElementFilename i ) )
				)
			)
			
		for r = 1 to rElement.count do (
			rElementN = #()
			rElementS = #()
			join rElementS #( rElementN = #( rElement[r][1] ) )
			join rElementS #( rElementN = #( rElement[r][2] ) )
			
			propNames = getPropNames rElement[r][1]
			
			for p in propNames where p != #bitmap AND p != #atmosphereOn do (
				join rElementS #( rElementN = #( p, getProperty rElement[r][1] p ) )
				)
			append rElementA rElementS
			)
		
		append presetsElement rElementA
			
		if rendDiag == "open" do (
			renderSceneDialog.commit()
			renderSceneDialog.open()
			)
		) --bntSet end
		
	on btnRun pressed do (
		if ddlPresets.items.count == 0 then (
			messagebox "Please set a preset first!" title:"Render Preseter"
			) else (
				sL = ddlPresets.SelectedIndex + 1
				if ddlPresets.items.count > 0 AND sL > 0 do (
					if renderSceneDialog.isOpen() then rendDiag = "open" else rendDiag = "closed"
					if rendDiag == "open" do renderSceneDialog.close()
					
					if renderers.current != presetsEngine[sL][1][1] do renderers.current = presetsEngine[sL][1][1]
						
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
						
					for i = 2 to presetsEngine[sL].count do (
						try ( setProperty renderers.current presetsEngine[sL][i][1] presetsEngine[sL][i][2] ) catch ()
						)
						
					--for d = 0 to rM.numrenderelements() do rM.SetRenderElementFilename d ""
					rM.removeallrenderelements()
						
					for p = 1 to presetsElement[sL].count do (
						eName = classof presetsElement[sL][p][1][1]
						if presetsElement[sL][p][2][1] != undefined do ePath = presetsElement[sL][p][2][1]
						
						for r = 1 to presetsElement[sL][p].count do (
							if presetsElement[sL][p][r][1] == #enabled do eEnabled = presetsElement[sL][p][r][2]
							if presetsElement[sL][p][r][1] == #filterOn do eFilterOn = presetsElement[sL][p][r][2]
							if presetsElement[sL][p][r][1] == #elementName do eElementName = presetsElement[sL][p][r][2]
							if presetsElement[sL][p][r][1] == #shadowOn do if presetsElement[sL][p][r][2] == true then sShadowOn = true else sShadowOn = false
							if presetsElement[sL][p][r][1] == #multiplier then eMultiplier = presetsElement[sL][p][r][2] else eMultiplier = 1.0
							if presetsElement[sL][p][r][1] == #label then eLabel = presetsElement[sL][p][r][2] else eLabel = undefined
							if presetsElement[sL][p][r][1] == #Shader then eShader = presetsElement[sL][p][r][2] else eShader = undefined
							)
						--print ePath
						rM.AddRenderElement ( eName enabled:eEnabled filterOn:eFilterOn elementName:eElementName shadowOn:sShadowOn multiplier:eMultiplier label:eLabel Shader:eShader )
							
						if ePath != undefined do rM.SetRenderElementFilename (p-1) ePath
						)

					if rendDiag == "open" do (
						renderSceneDialog.commit()
						renderSceneDialog.open()
						)	
					)
				)
		) -- btnRun end

		on btnDel pressed do (
			sL = ddlPresets.SelectedIndex + 1
			ddlPresets.items.clear()
			deleteItem PreName sL
			deleteItem presetsFrame sL
			deleteItem presetsEngine sL
			deleteItem presetsElement sL
			
			ddlPresets.items.addrange PreName
			if PreName.count == 0 then (
				ddlPresets.text = "Render Preset"
				ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB \
				( if fgCol.r < 50 then 127 else 0 ) ( if fgCol.g < 50 then 127 else 0 ) ( if fgCol.b < 50 then 127 else 0 )
				) else (
					ddlPresets.SelectedIndex = 0
					)
			)
	) -- rollout end

createDialog RenderPreseter
cui.RegisterDialogBar RenderPreseter minSize:[150, 25] maxSize:[151, 25] style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
)

