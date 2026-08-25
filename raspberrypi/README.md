
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



## Sesorer 

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

1. Last ned verktøyet: Gå til raspberrypi.com/software og last ned og installer Raspberry Pi Imager på PC-en din. Download for windows.

2. Koble til minnekortet: Sett Kingston 64GB-microSD-kortet inn i SD-kortadapteren, og plugg det i PC-en.

Velg enhet og system i Imager:

1. Choose Device: Velg Raspberry Pi 4.

2. Choose OS: Velg Raspberry Pi OS (64-bit).

3. Choose Storage: Velg minnekortet ditt.

Tilpass innstillinger (viktig for hodeløs oppstart): Når programmet spør om du vil bruke forhåndsinnstillinger (OS Customisation), velg Edit Settings:

1. Sett et valgfritt brukernavn og passord. chilliman, Optimus1234.

2. Huk av for trådløst nettverk, og skriv inn Wi-Fi-navn (SSID), passord og landkode NO.

3. Gå til fanen for tjenester (Services) og aktiver SSH (med passordautentisering).

Skriv til kortet: Trykk Save og deretter Yes for å starte formateringen og skrivingen.

Når det er ferdig, tar du ut kortet, setter det inn i Raspberry Pi 4, og kobler til strømmen. Gi den et par minutter til å koble seg til Wi-Fi, så er du klar til å koble til via SSH!

![Install os]()