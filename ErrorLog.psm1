using namespace System.Collections.Generic
using module ".\Logger.psm1"


class ErrorLog {
    [int]$errorCount = 0
    [int]$environment = $null
    [Logger]$logger = $null
    
    [String]$fromAddress = 'noreply@freedompay.com'
    [String]$toAddress = 'appsupport@freedompay.com'
    [String]$ccAddress = 'matt.gries@freedompay.com'
    [String]$subject = 'PayPal OnBoard Results'
    [String]$header = '<h1>PayPal OnBoard Process Results</h1>'
    [String]$listBlock = 'list-block'
    [String]$msg = $null

    ErrorLog([Logger]$logger) {
        $this.logger = $logger
    }

    [void]updateErrorCount() {
        $this.errorCount = $this.errorCount + 1
    }

    [void]invalidStart([String]$message) {
        $this.msg = 'Database connection error...'
        $this.logger.writeToLog($this.msg, 3)
        
        $this.msg = $message
        $this.logger.writeToLog($this.msg, 3)
        $this.updateErrorCount()
    }

    [void]invalidDirectory([String]$directory) {
        $this.msg = 'Directory Not Found'
        $this.logger.writeToLog($this.msg, 3)

        $this.msg = "Directory: $($directory)"
        $this.logger.writeToLog($this.msg, 3)

        $this.msg = "Application Aborted"
        $this.logger.writeToLog($this.msg, 3)
        $this.updateErrorCount()
    }

    [void]invalidFormInput([String]$filename, [List[PSCustomObject]]$errorList) {
        $this.msg = "Invalid Input Data: $($filename) - (File Skipped)"
        $this.logger.writeToLog($this.msg, 2)

        foreach ($err in $errorList) {
            $this.msg = $err.Name
            $this.logger.writeToLog($this.msg, 2)

            foreach ($props in $err.PsObject.Properties) {
                $this.msg = $props.Name + ": " + $props.Value
                $this.logger.writeToLog($this.msg, 2)
            }
        }
        $this.updateErrorCount()
    }

    [void]invalidFile([String]$filename, [String]$errorHeader) {
        $this.msg = $errorHeader
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = "File name: $($filename)"
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = "Skipping File"
        $this.logger.writeToLog($this.msg, 2)
        $this.updateErrorCount()
    }

    [void]invalidFile([String]$filename, [String]$errorHeader, [String]$body) {
        $this.msg = $errorHeader
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = "File name: $($filename)"
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = $body
        $this.logger.writeToLog($this.msg, 3)

        $this.msg = "Skipping File"
        $this.logger.writeToLog($this.msg, 2)
        $this.updateErrorCount()
    }

    [void]databaseError([PSCustomObject]$err) {
        $this.msg = "Database Error"
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = "Message: $($err.Exception.Message)"
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = "See log files for more details"
        
        $this.logger.writeToLog("ScriptStackTrace: " + $err.ScriptStackTrace, 3)
        $this.updateErrorCount()
    }

    [void]dataLoadError([String]$errHeader, [String]$idName, [String]$id, [String]$filename) {
        $this.msg = "Failed to Load $($errHeader)"
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = "$($idName): $($id)"
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = "File name: $($filename)"
        $this.logger.writeToLog($this.msg, 2)

        $this.msg = "Skipping File"
        $this.logger.writeToLog($this.msg, 2)
        $this.updateErrorCount()
    }
}
