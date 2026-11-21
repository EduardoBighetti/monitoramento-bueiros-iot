# Simula o ESP32 (sem hardware) quando a pilha esta rodando com Docker.
# Publica distancias do sensor no topico bueiros/simulado01/nivel a cada 5 s.
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\simular.ps1
#       powershell -ExecutionPolicy Bypass -File .\scripts\simular.ps1 -Distancias 80,60,40,15
# Com altura do bueiro = 100 cm:  80 cm -> 20% (normal) | 40 cm -> 60% (atencao) | 15 cm -> 85% (critico)
param([int[]]$Distancias = @(80, 60, 40, 15, 40, 80))
foreach ($d in $Distancias) {
  $ts = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
  $json = '{"id":"simulado01","distancia_cm":' + $d + ',"ts":"' + $ts + '"}'
  $json | docker compose exec -T mosquitto mosquitto_pub -t bueiros/simulado01/nivel -q 1 -s
  Write-Host "publicado: $json"
  Start-Sleep -Seconds 5
}
