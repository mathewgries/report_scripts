using namespace System.Data
using namespace System.Collections.Generic
using module ".\server\Connection.psm1"
using module ".\util\Logger.psm1"
using module ".\util\ErrorLog.psm1"
Import-Module -Force ".\scripts\written_and_earned_premium.psm1"
Import-Module -Force "$($PSScriptRoot)\helpers\helpers.psm1"

<#==================================================================================================

CHANGE THE Hihg datas in the calls to Get-States and Get-Premium before running
This needs to run on the local C: drive on a biberk machine

===================================================================================================#>

$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

#================================= SET UP THE DIRECTORIES  =========================================
# Directory variables
# Also to move the files once completed
[String]$user = $env:UserName
[string]$root = (Get-Item $PSScriptRoot).Parent.FullName
[string]$outbound = "${root}\reports"
[String]$script_dir = "$($root)\written_premium\scripts"

[String[]]$report_list = Get-Reports -dir $script_dir

<#==================================================================================================

# NEED TO ADD USER INSTRUCTION HERE VIA OUTPUT

===================================================================================================#>

# [String]$server = $null
# [String]$database = $null

# Write-Host "Enter Server Name"
# $server = Read-Host "Server:"
# Write-Host "Enter Database Name"
# $database = Read-Host "Database:"

# Application objects
# logger - tracks the apps progress to a txt file
# errorLog - This class contains the error message formatting for the Exceptions that are thrown
# conn - Connection to the database for retrieving store info
# [Logger]$logger = $null
# [ErrorLog]$errorLog = $null
# [Connection]$conn = $null

#================================= SET UP THE APPLICATION  =========================================

<#
    Starting here, and ending at :formloop, we are initializing up the application objects
    that we declared above. The logger is created first for tracking the app.
#>

#====================================== SET UP LOGGER  =============================================

# Create the logger for outputting to log files
# $logger = [Logger]::new($root)
# $logger.writeToLog("Starting Process", 1, "`r`n")
# Write-Host "Starting Process..."

#===================================== SET UP ERRORLOG  ============================================

# $logger.writeToLog("Loading ErrorLog module...", 1)
# Write-Host "Loading ErrorLog module..."
# $errorLog = [ErrorLog]::new($logger)
# $logger.writeToLog("ErrorLog module loaded", 1)
# Write-Host "ErrorLog module loaded"

#=================================== VALIDATE DIRECTORES  ==========================================

# try {
#     $logger.writeToLog("Verifying outbound directory", 1)
#     Write-Host "Verifying outbound directory..."
#     if (-NOT (Test-Path -Path $outbound)) {
#         New-Item -Path $outbound -ItemType Directory | Out-Null
#     }
#     $logger.writeToLog("Inbound and outbound directories verified", 1)
#     Write-Host "Outbound directories verified"
# }
# catch {
#     Write-Host "Could not locate outbound directory..."
#     Write-Host "Aborting application..."
#     $errorLog.invalidDirectory($inbound)
#     Close-App -logger $logger -level 3
# }

#======================================= SET UP THE ENVIRONMENT ====================================

# establish a connection to the db server and database
# $logger.writeToLog("Loading Connection module...", 1)
# Write-Host "Loading Connection module..."
# try {
#     $conn = [Connection]::new($logger, $errorLog)
#     $conn.testConnection()
#     $logger.writeToLog("Connection module loaded", 1)
#     Write-Host "Connection module loaded"
# }
# catch {
#     # Do not start if environment is incorrectly set
#     Write-Host "ERROR: Failure loading Connection module..."
#     Write-Host "Please view log files for more information..."
#     Write-Host "Aborting application..."
#     $errorLog.invalidStart($Error[0])
#     Close-App -logger $logger -level 3
# }

<#===================================================================================================

                            Get the data and export it to Excel

====================================================================================================#>

# $carrier_list = 'INCCIC20', 'NYAIIC20'
# $premium_types = 'E', 'W'

# for ($i = 0; $i -lt $carrier_list.Length; $i++) {
#     [String]$carrier = $carrier_list[$i]

#     for ($j = 0; $j -lt $premium_types.Length; $j++) {
#         [String]$premium_type = $premium_types[$j]
#         [String]$full_premium = $null

#         if ($premium_type -eq 'W') {
#             $full_premium = 'Written'
#         } else {
#             $full_premium = 'Earned'
#         }

#         [String]$full_path = "$($outbound)\$($carrier)_$($full_premium)_Premium.xlsx"
#         [DataSet]$results = Get-Premium -conn $conn -carrier $carrier -prem_type $premium_type -low_date '01-01-2017' -high_date '12-31-2023'
#         $results.Tables[0] | Export-Excel -Path $full_path -WorksheetName "$($carrier)_$($full_premium)" -BoldTopRow -NoNumberConversion * -AutoSize -ExcludeProperty ItemArray, RowError, RowState, Table, HasErrors
#     }
# }
