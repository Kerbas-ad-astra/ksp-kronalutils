# Kronal Vessel Viewer

*For capturing orthographic and offset views of spacecraft in KSP.*

## Features

Kronal Vessel Viewer adds a "KVV" button to the editor.  Click it to open up a window that shows a 'head-to-toe' view of your craft.

You can rotate and move the view of the spacecraft, set the image quality, take a screenshot, and most importantly, put the spacecraft into an "offset" (or "exploded") view, just like in the cutaway books.  Click the "Revert" button or close the KVV window to put the spacecraft back together again (and to re-enable editor functionality).

Screenshots are saved in the KSP screenshots directory (not with Steam's screenshots). Here's what they look like:

![Offset view of stock "GDLV Launch Vehicle" at minimum quality](https://raw.githubusercontent.com/Kerbas-ad-astra/KronalVesselViewer/master/front_GDLV3_1.png)

And then you can open it in your favorite image editor to turn it into a nice blueprint.  For an example of how to do this, see [**this tutorial by Aetol.**](https://imgur.com/a/jvgzyz4)

## Dependencies

- [**Click Through Blocker**](https://forum.kerbalspaceprogram.com/index.php?/topic/170747-141-click-through-blocker/)
- [**ToolbarController**](https://forum.kerbalspaceprogram.com/index.php?/topic/170747-18x-click-through-blocker/)

## Download and install

- [**GitHub**](https://github.com/Kerbas-ad-astra/KronalVesselViewer/releases)

From there, just unzip the "KronalVesselViewer" folder into your GameData directory.

Please let me know in [**the forum thread**](http://forum.kerbalspaceprogram.com/threads/XXXX) or on [**the GitHub issue tracker**](https://github.com/Kerbas-ad-astra/KronalVesselViewer/issues) if you find any issues!

## Version history and changelog

- 0.0.0a (02014 Apr 06)
	- Final release by Kronal for KSP 0.23.0
- 0.0.1 "El Padina" (02014 Sep 18)
	- Adopted by bigorangemachine, updated for KSP 0.24.2
	- Added control panel
- 0.0.2 "Dat-U-Eye" (02014 Sep 25)
	- Change Config Defaults
	- Changed button layouts and preview
	- Git deckblad added support for KAS Parts
- 0.0.3 "mrBlaQ" (02014 Sep 27)
	- GUI Window Click trap implmented. (Thanks Git M4V for directing me here)
	- Git deckblad (KSP forums mrBlaQ) resolved:
		- Fixed white lines issue by restricting image size to 4096px (max any dimension)
		- Made all renders Jump Up to 4096px. This creates higher quality renders with smaller craft.
	- Nils Daumann (Git Slin) was kind enough to change the license on the fxaa shader.
- 0.0.4 "Pitch Perfect" (02014 Oct 03)
	- Background colour sliders (white is no longer the only background colour render option) located under 'Blue Print'
	- Blue Print Shader is now disabled by default
		- 'Blue Print shader' was causing the issue with the white rendering lines and off colouring in the bottom left corner
		- Background colour controls are now available under 'Blue Print' which will eventually become 'Background' or 'Canvas'
	- UI Adjustments
		- Shadow Control Dial (experimental)
		- Bigger buttons
		- Moved Orthographic Button
		- Changed 'Exploded' references to 'Offset'
		- Image quality can now be controlled with a dial
	- Git deckblad (KSP forums mrBlaQ) resolved:
		- Shadow Rendering Control
		- Adjusted Camera Positioning
		- Improved Camera Controls
		- Part Option for Clamps
		- Procedural fairings bug fixes
			- Existing bug still exists where you must select minimum 4 fairings to hide 'Front Half'
		- Edge Detect shader adjustment
- *Various fixes and patches for KSP versions through 1.1 (through late 02016)*
- 0.0.6 (02016 Nov 26)
	- Adopted by linuxgurugamer
	- Fixed null ref when going into flight
	- Added support for stock fairings exploding and opacity (some dirty Reflection code)
	- Added .version file
	- Added version info into Assembly info
	- Converted numeric inputs into sliders on config screens
	- Converted shaders into bundle files
	- Added bundle files for all environments (Window, Windows OpenGL, OSX and Linux)
	- Removed engine fairing explode option
- 0.0.7 (02017 May 30)
	- Updated for KSP 1.3
- 0.0.9 (02018 Apr 22)
	- Updated for KSP 1.4.1
	- Added support for the ClickthroughBlocker
	- Added support for the ToolbarController
	- Renamed release directory to KronalVesselViewer
- *Various 0.0.9.x patches to update paths, reduce logspam, and add/fix shaders (02019 Jan 09)*
- 0.0.10 (02019 Jul 27)
	- Compiled for KSP 1.7.x.
	- Added InstallChecker
	- Updated AssemblyVersion.tt
- 0.1.0 "Throwing Shade" (02020 Jan 12)
	- Adopted by Kerbas-ad-astra
	- Fixed offsetting non-staged decouplers, and also offsetting Making History KV pods in a weird direction.
	- Added support for localization
	- Part shader bundles updated for KSP 1.8.1
	- Color adjust and FXAA shaders disabled
	- KAS mod support updated to post-1.0 (non-legacy) parts and modules
	- Procedural Fairings mod support disabled pending update for KSP 1.8.

## Roadmap

If anyone figures out how to make the post-processing shaders work again, I'll take a pull request, but otherwise I think it's just as well to leave those features out and do post-processing with your favorite image editor.

It would be nice to have some way to snap the point of view to right angles, or be able to set the view angle directly.

## Credits

This mod was originally written by Kronal, and then variously maintained by BigOrangeMachine, linuxgurugamer, and myself.

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software, either in source code form or as a compiled binary, for any purpose, commercial or non-commercial, and by any means.

In jurisdictions that recognize copyright laws, the author or authors of this software dedicate any and all copyright interest in the software to the public domain. We make this dedication for the benefit of the public at large and to the detriment of our heirs and successors. We intend this dedication to be an overt act of relinquishment in perpetuity of all present and future rights to this software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
