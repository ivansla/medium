FROM ivansla/my-local-repo:my-rhel-ubi

# aceuser
USER root

# Copy the BAR files into /tmp and process them:
#
# - Each file is compiled to ensure faster server startup
# - The files are unpacked into the server work directory
# - Once all files are in place, the work directory is optimized to speed up server start
# - The contents are made world-writable to allow for random userids at runtime
#
# The results of the commands can be found in the /tmp/deploys file.
#
ARG BAR_FILE_PATH
#ARG MQ_CLIENT_DOWNLOAD_URL=https://ak-delivery04-mul.dhe.ibm.com/sdfdl/v2/sar/CM/WS/0bv3q/0/Xa.2/Xb.jusyLTSp44S03g_hzCe87OopQHHST5VSUwgXcJ4a-ok-QD7OrjxXd4rJXWo/Xc.CM/WS/0bv3q/0/9.2.0.21-IBM-MQC-LinuxX64.tar.gz/Xd./Xf.LPR.D1VK/Xg.12612263/Xi.habanero/XY.habanero/XZ.GSyBu1m5MsKHU0uUvAw9pPYQ3z30JojJ/9.2.0.21-IBM-MQC-LinuxX64.tar.gz
ARG MQ_CLIENT_DOWNLOAD_URL=http://192.168.0.14:9000/9.3.4.1-IBM-MQC-LinuxX64.tar.gz
ENV LICENSE=accept

RUN microdnf update && microdnf install sudo iputils procps net-tools tar hostname findutils less nano nc && microdnf clean all

RUN mkdir -p /opt/ibm/MQClient \
    && curl ${MQ_CLIENT_DOWNLOAD_URL} | \
    tar zx --absolute-names \
    --strip-components 1 \
    -C /opt/ibm/MQClient

RUN rpm -ivh /opt/ibm/MQClient/MQSeriesClient-9.*.x86_64.rpm /opt/ibm/MQClient/MQSeriesGSKit-9.*.x86_64.rpm /opt/ibm/MQClient/MQSeriesRuntime-9.*.x86_64.rpm /opt/ibm/MQClient/MQSeriesJava-9.*.x86_64.rpm /opt/ibm/MQClient/MQSeriesJRE-9.*.x86_64.rpm

# Expose ports.  7600, 7800, 7843 for ACE;
EXPOSE 7600 7800 7843

# Set entrypoint to run the server
#ENTRYPOINT ["bash", "-c", ". /opt/ibm/ace-12/server/bin/mqsiprofile && IntegrationServer -w /home/aceuser/ace-server"]
CMD ["/bin/bash"]