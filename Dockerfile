FROM tomcat:8-jre8
MAINTAINER "Mohd Salim"
ADD ./target/*.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]