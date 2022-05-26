function run-dfsio() {
    PARALLEL=$1
    SIZE=$2
    OP=$3
    EXECUTORS=$4
    EXECUTOR_CORES=$5

    spark-submit \
        --num-executors $EXECUTORS \
        --conf spark.dynamicAllocation.enabled=false \
        --conf spark.executor.cores=$EXECUTOR_CORES \
        --conf 'spark.driver.extraJavaOptions=-Dalluxio.user.metrics.collection.enabled=true ' \
        --conf 'spark.executor.extraJavaOptions=-Dalluxio.user.metrics.collection.enabled=true ' \
        --class alluxio.benchmarks.TestDFSIO \
        --driver-java-options "-Dlog4j.configuration=file:///home/ec2-user/spark-log4j.properties" \
        /home/ec2-user/spark-dfsio/target/benchmarks-1.0.0-SNAPSHOT-jar-with-dependencies.jar \
        -p $PARALLEL \
        -s $SIZE \
        -o $OP \
        -b alluxio://MASTER_HOSTNAME:29998/dfsio/
}

function testMultiRuns() {
    run-dfsio $P $S w $E $C
    echo "----------------- Done 1st Write -----------------"
    alluxio fs free /
    sleep 15 # wait for data to be freed
    run-dfsio $P $S r $E $C
    echo "----------------- Done 1st Read  -----------------"
    sleep 30 # wait for data to be cached
    run-dfsio $P $S r $E $C
    echo "----------------- Done 2nd Read  -----------------"
    run-dfsio $P $S r $E $C
    echo "----------------- Done 3rd Read  -----------------"
    run-dfsio $P $S r $E $C
    echo "----------------- Done 4th Read  -----------------"
    run-dfsio $P $S r $E $C
    echo "----------------- Done 5th Read  -----------------"
}

function testWRR() {
    run-dfsio $P $S wrr $E $C
    echo "----------------- Done $1 Run -----------------"
}

function genData() {
    run-dfsio $P $S w $E $C
}

P=100
S=10
E=10
C=2

echo "================= BEG ($(date -Iminutes)) ================="
echo "================= [-p $P -s $S -e $E -c $C] ================="
# testWRR 1
# testWRR 2
# testWRR 3
genData
echo "================= END ($(date -Iminutes)) ================="
