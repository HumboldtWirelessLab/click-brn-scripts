--------------------------------------------------------------------------------------------------------------------------
						Administrations-Werkzeuge
--------------------------------------------------------------------------------------------------------------------------

 Skript "admin_measurement_directories.sh" 
 -----------------------------------------

 - dient dazu die einzelnen Ordner (1,2,3,4,etc.), die durch die Simulation oder Testbed-Messungen von der Click-Software erzeugt werden, in einem Verzeichnis mit dem aktuellen Datum und Uhrzeit ("%Y"-"%m"-"%d"_"%H":"%M":"%S"; siehe date ("man date")) zu verwalten.

- Aufruf "./admin_measurement_directories.sh [Ort_der_Ergebnisdateien]"

* Aufruf z. B. "admin_measurement_directories.sh ../"
** Daraus folgt, dass im übergeordnetem Verzeichnis ein Ordner mit dem aktuellem Datum und Uhrzeit generiert wird und die Ergebnisse der Simulation und des Testbeds in das neu genierte Vezeichnis verschoben werden.

Skript "admin_rm_directories.sh" 
--------------------------------
- manchmal möchte man einfach die Verzeichnisse der  Messergebnisse, die durch die Simulation oder Testbed-Messung erzeugt worden sind, löschen ohne die Dateien und anderen Verzeichnisse im aktuellen Verzeichnis zu löschen. Zum Löschvorgang gehören alle Verzeichnisse, die diese Struktur haben: "1/", "2/", "3/" ,...
 
- Aufruf "./admin_rm_directories.sh [Ort_der_Verzeichnise]"
* z. B. Aufruf "./admin_rm_directories.sh ../"

Skript "admin_measurement.sh"
-----------------------------

- dient zur "schnellen" Generierung von Informationen über die auszuwertenden Messungen in einer Datei "debug.txt"

Aufruf "admin_measurement.sh [Ort der Messergebnisse]"

* Aufruf z. B. "./admin_measurement.sh ../" 

oder ein bestimmtes Verzeichnis, das beispielsweise mit dem  Skript "admin_measurement_directories.sh" generiert worden ist

* Aufruf z. B. "./admin_measurement.sh ["%Y"-"%m"-"%d"_"%H":"%M":"%S"]"

--------------------------------------------------------------------------------------------------------------------------
						Auswertungs-Werkzeuge
--------------------------------------------------------------------------------------------------------------------------

Skript "eval.sh"
----------------

- verwendet das Skript "eval_helper.sh", wobei "eval_helper.sh" das Skript "drop_nsfiles.sh"  und die XML-Datei "channelload.xslt" verwendet.

- dient zur Evaluierung/Auswertung der Messergebnisse und verwendet relative Pfade zur Auswertung der Messergebnisse, d. h. es ist keine feste Verzeichnisstruktur nötig. Der Vorteil hierbei ist, dass die Messergebnisse in beliebige Verzeichnisse auf beliebge Rechner verschoben werden können, z. B. alle Messergebnisse vom Testbed-Server auf den eigenen Rechner herunterladen und die Ergebnisse mit dem eigenen Rechner evaluieren.

* Aufruf "./eval_helper.sh [Zielverzeichnis]"

** Aufruf z. B. "./eval_helper.sh ../"

** Aufruf z. B. "./eval_helper.sh ["%Y"-"%m"-"%d"_"%H":"%M":"%S"]"
*** im konkreten Fall z. B. ./eval.sh ../2013-04-20_13:56:39

* Erzeugt/Generiert dann die folgenden wichtigen Dateien im [Zielverzeichnis], 
wobei beim Aufruf von  "./eval_helper.sh ../" dich die Dateien im aktuellen Verzeichnis befinden:
1. inrange_mat.header           - Gibt eine Erklärung über die  einzelnen Spalten der CSV-Datei "inrange.mat" an
2. inrange.mat                  - Ergebnisse der Auswertung für die Simulation oder das Testbed
3. measurement_debugging.xml    - Enthält einige Debugging-Inforamtionen über die Auswertung der Simulation oder des Testbeds
