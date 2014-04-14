(
clearlistener()
presetsFrame = #()
	
for i = 55555500 to 55555599 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)
	
for i = 66666600 to 66666699 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)
	
for i = 77777700 to 77777799 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)
	
for i = 88888800 to 88888899 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)	
	
for i = 99999900 to 99999999 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)
	
print presetsFrame
)
--getAppData rootnode 1