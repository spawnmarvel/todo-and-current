
# Rasberry PI OIT



* Raspberry Pi 4 Model B (4GB): Et solid valg.
* Kingston Canvas Select Plus 64GB: Helt riktig valg til denne brukssaken – pålitelig nok til å kjøre operativsystemet og tåle kontinuerlig skriving av loggdata uten å koste skjorta
* Raspberry Pi 27W USB-C Strømforsyning: Denne er beregnet for Pi 5, men fungerer helt fint på Pi 4. Hvis Komplett har den offisielle 15W USB-C-strømforsyningen på lager, sparer du noen få tiere til, men 27W-versjonen du har valgt fungerer helt trygt.

Nettverkspesifikasjoner for Raspberry Pi 4 B

* Wi-Fi: Innebygd toband strålingsskjermet trådløst nettverk (2.4 GHz og 5.0 GHz IEEE 802.11ac).

* Ethernet: Ekte Gigabit Ethernet-port (10/100/1000 Mbit/s) for maksimal stabilitet dersom du har nettverkskabel i nærheten.

* Bluetooth: Innebygd Bluetooth 5.0 (BLE), som også gjør det mulig å hente data fra trådløse Bluetooth-temperatursensorer.

* Micro-HDMI-porter

* * Du må ha enten en Micro-HDMI til HDMI-kabel eller et lite Micro-HDMI til HDMI-adapter for å koble den til en vanlig TV eller dataskjerm

* Du kan kjøre en webtjener (som Nginx, Apache eller direkte via Grafana/Home Assistant) og aksessere den på lokalnettet eller over internett via port 80 (HTTP) eller 443 (HTTPS).


Raspberry Pi 4 offisielt deksel, rød/hvit

https://www.dustin.no/product/5020006823/4-case---redwhite-for-rpi-4



## Sensor 

Siden du vil unngå kabler, er Bluetooth Low Energy (BLE) eller Wi-Fi den enkleste løsningen. Da trenger du ikke koble noe direkte til GPIO-stiftene på Pi-en – alt leses av trådløst over nettverket eller antenne

* blåtann, wifi


Anbefalte modeller (Bluetooth / Wi-Fi)

Xiaomi Mijia Thermometer 2 (Bluetooth / BLE):

* Hva det er: Meget billig og populær liten sensor med e-ink/LCD-skjerm.

* Hvordan den fungerer: Sender kontinuerlig temperatur og fuktighet via BLE. Raspberry Pi 4 har innebygd Bluetooth og kan snappe opp målingene i bakgrunnen uten at sensoren må parres manuelt.

RuuviTag (Bluetooth / BLE):

* Hva det er: Finskbygd, robust og vanntett sensorknapp.

* Hvordan den fungerer: Ekstremt god rekkevidde og høy presisjon på temperatur, fuktighet og lufttrykk. Sender åpne BLE-data som Pi-en enkelt leser av.

Shelly Plus H&T (Wi-Fi):

* Hva det er: Trådløs sensor som kobles direkte på Wi-Fi-nettet ditt.

* Hvordan den fungerer: Sender måledata direkte til Pi-en over lokalnettet via MQTT eller HTTP (REST API). Krever ingen Bluetooth-rekkevidde, bare Wi-Fi-dekning.

Inkbird IBS-TH2 (Bluetooth):

* Hva det er: Kompakt BLE-temperatursensor (fås også i versjon med ekstern probekabel dersom du vil måle direkte i jorda).

Get data

* Python-skript: Du kan bruke biblioteker som bleak eller bluepy i Python for å lytte på BLE-signaler fra f.eks. Xiaomi eller RuuviTag og lagre dataene direkte.

* MQTT: Shelly-sensoren kan konfigureres i eget webgrensesnitt til å sende målinger direkte til en Mosquitto MQTT-broker som kjører på Raspberry Pi-en din.

* Home Assistant / BleAutomator: Kjører du Home Assistant på Pi-en, oppdager den automatiske BLE-sensorer i nærheten uten at du trenger å skrive kode.

## IOT

* Python: Kjører out-of-the-box på Raspberry Pi OS. Du kan begynne å skrive skripter for å lese av temperatur- og fuktighetssensorer med én gang uten å installere noe ekstra miljø.

Med 4 GB RAM og 64 GB lagring har du massevis av overskudd. Du kan kjøre følgende direkte på brikken:

* Grafana: For å lage dæsjbord og visualisere temperaturutviklingen over tid.

* Tidsseriedatabase (InfluxDB / Prometheus): For effektiv lagring av alle temperaturmålingene dine.

* Home Assistant: Hvis du vil automatisere vanning, vekstlys eller varme basert på målingene.

* MQTT-broker (Mosquitto): Hvis du vil koble til flere trådløse sensorer etter hvert.

