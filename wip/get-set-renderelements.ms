(
clearlistener()
rM = maxOps.GetCurRenderElementMgr()

element = #()
rElement = #()
rElementN = #()
rElementS = #()
rElementA = #()
	
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
	
	for p in propNames where p != #bitmap do (
		join rElementS #( rElementN = #( p , getProperty rElement[r][1] p ) )
		)
	
	append rElementA rElementS
	)
print rElementA
--rM.AddRenderElement ( ( classof rElementA[1][1][1] ) elementName:(rElementA[1][7][2] as name) )
setproperty rElementA[1][1][1] #shadowOn false

)
			

