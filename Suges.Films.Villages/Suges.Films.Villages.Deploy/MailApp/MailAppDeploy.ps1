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
#   This script collects all mail app manifest files from the build drop 
#   folder and deploys them to the exchange server which defined in 
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
    try {
        # Create PowerShell remote session to the exchange server and do app manifest deployments.
        Write-Host "Connecting to exchange server $DeployExchangeServerUrl"
        $session = Create-PSSession $UserName $Password $DeployExchangeServerUrl
        Import-PSSession $session -AllowClobber | out-null

        # Deploy all app manifests
        Get-OfficeAppManifests $dropLocation | Install-MailApp $summaryFile
    }
    finally {
        if ($session) {
            Remove-PSSession $session
            Write-Host "PowerShell remote session closed."
        }
    }

    if ($WebDeployServerName) {
        # Deploy all web applications
        Get-WebDeployScripts $dropLocation | Run-WebDeployScript $WebDeployServerName $WebDeployUsername $WebDeployPassword
    }
}
catch {
    Write-Error "Error occurred: " $_.Exception.ToString()
}