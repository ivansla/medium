FROM ivansla/my-repo:my-mq

# can solve problem for creating keystore on AMD processors. https://github.com/ibm-messaging/mq-container/issues/462
ENV ICC_SHIFT=3

COPY --chmod=777 mq_qmgr_ssl.mqsc /home/mqm
COPY --chmod=777 *.sh /home/mqm
COPY --chmod=777 --chown=mqm:mqm server.* /home/mqm/qmgrs/data/QMgr01/ssl/
COPY --chmod=777 --chown=mqm:mqm client.* /home/mqm/
#RUN ["/home/mqm/mq-setup.sh", "QMgr01", "1414", "mqexplorers"]
RUN ["/home/mqm/mq-ssl-setup.sh", "QMgr01"]
ENTRYPOINT ["/home/mqm/mq-start.sh", "QMgr01"]
