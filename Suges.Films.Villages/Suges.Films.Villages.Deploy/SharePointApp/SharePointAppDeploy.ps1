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
#   This script collects all SharePoint app packages from the build drop folder
#   and deploys them to the SharePoint server which defined in parameters.ps1 
#   file.
#------------------------------------------------------------------------------

Param (
    [Parameter(Mandatory = $false)]
    [string]$summaryFile
)

# Change path to load other PowerShell files
cd "$(Split-Path $MyInvocation.MyCommand.Path)"

. .\Parameters.ps1
. ..\Common.ps1
. .\DeploymentFunctions.ps1

try {
    Write-Host "Connecting to $SharePointDeployServerUrl..."
    $clientContext = Create-SharePointClientContext $SharePointDeployServerUrl $SpDeployUserDomain $SpDeployUsername $SpDeployPassword 
        
    $web = $clientContext.Web
    $clientContext.Load($web)
    $clientContext.ExecuteQuery()

    # Deploy all app packages
    Get-AppPackages "C:\agent\_work\2\s\Suges.Films.Villages\" | Install-App $clientContext $web $summaryFile

   
}
catch {
    Write-Error "Error occurred: " $_.Exception.ToString()
}