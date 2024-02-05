using namespace System.Data
using namespace System.Management.Automation
using module "..\util\Logger.psm1"
using module "..\util\ErrorLog.psm1"
Import-Module "$($PSScriptRoot)\..\helpers\helpers.psm1"

class Connection {
    [String]$server = $null
    [String]$database = $null
    [Logger]$logger = $null
    [ErrorLog]$errorLog = $null

    Connection([Logger]$logger, [ErrorLog]$errorLog) {
        $this.logger = $logger
        $this.errorLog = $errorLog
        $this.server = 'PBIBAZSQL2'
        $this.database = 'GIGINSDATA'
        $this.testConnection()
    }

    Connection([Logger]$logger, [ErrorLog]$errorLog, [String]$server, [String]$database) {
        $this.logger = $logger
        $this.errorLog = $errorLog
        $this.server = $server
        $this.database = $database
        $this.testConnection()
    }

    [DataSet]get([String]$query) {
        [DataSet]$results = $null
        try {
            $connectionString = 'Server={0};Database={1};Trusted_Connection=True' -f $this.server, $this.database
            $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
            $sqlConnection.Open()
            $sqlcmd = $sqlConnection.CreateCommand()
            $sqlcmd.CommandText = $query
            $sqlcmd.CommandTimeout = 5000
            $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
            $results = New-Object System.Data.DataSet
            $adp.Fill($results) | Out-Null
        }
        catch {
            $this.handleException($_)
        }
        return $results
    }

    [void]testConnection() {
        try {
            Write-Host 'Testing DB Connection...'
            $connectionString = 'Server={0};Database={1};Trusted_Connection=True' -f $this.server, $this.database
            $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
            $sqlConnection.Open()
            Write-Host 'Success!'
            $sqlConnection.Close()
        }
        catch {
            # $response = $false
            Write-Host 'Unable to connect to database...'
            Write-Host 'Aborting...'
            $this.handleException($_)
        }
    }

    [void]handleException([ErrorRecord]$err) {
        [system.exception]
        $this.errorLog.databaseError($err)
        Close-App -logger $this.logger -level 3
    }
}
