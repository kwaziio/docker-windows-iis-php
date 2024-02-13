#############################################################
# Base Microsoft Windows Server Core Image w/ IIS Installed #
#############################################################

FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

###############################################################
# Build Arguments for Visual C++ Redistributable Installation #
###############################################################

ARG VC_URL="https://aka.ms/vs/16/release/vc_redist.x64.exe"

############################################################################
# Downloads and Installs Visual C++ Redistributable for Visual Studio 2017 #
############################################################################

ADD ${VC_URL} C:\\vc_redist.x64.exe
RUN C:\\vc_redist.x64.exe /quiet /install

########################################
# Build Arguments for PHP Installation #
########################################

ARG PHP_VERSION="7.4.33"
ARG PHP_URL="https://windows.php.net/downloads/releases/php-${PHP_VERSION}-Win32-vc15-x64.zip"

##################################
# Downloads Official PHP Archive #
##################################

ADD ${PHP_URL} C:\\php.zip

########################################
# Installs Required Windows Feature(s) #
########################################

RUN powershell -Command \
  Install-WindowsFeature Web-CGI; \
  Install-WindowsFeature Web-Asp-Net45

#############################################
# Copies Custom PowerShell Scripts to Image #
#############################################

COPY scripts C:\\scripts

#############################################
# Installs PHP via Custom PowerShell Script #
#############################################\

RUN powershell -File C:\\scripts\\Install-PHP.ps1

###############################################
# Configures PHP via Custom PowerShell Script #
###############################################

RUN powershell -File C:\\scripts\\Configure-PHP.ps1

#################################################
# Configures Windows IIS to Handle PHP Requests #
#################################################

RUN powershell -File C:\\scripts\\Configure-IIS.ps1

#############################
# Updates Working Directory #
#############################

WORKDIR C:\\inetpub\\wwwroot

############################
# Exposes Required Port(s) #
############################

EXPOSE 80
