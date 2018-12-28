FROM ubuntu:12.04

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y git curl wget java xsltproc

# Install app
RUN mkdir -p /usr/tomcat7
RUN wget -o /usr/tomcat7/apache-tomcat-7.0.77.tar.gz https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.77/bin/apache-tomcat-7.0.77.tar.gz
RUN tar -C /usr/tomcat7 xzf /usr/tomcat7/apache-tomcat-7.0.77.tar.gz

# Configure tomcat
ADD /tmp/codedeploy-deployment-staging-area/SampleMavenTomcatApp.war /usr/tomcat7/webapps/ROOT.war
RUN cp /usr/tomcat7/conf/server.xml /usr/tomcat7/conf/server.xml.bak
ADD /tmp/codedeploy-deployment-staging-area/configure_http_port.xsl /usr/tomcat7/configure_http_port.xsl
RUN xsltproc /usr/tomcat7/configure_http_port.xsl /usr/tomcat7/conf/server.xml.bak > /usr/tomcat7/conf/server.xml

EXPOSE 80

CMD ["/usr/tomcat7/bin/catalina.sh", "run"]
