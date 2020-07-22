FROM productize/kicad:5.0.1-18.04
MAINTAINER Seppe Stas <seppe@productize.be>
LABEL Description="Base image with all dependencies and environment for KiCad automation scripts"

COPY src/requirements.txt .
RUN apt-get -y update && \
    apt-get install -y python2.7 python-pip xvfb recordmydesktop xdotool xclip tree x11-utils && \
    pip2 install -r requirements.txt && \
    rm requirements.txt && \
    apt-get -y remove python-pip && \
    rm -rf /var/lib/apt/lists/*

# Use a UTF-8 compatible LANG because KiCad 5 uses UTF-8 in the PCBNew title
# This causes a "failure in conversion from UTF8_STRING to ANSI_X3.4-1968" when
# attempting to look for the window name with xdotool.
ENV LANG C.UTF-8

# Copy default configuration and fp_lib_table to prevent first run dialog
COPY ./config/* /root/.config/kicad/
COPY __init__.py /usr/lib/python2.7/dist-packages/kicad-automation/
COPY src /usr/lib/python2.7/dist-packages/kicad-automation
