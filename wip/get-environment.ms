(
clearlistener()
envSet = #( backgroundColor, environmentMap, useEnvironmentMap, lightTintColor, lightLevel, ambientColor )
				
		atmo = #()
		atmos = #()
		atmospherics = #()
		fx = #()
		fxS = #()
		effects = #()
		ev = #()
		-- get exposure
		expo = SceneExposureControl.exposureControl
		if expo != undefined do (
			expos = #()
			exposS = #()
			exposure = #()
			
			join expos #( classof expo )
			
			expS = GetPropNames expo
			for exS in expS do (
				exSprop = getproperty expo exS
				
				if superclassof exSprop != RenderElement do (
					join exposure #( exposS = #( exS, exSprop ) )
					)
				)
			)

		-- get atmospherics
		for a = 1 to numAtmospherics do (
			join atmo #( getAtmospheric a )	
			)

		for t = 1 to atmo.count do (
			atmos = #()
			join atmos #( classof atmo[t], isActive ( getAtmospheric t ) )
			append atmospherics atmos
			)

		-- get effects
		for b in 1 to numeffects do (
			join fx #( getEffect b )
			)
			
		for x in 1 to fx.count do (
			fxS = #()
			join fxS #( classof fx[x], isActive ( getEffect x ) )
			append effects fxS
			)
			
		-- merge environment and effects
		envAndFx = #( envSet, exposure, atmospherics, effects )
		append ev envAndFx
		for p in ev do print p
)