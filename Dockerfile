# attempting to run FMAudit in a container

# FMAudit installer demands systemd, so let's use Fedora
FROM fedora:35
LABEL maintainer="Curtis@GreenKey.net"
LABEL org.label-schema.schema-version = "1.0"
LABEL org.label-schema.docker.cmd = "docker run -d -p 33330:33330 --tmpfs=/run --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs=/tmp --name fmaudit fmaudit"
ENV container docker

# FMAudit can't handle Java 11+, so we must install java-1.8.0-openjdk-headless
RUN dnf --assumeyes --setopt=install_weak_deps=False update \
    && \
    dnf --assumeyes --setopt=install_weak_deps=False install \
        systemd \
        java-1.8.0-openjdk-headless \
    && \
    dnf clean all \
    && \
    find /var/cache/dnf -mindepth 1 -delete

# schleping it temporarily into the root for now
COPY fmaudit.onsite.jar .
# since systemd isn't running yet in build, we need to defer the installation until first boot
COPY fmaudit-install.sh .
COPY fmaudit-install.service /etc/systemd/system/
RUN chmod -x /etc/systemd/system/fmaudit-install.service
RUN systemctl enable fmaudit-install

EXPOSE 33330/tcp

# enable systemd
CMD [ "/sbin/init" ]

# Halts the machine, starts the halt.target unit. This is mostly equivalent to systemctl start halt.target --job-mode=replace-irreversibly.
STOPSIGNAL SIGRTMIN+3
