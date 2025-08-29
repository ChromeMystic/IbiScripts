#Pfad in dem das Script gestartet wird.
$scriptPath = Split-Path $myInvocation.MyCommand.Path

#region Softwareprofil
# Check welches Profile auf dem Rechner läuft
$classic = "Classic"
$wp22 = "Default"
$wpVAP = "VAP"

$key = "HKLM:\*\*" # Schlüssel in dem das Deployment Profile abgelegt wird

# Prüfen ob der Registry Schlüssel vorhanden ist, wenn Ja wird der Entsprchende Eintrag in der Variable $profile gespeichert - wenn nicht, wird Classic gespeichert
IF ((Test-Path $key) -eq $false) {
    $profile = "Classic"
    } else {
        $profile = (Get-ItemProperty -Path $key).DeploymentProfile
        }

#endregion

#region check VAP Bridge (ContactCenter)
$installed = "Installed" # Wert für Installierte Software
$reg_path = "HKLM:\*\VAP_SOftware*" ## Registrypfad für VAP-Bridge Installationsstatus der stern ams Ende ermöglicht mehrere Ordner mit Versionsnummern zu prüfen.

## Definieren der variabe $vapBrig um Sicherzustellen, das auch Maschine bei denen VAP Software via Portal installiert wurde, erkannt werden.
if ($install_status -ne $null) {
$vapBrig = $install_status.Contains($installed)
} else { $vapBrig = $false}
#endregion

#region Variablen Definieren
$ibiPath = "C:\Program Files\IBITECH\IBI-aws\"
$ibiExe = "IBI.aws.Client.exe"
$ibiStart = $ibiPath + $ibiExe
#Argumente für WP Classic und WP 22
$ibiProd = """https://WEB_URL/prod.ibi"" /AdditionalRemarks ""https://WEB_URL/cli.ibi"" /CertificateSource """" /ErrorLogPath ""$env:tmp\IBIError"" /NoLocalCopy"
#Argumente für VAP
$ibiVAP = """https://WEB_URL/prod.ibi"" /AdditionalRemarks ""https://WEB_URL/vap.ibi"" ""https://WEB_URL/cli.ibi"" /CertificateSource """" /ErrorLogPath ""$env:tmp\Error"" /NoLocalCopy"
$datetime = Get-Date
#endregion

#region Ibi Prozess beenden
    Get-Process "IBI.aws.Client" -ErrorAction SilentlyContinue | Stop-Process -PassThru
#endregion

#region Ibi Prozess neu starten und Logeintrag verfassen.
If ($profile -eq $classic) {
    Start-Process $ibiStart $ibiProd
    Write-Output "$datetime Starte IBI Classic" | Out-File -FilePath $env:tmp\ibi-aws-start.log  
    } elseif ($profile -eq $wp22) {
        Start-Process $ibiStart $ibiProd
        Write-Output "$datetime Starte IBI WP22" | Out-File -FilePath $env:tmp\ibi-aws-start.log 
        } elseif ($profile -eq $wpVAP) {
            Start-Process $ibiStart $ibiVAP
            Write-Output "$datetime Starte IBI VAP" | Out-File -FilePath $env:tmp\ibi-aws-start.log 
            } elseif ($vap -eq $true) { 
                Start-Process $ibiStart $ibiVAP
                Write-Output " $datetimeStarte IBI VAP" | Out-File -FilePath $env:tmp\ibi-aws-start.log  } 
#endregion
