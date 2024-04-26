FROM ivansla/my-local-repo:my-rhel-ace-with-mq-client

# aceuser
USER root
RUN usermod -aG wheel aceuser
# Copy the BAR files into /tmp and process them:
#
# - Each file is compiled to ensure faster server startup
# - The files are unpacked into the server work directory
# - Once all files are in place, the work directory is optimized to speed up server start
# - The contents are made world-writable to allow for random userids at runtime
#
# The results of the commands can be found in the /tmp/deploys file.
#
COPY PsbPolicyProject.bar /tmp
##COPY Worker_MFAIdentityCheck/Config/Overrides/Test/override.properties /tmp
#COPY --chmod=777 --chown=1001:1001 server.conf.yaml /home/aceuser/ace-server/
COPY server.conf.yaml /home/aceuser/ace-server
##COPY --chmod=777 --chown=1001:1001 *.jks /home/aceuser/ace-server/
##COPY --chmod=777 --chown=1001:1001 *.pfx /home/aceuser/ace-server/
#COPY --chmod=777 --chown=1001:1001 client.* /home/aceuser/ace-server/

RUN export LICENSE=accept \
    && . /opt/ibm/ace-12/server/bin/mqsiprofile \
    && set -x  \
    && for FILE in /tmp/*.bar; do \
       echo "$FILE" >> /tmp/deploys && \
       ibmint deploy --input-bar-file ${FILE} --output-work-directory /home/aceuser/ace-server/ 2>&1 | tee -a /tmp/deploys; done \
#     && mqsisetdbparms -w /home/aceuser/ace-server -n mq::mqexplorer -u mqexplorer -p mqexplorer \
#     && mqsisetdbparms -w /home/aceuser/ace-server -n brokerKeystore::password -u ignore -p Pg3t4ycmZbTUkL5m \
#     && mqsisetdbparms -w /home/aceuser/ace-server -n brokerTruststore::password -u ignore -p Pg3t4ycmZbTUkL5m \
#     && mqsisetdbparms -w /home/aceuser/ace-server -n mq::ivansla -u ivansla -p LenovoLenovo123 \
    && chmod -R ugo+rwx /home/aceuser/ \
    && chmod -R ugo+rwx /var/mqsi/

USER 1001

# Expose ports.  7600, 7800, 7843 for ACE;
EXPOSE 7600 7800 7843

# Set entrypoint to run the server
#ENTRYPOINT ["bash", "-c", ". /opt/ibm/ace-12/server/bin/mqsiprofile && IntegrationServer -w /home/aceuser/ace-server"]
#CMD ["/bin/bash"]
ENTRYPOINT ["bash", "-c", "sleep 600"]