# Technical Challenge
## Terraform

I wrote the terraform code using modules, this is the structure of the files:
```sh
├── argo-manifests
│   └── app-of-apps
│       ├── dev
│       │   ├── api.yaml
│       │   └── static.yaml
│       ├── main
│       │   ├── api.yaml
│       │   └── static.yaml
│       └── stage
│           ├── api.yaml
│           └── static.yaml
├── backend.tf
├── main.tf
├── modules
│   ├── eks
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── output.tf
├── providers.tf
├── README.md
├── tfvars
│   ├── dev.tfvars
│   ├── prod.tfvars
│   └── stage.tfvars
```
### How tu run

Each environment will be deployed in its own workspace: dev, prod and stage and has its won var values files (tfvars/prod.tfvars, tfvars/dev.tfvars, tfvars/stage.tfvars).
To apply the terraform code you need to be in the root folder with backend configured and the aws credentials configured in the aws cli and run:

```sh
terraform init
terraform workspace select dev # change dev for the environment that you need
terraform plan -var-file ./tfvars/dev.tfvars #check wath it'll be created
terraform apply  -var-file ./tfvars/dev.tfvars #and if it's ok copnfir the apply
```



### Floder: argo-manifests

In this folder there are other folder, one for each environment that contains the Argo Apps CRDS to deploy the Argo Apps pointin to the app repo as source and the eks cluster as detination to deploy it.

### Modules Folder

Here are the modules that I'll use to deploy the resources:

- eks: here I use the eks module to deploy the eks cluster and then the eks_blueprints_addons module to deploy argo inside of the cluster and point it the workloads to the path wher I have the Argo manifests.

- vpc: here I configure al the terrafor code to deploy the vpc and their realated resources.

### tfvars

Here I put one file for each env where you define the specific configuratioon for each environmet that will applied in its corresponding workspace

### Root folder files
 
 - backend.tf: all the configuration needed to store the terraform state file in a remote backen in this case an s3 bucket

 - main.tf: the entry point of the code, from here you call the module passing them the specific configs needed.

 - providers.tf: all the configuration related to the providers needed to deploy the code

 - variables.tf: variables definitions
