Get-ChildItem -Filter *.log -Path $PSScriptRoot\logs | ForEach-Object{
    $newName = $_.Name -replace "*.log", "*.txt"
    Rename-Item $_$newName
}