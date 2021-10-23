### VisualOffice-Infra - Отработка практик и инструментов
# Ansible
### Hosts
Каждый хост разделен на группы:  
[webapp] - Веб-интерфейс приложения  
[reader] - Сервис читатель из БД  
[writer] - Сервис писатель в БД  
[database] - БД Postgres  
[monitoring] - Мониторинг, используется dockprom: https://github.com/stefanprodan/dockprom  
Запуск приложения и мониторинг возможен и на 1 хосте  
### Переменные
***all.example.yml*** - содержит запись ssh_user, где нужно указать пользователя, из под которого будет выполнятся запуск.  
***app.example.yml*** - содержит название контейнера, образа и его версию по всем компонентам, кроме мониторинга.  
## Playbooks
### Docker
Запуск приложения используя докер-контейнеры.
***tasks/install_docker.yml*** - Установка docker, pip и docker-compose на хост/все нужные хосты.  
***run_standalone.yml*** - Запуск приложения на одном хосте. Что бы плейбук отработал, необходимо создать в hosts только 1 запись.  
***run_multihost.yml*** - Запуск приложения на разных хостах.  
Содержит в себе переменную fill_database. При значении true, БД заполняется тестовыми данными.  
***run_compose.yml*** - Запуск приложения с помощью docker-compose на 1 хосте.  
***run_dockprom.yml*** - Запуск мониторинга (dockprom) с помощью docker-compose на указанном хосте.  
### Service
Запуск приложения как службу (systemd).   
***run_standalone.yml*** - Запуск приложения на одном хосте. Что бы плейбук отработал, необходимо создать в hosts только 1 запись.  
***run_multihost.yml*** - Запуск приложения на разных хостах.  
### Запуск
1. В ansible.cfg укажите remote_user  
2. Заполните hosts.example и переименуйте файл в hosts.  
3. Установите необходимые роли  
```sh
ansible-galaxy install -r ansible/requirements.yml
```
4. Установите docker, pip и docker-compose на все или некоторые хосты с помощью плейбука install_docker.yml  
```sh
ansible-playbook ansible/playbooks/docker/tasks/install_docker.yml --extra-vars "ansible_sudo_pass=password"
```
5. Запустите необходимый плейбук на ваш выбор, например:  
```sh
ansible-playbook ansible/playbooks/docker/run_multihost.yml --extra-vars "ansible_sudo_pass=password"
```
## CI
С помощью Github Actions проверяются все плейбуки инструментом Ansible-lint при пуше в мастер.  
# Terraform
С помощью Terraform и AWS создаются 4 хоста под приложение, создается сеть VPC, 2 подсети, настраиваются таблица маршрутизации, генерируются файлы SSH Config (jump хосты), ansible.cfg и ansible hosts файл.  
### variables.tf
***aws_region*** - Регион.  
***vpc_cidr*** - Сеть для VPC.  
***public_subnet-cidr*** - Публичная подсеть с доступом в интернет.  
***private_subnet_cidr*** - Частная подсеть без доступа в интернет, с доступом до публичной сети и наоборот.  
***key_path*** - Путь до открытого ключа.    
***key_name*** - Имя закрытого ключа.  
### Запуск
Тесты производились на образе Ubuntu 20.04
1. Установите awscli, если отсутствует.  
```sh
sudo apt install awscli
```
2. Установите terraform, если отсутствует.  
```sh
curl -O https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip  
unzip terraform_1.0.9_linux_amd64.zip   
sudo cp terraform /usr/local/bin/  
```
3. Настройте AWS (Необходимо знать Access Key ID, Secret Acces Key вашей УЗ)  
Подробнее тут: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html  
```sh
aws configure
```
4. Возьмите существующую или сгенерируйте пару ключей, например так:  
```sh
ssh-keygen -t rsa -b 4096 -C "nickname@email.com"
```
5. Положите открытый и закрытый ключ по пути ~/.ssh/  
6. Отредактируйте variables.tf, указав там название закрытого ключа и путь до открытого ключа.  
7. В папке terraform проинициализируйте рабочую директорию терраформа.  
```sh
terraform init
```
8. Запустите terraform plan  
```sh
terraform plan
```
9. Создайте инфраструктуру  
```sh
terraform apply
```
10. В директории terraform/files вы найдете:  
* ansible.cfg - Конфигурация для Ansible, нужно положить по пути ../ansible/ansible.cfg  
* config - Конфигурация для SSH (jump hosts), нужно положить по пути ~/.ssh/config  
* hosts - Хост файл для Ansible, нужно положить по пути ../ansible/hosts
