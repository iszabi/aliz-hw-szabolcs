# aliz-hw-szabolcs
Test for Aliz / Nexus on GKS with using Docker image / GKS Cluster with Terraform

2. Kubernetes configs for Nexus Deployment
(Service, Persistence volume, Deployment files.)

3. Kubernetes on Google Cloud Platform (GKE) with Terraform

- Terraform needs to be authorized to communicate with the Google Cloud API to create and manage resources in our GCP project. We achieve this by enabling the corresponding APIs and creating a service account with appropriate roles:

```bash
    $ gcloud services enable compute.googleapis.com
    $ gcloud services enable servicenetworking.googleapis.com
    $ gcloud services enable cloudresourcemanager.googleapis.com
    $ gcloud services enable container.googleapis.com
```
- Then create a service account:
```bash
$ gcloud iam service-accounts create iszabi-gkesa
```

(There is available a service account with permission limitation (467918867612-compute@developer.gserviceaccount.com) so I couldn't export my project account credential what other organization provided with limited permission.

- Now we can grant the necessary roles for our service account to create a GKE cluster and the associated resources:

```bash
    $ gcloud projects add-iam-policy-binding <project_name> --member serviceAccount:<service_account_name>@<project_name>.iam.gserviceaccount.com --role roles/container.admin
    $ gcloud projects add-iam-policy-binding <project_name> --member serviceAccount:<service_account_name>@<project_name>.iam.gserviceaccount.com --role roles/compute.admin
    $ gcloud projects add-iam-policy-binding <project_name> --member serviceAccount:<service_account_name>@<project_name>.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
    $ gcloud projects add-iam-policy-binding <project_name> --member serviceAccount:<service_account_name>@<project_name>.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
```

- Finally, we can create and download a key file that Terraform will use to authenticate as the service account against the Google Cloud Platform API:

```bash
    $ gcloud iam service-accounts keys create terraform-gke-keyfile.json --iam-account=<service_account_name>@<project_name>.iam.gserviceaccount.com
```
 - I will configure Terraform to store the state in a Google Cloud Storage Bucket
```bash
    $ gsutil mb -p aliz-hw-szabolcs -c regional -l europe-west4 gs://aliz-hw-szabolcs-bucket-1/
```
  (I used West Europa /Eemshaven, Netherlands/ for location )

 - Now I must have grant read/write permissions on this bucket to my service account:
```bash    
    $ gsutil iam ch serviceAccount:<service_account_name>@<project_name>.iam.gserviceaccount.com:legacyBucketWriter gs://<bucket_name>/
```
 - I can now configure Terraform to use this bucket to store the state. I'm storing this paramters in terraform.tf file in the same directory where the service account key file is located. See more in /terraform folders.

 - We can now run terraform init and the output will display that the Google Cloud Storage backend is properly configured.
```bash  
    $ terraform init 
```
 - Create the GKE cluster after with terraform files.
```bash
    $ terraform plan
    $ terraform apply
```
- When prompted for confirmation, type in “yes” and wait a few minutes for Terraform to build the cluster.
- When Terraform is done, we can check the status of the cluster and configure the kubectl command line tool to connect to it with:

    $ gcloud container clusters list
    $ gcloud container clusters get-credentials gke-cluster
```

(After take some minutes it will be finished building a Kubernetes cluster on Google Cloud Platform.)

Created by Szabolcs Illes /December 10, 2020/