(
clearlistener()
atmo = #()
atmos = #()
atmosA = #()
atmosS = #()
for a = 1 to numAtmospherics do (
	join atmo #( getAtmospheric a )	
	)

for t = 1 to atmo.count do (
	atmos = #()
	atS = GetPropNames ( getAtmospheric t )
	
	join atmos #( classof atmo[t] )

	for atV in atS do (
		atmprop = getproperty atmo[t] atV
		if superclassof atmprop == textureMap then (
			join atmos #( atmosS = #( atV, classof atmprop, atmprop.name ) )
			) else if superclassof atmprop == helper OR superclassof atmprop == light then (
				join atmos #( atmosS = #( atV, classof atmprop, atmprop.name ) )
			) else if classof atmprop != ArrayParameter then (
				join atmos #( atmosS = #( atV, atmprop ) )
				)
		)

	append atmosA atmos
	)	
for a in atmosA do print a
)