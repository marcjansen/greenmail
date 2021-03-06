#! /bin/bash

copy_artifacts() {
 ARTIFACT_VARIANT_DIR="$CIRCLE_ARTIFACTS/greenmail-$1"
 echo $ARTIFACT_VARIANT_DIR
 mkdir $ARTIFACT_VARIANT_DIR && \
 find . -name \*.log -exec cp -r --parent {} $ARTIFACT_VARIANT_DIR/ \;
}

run_maven() {
 mvn clean install -DskipTests
 mvn test
}

jdk6() {
 sudo update-alternatives --set java "/usr/lib/jvm/jdk1.6.0/bin/java"
 sudo update-alternatives --set javac "/usr/lib/jvm/jdk1.6.0/bin/javac"
}

jdk7() {
 sudo update-alternatives --set java "/usr/lib/jvm/jdk1.7.0/bin/java"
 sudo update-alternatives --set javac "/usr/lib/jvm/jdk1.7.0/bin/javac"
}

jdk8() {
 sudo update-alternatives --set java "/usr/lib/jvm/jdk1.8.0/bin/java"
 sudo update-alternatives --set javac "/usr/lib/jvm/jdk1.8.0/bin/javac"
}

openjdk6() {
 sudo update-alternatives --set java "/usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java"
 sudo update-alternatives --set javac "/usr/lib/jvm/java-6-openjdk-amd64/bin/javac"
}

openjdk7() {
 sudo update-alternatives --set java "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java"
 sudo update-alternatives --set javac "/usr/lib/jvm/java-7-openjdk-amd64/bin/javac"
}

case $CIRCLE_NODE_INDEX in 
	0)
	 echo "Building GreenMail on Oracle JDK6"
	 jdk6
	 run_maven
	 copy_artifacts "jdk1.6.0"
	 ;;
	
	1)
	 echo "Building GreenMail on Oracle JDK7"
	 jdk7
	 run_maven
	 copy_artifacts "jdk1.7.0"
	 ;;
	
	2)
	 echo "Building GreenMail on Oracle JDK8"
	 jdk8
         run_maven
	 copy_artifacts "jdk1.8.0"
	 ;;

	3)
	 echo "Building GreenMail on OpenJDK6"
	 openjdk6
	 run_maven
	 copy_artifacts "java-6-openjdk-amd64" 
	 echo "Building GreenMail on OpenJDK7"
	 openjdk7
         run_maven
	 copy_artifacts "java-7-openjdk-amd64"
	 ;;
esac

