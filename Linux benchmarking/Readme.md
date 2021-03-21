# X-Plane 11.50+ Benchmarking Script for Linux

This is a handy script that will automate X-Plane benchmark runs on Linux. It will run a standard X-Plane scenario (SMO file) with a certain rendering configuration (numerical code; see below) in either OpenGL or Vulkan mode with either LLVM or ACO as a shader compiler (ACO is only available on Mesa drivers). Multiple, sequential benchmark runs can be specified.

Test results are logged in an output file, which is appended and therefor has to be manually maintained. New sessions are timestamped.

&nbsp;

## Requirements

- X-Plane 11.50+ (preferably vanilla without any plugins)
- Bash, grep, sed, uname (should be default in any distro)
- Xrandr (for reporting display resolutions)
- Loginctl (determining window manager)

&nbsp;

## Installation and Configuration

The script uses relative paths, so it must be located in X-Plane's root folder.

Adjusting the amount of benchmarking function calls with their appropriate parameters isd the only configuration that is necessary. These calls are located at the end of the script between the *addheader* and *extracthw* calls and determine the amount of tests that are to be run per session.

A function call loooks like this:

*runbench [test] [API] [Vulkan mode]*

- *runbench*: Calls the function
- *test*: Common tests are 3,4,5,54 and 55. Recommended are tests 5 and 55, or only 55, as these are the most demanding.
- *API*: Should be "opengl" (any X-Plane 11 version) or "vulkan" (X-Plane 11.50+), without quotes.
- *Vulkan mode*: If you want to use the ACO compiler, use "aco", otherwise the standard llvm compiler is used.

Sequential benchmark runs can be set up by simply calling the function multiple times with the appropiate parameters (such as in the example configuration).

&nbsp;

## Usage

1. Configure the script (see above)
2. Run the script from the X-Plane root folder
3. Wait

&nbsp;

## Benchmarking results

Each time the script is started, *Z_Bench_Result_DB.txt* is created or appended, no matter whether a benchmark run was conducted or not.
This file contains the following information:

- At the start of the session:
	- A session header, including a timestamp (useful for adding a short note about your system configuration later on)
- For each benchmark run:
	- The command line options passed to the X-Plane binary
	- Information about the device and driver versions used, extracted from X-Plane's log file
	- FPS test results, as extracted from X-Plane's log file
* At the end of the session:
	- X-Plane version and build number (from Log.txt)
	- CPU model and reported frequency (from Log.txt)
	- System / Video RAM (from Log.txt)
	- Screen resolution (from XRandr)
	- Kernel name (from uname) / Displaymanager (from loginctl)

&nbsp;

## Drawbacks

This script tries to grab as much information as it can from Linux and the Log.txt, but consistency and completeness is not guaranteed. Especially the display resolutions will require manual cleaning or clarification if X-Plane is run in a multi-monitor environment.

When posting benchmarking results, any other useful info that could have influence on performance should be stated.

**X-Plane's benchmark appears to be mostly CPU-limited (at higher cettings), so you will not see much, if any difference from testing different GPUs!**

&nbsp;

## References

[https://www.x-plane.com/kb/frame-rate-test/](https://www.x-plane.com/kb/frame-rate-test/) 

&nbsp;

## License

[EUPL v1.2](https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md)