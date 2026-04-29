FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl unzip tar gzip \
      openssh-client \
      git jq less vim-tiny iputils-ping dnsutils \
      gnupg python3 python3-pip \
      bsdmainutils util-linux \
      sudo \
 && rm -rf /var/lib/apt/lists/*

# ubuntu:24.04 ships a default `ubuntu` user at uid/gid 1000 — rename to `oriol`
# so the bind-mounted ~/.ssh (owned by host uid 1000) is readable without
# permission gymnastics. NOPASSWD sudo for convenience inside the sandbox.
RUN groupmod -n oriol ubuntu \
 && usermod  -l oriol -d /home/oriol -m ubuntu \
 && usermod  -aG sudo oriol \
 && echo 'oriol ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/oriol \
 && chmod 0440 /etc/sudoers.d/oriol

# Node.js 20 (for npx-based MCP shell server)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*

# AWS CLI v2
RUN ARCH=$(uname -m) \
 && case "$ARCH" in \
        x86_64)  AWSARCH=x86_64 ;; \
        aarch64) AWSARCH=aarch64 ;; \
        *) echo "unsupported arch $ARCH"; exit 1 ;; \
    esac \
 && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWSARCH}.zip" -o /tmp/awscliv2.zip \
 && unzip -q /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip

# kubectl (latest stable)
RUN ARCH=$(dpkg --print-architecture) \
 && KVER=$(curl -fsSL https://dl.k8s.io/release/stable.txt) \
 && curl -fsSL "https://dl.k8s.io/release/${KVER}/bin/linux/${ARCH}/kubectl" -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

# eksctl
RUN ARCH=$(dpkg --print-architecture) \
 && curl -fsSL -o /tmp/eksctl.tar.gz \
      "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${ARCH}.tar.gz" \
 && tar -xzf /tmp/eksctl.tar.gz -C /usr/local/bin eksctl \
 && chmod +x /usr/local/bin/eksctl \
 && rm /tmp/eksctl.tar.gz

# zellij — persistent terminal session that survives mcphub stdio child restarts.
RUN ARCH=$(uname -m) \
 && case "$ARCH" in \
        x86_64)  Z=x86_64-unknown-linux-musl ;; \
        aarch64) Z=aarch64-unknown-linux-musl ;; \
        *) echo "unsupported arch $ARCH"; exit 1 ;; \
    esac \
 && curl -fsSL "https://github.com/zellij-org/zellij/releases/latest/download/zellij-$Z.tar.gz" -o /tmp/z.tgz \
 && tar -xzf /tmp/z.tgz -C /usr/local/bin/ \
 && chmod +x /usr/local/bin/zellij \
 && rm /tmp/z.tgz

# minimal zellij config: skip first-run wizard, no welcome screen
RUN install -d -o oriol -g oriol /home/oriol/.config/zellij \
 && cat > /home/oriol/.config/zellij/config.kdl <<'KDL'
show_startup_tips false
show_release_notes false
pane_frames false
KDL
RUN chown -R oriol:oriol /home/oriol/.config

# sb-zj: helper to send a command to the persistent zellij session "sb"
# and return the captured screen output. Idempotently creates session.
RUN cat > /usr/local/bin/sb-zj <<'HELPER' \
 && chmod +x /usr/local/bin/sb-zj
#!/bin/bash
# usage: sb-zj "<shell command>"  → runs in zellij session "sb", prints last screen
set -e
SESSION=sb
if ! zellij list-sessions 2>/dev/null | grep -q "$SESSION"; then
  setsid script -qc "zellij attach -c $SESSION" /dev/null </dev/null >/dev/null 2>&1 &
  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
    zellij list-sessions 2>/dev/null | grep -q "$SESSION" && break
    sleep 0.5
  done
fi
zellij -s $SESSION action write-chars "$1"
zellij -s $SESSION action write 13   # Enter
sleep "${SB_ZJ_WAIT:-0.7}"
zellij -s $SESSION action dump-screen
HELPER

# Entrypoint: pre-warm the zellij session so first MCP call is cheap.
RUN cat > /usr/local/bin/sandbox-entrypoint.sh <<'ENTRY' \
 && chmod +x /usr/local/bin/sandbox-entrypoint.sh
#!/bin/bash
# spawn the persistent zellij session "sb" detached
setsid script -qc "zellij attach -c sb" /dev/null </dev/null >/tmp/zj.log 2>&1 &
for i in 1 2 3 4 5 6 7 8 9 10; do
  zellij list-sessions 2>/dev/null | grep -q sb && break
  sleep 0.5
done
# nudge dismiss any leftover welcome panel
zellij -s sb action write 27 >/dev/null 2>&1 || true
zellij -s sb action write 13 >/dev/null 2>&1 || true
exec tail -f /dev/null
ENTRY

USER oriol
WORKDIR /home/oriol
CMD ["/usr/local/bin/sandbox-entrypoint.sh"]
