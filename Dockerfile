FROM registry.access.redhat.com/ubi10/ubi-minimal:latest

# 1. Systempakete installieren
RUN microdnf install -y socat && microdnf clean all

# 2. Die HTML-Seite bauen
RUN echo "<html><body><h1>S2I-Konzepte verstanden!</h1></body></html>" > /tmp/index.html

# 3. Das HTTP-Antwort-Paket vorab sauber zusammenbauen
RUN echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r" > /tmp/http_response.txt && \
    cat /tmp/index.html >> /tmp/http_response.txt

# 4. Auf unprivilegierten User wechseln
USER 1001

# 5. Port freigeben und Datei via socat direkt streamen (ohne Shell-Gefahr!)
EXPOSE 8080
CMD ["/usr/bin/socat", "TCP-LISTEN:8080,reuseaddr,fork", "OPEN:/tmp/http_response.txt"]
