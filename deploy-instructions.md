# Instrucciones para implementar HTTPS en el servidor de Noit

Sigue estos pasos para implementar correctamente HTTPS utilizando Let's Encrypt y Certbot:

## 1. Copia los archivos al servidor

```bash
# Desde tu máquina local
ssh -i keys/noit.pem ubuntu@98.84.34.55 "mkdir -p /home/ubuntu/noit-app/nginx/conf /home/ubuntu/noit-app/certbot/conf /home/ubuntu/noit-app/certbot/www"
scp -i keys/noit.pem docker-compose-https.yaml ubuntu@98.84.34.55:/home/ubuntu/noit-app/docker-compose.yaml
scp -i keys/noit.pem nginx-http.conf ubuntu@98.84.34.55:/home/ubuntu/noit-app/nginx/conf/default.conf
scp -i keys/noit.pem nginx-https.conf ubuntu@98.84.34.55:/home/ubuntu/noit-app/nginx/conf/https.conf
```

## 2. Detener los servicios existentes y lanzar la nueva configuración

```bash
ssh -i keys/noit.pem ubuntu@98.84.34.55

# En el servidor
cd /home/ubuntu/noit-app
docker-compose down
docker-compose up -d
```

## 3. Verificar que el servicio HTTP funciona correctamente

Visita http://noit.com.co y asegúrate de que puedes acceder a la aplicación.

## 4. Esperar a que Certbot obtenga los certificados

Certbot intentará automáticamente obtener certificados. Puedes verificar el progreso con:

```bash
cd /home/ubuntu/noit-app
docker-compose logs certbot
```

## 5. Verificar que HTTPS está funcionando

Una vez que Certbot haya obtenido los certificados, intenta acceder a través de HTTPS:
https://noit.com.co

## Resolución de problemas

### Si Certbot falla al obtener certificados

1. Verifica que los puertos 80 y 443 estén abiertos en AWS:
```bash
curl -v http://noit.com.co/.well-known/acme-challenge/test
```

2. Verifica los logs de Certbot para más detalles:
```bash
docker-compose logs certbot
```

3. Si sigue fallando, puedes intentar usar el modo de prueba añadiendo `--staging` en el comando de Certbot.

### Si HTTPS no funciona después de obtener certificados

1. Verifica que los archivos de certificados existen:
```bash
ls -la /home/ubuntu/noit-app/certbot/conf/live/noit.com.co/
```

2. Verifica los logs de Nginx:
```bash
docker-compose logs nginx
```

3. Reinicia Nginx para asegurarte de que carga la nueva configuración:
```bash
docker exec -it noit-app-nginx-1 nginx -s reload
``` 