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

	local PreName = #()
	local propN = GetPropNames renderers.current	
	local setName = #()
	local setVal = #()
	local rendDiag = "closed"
	local presetsFrame = #()
	local presetsEngine = #()
	
	dotnetcontrol ddlPresets "combobox" pos:[2,2] width:100 height:20
	button btnSet "Set" pos:[103,2] width:22 height:20
	button btnRun "Run" pos:[126,2] width:23 height:20
	
	 on RenderPreseter open do (
		ddlPresets.text = "Presets:"
		bgCol = ( ( colorman.getColor #background )*255 ) as color
		fgCol = ( ( colorman.getColor #text )*255 ) as color
		ddlPresets.BackColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( bgCol.r + 20 ) ( bgCol.g + 20 ) ( bgCol.b + 20 )
		ddlPresets.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
		)

	--setProperty corRen #filter 2
	on btnSet pressed do (
		ddlPresets.items.clear()
		
		if ddlPresets.text != "Presets:" then (
			append PreName ddlPresets.text
			ddlPresets.items.addrange PreName
			ddlPresets.SelectedIndex = ddlPresets.items.count - 1
			) else (
				messagebox "Please add a preset name first!" title:"Render Preseter"
				)
		
		propN = GetPropNames renderers.current
		setVal = #()
		setName = #()
		if renderSceneDialog.isOpen() then rendDiag = "open" else rendDiag = "closed"
		if rendDiag == "open" do renderSceneDialog.close()
		
		renSet = #( rendTimeType, rendNThFrame, rendStart, rendEnd, rendFileNumberBase, rendPickupFrames, \
			getRenderType(), renderWidth, renderHeight, renderPixelAspect, getRendApertureWidth(), \
			rendAtmosphere, renderEffects, renderDisplacements, rendColorCheck, rendFieldRender, rendHidden, \
			rendSimplifyAreaLights, rendForce2Side, rendSuperBlack, rendSaveFile, rendOutputFilename, rendUseDevice, \
			rendShowVFB, skipRenderedFrames, usePreRendScript, preRendScript, usePostRendScript, postRendScript )

		append presetsFrame renSet
			
		join setName #( setVal = #( renderers.current ) )

		for i in propN do (
			join setName #( setVal = #( i, getproperty renderers.current i ) )
			)
		append presetsEngine setName
			
		if rendDiag == "open" do (
			renderSceneDialog.commit()
			renderSceneDialog.open()
			)
		)
		
	on btnRun pressed do (
		if ddlPresets.items.count == 0 then (
			messagebox "Please set a preset first!" title:"Render Preseter"
			) else (
				sL = ddlPresets.SelectedIndex + 1
				clearlistener()
				if ddlPresets.items.count > 1 AND sL > 0 do (
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
						
					if rendDiag == "open" do (
						renderSceneDialog.commit()
						renderSceneDialog.open()
						)	
					)
				)
		) -- btnRun end

	) -- rollout end

createDialog RenderPreseter
cui.RegisterDialogBar RenderPreseter minSize:[150, 25] maxSize:[151, 25] style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
)

