#!/bin/bash

#### Helm Install
sudo chmod go-rw /home/suporte/.kube/config
sudo snap install helm --classic

#### Metallb Install
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

#### Nginx Ingress Install
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx --version 3.34.0

### Deploy PHP 4Linux
kubectl apply -f /home/suporte/545/cks/infra-setup/recursos.yaml
