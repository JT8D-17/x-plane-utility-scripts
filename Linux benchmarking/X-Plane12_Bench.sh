#! /bin/bash
#
# X-Plane Benchmark - Automated script by BK
#
# README: https://github.com/JT8D-17/x-plane-utility-scripts/Benchmarking/readme.md
#
# LICENSED UNDER EUPL v1.2: https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md
#
#
# Execution and parameters: See bottom of file
#
#
# Configuration and Parameters

Outputfile="$PWD/Z_Bench_Result_DB".txt
Logfile="$PWD/Log.txt"
Replayfile=Output/replays/test_flight_737.fps
FullscreenRes=1920x1080
benchmarks="41 43 45"
rendererOption="" #[llvm,amdvlk]

# repeat runs for statistical integrity
repeatBench=false
repeatCount=3 #run each benchmark x times



# SCRIPT
function runbench {

    if [ "$3" = "llvm" ]; then
        #export RADV_PERFTEST=llvm #Before Mesa 20.2
        export RADV_DEBUG=llvm #Since Mesa 20.2
        "$PWD/X-Plane-x86_64" --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    elif [ "$3" = "amdvlk" ]; then
        #not officially supported by LR; forcing execution
        VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_icd64.json "$PWD/X-Plane-x86_64" --force_run --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    else
        #export RADV_PERFTEST=aco #Not needed since Mesa 20.2
        "$PWD/X-Plane-x86_64" --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    fi

}

function addheader {
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo SESSION START: "$(date "+%d/%m/%Y, %H:%M:%S h")" >> "$Outputfile"
}

function writeparams {
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo Bench: "$1" Samples: "$repeatCount" >> "$Outputfile"
    echo Command line options: --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1 >> "$Outputfile"
    if [ "$2" = "llvm" ]; then
        echo "Vulkan Driver: AMD Mesa (LLVM compiler)" >> "$Outputfile"
    elif [ "$2" = "amdvlk" ]; then
        echo "Vulkan Driver: AMDVLK" >> "$Outputfile"
    else
        echo "Vulkan Driver: NVidia or AMD Mesa (ACO compiler)" >> "$Outputfile"
    fi
}

function writeresults {
    grep "FRAMERATE TEST:\|GPU LOAD:" "$Logfile" | grep -E -o "[a-zA-Z]+=[0-9]*(\.[0-9]+)?" | paste -sd' ' - | awk '{print $1,$2,$5,$6,$3}' >> "$Outputfile"
}

function extracthw {
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo X-Plane version : "$(grep "log.txt for" "$Logfile" | awk '{print $4,$5,$6,$7}')" >> "$Outputfile"
    echo CPU : "$(grep -m 1 -o 'model name.*' "$Logfile" | sed 's/model name\s: //g')" \("$(grep -m 1 -o 'cpu MHz.*' "$Logfile" | sed 's/cpu MHz\s\t: //g')" MHz\) >> "$Outputfile"
    grep "Vulkan Device" "$Logfile" >> "$Outputfile"
    grep "OpenGL Render" "$Logfile" >> "$Outputfile"
    grep "Vulkan Version" "$Logfile" >> "$Outputfile"
    grep "OpenGL Version" "$Logfile" >> "$Outputfile"
    grep "Vulkan Driver" "$Logfile" >> "$Outputfile"
    echo RAM / VRAM : "$(grep -o 'MemTotal.*' "$Logfile" | sed 's/MemTotal://g' | sed 's/^ *//g')" / "$(grep -o 'Device memory.*' "$Logfile" | sed 's/Device memory\s\s\s\s\s\s\s:\s//g')" kB >> "$Outputfile"
    echo Screen resolution\(s\) : "$(xrandr | grep -w connected  | awk -F'[ +]' '{print $3,$4}')" >> "$Outputfile"
    echo Linux kernel / Display server : "$(uname -r)" / "$(loginctl show-session "$(loginctl | grep "$(whoami)" | awk '{print $1}')" -p Type --value)" >> "$Outputfile"
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo SESSION END: "$(date "+%d/%m/%Y, %H:%M:%S h")" >> "$Outputfile"
}

# Script Execution
# Parameters for Vulkan: runbench [3/4/5/54/55] vulkan [llvm/amdvlk]

addheader

if [ "$repeatBench"="true" ]; then
    for n in $benchmarks; do
        writeparams "$n" "$rendererOption"
        i=1; while [ $i -le $repeatCount ]; do
            runbench "$n" "$rendererOption"
            writeresults
            ((i++))
        done
    done
else
    for n in $benchmarks; do
        writeparams "$n" "$rendererOption"
        runbench "$n" "$rendererOption"
        writeresults
    done
fi

extracthw
