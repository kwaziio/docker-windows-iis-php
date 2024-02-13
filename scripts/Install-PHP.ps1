###############################################################
# PowerShell Script for Installing PHP via Downloaded Archive #
###############################################################

Write-Output "Extracting Downloaded PHP Archive..."
Expand-Archive -Path C:\\php.zip -DestinationPath C:\\php

Write-Output "Removing Temporary Download Artifact..."
Remove-Item -Path C:\\php.zip

Write-Output "Adding PHP Installation Directory to Machine Path..."
$path = $env:path + ";C:\\php"
[Environment]::SetEnvironmentVariable("PATH", $path, [EnvironmentVariableTarget]::Machine)
