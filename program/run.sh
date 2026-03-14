#!/bin/bash
# 1. Compile the code
javac CompanyDB.java

# 2. Run the code with the Classpath (-cp) pointing to the MySQL Driver
# Note: the "." includes your current folder where CompanyDB.class lives
java -cp .:/usr/share/java/mysql-connector-java.jar CompanyDB


rm *.class
