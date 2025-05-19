#!/bin/bash

# Verifica si se proporcionó la IP
if [ -z "$1" ]; then
  echo "Error: Debes proporcionar la IP pública de la instancia EC2"
  echo "Uso: ./run-ansible.sh <ip-publica> [nombre-clave]"
  exit 1
fi

IP_PUBLICA=$1
NOMBRE_CLAVE=${2:-"tu-clave"} # Valor por defecto si no se proporciona

# Eliminar la extensión .pem si está presente
NOMBRE_CLAVE=${NOMBRE_CLAVE%.pem}

# Activar entorno virtual
echo "Activando entorno virtual..."
source venv/bin/activate

# Crear inventario temporal
cat > ansible/inventory-temp.ini << EOF
[noit_server]
$IP_PUBLICA ansible_user=ubuntu ansible_ssh_private_key_file=../keys/${NOMBRE_CLAVE}.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

# Ejecutar Ansible
cd ansible
ansible-playbook -i inventory-temp.ini docker-setup.yml -v

# Limpiar
rm inventory-temp.ini
cd ..

# Desactivar entorno virtual
deactivate

echo "Ansible ejecutado correctamente en $IP_PUBLICA" 