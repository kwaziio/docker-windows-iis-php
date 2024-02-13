################################################################
# PowerShell Script for Configuring Windows IIS to Support PHP #
################################################################

Write-Output "Importing the WebAdministration PowerShell Module..."
Import-Module WebAdministration

Write-Output "Creating a New Web Handler for PHP w/ Fast CGI..."
New-WebHandler `
  -Name 'PHP-FastCGI' `
  -Path '*.php' `
  -Verb '*' `
  -Modules 'FastCgiModule' `
  -ScriptProcessor 'C:\\php\\php-cgi.exe' `
  -ResourceType 'Either'

Write-Output "Creating PHP Application Pool Configuration..."
New-Item -Path 'IIS:\AppPools\PHPAppPool'

Write-Output "Updating Managed Runtime Version Configuration for the PHP Application Pool"
Set-ItemProperty -Path 'IIS:\AppPools\PHPAppPool' -Name 'managedRuntimeVersion' -Value ''

Write-Output "Allowing 32-Bit Application Support on 64-Bit Windows..."
Set-ItemProperty -Path 'IIS:\AppPools\PHPAppPool' -Name 'enable32BitAppOnWin64' -Value $true

Write-Output "Adding PHP Application Pool to Default Web Site on IIS..."
Set-ItemProperty -Path 'IIS:\Sites\Default Web Site' -Name 'applicationPool' -Value 'PHPAppPool'

Write-Output "Adding Fast CGI Configuration to IIS Web Server Configuration..."
Add-WebConfiguration "/system.webServer/fastCgi" -value @{fullPath="C:\\php\\php-cgi.exe"}

Write-Output "Creating Default (Empty) PHP Index File for Validation..."
"<?php phpinfo(); ?>" | Set-Content C:\\inetpub\wwwroot\index.php

Write-Output "Making 'index.php' the Default Document for All IIS Applications..."
Add-WebConfigurationProperty -PSPath "MACHINE/WEBROOT/APPHOST" -Filter "system.webServer/defaultDocument/files" -Name "." -Value @{value="index.php"}
