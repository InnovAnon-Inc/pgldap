FROM ubuntu as build

ARG DEBIAN_FRONTEND=noninteractive

COPY dist/ /tmp/dist/

#    #psmisc                         \
#    #odbc-postgresql                \
#    #unixodbc                       \
RUN rm -v                          \
    /tmp/dist/ldap-utils_*.deb     \
    /tmp/dist/libldap*-dev_*.deb   \
&&  apt update                     \
&&  apt full-upgrade -y            \
    --no-install-recommends        \
&&  apt install      -y            \
    --no-install-recommends        \
    /tmp/dist/slapd_*.deb          \
    /tmp/dist/libldap-*.deb        \
&&  apt autoremove   -y            \
    --purge                        \
&&  apt clean        -y            \
&&  rm -rf  /var/lib/apt/lists/*   \
&&  rm -rf  /etc/ldap/slapd.d      \
&&  rm -rfv /tmp/dist/

#RUN sed -i                                                     \
#    's@^SLAPD_CONF=.*$@SLAPD_CONF=/etc/ldap/certs/slapd.conf@' \
#    /etc/default/slapd
COPY etc/apparmor.d/local/usr.sbin.slapd \
    /etc/apparmor.d/local/usr.sbin.slapd

# /etc/ldap/certs/slapd.conf
# /etc/ldap/certs/LDAP.chain.crt
# /etc/ldap/certs/LDAP.crt
# /etc/ldap/certs/LDAP.key
VOLUME ["/etc/ldap/certs"]
# /root/.odbc.ini
VOLUME ["/root"]

ENTRYPOINT [              \
  "/usr/sbin/slapd",      \
  "-F", "/etc/ldap/certs" \
]

CMD [                     \
  "-d", "9"               \
]
