Host do-01
    HostName ${do-01-ip}
    IdentityFile ~/.ssh/${key_name}
    User ubuntu

Host do-02
    HostName ${do-02-ip}
    IdentityFile ~/.ssh/${key_name}
    User ubuntu
    ForwardAgent yes
    ProxyCommand ssh do-01 -W %h:%p

Host do-03
    HostName ${do-03-ip}
    IdentityFile ~/.ssh/${key_name}
    User ubuntu
    ForwardAgent yes
    ProxyCommand ssh do-01 -W %h:%p

Host do-04
    HostName ${do-04-ip}
    IdentityFile ~/.ssh/${key_name}
    User ubuntu
    ForwardAgent yes
    ProxyCommand ssh do-01 -W %h:%p