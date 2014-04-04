-- Dotnet combo
clearlistener()
rollout tehRollout  "Dotnet combo" width:150 height:25 (
	dotnetcontrol tehCombo  "combobox" pos:[2,2] width:100 height:20
	button btnSet "Set" pos:[103,2] width:22 height:20
	button btnRun "Run" pos:[126,2] width:23 height:20
	local it = #("Presets:")
on tehRollout open do (
	tehCombo.text = "Presets:"
	--tehCombo.items.addrange it
	bgCol = ( ( colorman.getColor #background )*255 ) as color
	fgCol = ( ( colorman.getColor #text )*255 ) as color
	tehCombo.BackColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( bgCol.r + 20 ) ( bgCol.g + 20 ) ( bgCol.b + 20 )
	tehCombo.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB ( fgCol.r + 30 ) ( fgCol.g + 30 ) ( fgCol.b + 30 )
	--tehCombo.SelectedIndex = 0
	)
	
	on btnSet pressed do (
		it = #()
		tehCombo.items.clear
		append it tehCombo.text
		tehCombo.items.addrange it
		tehCombo.SelectedIndex = tehCombo.items.count - 1
		)
)

createDialog tehRollout
cui.RegisterDialogBar tehRollout minSize:[150, 25] maxSize:[151, 25] style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
-- Some useful info
--show tehRollout.controls[1].items.item
