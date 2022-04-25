---
title: "Projects"
date: 2022-04-21T19:15:19-07:00
disable_feed: true
---

## fireboard-viewer
[FireBoard](https://www.fireboard.com/) is a commercially-available cloud-connected thermometer array that I use for BBQ. The mobile application to interact with the thermometer is sufficient for most use-cases, however I wanted more control over the temperature plots to do fun things like display the derivative of temperature. So, [fireboard-viewer](https://github.com/cwlucas41/fireboard-viewer) is a simple python script that I hacked together one day while smoking a brisket that interacts with the fireboard API and gives me full access to the temperature data.

## WebDAQ
[WebDAQ](https://github.com/cwlucas41/webDAQ) is an internet of things data acquisition system (DAQ) which enables the DAQ and the client application to be connected through the cloud instead of being physically connected. The project includes hardware and software designs for the DAQ itself to handle processing of the analog signal and converting it to a digital signal, a client application to control the DAQ and view collected samples, and a cloud component to facilitate commands, real time streaming, and persistence of historical signal data.

*WebDAQ was a goup capstone project that counted toward my primary major of Computer Engineering on my Bachelor of Science degree.*

## Context Aware Synonym Suggester (CASS)
[CASS](https://github.com/cwlucas41/CASS) is a synonym suggester for LibreOffice that uses the context of the words and sentences around a target word to help identify the sense/meaning of the target word and then prioritize synonyms with the detected meaning. Word processors including LibreOffice and Microsoft Word don't do a great job of providing useful synonyms for words with multiple meanings. CASS is able to offer better suggestions by applying word sense disambiguation algorithms to the context around the target word.

*CASS was a goup capstone project that counted toward my secondary major of Computer Science on my Bachelor of Science degree.*
