cd logs
Get-ChildItem -Filter *.logs | ForEach-Object{
#Get-ChildItem -Filter *.log -Path $pwd\logs | ForEach-Object{
    $newName = $_.Name -replace ".logs", ".txt"
    Rename-Item $_ $newName
}