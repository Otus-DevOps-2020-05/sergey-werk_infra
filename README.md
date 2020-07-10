# sergey-werk_infra
sergey-werk Infra repository

## Connect with

Подключиться к хосту внутренней сети можно воспользовавшись функцией ProxyJump стандартного ssh-клиента:

		ssh -J appuser@bastion appuser@internalhost

Для устаревших версий ssh:

    ssh -o ProxyCommand='ssh -q -W %h:%p appuser@bastion' appuser@internalhost

Также можно сохранить конфигурацию в файле ~/.ssh/config

Host internalhost
        User appuser
        HostName 10.130.0.9
        ProxyJump appuser@bastion
        IdentityFile ~/.ssh/appuser


bastion_IP = 84.201.133.129
someinternalhost_IP = 10.130.0.9
