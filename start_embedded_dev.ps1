# start_embedded_dev.ps1
# Starting Arignar Embedded Development Environment

# Function to cleanup background processes
function Cleanup {
    Write-Host "`nCleaning up processes..." -ForegroundColor Yellow

    if ($null -ne $FlutterJob) {
        Stop-Job -Job $FlutterJob -ErrorAction SilentlyContinue
        Remove-Job -Job $FlutterJob -ErrorAction SilentlyContinue
        Write-Host "Flutter web server stopped" -ForegroundColor Green
    }

    if ($null -ne $HttpServerProcess) {
        Stop-Process -Id $HttpServerProcess.Id -ErrorAction SilentlyContinue
        Write-Host "HTTP server stopped" -ForegroundColor Green
    }

    exit 0
}

# Set trap to cleanup on script exit
$null = Register-EngineEvent PowerShell.Exiting -Action { Cleanup }
$null = [Console]::TreatControlCAsInput = $false

# Note: some PowerShell hosts do not expose Console::CancelKeyPress for direct assignment.
# We already registered a PowerShell.Exiting engine event above; avoid binding CancelKeyPress
# directly to prevent "PropertyAssignmentException" in constrained hosts.

Write-Host "Starting Arignar Embedded Development Environment" -ForegroundColor Blue

# Check if Flutter is installed
try {
    $null = Get-Command flutter -ErrorAction Stop
} catch {
    Write-Host "Flutter is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Check if Python is installed (for simple HTTP server)
try {
    $null = Get-Command python -ErrorAction Stop
} catch {
    Write-Host "Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python to use the simple HTTP server" -ForegroundColor Yellow
    exit 1
}

Write-Host "Local development HTML created" -ForegroundColor Green

# Start Flutter web server in background
Write-Host "Starting Flutter web server on port 5000..." -ForegroundColor Blue
$FlutterJob = Start-Job -ScriptBlock { flutter run -d web-server --web-port=5000 --web-hostname=0.0.0.0 }
Start-Sleep -Seconds 3

# Start simple HTTP server in background
Write-Host "Starting simple HTTP server on port 60494..." -ForegroundColor Blue
Push-Location embeddedWeb\public
$HttpServerProcess = Start-Process -FilePath "python" -ArgumentList "-m", "http.server", "60494" -PassThru -NoNewWindow
Pop-Location

# Wait a moment for HTTP server to start
Start-Sleep -Seconds 2

Write-Host "Development environment started successfully!" -ForegroundColor Green
Write-Host "Flutter Web App: http://localhost:5000" -ForegroundColor Blue
Write-Host "Embedded Portal: http://localhost:60494" -ForegroundColor Blue
Write-Host "Local Development Portal: http://localhost:60494/sample.html" -ForegroundColor Blue
Write-Host ""
Write-Host "Tips:" -ForegroundColor Yellow
Write-Host "  • Use http://localhost:60494/sample.html for testing embedded integration"
Write-Host "  • Use http://localhost:5000 for direct Flutter development"
Write-Host "  • Hot reload works on the Flutter server"
Write-Host "  • Press Ctrl+C to stop both servers"
Write-Host ""

# Wait for user to stop the servers
try {
    while ($true) {
        Start-Sleep -Seconds 1
        if ($HttpServerProcess.HasExited) {
            Write-Host "HTTP server exited unexpectedly" -ForegroundColor Red
            break
        }
    }
} catch {
    Cleanup
}
