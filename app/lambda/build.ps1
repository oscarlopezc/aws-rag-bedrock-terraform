Write-Host "Building Lambda package..."

$OutputZip = "..\..\terraform\lambda.zip"

if (Test-Path $OutputZip) {
    Remove-Item $OutputZip -Force
}

Compress-Archive `
    -Path .\lambda_function.py `
    -DestinationPath $OutputZip

Write-Host ""
Write-Host "Lambda package created successfully!"
Write-Host $OutputZip