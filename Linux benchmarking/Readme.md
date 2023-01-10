# X-Plane 11.50+/12 Benchmarking Script for Linux

Either of these scripts will automate X-Plane benchmark runs on Linux. It will run a standard X-Plane scenario (SMO file) with a certain rendering configuration (numerical code; see below) in either OpenGL or Vulkan mode (XP11 only; XP12 is exclusively using Vulkan) with either LLVM or ACO as a shader compiler (ACO is only available on Mesa drivers). Multiple, sequential benchmark runs can be specified.

Test results are logged in an output file, which is appended and therefore has to be manually maintained. New sessions are timestamped.

&nbsp;

## Requirements

- X-Plane 11.50+/12 (preferably vanilla without any plugins)
- Bash, awk, grep, sed, uname (should be available in any distro)
- Xrandr (for reporting display resolutions)
- Loginctl (determining window manager)

&nbsp;

## Installation and Configuration

Either script uses relative paths, so it must be located in X-Plane's root folder.

The sripts differ in functionality. The X-Plane 11 script is configured by inserting benchmarking function calls with their appropriate parameters. 
These calls are located at the end of the script between the *addheader* and *extracthw* calls and determine the amount of tests that are to be run per session.
The X-Plane 12 script is configured by changing variables in the configuration section of the script.

&nbsp;

### X-Plane11_Bench.sh script function call

*runbench [test] [API] [Mode]*

- *runbench*: Calls the function
- *test*: Define the test codes that the script should perform.
Common codes are 3,4,5,54 and 55. Recommended are tests 5 and 55, or only 55, as these are the most demanding.
- *API*: Select the graphics API to be used for the benchmark.   
Should be "opengl" (any X-Plane 11 version) or "vulkan" (X-Plane 11.50+) (without quotes).
- *Mode*: Switch between driver modes, shader compilers or drivers.   
"glthread" forces Mesa's GLThread mode on, otherwise it'll be off. **OpenGL only!**   
"llvm" forces usage of the LLVM compiler (otherwise uses the default aco compiler). **Vulkan mode and Mesa drivers only!**   
"amdvlk" forces usage of the AMDVLK Vulkan driver. **Vulkan mode only!**

&nbsp;

Sequential benchmark runs can be set up by simply calling the function multiple times with the appropiate parameters (such as in the example configuration).

&nbsp;

### X-Plane12_Bench.sh configuration

#### Required settings

- *FullscreenRes*: Sets the screen resolution to run the benchmark with.
- *benchmarks*: Define the test codes that the script should perform. Set to a string or string array (separate with whitespace).

#### Optional settings
- *rendererOption* Switch between drivers and shader compilers. X-Plane 12 forces the vulkan API.
"llvm" forces usage of the LLVM compiler (otherwise uses the default aco compiler). **Mesa drivers only**   
"amdvlk" forces usage of the AMDVLK Vulkan driver. **This driver is not officially supported by X-Plane 12**
- *repeatBench* and *repeatCount* specify, if and how often you want to repeat each benchmark run in *benchmarks*
- *write_csv* set to true, if you also want to output the most relevant data to a .csv file, allowing more comfortable evalutation with tools like Python or LibreOffice.

&nbsp;

## Usage

1. Pick a script suitable for XP11 or XP12
2. Configure the script (see above)
3. Run the script from the X-Plane root folder
4. Wait

&nbsp;

## Benchmarking results

Each time the script is started, *Z_Bench_Result_DB.txt* is created or appended, no matter whether a benchmark run was conducted or not.
This file contains the following information:

- At the start of the session:
	- A session header, including a timestamp (useful for adding a short note about your system configuration later on)
	- Driver mode used in that session (X-Plane 12) This assumes that you would only change your driver config in between sessions.
- For each benchmark run:
	- The command line options passed to the X-Plane binary
	- Information about the device and driver versions used, extracted from X-Plane's log file (X-Plane 11)
	- FPS test results, as extracted from X-Plane's log file
* At the end of the session:
	- X-Plane version and build number (from Log.txt)
	- CPU model and reported frequency (from Log.txt)
	- Information about the device and driver versions used, extracted from X-Plane's log file (X-Plane 12)
	- System / Video RAM (from Log.txt)
	- Screen resolution (from XRandr)
	- Kernel name (from uname) / Displaymanager (from loginctl)

&nbsp;

## Drawbacks

This script tries to grab as much information as it can from Linux and the Log.txt, but consistency and completeness is not guaranteed. Especially the display resolutions will require manual cleaning or clarification if X-Plane is run in a multi-monitor environment.

When posting benchmarking results, any other useful info that could have influence on performance should be stated.

**X-Plane's benchmark appears to be mostly CPU-limited (at higher settings), so you will not see much, if any difference from testing different GPUs!**

&nbsp;

## References

[https://www.x-plane.com/kb/frame-rate-test/](https://www.x-plane.com/kb/frame-rate-test/) 

&nbsp;

## License

[EUPL v1.2](https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md)
