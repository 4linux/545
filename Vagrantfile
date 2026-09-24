# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DISABLE_VBOXSYMLINKCREATE'] = '1'

vms = {
  'kube-master' => {
    'memory' => '4096',
    'cpus' => 2,
    'ip' => '100',
    'box' => 'ubuntu/jammy64',
    'provision' => 'provision/ansible/kube-master.yaml'
  },

  'kube-node1' => {
    'memory' => '3072',
    'cpus' => 2,
    'ip' => '101',
    'box' => 'ubuntu/jammy64',
    'provision' => 'provision/ansible/kube-node1.yaml'
  },

  'kube-node2' => {
    'memory' => '3072',
    'cpus' => 2,
    'ip' => '102',
    'box' => 'ubuntu/jammy64',
    'provision' => 'provision/ansible/kube-node2.yaml'
  },

  'kube-registry' => {
    'memory' => '1536',
    'cpus' => 1,
    'ip' => '103',
    'box' => 'ubuntu/jammy64',
    'provision' => 'provision/ansible/kube-registry.yaml'
  }
}

Vagrant.configure('2') do |config|

  # Evita verificar novas versões da box a cada inicialização.
  config.vm.box_check_update = false

  # Tempo máximo para aguardar o boot das VMs.
  config.vm.boot_timeout = 600

  vms.each do |name, conf|

    config.vm.define name do |k|

      k.vm.box = conf['box']
      k.vm.hostname = name

      # Rede privada utilizada pelo ambiente do curso.
      k.vm.network 'private_network',
        ip: "172.16.1.#{conf['ip']}"

      # -----------------------------------------------------------------------
      # VirtualBox
      # -----------------------------------------------------------------------

      k.vm.provider 'virtualbox' do |vb|

        vb.memory = conf['memory']
        vb.cpus = conf['cpus']

        # Utiliza discos diferenciais em relação à box base.
        # Reduz tempo de criação e consumo de espaço em disco.
        vb.linked_clone = true

        # Evita a verificação do Guest Additions durante o boot.
        vb.check_guest_additions = false

        # Otimizações para guests Linux.
        vb.customize [
          'modifyvm',
          :id,
          '--paravirtprovider',
          'kvm'
        ]

        vb.customize [
          'modifyvm',
          :id,
          '--nestedpaging',
          'on'
        ]
      end

      # -----------------------------------------------------------------------
      # Instalação do Ansible
      # -----------------------------------------------------------------------

      k.vm.provision 'shell',
        privileged: true,
        inline: <<-SHELL

        set -e

        rm -f \
          /etc/apt/sources.list.d/ansible-ubuntu-ansible-jammy.list

        if ! command -v ansible-playbook >/dev/null 2>&1; then

          apt-get update -y

          DEBIAN_FRONTEND=noninteractive \
            apt-get install -y ansible-core

        fi

      SHELL

      # -----------------------------------------------------------------------
      # Provisionamento Ansible
      # -----------------------------------------------------------------------

      k.vm.provision 'ansible_local' do |ansible|

        ansible.playbook = conf['provision']

        # O Ansible já foi instalado pelo provisionador Shell acima.
        ansible.install = false

        # Utiliza o formato de inventário compatível com Ansible 2.x ou superior.
        ansible.compatibility_mode = "2.0"
      end

    end
  end
end
