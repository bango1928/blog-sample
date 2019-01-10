# Wordpress Blog
A wordpress blog sample and deploy to kubernetes.

## Prerequisites
Please install this dependency below, i'm using macOS as my workstation.
- `kubectl`, https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-homebrew-on-macos
- `terraform`, https://learn.hashicorp.com/terraform/getting-started/install.html
- `gcloud sdk`, https://cloud.google.com/sdk/docs/quickstart-macos
- `helm`, https://docs.helm.sh/using_helm/#from-homebrew-macos

## Prepare GKE Cluster

### Service Account
I'am using spessific account to deploy the cluster. To create the service account, from google cloud console, choose IAM & Admin > Service Accounts, and click Create Service Account. Name the service account terraform and assign it the Project Editor role. Download a JSON file and put it to file `gke-cluster/credential/account.json`.

I am using terraform to build the GKE Cluster. From `gke-cluster` directory, you can follow this step:
- Initialize the terraform, download and install all dependency
```
terraform init
``` 
- Review the execution plan
```
terraform plan
```
- Build the GKE Cluster
```
terraform apply
```

You need to waiting until terraform finish to build the cluster, it give the progress log output. After the cluster created, you can access and get the config to your kubeconfig.
- Get the cluster list on your GKE
```
gcloud container clusters list
```
- Get your cluster credential (in my case, the cluster name is `gke-cluster`). Kubeconfig entry will add to your kubectl config automatically
```
gcloud container clusters get-credentials gke-cluster --zone=asia-southeast1-a
```

Until this step, the cluster shoud be ready and you can verify by execute `kubectl cluster-info`

Because we're deploying the wordpress blog using helm, we need to deploy tiller to the kubernetes cluster with this step:
- Create tiller service account that will used by tiller
```
kubectl create -f tiller.yaml
```
- Deploy tiller with spessific service account
```
helm init --service-account tiller 
```

## Deploy Blog
To deploy the blog, execute this command:
```
./blog.sh deploy
```

## Scale Up Blog
To scale the blog, execute this command:
```
./blog.sh scale
```

## Delete Up Blog
To scale the blog, execute this command:
```
./blog.sh delete
```