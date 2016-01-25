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
#   This script contains functions used to install/uninstall SharePoint apps.
#------------------------------------------------------------------------------

function Get-AppPackages($dropLocation) {
    return Get-ChildItem -Path $dropLocation -Include "*.app" -Recurse
}

function Install-App($clientContext, $web, $summaryFile) {
    process {    
        $appPackage = $_
        $appName = [System.IO.Path]::GetFileNameWithoutExtension($appPackage)

        Write-Host "Start to install app $appName..."

        $productId = Get-ProductId $appPackage
        if (!$productId) {
            Write-Error "Cannot find product Id of app $appName."
            return
        }
    
        # Try to uninstall any existing app instances first.
        Uninstall-App $clientContext $web $productId

        Write-Host "Installing app $appName..." 
        $appInstance = $web.LoadAndInstallAppInSpecifiedLocale(([System.IO.FileInfo]$appPackage).OpenRead(), $web.Language)
        $clientContext.Load($appInstance)
        $clientContext.ExecuteQuery()

        $appInstance = WaitForAppOperationComplete $clientContext $web $appInstance.Id

        if (!$appInstance -Or $appInstance.Status -ne [Microsoft.SharePoint.Client.AppInstanceStatus]::Installed) {
            if ($appInstance -And $appInstance.Id) {
                Write-Host "App installation failed. To check app details, go to"
                Write-Link "$($web.Url.TrimEnd('/'))/_layouts/15/AppMonitoringDetails.aspx?AppInstanceId=$($appInstance.Id)"
            }
            throw "App installation failed."
        }

        # Append links to build log and summary file.
        Write-Summary $appName $summaryFile
    }
}

function Uninstall-App($clientContext, $web, $productId) {
    $appInstances = $web.GetAppInstancesByProductId($productId)
    $clientContext.Load($appInstances)
    $clientContext.ExecuteQuery()

    if ($appInstances -And $appInstances.Length -gt 0) {
        $appInstance = $appInstances[0]

        Write-Host "Uninstalling app with instance id $($appInstance.Id)..."
        $appInstance.Uninstall() | out-null
        $clientContext.Load($appInstance)
        $clientContext.ExecuteQuery()

        $appInstance = WaitForAppOperationComplete $clientContext $web $appInstance.Id
        
        # Assume the app uninstallation succeeded
        Write-Host "App was uninstalled successfully."
    }
}

function Get-ProductId($appPackage) {
    Add-Type -AssemblyName System.IO.Compression

    try {
        $zipArchive = New-Object System.IO.Compression.ZipArchive(([System.IO.FileInfo]$appPackage).OpenRead())
        $manifestFileStreamReader =  New-Object System.IO.StreamReader($zipArchive.GetEntry("AppManifest.xml").Open())
        $manifestXml = [xml]$manifestFileStreamReader.ReadToEnd()
        $productId = $manifestXml.App.ProductID
        return $productId;
    }
    finally {
        if ($zipArchive) {
            $zipArchive.Dispose()
        }
        if ($manifestFileStreamReader) {
            $manifestFileStreamReader.Dispose()
        }
    }
    return $null
}

function WaitForAppOperationComplete($clientContext, $web, $appInstanceId) {
    for ($i = 0; $i -le 2000; $i++) {
        try {
            $instance = $web.GetAppInstanceById($appInstanceId)
            $clientContext.Load($instance)
            $clientContext.ExecuteQuery()
        }
        catch [Microsoft.SharePoint.Client.ServerException] {
            # When the uninstall finished, "app is not found" server exception will be thrown.
            # Assume the uninstalling operation succeeded.
            break
        }

        if (!$instance) {
            break
        }

        $result = $instance.Status;
        if ($result -ne [Microsoft.SharePoint.Client.AppInstanceStatus]::Installed -And
            !$instance.InError -And 
            # If an app has failed to install correctly, it would return to initialized state if auto-cancel was enabled
            $result -ne [Microsoft.SharePoint.Client.AppInstanceStatus]::Initialized) {
            Write-Host "Instance status: $result"
            Start-Sleep -m 1000
        }
        else {
            break
        }
    }
    return $instance;
}

function Write-Summary($appName, $summaryFile) {
    $nl = [Environment]::NewLine

    $summary = "App ""$appName"" was installed successfully.$nl"
    $summary += "    Trust the app at: $(Create-Link "$($web.Url.TrimEnd('/'))/_layouts/15/appinv.aspx?AppInstanceId={$($appInstance.Id)}")$nl"
    $summary += "    Open the app at: $(Create-Link "$($web.Url.TrimEnd('/'))/_layouts/15/appredirect.aspx?instance_id=$($appInstance.Id)")$nl"

    if ($summaryFile) {
        $summary | Tee-Object -FilePath $summaryFile -Append
    }
    else {
        Write-Host $summary
    }
}