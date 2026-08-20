
# Rasberry PI OIT



* Raspberry Pi 4 Model B (4GB): Et solid valg.
* Kingston Canvas Select Plus 64GB: Helt riktig valg til denne brukssaken – pålitelig nok til å kjøre operativsystemet og tåle kontinuerlig skriving av loggdata uten å koste skjorta
* Raspberry Pi 27W USB-C Strømforsyning: Denne er beregnet for Pi 5, men fungerer helt fint på Pi 4. Hvis Komplett har den offisielle 15W USB-C-strømforsyningen på lager, sparer du noen få tiere til, men 27W-versjonen du har valgt fungerer helt trygt.

Raspberry Pi 4 offisielt deksel, rød/hvit

https://www.power.no/data-og-tilbehoer/datakomponenter/tilbehoer/raspberry-pi-4-offisielt-deksel-roedhvit/p-3959176/



## DHT22 AM2302 Digital Temperatursensor Temperature Humidity Sensor Replace SHT15 Logger

https://elkim.no/produkt/dht22-am2302-digital-temperatursensor-temperature-humidity-sensor-replace-sht15-logger/


## IOT

* Python: Kjører out-of-the-box på Raspberry Pi OS. Du kan begynne å skrive skripter for å lese av temperatur- og fuktighetssensorer med én gang uten å installere noe ekstra miljø.


Med 4 GB RAM og 64 GB lagring har du massevis av overskudd. Du kan kjøre følgende direkte på brikken:

* Grafana: For å lage dæsjbord og visualisere temperaturutviklingen over tid.

* Tidsseriedatabase (InfluxDB / Prometheus): For effektiv lagring av alle temperaturmålingene dine.

* Home Assistant: Hvis du vil automatisere vanning, vekstlys eller varme basert på målingene.

* MQTT-broker (Mosquitto): Hvis du vil koble til flere trådløse sensorer etter hvert.