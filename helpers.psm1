
Function Close-App {
    param(
        [Logger]$logger,
        [String]$message,    
        [int]$level
    )

    [String]$timestamp = Get-Date -Format 'MM/dd/yyyy HH:mm:ss'
    
    if ($message) {
        $logger.writeToLog($message, $level)
    }
    
    $logger.writeToLog("Closing Application...", $level)
    exit 1
}

Function Get-Reports {
    param(
        [String]$dir
    )
    
    [String[]]$reports = Get-ChildItem -Path $dir | ForEach-Object { 
        (Get-ItemProperty -Path $dir'\'$_).Name
    }

    return $reports
}
