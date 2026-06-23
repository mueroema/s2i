FROM registry.access.redhat.com/ubi10/ubi-minimal:latest

# Hier sind wir noch root und DÜRFEN dnf nutzen!
RUN microdnf install -y socat && microdnf clean all

# Wir bauen deine index.html
RUN echo "<html><body><h1>S2I-Konzepte verstanden!</h1></body></html>" > /tmp/index.html

# Wichtig für OpenShift: Wir wechseln auf den unprivilegierten User
USER 1001

# Der Startbefehl für den Pod
EXPOSE 8080
CMD ["/usr/bin/socat", "TCP-LISTEN:8080,reuseaddr,fork", "SYSTEM:echo -e 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n'; cat /tmp/index.html"]
