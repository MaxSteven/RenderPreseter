(
clearlistener()
re = maxOps.GetCurRenderElementMgr()
--renderers.current
rElement = #()
rElements = #()
	
for i = 0 to re.numrenderelements() do (
	if (classof (re.GetRenderElement i)) != UndefinedClass do (
	--	show ( (re.GetRenderElement i))
	--	if (classof (re.GetRenderElement i)) == mr_Shader_Element do show (re.GetRenderElement i)
		propNames = getPropNames (re.GetRenderElement i)

		join rElements #( rElement = #( ( classof ( re.GetRenderElement i ) ) ) )

		for p = 1 to propNames.count do (
			property = getProperty (re.GetRenderElement i) propNames[p]
			join rElement #( ( property ) )
			join rElements #( rElement )
			)
		)
	)
print rElements
)	

--re.AddRenderElement ( rElements[1][1] elementName:rElements[1][2] )
