(
clearlistener()

-- environment
atmo = #()
atmos = #()
atmospherics = #()
fx = #()
fxS = #()
effects = #()
environment = #()
envSet = #(  backgroundColor, useEnvironmentMap, lightTintColor, lightLevel, ambientColor, if environmentMap != undefined then ( classof environmentMap ) else undefined, if environmentMap != undefined do environmentMap.name )

-- get exposure
expo = SceneExposureControl.exposureControl
if expo != undefined do (
	exposS = #()
	exposure = #()
	
	join exposure #( classof expo )
	
	expS = GetPropNames expo
	for exS in expS do (
		exSprop = getproperty expo exS
		print exS
		print exSprop
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
append environment envAndFx
for p in environment do print p
)