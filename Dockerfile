FROM glondu/beleniosbase:20211008-1


USER root
ENV DEBIAN_FRONTEND="noninteractive"
ARG DEBIAN_FRONTEND=noninteractive

# CONFIG SENDMAIL
RUN apt-get update && apt-get -y install mailutils bsd-mailx msmtp msmtp-mta
RUN echo "host smtp.domain.com" >> /etc/msmtprc
RUN echo "logfile /var/log/msmtp.log" >> /etc/msmtprc
RUN echo "from email@domain.com" >> /etc/msmtprc
RUN touch /var/log/msmtp.log

ARG PATH="/home/belenios/.belenios/bootstrap/bin:$PATH"
ENV PATH="/home/belenios/.belenios/bootstrap/bin:$PATH"
ARG OPAMROOT=/home/belenios/.belenios/opam
ENV OPAMROOT=/home/belenios/.belenios/opam

RUN eval $(opam env)
RUN opam update && opam upgrade
RUN opam install --yes dune atdgen zarith cryptokit cmdliner calendar eliom csv


RUN git clone https://gitlab.inria.fr/belenios/belenios.git /home/belenios/install
WORKDIR /home/belenios/install

RUN eval $(opam env) && make build-release-server

COPY ocsigenserver.conf.in /home/belenios/install/demo/ocsigenserver.conf.in

USER belenios
COPY start.sh /home/belenios/install

USER root
RUN chmod a+x /home/belenios/install/start.sh
RUN chgrp -R 0 /home/belenios/install/
RUN chmod -R g+rw /home/belenios/install/

EXPOSE 8080

USER belenios
CMD [ "/home/belenios/install/start.sh" ]
