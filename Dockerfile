FROM centos:6.6
MAINTAINER liski.ortega@gmail.com
#Set pass root
RUN echo 'root:C4r4c@s' | chpasswd
#Set env variables  JBOSS
ENV JBOSS_HOME /opt/jboss
########################################################################
# Install using local files
########################################################################

#Install Java
COPY ./jdk-7u72-linux-x64.rpm /opt/
RUN rpm -ivh /opt/jdk-7u72-linux-x64.rpm

#Set env variables JAVA 
ENV JAVA_HOME /usr/java/jdk1.7.0_72/

#Install Jboss
ADD jboss-as-7.1.1.Final.tar.gz /opt/
########################################################################
# End of install using local files
########################################################################
#Link simbolico JBOSS
RUN ln -s /opt/jboss-as-7.1.1.Final /opt/jboss 

#Actualizar directorio de configuracion MODULES
ADD modules.tar.gz /opt/jboss/

#Actualizar directorio de configuracion STANDALONE
ADD standalone.tar.gz /opt/jboss/ 

#Actualizar archivo de configuracion standalone.conf
ADD standalone.conf /opt/jboss/bin/
ADD standalone-full.xml /opt/jboss/standalone/configuration/ 

RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss
# Specify the user which should be used to execute all commands below
RUN  chown -R jboss.jboss /opt/jboss/bin \
     && chown -R jboss.jboss /opt/jboss/standalone/configuration/standalone-full.xml
USER jboss
#Expose el puerto 
EXPOSE 8443
EXPOSE 9990
CMD ["/bin/sh", "-c", "$JBOSS_HOME/bin/standalone.sh -c standalone-full.xml -b 0.0.0.0 -bmanagement 0.0.0.0"]
