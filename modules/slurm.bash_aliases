#!/bin/bash

sacct_mem() {
    sacct -j "$1" --format=JobID,JobName%20,MaxRSS,MaxVMSize,Elapsed,Start,End,State,ExitCode --units=G
}

sstat_mem() {
    sstat -j "$1" --format=JobID,MaxRSS,MaxVMSize,AveRSS,AveCPU,NTasks
}
