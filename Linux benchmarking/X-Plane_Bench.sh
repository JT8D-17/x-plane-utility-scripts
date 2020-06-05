#! /bin/bash
#
# X-Plane Benchmark - Automated script by BK
#
# README: https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/Linux%20benchmarking/Readme.md
#
# LICENSED UNDER EUPL v1.2: https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md
#
# Configuration

Outputfile="$PWD/Z_Bench_Result_DB".txt
Logfile="$PWD/Log.txt"
Replayfile=Output/replays/test_flight_c4.fdr

# SCRIPT
function runbench {

echo ----------------------------------------------------------------------------- >> $Outputfile

if [ "$2" = "opengl" ]; then
    echo Command line options: --$2 --fps_test=$1 --load_smo=$Replayfile >> $Outputfile
    "$PWD/X-Plane-x86_64" --$2 --fps_test=$1 --load_smo=$Replayfile
else
    if [ "$3" = "aco" ]; then
        echo Command line options: --$2 --fps_test=$1 --load_smo=$Replayfile >> $Outputfile
        export RADV_PERFTEST=aco 
        "$PWD/X-Plane-x86_64" --$2 --fps_test=$1 --load_smo=$Replayfile
    else
        echo Command line options: --$2 --fps_test=$1 --load_smo=$Replayfile >> $Outputfile
        export RADV_PERFTEST=llvm
        "$PWD/X-Plane-x86_64" --$2 --fps_test=$1 --load_smo=$Replayfile
    fi
fi

grep "Vulkan Device" $Logfile >> $Outputfile
grep "OpenGL Render" $Logfile >> $Outputfile
grep "Vulkan Version" $Logfile >> $Outputfile
grep "OpenGL Version" $Logfile >> $Outputfile
grep "Vulkan Driver" $Logfile >> $Outputfile
grep "FRAMERATE TEST:" $Logfile >> $Outputfile
grep "GPU LOAD:" $Logfile >> $Outputfile
}

function addheader {
    echo ----------------------------------------------------------------------------- >> $Outputfile
    echo SESSION START: $(date "+%d/%m/%Y, %H:%M:%S h") >> $Outputfile
}

function extracthw {
    echo ----------------------------------------------------------------------------- >> $Outputfile
    echo X-Plane version : $(grep "log.txt for" $Logfile | awk '{print $4,$5,$6,$7}') >> $Outputfile
    echo CPU : $(grep -m 1 -o 'model name.*' $Logfile | sed 's/model name\s: //g') \($(grep -m 1 -o 'cpu MHz.*' $Logfile | sed 's/cpu MHz\s\t: //g'
) MHz\) >> $Outputfile
    echo RAM / VRAM : $(grep -o 'MemTotal.*' $Logfile | sed 's/MemTotal://g' | sed 's/^ *//g') \/ $(grep -o 'Device memory.*' $Logfile | sed 's/Device memory\s\s\s\s\s\s\s:\s//g') kB >> $Outputfile
    echo Screen resolution\(s\) : $(xrandr | grep -w connected  | awk -F'[ +]' '{print $3,$4}') >> $Outputfile
    echo Linux kernel / Display server : $(uname -r) \/ $(loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type --value) >> $Outputfile
    echo ----------------------------------------------------------------------------- >> $Outputfile
    echo SESSION END >> $Outputfile
}

addheader
runbench 5 opengl
runbench 5 vulkan
runbench 5 vulkan aco
runbench 54 opengl
runbench 54 vulkan
runbench 54 vulkan aco
runbench 55 opengl
runbench 55 vulkan
runbench 55 vulkan aco
extracthw
