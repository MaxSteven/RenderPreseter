(
clearlistener()
presetsFrame = #()
	
for i = 66666601 to 66666699 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)
	
for i = 77777701 to 77777799 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)
	
for i = 88888801 to 88888899 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)	
	
for i = 99999901 to 99999999 do (
	if getAppData rootnode i != undefined do (
		deleteAppData rootnode i
		)
	)
	
print presetsFrame
)
--getAppData rootnode 1