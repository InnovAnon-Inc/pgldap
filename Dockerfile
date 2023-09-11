FROM ubuntu as build

ARG DEBIAN_FRONTEND=noninteractive

#COPY etc/apt/apt.conf.d/00aptproxy \
#    /etc/apt/apt.conf.d/00aptproxy

COPY dist/ /tmp/dist/

#    #psmisc                         \
#    #odbc-postgresql                \
#    #unixodbc                       \
RUN apt update                     \
&&  apt full-upgrade -y            \
    --no-install-recommends        \
&&  apt install      -y            \
    --no-install-recommends        \
    /tmp/dist/slapd_*.deb          \
&&  apt autoremove   -y            \
    --purge                        \
&&  apt clean        -y            \
&&  rm -rf /var/lib/apt/lists/*    \
&&  rm -rf /etc/ldap/slapd.d       \
&&  rm -v  /tmp/dist/*.deb

#     /tmp/slapd_2.5.16+dfsg-0ubuntu0.22.04.2_amd64.deb                \
#     /tmp/libldap-2.5-0_2.5.16+dfsg-0ubuntu0.22.04.2_amd64.deb        \
#     /tmp/libldap-common_2.5.16+dfsg-0ubuntu0.22.04.2_all.deb         \
#COPY etc/apt/sources.list.d/InnovAnon-Inc.list \
#     etc/apt/sources.list.d/
#COPY etc/apt/keyrings/InnovAnon-Inc.asc        \
#     etc/apt/keyrings/
#RUN apt update                     \
#&&  apt install      -y            \
#    --no-install-recommends        \
#    pgslapd                        \

# TODO use a conf volume
RUN sed -i                                             \
  's@^SLAPD_CONF=.*$@SLAPD_CONF=/etc/ldap/certs/slapd.conf@' \
  /etc/default/slapd
COPY ./etc/apparmor.d/local/usr.sbin.slapd \
      /etc/apparmor.d/local/usr.sbin.slapd
#COPY ./etc/ldap/slapd.conf                 \
#      /etc/ldap/slapd.conf
# TODO how to change location of odbc.ini
#COPY ./etc/odbc.ini                        \
#      /etc/odbc.ini

VOLUME ["/etc/ldap/certs"]
# /root/.odbc.ini
VOLUME ["/root"]

  #"-r", "/slapd-chroot", \
  #"-u", "openldap"       \
ENTRYPOINT [             \
  "/usr/sbin/slapd",     \
  "-d", "9"              \
]

