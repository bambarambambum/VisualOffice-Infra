### VisualOffice-Infra - Отработка практик и инструментов
## Ansible
# Hosts
Каждый хост разделен на группы:  
[webapp] - Веб-интерфейс приложения  
[reader] - Сервис читатель из БД  
[writer] - Сервис писатель в БД  
[database] - БД Postgres  
[monitoring] - Мониторинг, используется dockprom: https://github.com/stefanprodan/dockprom  
Запуск приложения и мониторинг возможен и на 1 хосте  
# Переменные
***all.example.yml*** - содержит запись ssh_user, где нужно указать пользователя, из под которого будет выполнятся запуск.  
***app.example.yml*** - содержит название контейнера, образа и его версию по всем компонентам, кроме мониторинга.  
# Playbooks
***install_docker.yml*** - Установка docker, pip и docker-compose на хост/все нужные хосты.  
***run_app_standalone.yml*** - Запуск приложения на одном хосте. Что бы плейбук отработал, необходимо создать в hosts только 1 запись.  
***run_app_multihost.yml*** - Запуск приложения на разных хостах.  
Содержит в себе переменную fill_database. При значении true, БД заполняется тестовыми данными.  
***run_app_compose_standalone.yml*** - Запуск приложения с помощью docker-compose на 1 хосте.  
***run_dockprom.yml*** - Запуск мониторинга (dockprom) с помощью docker-compose на указанном хосте.  
# Запуск
1. В ansible.cfg укажите remote_user  
2. Заполните hosts.example и переименуйте файл в hosts.  
3. Установите необходимые роли  
```sh
ansible-galaxy install -r ansible/requirements.yml
```
4. Установите docker, pip и docker-compose на все или некоторые хосты с помощью плейбука install_docker.yml  
```sh
ansible-playbook ansible/playbooks/install_docker.yml --extra-vars "ansible_sudo_pass=password"
```
5. Запустите необходимый плейбук на ваш выбор, например:  
```sh
ansible-playbook ansible/playbooks/run_app_multihost.yml --extra-vars "ansible_sudo_pass=password"
```