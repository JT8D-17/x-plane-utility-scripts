# X-Plane 11/12 Installation Scripts for Linux

These are handy scripts that will automate a good portion of X-Plane 11/12's installation. When run from a "client" folder intended for an X-Plane installation (the one that contains the binaries), it will set up a base folder containing shared elements parallel to it. After that, it will create symbolic links to the shared elements in the base folder. The installer also offers various methods to deal with custom scenery folders.

I use this to create several different X-Plane 11/12 installations with a minimum of file duplication.

**THESE SCRIPTS ARE TO BE CONSIDERED EXPERIMENTAL AND WERE PRIMARILY TAILORED TO MY PERSONAL REQUIREMENTS. USE AT YOUR OWN RISK**  

&nbsp;

## Notes

- **Pick either the X-Plane 11 or 12 version of the script**
- Run this from a folder that you want to have X-Plane's binaries in
- The path to the resources folder is parallel to the X-Plane installation (binaries) folder
- There will be separate folders for add-on aircraft, add-on sceneries and add-on orthos. Use these to store your third party aircraft, sceneries and othos respectively.
- The control profile folder is always located in the resources folder
- *Base_data* contains all items from a default X-Plane installation
- At the end of the installation, *~/.x-plane/x-plane_install_11.txt* or *~/.x-plane/x-plane_install_12.txt* will be automatically appended with the path to the folder containign the X-Plane binaries
- The "output" (except the control profile folder) and "plugins" folders remain local to the folder(s) containing the X-Plane binaries, i.e. no support for shared plugins or settings
- Run the script first to create all the base folders, then run the installer
- Initial management of the "Custom Scenery" folder may have to be done manually. Let the installer download the files to the folder with X-Plane's binaries first, then manually move the "Custom Scenery" folder into the *X-Plane_Resources/Base_Data/* folder. After that, run the script again and implement the desired type of add-on scenery linking
- I've tried to make this relatively fail-safe, but it's best to test all the features in a controlled environment before installing a production-grade X-Plane

&nbsp;

## License

[EUPL v1.2](https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md)