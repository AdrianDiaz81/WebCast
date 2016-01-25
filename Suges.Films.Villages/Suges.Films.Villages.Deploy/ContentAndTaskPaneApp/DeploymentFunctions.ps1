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
#   This script contains functions to upload an office app manifest file to a
#   corporate app catalog SharePoint site.
#------------------------------------------------------------------------------

function Upload-AppManifest($clientContext, $web, $summaryFile) {
    process {
        $appManifest = $_
        $appName = [System.IO.Path]::GetFileNameWithoutExtension($appManifest)

        Write-Host "Start to upload $appName..."

        $fci = new-object Microsoft.SharePoint.Client.FileCreationInformation
        $fci.Overwrite = $true
        $fci.Content = Get-Content -Encoding byte -path $appManifest
        $fci.Url = "$($SharePointDeployServerUrl.TrimEnd('/'))/AgaveCatalog/$appName"
        $appsForOfficeList = $web.Lists.GetByTitle("Apps for Office")
        $file = $appsForOfficeList.RootFolder.Files.Add($fci)
        $clientContext.Load($file)
        $clientContext.ExecuteQuery()
        
        # Append links to build log and summary file.
        Write-Summary $appName $summaryFile
    }
}

function Write-Summary($appName, $summaryFile) {
    $nl = [Environment]::NewLine

    $summary = "App ""$appName"" was uploaded successfully.$nl"
    $summary += "    Open the app catalog at: $(Create-Link "$($SharePointDeployServerUrl.TrimEnd('/'))/AgaveCatalog/")$nl"

    if ($summaryFile) {
        $summary | Tee-Object -FilePath $summaryFile -Append
    }
    else {
        Write-Host $summary
    }
}