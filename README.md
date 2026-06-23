# s2i

Im S2I-Framework (Source-to-Image) von OpenShift dreht sich alles um Automatisierung. Damit OpenShift weiß, wie es aus Ihrem rohen Quellcode ein fertiges, lauffähiges Container-Image baut, verlässt es sich auf ein Set von vordefinierten Skripten.

Diese Skripte liegen entweder bereits im Builder-Image (meist unter /usr/libexec/s2i/) oder können von Ihnen im Quellcode-Repository unter .s2i/bin/ überschrieben werden.

Hier ist die genaue Erklärung der drei wichtigsten Skripte: assemble, run und usage.

## Das assemble-Skript (Die Bauanleitung)
Das assemble-Skript ist das Herzstück der Build-Phase. Es wird ausgeführt, während OpenShift Ihr neues Anwendungs-Image erstellt (z. B. während oc start-build).

Wann läuft es? Nur einmal während des Image-Builds im Cluster.

Was ist seine Aufgabe? Es nimmt den Quellcode, den OpenShift in den Build-Pod geladen hat (standardmäßig im Verzeichnis /tmp/src), und bereitet ihn für die Ausführung vor.

Typische Aktionen im Skript:

Abhängigkeiten herunterladen und installieren (z. B. npm install bei Node.js oder pip install -r requirements.txt bei Python).

Den Code kompilieren (z. B. mvn package bei Java).

Die fertigen Binärdateien oder Skripte in das finale Verzeichnis verschieben (meist /opt/app-root/src).

## Das run-Skript (Der Startknopf)
Das run-Skript definiert das Standardverhalten des fertigen Anwendungs-Containers, wenn dieser später im Pod gestartet wird.

Wann läuft es? Jedes Mal, wenn ein neuer Anwendungs-Pod gestartet oder hochskaliert wird (Deployment-Phase). Es wird als CMD (Command) im Dockerfile-Äquivalent des finalen Images hinterlegt.

Was ist seine Aufgabe? Es startet Ihre Anwendung und hält den Container am Leben.

Typische Aktionen im Skript:

Ausführen des Webservers oder der Laufzeitumgebung (z. B. npm start, python app.py oder java -jar app.jar).

Es stellt sicher, dass der Prozess im Vordergrund läuft (PID 1). Stirbt dieser Prozess, merkt OpenShift das und startet den Pod neu.

## Das usage-Skript (Der Beipackzettel)
Das usage-Skript ist ein reines Informations-Skript für den Entwickler.

Wann läuft es? Wenn Sie (oder OpenShift) das nackte Builder-Image starten, ohne ihm Quellcode zu übergeben.

Was ist seine Aufgabe? Es gibt eine strukturierte Anleitung auf der Konsole aus, wie man dieses spezifische S2I-Image korrekt verwendet.

Typische Inhalte:

Welche Programmierversion ist installiert? (z. B. "This nodejs:16 builder image allows you to...")

Welche Umgebungsvariablen (Environment Variables) können übergeben werden, um den Build zu steuern? (z. B. HTTP_PROXY, NPM_RUN etc.)

## Beispiele
Verwendet das Dockerfile
```
oc new-app --name docker --strategy=docker https://github.com/mueroema/s2i.git
```

Verwendet die s2i Scripts im hidden .s2i Ordner:
```
oc new-app --name s2i httpd~https://github.com/mueroema/s2i.git
```


