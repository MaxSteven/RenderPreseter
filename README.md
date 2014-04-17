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

Features:
--------

 - save all settings from the common render window
 - save renderer and all render settings, also material override*, lens shader* etc.
 - save render elements
 - save environment 
 - save exposure settings
 - save atmospherics*
 - save effects*
 - save all settings to the scene, after close and loading the scene all settings getting back
 
 
* Limitations:
 - Materials, maps and shader can only be restored when they are in the scene. For example in the material editor or applied to an object.
 - Atmospherics only save the name and the active or de-active state. Don't delete the atmosphere if you need it later, only de-activate it.
 - With the effects is the same like the Atmospherics.


For using it, go in 3Ds Max under MaxScript: Run Script... and select the script file. 
Drag and drop the script in the screen, or us the .mcr script for a button (category jb_scripts).



