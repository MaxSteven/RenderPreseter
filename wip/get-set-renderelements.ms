clearlistener()
re = maxOps.GetCurRenderElementMgr()
--renderers.current
rElement = #()
rElements = #()
print (re.numrenderelements())
for i = 0 to re.numrenderelements() do (
	if (classof (re.GetRenderElement i)) != UndefinedClass do (
		print (classof (re.GetRenderElement i))
	--	if (classof (re.GetRenderElement i)) == mr_Shader_Element do show (re.GetRenderElement i)
		join rElements #( rElement = #( (classof (re.GetRenderElement i)), (re.GetRenderElement i).elementName, re.GetElementsActive(), (re.GetRenderElement i).filterOn, re.GetDisplayElements(), re.GetRenderElementFilename i ) )
		)
	)
print rElements
	
if renderSceneDialog.isOpen() then rendDiag = "open" else rendDiag = "closed"
if rendDiag == "open" do renderSceneDialog.close()
re.AddRenderElement ( rElements[1][1] elementName:rElements[1][2] )
	
if rendDiag == "open" do (
	renderSceneDialog.commit()
	renderSceneDialog.open()
	)