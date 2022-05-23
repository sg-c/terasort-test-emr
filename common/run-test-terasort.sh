function run() {
    local numOfExecutors=$1
    local executorCores=$2
    local dataSize=$3

    time spark-submit \
        --num-executors $numOfExecutors \
        --executor-memory 8g \
        --conf spark.shuffle.file.buffer=128k \
        --conf spark.executor.cores=$executorCores \
        --class com.github.ehiggs.spark.terasort.TeraGen \
        --conf spark.default.parallelism=160 \
        --conf spark.dynamicAllocation.enabled=false \
        --conf 'spark.driver.extraJavaOptions=-Dalluxio.user.metrics.collection.enabled=true ' \
        --conf 'spark.executor.extraJavaOptions=-Dalluxio.user.metrics.collection.enabled=true ' \
        --driver-java-options "-Dlog4j.configuration=file:///home/ec2-user/spark-log4j.properties" \
        ~/spark-terasort/target/spark-terasort-1.1-SNAPSHOT-jar-with-dependencies.jar \
        "$dataSize" \
        alluxio://MASTER_HOSTNAME:29998/terasort/in

    time spark-submit \
        --num-executors $numOfExecutors \
        --executor-memory 8g \
        --conf spark.shuffle.file.buffer=128k \
        --conf spark.executor.cores=$executorCores \
        --class com.github.ehiggs.spark.terasort.TeraSort \
        --conf spark.default.parallelism=160 \
        --conf spark.dynamicAllocation.enabled=false \
        --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
        --conf 'spark.driver.extraJavaOptions=-Dalluxio.user.metrics.collection.enabled=true ' \
        --conf 'spark.executor.extraJavaOptions=-Dalluxio.user.metrics.collection.enabled=true ' \
        --driver-java-options "-Dlog4j.configuration=file:///home/ec2-user/spark-log4j.properties" \
        ~/spark-terasort/target/spark-terasort-1.1-SNAPSHOT-jar-with-dependencies.jar \
        alluxio://MASTER_HOSTNAME:29998/terasort/in \
        alluxio://MASTER_HOSTNAME:29998/terasort/out
}

function notify() {
    echo -ne '\007'
    sleep 1
    echo -ne '\007'
    sleep 1
    echo -ne '\007'
    sleep 1
    echo -ne '\007'
}

NUM_EXECUTORS=25
EXECUTOR_CORES=2
DATA_SIZE=150g

time run $NUM_EXECUTORS $EXECUTOR_CORES $DATA_SIZE

notify

