# update pom.xml
HADOOP_VER=2.8.3 # update me
SPARK_VER=2.3.1 # update me

cd ~
aws s3 cp s3://alluxio.saiguang.test/spark-dfsio.tar.gz spark-dfsio.tar.gz
tar -xf spark-dfsio.tar.gz

#install maven
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven

cd ~/spark-dfsio/

sed -i "s/<hadoop\.version>.*<\/hadoop\.version>/<hadoop.version>$HADOOP_VER<\/hadoop.version>/g" pom.xml
sed -i "s/<spark\.version>.*<\/spark\.version>/<spark.version>$SPARK_VER<\/spark.version>/g" pom.xml
sed -i "s/spark-core_2\.[0-9][0-9]/spark-core_2.11/g" pom.xml

# build dfs-io
mvn install