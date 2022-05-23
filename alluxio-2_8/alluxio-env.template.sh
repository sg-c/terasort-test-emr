# Alluxio GC 
ALLUXIO_JAVA_OPTS=" 
-XX:+PrintGC 
-XX:+PrintGCDetails 
-XX:+PrintTenuringDistribution 
-XX:+PrintGCTimeStamps 
-XX:+PrintGCDateStamps 
-XX:+UseConcMarkSweepGC 
-XX:+UseParNewGC 
-Xloggc:/home/ec2-user/alluxio/logs/master_%p_gc.log 
"

# Master
ALLUXIO_MASTER_JAVA_OPTS+=" 
-Xms16g 
-Xmx16g 
-XX:MaxDirectMemorySize=10g  
"

# Worker
ALLUXIO_WORKER_JAVA_OPTS+=" 
-Xms8g  
-Xmx8g 
-XX:MaxDirectMemorySize=6g 
"

# Job Master
ALLUXIO_JOB_MASTER_JAVA_OPTS+=" 
-Xms4g 
-Xmx4g 
-XX:MaxDirectMemorySize=3g  
"

# Job Worker
ALLUXIO_JOB_WORKER_JAVA_OPTS+=" 
-Xms4g 
-Xmx4g 
-XX:MaxDirectMemorySize=3g  
"