## Docs

https://www.raspberrypi.com/documentation/computers/getting-started.html

## Slik installerer du OS trinn for trinn

1. Last ned verktøyet: Gå til raspberrypi.com/software og last ned og installer Raspberry Pi Imager på PC-en din. Download for windows. Installer og kjøre det deretter som admin.

2. Koble til minnekortet: Sett Kingston 64GB-microSD-kortet inn i SD-kortadapteren, og plugg det i PC-en.

Velg enhet og system i Imager:

1. Choose Device: Velg Raspberry Pi 4.

2. Choose OS: Velg Raspberry Pi OS (64-bit).

3. Choose Storage: Velg minnekortet ditt.

Tilpass innstillinger (viktig for hodeløs oppstart): Når programmet spør om du vil bruke forhåndsinnstillinger (OS Customisation), velg Edit Settings:

1. Sett et valgfritt brukernavn og passord. (view bitw).

2. Huk av for trådløst nettverk, og skriv inn Wi-Fi-navn (SSID), passord og landkode NO.

3. Gå til fanen for tjenester (Services) og aktiver SSH (med passordautentisering).

Skriv til kortet: Trykk Save og deretter Yes for å starte formateringen og skrivingen.

Når det er ferdig, tar du ut kortet, setter det inn i Raspberry Pi 4, og kobler til strømmen. Gi den et par minutter til å koble seg til Wi-Fi, så er du klar til å koble til via SSH!

![Install os](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/os.png)

## Koble til


Vi kjører et enkelt PowerShell-skript som vasker hele subnettet og lister ut alle aktive IP-adresser på nettverket ditt

```ps1
Get-NetNeighbor -AddressFamily IPv4 | Where-Object { $_.State -ne "Unreachable" -and $_.IPAddress -like "192.168.10.*" } | Select-Object IPAddress, LinkLayerAddress

# da skal du finne en ny ip adresse, 
# evt trekk ut strøm fra raspberry pi og sette den tilbake igjen
```

Ping

```ps1
ping mira1.local
```

Koble til

```bash
ssh chilliman@mira1.local

uname -a
Linux mira1 6.18.34+rpt-rpi-v8 #1 SMP PREEMPT Debian 1:6.18.34-1+rpt1 (2026-06-09) aarch64 GNU/Linux

free -h
top -d 5


df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            1.6G     0  1.6G   0% /dev
tmpfs           760M  9.1M  751M   2% /run
/dev/mmcblk0p2   57G  6.6G   48G  13% /
tmpfs           1.9G  224K  1.9G   1% /dev/shm
tmpfs           5.0M   16K  5.0M   1% /run/lock
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs           1.9G  4.0K  1.9G   1% /tmp
/dev/mmcblk0p1  505M   87M  418M  18% /boot/firmware
tmpfs           380M   64K  380M   1% /run/user/1000
tmpfs           1.0M     0  1.0M   0% /run/credentials/getty@tty1.service

ip address show
# 192.168.10.212

exit

ssh chilliman@192.168.10.212

# oppdater
sudo apt update

# kjør oppgradering, det tar litt tid
sudo apt upgrade


df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            1.6G     0  1.6G   0% /dev
tmpfs           760M  9.1M  751M   2% /run
/dev/mmcblk0p2   57G  7.2G   48G  14% /
tmpfs           1.9G  224K  1.9G   1% /dev/shm
tmpfs           5.0M   16K  5.0M   1% /run/lock
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs           1.9G  4.0K  1.9G   1% /tmp
/dev/mmcblk0p1  505M   79M  426M  16% /boot/firmware
tmpfs           380M   64K  380M   1% /run/user/1000
tmpfs           1.0M     0  1.0M   0% /run/credentials/getty@tty1.service

```



## Grafana

```bash
# 1. Installer nødvendige verktøy
sudo apt install -y apt-transport-https wget gpg

# 2. Opprett nøkkelmappe og last ned Grafana sin GPG-nøkkel
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# 3. Legg til Grafana-arkivet i kildelisten
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Oppdater
sudo apt update

# Pakken grafana: Open Source Edition (OSS) – gratis å bruke til alle formål.
sudo apt install grafana


# Aktiver
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Sjekk running

sudo systemctl status grafana-server

grafana-server.service - Grafana instance
     Loaded: loaded (/usr/lib/systemd/system/grafana-server.service; enabled; preset: enabled)
     Active: active (running) since Tue 2026-08-25 18:32:12 CEST; 5s ago

```

Besøk Grafana

* http://192.168.10.212:3000

* http://mira1.local:3000/login

admin (se bitw)

## Grafana ssl https://mira1.local:3000/

