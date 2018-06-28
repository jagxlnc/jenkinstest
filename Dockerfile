FROM  dc1cp01.icp:8500/default/websphere-liberty-z:webProfile6-june2018.2
# RUN keytool -keystore /opt/ibm/java/jre/lib/security/cacerts -storepass changeit -noprompt -trustcacerts -importcert --alias issuing -file /usr/local/share/ca-certificates/issuing.crt
COPY /target/liberty/wlp/usr/servers/defaultServer /config/
COPY /target/liberty/wlp/usr/shared/resources /config/resources/
# Install required features if not present, install APM Data Collector
RUN installUtility install --acceptLicense defaultServer && installUtility install --acceptLicense apmDataCollector-7.4
