function print_steps() {
    echo "
Step:
1. use run the function genData() in script 'run-test-dfsio.sh' to generate data.
2. run 'alluxio fs ls /dfsio/TestDFSIO/data' to make sure all files are persisted.
3. run 'alluxio fs free /' to off load all data in Alluxio.
4. execute 'time alluxio fs load /dfsio' for 1.8 or 'time alluxio fs distributedLoad /dfsio' \
for 2.8 to compare the time used for loading data.
"
}

function run_load_test() {
    alluxio fs free /

    sleep 5 # wait for all data are freed

    echo "start to load data"
    [[ $(alluxio version) == "1.8"* ]] && time alluxio fs load /dfsio | grep "real"
    [[ $(alluxio version) == *"2."* ]] && time alluxio fs distributedLoad /dfsio | grep "real"

    echo "check used space in alluxio"
    [[ $(alluxio version) == "1.8"* ]] && alluxio fs du /dfsio
    [[ $(alluxio version) == *"2."* ]] && alluxio fs du -h -s /dfsio
}

function run_load_test_3_times() {
    for n in {1..3}; do
        echo "========= run_load_test #$n ========="
        run_load_test
    done
}

run_load_test_3_times
