#!/bin/bash
mvn nsis:generate-headerfile
mvn nsis:make -Dnsis.scriptfile=target/nsis/installer.nsi
