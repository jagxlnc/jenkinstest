FROM websphere-liberty:webProfile7
# RUN keytool -keystore /opt/ibm/java/jre/lib/security/cacerts -storepass changeit -noprompt -trustcacerts -importcert --alias issuing -file /usr/local/share/ca-certificates/issuing.crt
COPY /target/jenkinstest-1.0-SNAPSHOT.war /config/dropins/
COPY /src/main/liberty/config/server.xml /config/
COPY /src/main/resources/index.html /config/resources/
RUN installUtility install --acceptLicense defaultServer
