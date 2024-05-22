#C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
# Author: Isaac Mendez
# Date: 22/05/2024
# Topic: Compresor de logs a archivos de texto para APIs y registros especializados para enviar por correo
# A los vendors principales

###################################################################################################
#                                                                                                 #
#   Input Interfaces                                                                              #
#                                                                                                 #
###################################################################################################
#
# Command to use 
#
#.\rename-logs.ps1
#
# Tree Structure
# \
# rename-logs.ps1
# logs\
# -- WEB
# -- WEB_API
# -- STTP
# -- STTP_API
# ----Integraciones




Set-Variable -Name "counter" -value 0

function Rename-Files($folder){
	#Get-ChildItem -Filter *.log | ForEach-Object {
	Get-ChildItem -Path $folder\*.log | ForEach-Object {
		$counter += 1
		$newName = $counter.toString()+'.txt'

		#Reemplazar solo extension
		#$_ es la variable por defecto del foreach
		#$newName = $_.Name -replace '.log', '.txt'
		
		Rename-Item $_ $newName
	}
}


function Directory-Changer-Renamer{

	# Obtenemos solo el nombre de base del archivo
	#$folders = (Get-ChildItem -Path .\ -Directory).BaseName
	# Obtenemos su pwd completo
	$folders = (Get-ChildItem -Path .\ -Directory).FullName
	ForEach ($folder in $folders){
		# Obtenemos los folders con logs
		$files_on_folder = (Get-ChildItem  -Path $folder\*.*).FullName
		
		#Chequeamos los que no estan vacios
		if( -not ([string]::IsNullOrEmpty($files_on_folder)) ){
			#Set here the files where will be renamed
			#Set-Location $folder
			Write-Output "FILES:" $folder
			Rename-Files $folder
		}
		
	}
}

# Llamamos la funcion 
Directory-Changer-Renamer

# Area de comprension de archivos 

$compress = @{
	Path = (Get-Location).Path+'\logs'
	CompressionLevel = "Fastest"
	DestinationPath = (Get-Location).Path+'\compress.zip'
}
Compress-Archive @compress
