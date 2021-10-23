[defaults]
inventory  = hosts
roles_path = roles
transport  = ssh
private_key_file = ~/.ssh/${key_name}
remote_user = ${remote_user}

[ssh_connection]
pipelining = true
retries    = 2
ssh_args   = -o ControlMaster=auto -o ControlPersist=5m -o ConnectTimeout=10 -o ConnectionAttempts=5
