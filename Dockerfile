FROM registry.access.redhat.com/ubi10/ubi-minimal:latest

# 1. Systempakete als root installieren
RUN microdnf install -y socat && microdnf clean all

# 2. JETZT SCHON auf den unprivilegierten User wechseln
# Alle folgenden Dateien gehören damit automatisch der Gruppe 0 / User 1001
USER 1001

# 3. Die HTML-Seite und das HTTP-Antwortpaket in /tmp bauen
RUN echo "<html><body><h1>S2I-Konzepte verstanden!</h1></body></html>" > /tmp/index.html
RUN echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r" > /tmp/http_response.txt && \
    cat /tmp/index.html >> /tmp/http_response.txt

# 4. Port freigeben und Datei via socat im reinen LESEMODUS (,rdonly) streamen
EXPOSE 8080
CMD ["/usr/bin/socat", "TCP-LISTEN:8080,reuseaddr,fork", "OPEN:/tmp/http_response.txt,rdonly"]
