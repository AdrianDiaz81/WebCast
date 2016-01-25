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
#   Parameters needed for deployment of mail app packages and web packages.
#------------------------------------------------------------------------------

# Exchange account used to deploy the app.
$UserName = ""
$Password = ""

# The URL of remote Windows PowerShell endpoint of the target exchange server. (e.g. https://ps.outlook.com/powershell/)
$DeployExchangeServerUrl = ""

# User name and password to connect to the target web deployment server.
# The account must be in the administrator group for remote deployment.
$WebDeployUsername = ""
$WebDeployPassword = ""

# The target web deployment server name (not URL).
$WebDeployServerName = ""