# Infraestructura Noit con Terraform y Ansible

Este proyecto configura la infraestructura para la aplicación Noit en AWS usando Terraform para el aprovisionamiento de infraestructura y Ansible para la configuración de las instancias.

## Requisitos previos

- Terraform instalado
- Ansible instalado
- AWS CLI configurado con un perfil llamado "noit"
- Par de claves SSH creado en AWS

## Estructura del proyecto

```
.
├── main.tf             # Archivo principal de Terraform
├── variables.tf        # Definición de variables
├── ansible/            # Configuración de Ansible
│   ├── docker-setup.yml           # Playbook principal
│   └── roles/                     # Roles de Ansible
│       └── docker/                # Rol para instalar Docker
│           └── tasks/
│               └── main.yml       # Tareas del rol
├── templates/          # Plantillas para generar archivos
│   └── inventory.tpl   # Plantilla para el inventario de Ansible
└── keys/               # Directorio para almacenar la clave privada SSH
```

## Configuración

1. Coloca tu archivo de clave privada SSH (`.pem`) en el directorio `keys/` con el mismo nombre que especifiques para la variable `key_name`.

2. Crea un archivo `terraform.tfvars` con los siguientes valores:

```hcl
region    = "us-east-1"  # O tu región preferida
key_name  = "nombre-de-tu-clave"  # Sin la extensión .pem
```

## Despliegue

1. Inicializa Terraform:

```bash
terraform init
```

2. Planifica los cambios:

```bash
terraform plan
```

3. Aplica la configuración:

```bash
terraform apply
```

4. Cuando termines, puedes destruir la infraestructura:

```bash
terraform destroy
```

## Acceso a la instancia

Una vez desplegada la infraestructura, puedes acceder a la instancia EC2 mediante SSH:

```bash
ssh -i keys/nombre-de-tu-clave.pem ubuntu@<ip-pública>
```

La IP pública se mostrará en la salida de Terraform después de aplicar la configuración.

## Personalización de Docker

Puedes personalizar la instalación de Docker y Docker Compose editando el archivo `ansible/roles/docker/tasks/main.yml`. Para agregar configuraciones adicionales o desplegar contenedores específicos, puedes:

1. Crear nuevos roles de Ansible
2. Modificar el playbook `ansible/docker-setup.yml` para incluir tareas adicionales
3. Agregar templates o archivos de configuración para tus aplicaciones

1. Crear nuevos roles de Ansible
2. Modificar el playbook `ansible/docker-setup.yml` para incluir tareas adicionales
3. Agregar templates o archivos de configuración para tus aplicaciones 