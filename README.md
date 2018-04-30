Oxpath Docker Container

Author: Hendrik Adam hendrik.adam@smail.th-koeln.de

### Requirements:

Docker

oxpath-cli.jar

Specific folder structure:

        root
            input
                < oxpath rule files go here >
            output
                < expect output here >
            oxpath
                oxpath-cli.jar
                wrapper.py
            Dockerfile
            run.sh
            Readme.md



### Building:

###### Linux / Mac:

    Use run.sh to build and execute the Docker Container.
    First edit the paths in the run.sh so they fit to your setup.

###### Windows:

    For Windows execute the commands below from your powershell. Edit them appropriatly.

      docker build -t oxpath:latest PATHTOTHISFOLDER

### Running:

###### Linux / Mac:

    Use run.sh or the commands contained in run.sh

###### Windows:

    docker run -d -it --name=oxpath -v PATHTOTHEINPUTFOLDER:/usr/src/oxpath/input -v PATHTOTHEOUTPUTFOLDER:/usr/src/oxpath/output oxpath:latest

### Usage:

  Place your oxpath-rules in the input folder and wait for the magic to happen.... or the output to appear in the output folder
