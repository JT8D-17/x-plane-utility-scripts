#! /bin/bash
#
# X-Plane Benchmark - Automated script by BK, extended by jonaseberle and hdrie
# X-Plane 12 only! (vulkan renderer)
#
# README: https://github.com/JT8D-17/x-plane-utility-scripts/Benchmarking/readme.md
#
# LICENSED UNDER EUPL v1.2: https://github.com/JT8D-17/x-plane-utility-scripts/blob/master/license.md
#
#
# Execution: See bottom of file
#
#
#--------------------------------------------------------------
# CONFIGURATION / PARAMETERS
Outputfile="$PWD/Z_Bench_Result_DB".txt
Logfile="$PWD/Log.txt"
Replayfile=Output/replays/test_flight_737.fps
# Set desired screen resolution (MANDATORY):
FullscreenRes=1920x1080
# One or more (separate with whitespace) benchmark code(s) to run (MANDATORY), refer to https://www.x-plane.com/kb/frame-rate-test/ for supported values
benchmarks="1 3 5 41 43 45"

# Optional, AMD ONLY: change vulkan driver
# "llvm" uses the LLVM compiler instead of ACO
# "amdvlk" uses AMD's open source Vulkan driver instead of Mesa's RADV
# PICK ONE (default/fallback: "" = RADV + ACO)
rendererOption="" 

# Optional: Repeat runs for statistical integrity:
repeatBench=false # toggle [true|false]
repeatCount=3 # run each benchmark x times

# Optional: Write to .csv
write_csv=false # toggle [true|false]
CSVoutputfile="$PWD/ZZ_Bench_Result_DB".csv


#--------------------------------------------------------------
# FUNCTION DEFINITIONS

function runbench {
# Call as follows: runbench [*test-code*] ["llvm"|"amdvlk"|*other/none*]

    if [ "$rendererOption" = "llvm" ]; then
        # export RADV_PERFTEST=llvm #Before Mesa 20.2
        export RADV_DEBUG=llvm #Since Mesa 20.2
        "$PWD/X-Plane-x86_64" --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    elif [ "$rendererOption" = "amdvlk" ]; then
        # not officially supported by LR; forcing execution
        VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_icd64.json "$PWD/X-Plane-x86_64" --force_run --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    else
        # export RADV_PERFTEST=aco #Not needed since Mesa 20.2
        "$PWD/X-Plane-x86_64" --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1
    fi

}

function addheader {
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo SESSION START: "$(date "+%d/%m/%Y, %H:%M:%S h")" >> "$Outputfile"
    if [ "$rendererOption" = "llvm" ]; then
        echo "Vulkan Driver: AMD Mesa (LLVM compiler)" >> "$Outputfile"
    elif [ "$rendererOption" = "amdvlk" ]; then
        echo "Vulkan Driver: AMDVLK" >> "$Outputfile"
    else
        echo "Vulkan Driver: NVidia or AMD Mesa (ACO compiler)" >> "$Outputfile"
    fi
}

function writeparams {
# Call as follows: writeparams [*test-code*] ["llvm"|"amdvlk"|*other/none*]
    echo ----------------------------------------------------------------------------- >> "$Outputfile"
    echo Benchmark Preset: "$1" >> "$Outputfile"
    echo Command line options: --fps_test="$1" --full=$FullscreenRes --load_smo=$Replayfile --weather_seed=1 --time_seed=1 >> "$Outputfile"
}

function writelog {
    grep "FRAMERATE TEST:\|GPU LOAD:" "$Logfile" | grep -E -o "[a-zA-Z]+=[0-9]*(\.[0-9]+)?%?" | paste -sd' ' - | awk '{print $1,$2,$5,$6,$3}' >> "$Outputfile"
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

function writecsv {
    # initialize csv values
    bench_date="$(date "+%d/%m/%Y %H:%M:%S")"
    xp_version="$(grep 'log.txt for' "$Logfile" | awk '{print $4}')"
    kernel_version="$(uname -r)"
    vulkan_version="$(grep 'Vulkan Version' "$Logfile" | awk '{print $4}')"
    vulkan_driver="$(grep 'Vulkan Driver' "$Logfile" | awk '{print $4}')"
    bench_preset="$1"
    csv_header="bench_date;xp_version;kernel_version;vulkan_version;vulkan_driver;renderer_option;bench_preset;resolution;time;frames;fps;wait;load"
    csv_attributes="$bench_date;$xp_version;$kernel_version;$vulkan_version;$vulkan_driver;$rendererOption;$bench_preset;$FullscreenRes"
    raw_results="$(grep 'FRAMERATE TEST:\|GPU LOAD:' "$Logfile" | grep -E -o '[a-zA-Z]+=[0-9]*(\.[0-9]+)?%?')"
    csv_results=("$(echo "$raw_results" | sed -n '0,/time/s/^time=//p');" # string array to allow legible formatting while minimizing whitespace
                "$(echo "$raw_results" | sed -n 's/^frames=//p');"
                "$(echo "$raw_results" | sed -n 's/^fps=//p');"
                "$(echo "$raw_results" | sed -n 's/^wait=//p');"
                "$(echo "$raw_results" | sed -n 's/^load=//p')")

    # If file doesn't exist, write csv header
    if [ ! -f "$CSVoutputfile" ]; then
        echo "$csv_header" >> "$CSVoutputfile"
    fi

    # write values to csv: concatenate attributes string and results string array
    echo "$csv_attributes;${csv_results[@]}" >> "$CSVoutputfile"
}

#--------------------------------------------------------------
# SCRIPT EXECUTION

addheader

if [ $repeatBench = true ]; then
    for n in $benchmarks; do
        writeparams "$n"
        i=1; while [ $i -le $repeatCount ]; do
            runbench "$n"
            writelog
            if [ $write_csv = true ]; then writecsv "$n"; fi
            ((i++))
        done
    done
else
    for n in $benchmarks; do
        writeparams "$n"
        runbench "$n"
        writelog
        if [ $write_csv = true ]; then writecsv "$n"; fi
    done
fi

extracthw
