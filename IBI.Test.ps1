#Pfad in dem das Script gestarte wird.
$scriptPath = Split-Path $myInvocation.MyCommand.Path
# Variablen Definieren
$ibiPath = "C:\Program Files\IBITECH\IBI-aws\"
$ibiExe = "IBI.aws.Client.exe"
$ibiArgs = """https://WEB_URL/test.ibi"" /CertificateSource """" /ErrorLogPath ""$scriptPath\Error"" /NoLocalCopy"

$ibiStart = $ibiPath + $ibiExe

#Ibi Prozess beenden
Get-Process "IBI.aws.Client" -ErrorAction SilentlyContinue | Stop-Process -PassThru
#Ibi Prozess neu starten
Start-Process $ibiStart $ibiArgs