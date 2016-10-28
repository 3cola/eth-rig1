#!/bin/bash -x

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100

/root/cpp-ethereum/build/ethminer/ethminer --farm-recheck 200 -G -S eu1.ethermine.org:4444 -FS eu2.ethermine.org:4444 -O 0xfc2b7dd0b652bdd4a325e3984aab8f9cf0cad7e5.Rig1

