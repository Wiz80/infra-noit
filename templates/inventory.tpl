[noit_server]
${server_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${ssh_keyfile} ansible_ssh_common_args='-o StrictHostKeyChecking=no' 