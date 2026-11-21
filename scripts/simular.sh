#!/bin/sh
# Simula o ESP32 (sem hardware) quando a pilha esta rodando com Docker (Linux / macOS / Git Bash).
# Uso:  sh scripts/simular.sh            ou          sh scripts/simular.sh 80 60 40 15
# Com altura do bueiro = 100 cm:  80 cm -> 20% (normal) | 40 cm -> 60% (atencao) | 15 cm -> 85% (critico)
[ $# -eq 0 ] && set -- 80 60 40 15 40 80
for d in "$@"; do
  ts=$(date -u +%Y-%m-%dT%H:%M:%S.000Z)
  json="{\"id\":\"simulado01\",\"distancia_cm\":$d,\"ts\":\"$ts\"}"
  echo "$json" | docker compose exec -T mosquitto mosquitto_pub -t bueiros/simulado01/nivel -q 1 -s
  echo "publicado: $json"
  sleep 5
done