```bash
sudo mkdir -p /etc/grafana/certs

cd /etc/grafana/certs

sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout grafana.key \
  -out grafana.crt \
  -subj "/CN=mira1.local"

sudo chown -R grafana:grafana /etc/grafana/certs
sudo chmod 600 grafana.key
sudo chmod 644 grafana.crt


sudo nano /etc/grafana/grafana.ini

# remove ; before parameter
# protocol = https
# add:
# cert_file = /etc/grafana/certs/grafana.crt
# cert_key = /etc/grafana/certs/grafana.key


sudo systemctl restart grafana-server
sudo systemctl status grafana-server

● grafana-server.service - Grafana instance
     Loaded: loaded (/usr/lib/systemd/system/grafana-server.service; enabled; preset: enabled)
     Active: active (running) since Tue 2026-08-25 21:49:33 CEST; 3s ago

```
## Grafana monitorer localhost med prometheus-node-exporter


```bash
sudo apt update
sudo apt install -y prometheus prometheus-node-exporter

# Start og aktiver tjenestene
sudo systemctl enable --now prometheus
sudo systemctl enable --now prometheus-node-exporter

# sjekk den
sudo systemctl status prometheus-node-exporter

prometheus-node-exporter.service - Prometheus exporter for machine metrics
     Loaded: loaded (/usr/lib/systemd/system/prometheus-node-exporter.service; enabled; preset: enabled)
     Active: active (running) since Tue 2026-08-25 18:37:58 CEST; 44s ago
```

Koble til i Grafana


* Åpne Grafana i nettleseren ([http://192.168.10.212:3000](http://192.168.10.212:3000)).

* Gå til Connections (tannhjul/meny i venstremenyen) Data sources Add data source.Velg Prometheus.

* I feltet Prometheus server URL, Skriv inn:

http://localhost:9090

Rull helt ned og trykk på Save & test. Du skal få en grønn melding som bekrefter at datakilden fungerer.


![prom](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/prom.png)

Importer et ferdig Raspberry Pi / Node Exporter Dashboard

I stedet for å bygge grafer manuelt, kan du importere et ferdig dashboard som viser alt av helsedata:

* I Grafana, klikk på + (Create / Import) øverst til høyre eller i sidemenyen, og velg Import dashboard.

![import](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/import.png)


* I feltet Import via grafana.com, skriv inn ID: 1860 (et populært Node Exporter Full dashboard) og trykk Load

![1860](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/1860.png)


* (Velg Prometheus under Select a Prometheus data source)

* Trykk Import, ja

Nå har du et fullstendig helse-dashboard som viser CPU-belastning, RAM-bruk, disker, temperaturer og nettverkstrafikk direkte fra localhost


![dash](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/dash.png)

Det er predefinert oppsett.


![dash2](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/dash2.png)

## Slå av Raspberry pi


```bash
sudo shutdown -h now
```

Vent ca. 10–15 sekunder til det grønne lyset slutter å blinke helt og kun det røde lyset lyser fast (eller slukker). Da kan du trygt ta ut USB-C-kabelen.



## Zigbee

Når målet er å bygge ut et enhetlig økosystem fra én temperaturmåler til fuktighet, bevegelse og andre sensorer over tid, står valget i praksis mellom tre hovedprotokoller


Zigbee (Mest populær for universelt sensornettverk):

* Hvorfor den brukes: Den absolutt mest brukte protokollen for trådløse batteridrevne sensorer (Aqara, Sonoff, IKEA Tradfri, Philips Hue).

* Arkitektur: Danner et mesh-nettverk der strømforsynte enheter (som smartplugger) fungerer som repeatere.

* Sensorutvalg: Gigantisk utvalg av rimelige temperatur-, fuktighets-, bevegelses-, dør/vindu- og lekkasjesensorer.

* Krav: Krever en USB Zigbee-dongel (f.eks. Sonoff Zigbee 3.0 USB Dongle Plus til ca. 200–300 kr) plugget i Raspberry Pi-en.

Wi-Fi (Enkelt i starten, men krevende på sikt)

BLE / Bluetooth Low Energy (Billigst for temperatur, begrenset for bevegelse)

* Hvorfor den brukes: Ekstremt billige temperatursensorer (f.eks. Xiaomi Mijia eller Govee til under en hundrelapp).

* Begrensninger: Dårlig rekkevidde gjennom vegger, danner ikke mesh, og utvalget av bevegelsessensorer og annet tilbehør er marginalt sammenlignet med Zigbee.



1. USB Zigbee Co-ordinator (Coordinator/Dongel)

Funksjon: Plugges direkte inn i en av USB-portene på Raspberry Pi-en (mira1). Den fungerer som antenne og radio-gateway for nettverket ditt

2. Trådløs Zigbee-temperatursensor

Når du har plugget inn USB-dongelen, installerer vi Zigbee2MQTT på Raspberry Pi-en.

