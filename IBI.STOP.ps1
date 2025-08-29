#Ibi Prozess beenden
Get-Process "IBI.aws.Client" -ErrorAction SilentlyContinue | Stop-Process -PassThru