# sergey-werk_infra
sergey-werk Infra repository

## Connect with ProxyJump

Подключиться к хосту внутренней сети можно воспользовавшись функцией ProxyJump стандартного ssh-клиента:

		ssh -J appuser@bastion appuser@internalhost

Для устаревших версий ssh:

    ssh -o ProxyCommand='ssh -q -W %h:%p appuser@bastion' appuser@internalhost

Также можно сохранить конфигурацию в файле `~/.ssh/config`:
```
Host internalhost
        User appuser
        HostName 10.130.0.9
        ProxyJump appuser@bastion
        IdentityFile ~/.ssh/appuser
```

## YC testapp

```
testapp_IP = 84.201.135.50
testapp_port = 9292
```

#### Run machine with bootstrap.sh:

```
yc compute instance create \
   --name reddit-app2 \
   --hostname reddit-app2 \
   --memory=4 \
   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=4GB,type=network-ssd \
   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4, \
   --metadata serial-port-enable=1 \
   --metadata-from-file user-data=./bootstrap-metadata.yaml
```

#### Packer

```
packer verify immutable.json
packer build -var-file=variables.json immutable.json
```

#### Terraform with YC

[Docs](https://www.terraform.io/docs/providers/yandex/index.html)


Почему-то не работает с ssh-agent (не получается использовать запароленный ключ).
```
Error: Failed to parse ssh private key: ssh: this private key is passphrase protected
```

Шпаргалка по командам:
```
yc config list

terraform show
terraform refresh
terraform output
terraform taint yandex_compute_instance.app
terraform state pull

```
Самая полезная вещь:
```
export TF_LOG=TRACE; terraform apply
```

##### Бэкенд в Object Storage

см. backend.tf
```
export AWS_SHARED_CREDENTIALS_FILE=~/current/otus-devops/yc/storage_credeintials
terraform state pull
```

Косяки (на август 2020):

* Использование переменных не работает в описании бэкенда!
* aws-sdk-go не поддерживает загрузку конфигурации из файла для эндпоинтов кроме aws.
* Соответственно, `shared_credentials_file` не работает.
* Шифрование бакетов в YC Object Storage отсутствует?
* S3-бэкенд терраформа поддерживает блокировку через DynamoDB AWS (в YC нет аналогов с оплатой за каждый запрос).

Есть три варианта:
 1. to specify `access_key` and `access_key` here,
 2. to set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env. variables,
 3. to set AWS_SHARED_CREDENTIALS_FILE env. variable.

#### Ansible

```
 ansible all -m ping -i inventory.yml
 ansible app -m command -a 'ruby -v'
 ansible app -m shell -a 'ruby -v; bundler -v'
 ansible db -m command -a "systemctl status mongod"
 ansible db -m service -a name=mongod
 ansible app -m git -a "repo=https://github.com/express42/reddit.git dest=/home/ubuntu/reddit"
 ansible app -m command -a 'rm -rf ~/reddit'
```

##### Dynamic inventory with custom script
```
ansible all -m ping -i inventory.sh
84.201.157.8 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
84.201.133.154 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}


ansible-inventory -i inventory.sh  --graph
@all:
  |--@ungrouped:
  |  |--84.201.133.154
  |  |--84.201.157.8
```

##### Ansible


```
YC_ANSIBLE_SERVICE_ACCOUNT_FILE=~/.../iam_key.json
ansible-playbook reddit_app_multiple_plays.yml -i inventory_yc_compute.yml
```
