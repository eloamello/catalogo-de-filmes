# bin/dev.ps1

$foremanInstalled = gem list foreman -i --silent

if (-not $foremanInstalled) {
    Write-Host "Installing foreman..."
    gem install foreman
}

$procfile = "Procfile.win.dev"

foreman start -f $procfile @args
