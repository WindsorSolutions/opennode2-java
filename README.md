# OpenNode 2 Java

This is the project for the Java version of the OpenNode 2 product. This project contains both the OpenNode 2 
application itself as well as all of the plugins developed for OpenNode 2. Keeping the plugins in the same repository
as the product ensures that the plugins will at least compile against the current version of ON2.

## Configuring

There are a couple of places where you will need to configure some settings to that OpenNode2 can function correctly. 
When Maven is building the project, it will try to match the name of the running profile (i.e. "dev" or "docker") with 
a properties file inside the OpenNode2 administration web application. This is done so that you have a project that 
you may immediately run. These properties files contain the URL to your database server, credentials for sending email, 
etc.

Templates for these files are provided in order to get your started, they are in `node-ng/node-web/src/main/resources`
and their file names end with `.template`.

For example, you might run the following shell scripts to create copies of the template files.

    cd node-ng/node-web/src/main/resrouces
    cp application-dev.properties.sample application-dev.properties
    cp application-docker.properties.sample application-docker.properties
    
From there you can edit these files so that they match your environment. The same steps should be performed for the 
files in `resources/distribution-overlay-debug/conf` and `resources/distribution-overlay-dev/conf`. 
    
## Building

The project uses Maven to manage the project, build artifacts, etc. By default Maven will build the product with the 
"development" profile, meaning that the log files will be as informative as possible. To build the project, simply
invoke Maven in the project's top-level directory.

    mvn clean install
    
To build a version suitable for production deployment, tell Maven to use the production profile.

    mvn -Pprod clean install
    
    