$body = @{
    ip = '192.168.0.99'
    rack = 0
    slot = 1
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri http://localhost:5000/api/connect -Method POST -Body $body -ContentType 'application/json'
$response | ConvertTo-Json -Depth 10
