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
#   Common utility functions shared by office app deployment scripts.
#------------------------------------------------------------------------------

function Get-OfficeAppManifests($dropLocation) {
    return Get-ChildItem -Path $dropLocation -Directory "OfficeAppManifests" -Recurse |
           Get-ChildItem -Include "*.xml" |
           Select-Object -Expand FullName
}

function Get-WebDeployScripts($dropLocation) {
    return Get-ChildItem -Path $dropLocation -Include "*.web.deploy.cmd" -Recurse
}

function Run-WebDeployScript($serverName, $userName, $password) {
    process {
        try {
            Write-Host "Installing web application by running $_..."

            & $_ /Y /M:$serverName /U:$userName /P:$password
        }
        catch {
            Write-Error "Error occurred while deploying web application: " $_.Exception.ToString()
        }
    }
}

function Create-SharePointClientContext($serverUrl, $domain, $username, $password) {
    Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

    [Microsoft.SharePoint.Client.ClientContext]$cc = New-Object Microsoft.SharePoint.Client.ClientContext($serverUrl)

 Write-Host "Connecting End"
        $securePwd = ConvertTo-SecureString $password -AsPlainText -force
        [Microsoft.SharePoint.Client.SharePointOnlineCredentials]$spocreds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $securePwd)
        $cc.Credentials = $spocreds
     Write-Host "Connecting Finished"
    return $cc
}

function Create-Link($link, $text) {
    if ($text) {
        return "[$text]($link)"
    }
    else {
        return "[$link]($link)"
    }
}
