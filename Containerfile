FROM registry.access.redhat.com/ubi10/s2i-core:latest

# Hier sind wir noch root und DÜRFEN dnf nutzen!
RUN dnf install -y socat && dnf clean all
