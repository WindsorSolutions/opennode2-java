# ICIS AIR Data Loader

The project provides an OpenNode2 plugin (compatible with version 2.15 and 
newer) that can read in the custom file format provided by Ohio EPA and
then load that data into a set of staging tables. Once the data is in the
staging tables the regular OpenNode2 ICIS Air plugin may be used to process
that data and send it to the EPA.

## Where does this data come from?

This Ohio ICIS Air data file comes from their STARS system. The STARS system
provides a web services that has a series of endpoints, each of these endpoints
provides a different ICIS Air payload. Ohio has another project, the 
"Web Daemon", that collects these payload files and stores them on disk in a 
location accessible to the OpenNode2 instance. Once web daemon has completed
donwloading the files this plugin may be run; it will read through those files
and then stage them for the OpenNode2 ICIS Air plugin.
