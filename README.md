---
title: RenderPreseter

description: MaxScript for set render presets

author: Jonathan Baecker (jb_alvarado)

created:  2014-04-04

modified: 2014-04-17

---

RenderPreseter
=========


![Render Preseter](http://www.pixelcrusher.de/files/RenderPreseter.png "RenderPreseter")


![Render Preseter Dock](http://www.pixelcrusher.de/files/RenderPreseter_dock.png "RenderPreseterDock")


Download
--------

### [Click here to download latest version](https://github.com/jb-alvarado/RenderPreseter/archive/master.zip)

Current release is **v0.6**

For using it, go in 3Ds Max under MaxScript: Run Script... and select the script file. 
Drag and drop the script in the screen, or us the .mcr script for a button (category jb_scripts).


Features:
--------

 - save all settings from the common render window
 - save renderer and all render setting, also material override*, lens shader* etc.
 - save render elements
 - save environment 
 - save exposure settings
 - save atmospherics*
 - save effect*
 
 - save all settings to the scene, after close and loading the scene all settings getting back
 
 
Limitations:
 - Materials, maps and shader can only be restored when they are in the scene. For example in the material editor or applied to an object.
 - Atmospherics only save the name and the active or de-active state. Don't delete the atmosphere if you need it later, only de-activate it.
 - Same like the Atmospherics


