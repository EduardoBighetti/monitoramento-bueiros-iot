// Simula o ESP32 (sem hardware): publica distancias no topico bueiros/<id>/nivel
// Uso: node simular.js [host] [distancia1 distancia2 ...]     ex.: node simular.js 127.0.0.1 80 60 40 15 40 80
const mqtt = require('mqtt');
const args = process.argv.slice(2);
const host = isNaN(Number(args[0])) && args.length ? args.shift() : '127.0.0.1';
const dists = (args.length ? args : ['80', '60', '40', '15', '40', '80']).map(Number);
const id = 'simulado01';
const c = mqtt.connect('mqtt://' + host + ':1883', { clientId: 'simulador-' + Math.random().toString(16).slice(2, 8) });
c.on('connect', () => {
  let i = 0;
  const next = () => {
    if (i >= dists.length) return setTimeout(() => c.end(), 500);
    const p = JSON.stringify({ id, distancia_cm: dists[i], ts: new Date().toISOString() });
    c.publish('bueiros/' + id + '/nivel', p, { qos: 1 }, () => { console.log('publicado', p); i++; setTimeout(next, 5000); });
  };
  next();
});
c.on('error', (e) => { console.error('erro mqtt:', e.message); process.exit(1); });
