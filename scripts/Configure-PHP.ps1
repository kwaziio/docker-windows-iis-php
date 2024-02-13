##############################################################
# PowerShell Script for Configuring Previously Installed PHP #
##############################################################

Write-Output "Creating New PHP INI File from Production Template..."
$ini = "C:\\php\\php.ini"
Copy-Item -Path C:\\php\\php.ini-production -Destination "C:\\php\\php.ini"

Write-Output "Overriding Default Values in PHP INI File..."
(Get-Content $ini).Replace('; extension_dir = "ext"', 'extension_dir = "C:\\php\\ext"') | Set-Content $ini
(Get-Content $ini).Replace('; extension=mbstring', 'extension=mbstring') | Set-Content $ini
(Get-Content $ini).Replace('; extension=mysqli', 'extension=mysqli') | Set-Content $ini
(Get-Content $ini).Replace('; extension=curl', 'extension=curl') | Set-Content $ini
(Get-Content $ini).Replace('; cgi.force_redirect = 1', 'cgi.force_redirect = 0') | Set-Content $ini
(Get-Content $ini).Replace('; cgi.fix_pathinfo=1', 'cgi.fix_pathinfo=0') | Set-Content $ini
(Get-Content $ini).Replace('; fastcgi.impersonate = 1', 'fastcgi.impersonate = 1') | Set-Content $ini
(Get-Content $ini).Replace('; fastcgi.logging = 0', 'fastcgi.logging = 0') | Set-Content $ini
