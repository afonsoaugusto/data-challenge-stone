# Data-Challenge-Stone - Data Platform

[![deepcode](https://www.deepcode.ai/api/gh/badge?key=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwbGF0Zm9ybTEiOiJnaCIsIm93bmVyMSI6ImFmb25zb2F1Z3VzdG8iLCJyZXBvMSI6ImRhdGEtY2hhbGxlbmdlLXN0b25lIiwiaW5jbHVkZUxpbnQiOmZhbHNlLCJhdXRob3JJZCI6MjMwNDAsImlhdCI6MTYxNzA1OTY3Nn0.yAAUnREvla7WJ8bzpoj_j_pZB7G6DY39r9llH7PSbHQ)](https://www.deepcode.ai/app/gh/afonsoaugusto/data-challenge-stone/_/dashboard?utm_content=gh%2Fafonsoaugusto%2Fdata-challenge-stone)

Desafio Data Challenge Stone na categoria Data Platform

## Desafio

### Descrição

Criar um cluster Spark no Kubernetes, e executar um job de spark com 3 [executors](https://spark.apache.org/docs/latest/cluster-overview.html#glossary).

Garanta de que cada nós do cluster de Kubernetes conversem entre si seguindo as boas práticas de segurança:

* Limitação de acesso a portas para a integração
* Criação de roles de usuários no cluster
  * Admin
  * Edit
  * View

O ambiente deve ser local e disponibilizado no github

### Entrega 1

Desenho da solução + Imagens de Docker

### Entrega 2

Apresentação do projeto em 20 min detalhando o problema e a solução implementada

### Intens de avaliação da solução

* (p 1.5) Deployability (roteiro de implentação)
* (p 1.5) Performance
* (p 1.5) Estrutura de códigos/artefatos (manutenibilidade)
* (p 2.0) Recuperação em caso de falhas
* (p 2.0) Documentação
* (p 1.5) Segurança

### Intens de avaliação da apresentação

* Conhecimento da solução implementada
* Storytelling
* Maiores dificuldades
* Beneficios da solução

## Arquitetura

![k8s-namespaces](img/k8s-namespaces.png)

## Estrutura do Projeto

```sh
$tree -a -I .git -v
.
├── .circleci
│   └── config.yml
├── .devcontainer
│   ├── Dockerfile
│   ├── devcontainer.json
│   └── library-scripts
│       ├── common-debian.sh
│       └── docker-in-docker-debian.sh
├── .env.private
├── .env.project
├── .gitignore
├── .kubectl_aliases
├── Case-Plataforma-de-Dados-Data-Platform.pdf
├── LICENSE
├── Makefile
├── README.md
├── airflow-operator
│   ├── 01-airflow.sh
│   ├── airflow-namespace.yml
│   ├── airflow-rbac.yml
│   └── dags
│       ├── spark-pagerank.yml
│       ├── spark-pi.yml
│       ├── spark_pagerank.py
│       ├── spark_pi.py
│       └── test-data-pipeline.py
├── docker
│   ├── Makefile
│   ├── build.sh
│   └── publish.sh
├── img
│   └── k8s-namespaces.png
├── kubernetes
│   ├── auxiliaries-setup
│   │   ├── 01-minio.sh
│   │   └── minio-namespace.yml
│   └── local-setup
│       ├── kind-config.yml.tmpl
│       └── scripts
│           ├── 00-local-setup.sh
│           ├── 01-install-kind.sh
│           ├── 02-install-kubectl.sh
│           ├── 03-install-helm.sh
│           ├── 04-install-mc-client.sh
│           ├── 99-cleanup.sh
│           └── 101-setup-dashboard.sh
├── notas.txt
├── spark-applications
│   └── pagerank
│       ├── Dockerfile
│       ├── pagerank.py
│       └── pagerank.yml
└── spark-operator
    ├── install-spark-operator.sh
    └── spark-namespaces.yml

14 directories, 41 files
```

## Solução

### Kubernetes

#### [Kind](https://kind.sigs.k8s.io/)

Foi escolhido o kind devido a possibilidade simular um cluster kubernetes com a possibilidade ser multi node para workers e termos HA para o control-plane.

Importante salientar que para ele operar é necessário apenas o docker. O Kubectl se torna necessário para interagir com o cluster.

#### [Helm](https://helm.sh/docs/)

Foi escolhido utilizar o *helm* para deployar os *operators* para simplificar a sua gestão e criação dos componentes necessários para a solução.

### Kubernetes-Operators

#### [spark-on-k8s-operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/)

#### [Minio-operator](https://github.com/minio/operator/blob/master/README.md)

### Local setup

```sh
sudo apt-get update && \
sudo apt-get install make -y
make setup-local
```

#### Local cluster iniciado

```sh
-> kubectl cluster-info --context kind-k8s-data-challenge

Kubernetes control plane is running at https://127.0.0.1:33453
KubeDNS is running at https://127.0.0.1:33453/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### Cleanup environment

```sh
kind delete cluster --name=k8s-data-challenge
```

## Referências

* [kubectl/cheatsheet](https://kubernetes.io/pt/docs/reference/kubectl/cheatsheet/)
* [Kind](https://kind.sigs.k8s.io/)
* [Helm](https://helm.sh/docs/)
* [spark-on-k8s-operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/)
* [Minio-operator](https://github.com/minio/operator/blob/master/README.md)
* [Testing in Airflow](https://blog.usejournal.com/testing-in-airflow-part-1-dag-validation-tests-dag-definition-tests-and-unit-tests-2aa94970570c)