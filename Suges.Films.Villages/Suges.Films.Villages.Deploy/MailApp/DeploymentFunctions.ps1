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
#   This script contains functions used to install/uninstall office mail apps.
#------------------------------------------------------------------------------

function Create-PSSession($userName, $password, $exchangeServerUrl) {
    $securePassword = ConvertTo-SecureString $password -AsPlainText -force
    $credential = New-Object System.Management.Automation.PsCredential($userName, $securePassword)
    $sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
    $session = New-PSSession -ConfigurationName Microsoft.Exchange -SessionOption $sessionOption -ConnectionUri $exchangeServerUrl -Authentication Basic -Credential $credential -AllowRedirection
    return $session
}

function Install-MailApp($summaryFile) {
    process {
        $appManifest = $_
        $appName = [System.IO.Path]::GetFileNameWithoutExtension($appManifest)

        Write-Host "Start to install app $appName..."

        $appId = Get-MailAppId $appManifest
        if (!$appId) {
            Write-Error "Cannot find product Id of app $appName"
            Continue
        }

        # Try to uninstall existing app first.
        Uninstall-MailApp $appId

        Write-Host "Installing app $appName..."
        $data = Get-Content -Path $appManifest -Encoding Byte -ReadCount 0
        New-App -FileData $data -Confirm:$False | out-null
       
        # Append links to build log and summary file.
        Write-Summary $appName $summaryFile
    }
}

function Uninstall-MailApp($appId) {
    $app = Get-App | Where-Object { $_.AppId -eq $appId }
    
    if ($app) {
        Write-Host "Uninstalling mail app with id $appId..."
        Remove-App -Identity $appId -Confirm:$False
        Write-Host "Mail app was uninstalled successfully."
    }
}

function Get-MailAppId($appManifest) {
    $manifestXml = [xml](Get-Content $appManifest)
    $appId = $manifestXml.OfficeApp.Id
    return $appId
}

function Write-Summary($appName, $summaryFile) {
    $nl = [Environment]::NewLine

    $summary = "App ""$appName"" was installed successfully.$nl"

    if ($summaryFile) {
        $summary | Tee-Object -FilePath $summaryFile -Append
    }
    else {
        Write-Host $summary
    }
}