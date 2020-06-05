# X-Plane 11.50+ Installation Script for Linux

This is a handy script that will automate X-Plane installation. When run from a "client" folder intended for an X-Plane installation, it will set up a base folder containing shared elements parallel to it. After that, it will create symbolic links to the shared elements in the base folder. The installer also offers various methods to deal with custom scenery folders.

I use this to create several different X-Plane installations with a minimum of file duplication.

**THIS SCRIPT IS TO BE CONSIDERED VERY EXPERIMENTAL AND WAS ONLY TAILORED TO MY PERSONAL NEEDS. USE AT YOUR OWN RISK**  

--

## Notes

- The base folder installation path is fixed **and has to be adapted to your partition path** (*parent_folder* variable in the script)
- The control profile folder is always located in the base folder
- When no X-Plane installation folder path information is present yet, you have to run Laminar's X-Plane installer once and set everything up
- The "output" (except the control profile folder) and "plugins" folders remain local to the client folders, i.e. no shared plugins or settings
- Test this in a safe envioronment first

--

## License

[EUPL v1.2](https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md)