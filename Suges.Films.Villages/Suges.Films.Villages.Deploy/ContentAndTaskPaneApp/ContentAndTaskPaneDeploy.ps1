#------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation.  All rights reserved.
#
# Licensed under the Microsoft Limited Public License (the "License");
# you may not use this file except in compliance with the License.
# A full copy of the license is provided in the root folder of the 
# project directory.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Description:
#   This script collects all office app manifest files from the build drop 
#   folder and uploads them to the corporate app catalog site defined in the 
#   parameters.ps1 file.
#------------------------------------------------------------------------------

Param (
    [Parameter(Mandatory = $True)]
    [string]$dropLocation,
    [Parameter(Mandatory = $false)]
    [string]$summaryFile
)

# Change path to load other PowerShell files
cd "$(Split-Path $MyInvocation.MyCommand.Path)"

. ./Parameters.ps1
. ../Common.ps1
. ./DeploymentFunctions.ps1

try {
    Write-Host "Connecting to $SharePointDeployServerUrl..."
    $clientContext = Create-SharePointClientContext $SharePointDeployServerUrl $SpDeployUserDomain $SpDeployUsername $SpDeployPassword 
    
    $web = $clientContext.Web
    $clientContext.Load($web)
    $clientContext.ExecuteQuery()

    # Deploy all app packages
    Get-OfficeAppManifests $dropLocation | Upload-AppManifest $clientContext $web $summaryFile

    if ($WebDeployServerName) {
        # Deploy all web applications
        Get-WebDeployScripts $dropLocation | Run-WebDeployScript $WebDeployServerName $WebDeployUsername $WebDeployPassword
    }
}
catch {
    Write-Error "Error occurred: " $_.Exception.ToString()
}