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
# Configuration

Outputfile="$PWD/Z_Bench_Result_DB".txt
Logfile="$PWD/Log.txt"
Replayfile=Output/replays/test_flight_737.fps
FullscreenRes=1920x1080

# SCRIPT
function runbench {

echo ----------------------------------------------------------------------------- >> "$Outputfile"

if [ "$2" = "opengl" ]; then
    if [ "$3" = "glthread" ]; then
        echo "OpenGL: AMD Mesa_glthread = true" >> "$Outputfile"
        echo Command line options: --"$2" --fps_test="$1" --load_smo=$Replayfile >> "$Outputfile"
        export mesa_glthread=true 
        "$PWD/X-Plane-x86_64" --"$2" --fps_test="$1" --load_smo=$Replayfile
    else
        echo "OpenGL: NVidia or AMD Mesa_glthread = false" >> "$Outputfile"
        echo Command line options: --"$2" --fps_test="$1" --load_smo=$Replayfile >> "$Outputfile"
        export mesa_glthread=false 
        "$PWD/X-Plane-x86_64" --"$2" --fps_test="$1" --load_smo=$Replayfile
    fi
else
    if [ "$3" = "llvm" ]; then
        echo "Vulkan: AMD Mesa (LLVM compiler)" >> "$Outputfile"
        echo Command line options: --"$2" --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1 >> "$Outputfile"
        #export RADV_PERFTEST=llvm #Before Mesa 20.2
        export RADV_DEBUG=llvm #Since Mesa 20.2
        "$PWD/X-Plane-x86_64" --"$2" --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    elif [ "$3" = "amdvlk" ]; then
        echo "Vulkan: AMDVLK" >> "$Outputfile"
        echo Command line options: --"$2" --force_run --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1 >> "$Outputfile"
        VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_icd64.json "$PWD/X-Plane-x86_64" --"$2" --force_run --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    else
        echo "Vulkan: NVidia or AMD Mesa (ACO compiler)" >> "$Outputfile"
        echo Command line options: --"$2" --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1 >> "$Outputfile"
        #export RADV_PERFTEST=aco #Not needed since Mesa 20.2
        "$PWD/X-Plane-x86_64" --"$2" --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    fi
fi

grep "Vulkan Device" "$Logfile" >> "$Outputfile"
grep "OpenGL Render" "$Logfile" >> "$Outputfile"
grep "Vulkan Version" "$Logfile" >> "$Outputfile"
grep "OpenGL Version" "$Logfile" >> "$Outputfile"
grep "Vulkan Driver" "$Logfile" >> "$Outputfile"
grep "FRAMERATE TEST:" "$Logfile" >> "$Outputfile"
grep "GPU LOAD:" "$Logfile" >> "$Outputfile"
}

function addheader {
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo SESSION START: "$(date "+%d/%m/%Y, %H:%M:%S h")" >> "$Outputfile"
}

function extracthw {
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo X-Plane version : "$(grep "log.txt for" "$Logfile" | awk '{print $4,$5,$6,$7}')" >> "$Outputfile"
    echo CPU : "$(grep -m 1 -o 'model name.*' "$Logfile" | sed 's/model name\s: //g')" \("$(grep -m 1 -o 'cpu MHz.*' "$Logfile" | sed 's/cpu MHz\s\t: //g')" MHz\) >> "$Outputfile"
    echo RAM / VRAM : "$(grep -o 'MemTotal.*' "$Logfile" | sed 's/MemTotal://g' | sed 's/^ *//g')" / "$(grep -o 'Device memory.*' "$Logfile" | sed 's/Device memory\s\s\s\s\s\s\s:\s//g')" kB >> "$Outputfile"
    echo Screen resolution\(s\) : "$(xrandr | grep -w connected  | awk -F'[ +]' '{print $3,$4}')" >> "$Outputfile"
    echo Linux kernel / Display server : "$(uname -r)" / "$(loginctl show-session "$(loginctl | grep "$(whoami)" | awk '{print $1}')" -p Type --value)" >> "$Outputfile"
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo SESSION END >> "$Outputfile"
}

# Script Execution
# Parameters for OpenGL: runbench [3/4/5/54/55] opengl [glthread]
# Parameters for Vulkan: runbench [3/4/5/54/55] vulkan [llvm/amdvlk]
addheader
#runbench 55 opengl          # NVidia and AMD
# runbench 55 opengl glthread # AMD with Mesa ONLY
runbench 1 vulkan          # NVidia and AMD
#runbench 2 vulkan          # NVidia and AMD
runbench 3 vulkan          # NVidia and AMD
#runbench 4 vulkan          # NVidia and AMD
runbench 5 vulkan          # NVidia and AMD
runbench 41 vulkan          # NVidia and AMD
runbench 43 vulkan          # NVidia and AMD
runbench 45 vulkan          # NVidia and AMD
#runbench 54 vulkan          # NVidia and AMD
#runbench 55 vulkan          # NVidia and AMD
#runbench 55 vulkan llvm     # AMD with Mesa ONLY
#runbench 55 vulkan amdvlk   # AMD with AMDVLK ONLY
extracthw
