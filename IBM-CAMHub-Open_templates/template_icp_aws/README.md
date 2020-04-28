# Highly Available ICP Deployment on AWS

This Terraform configurations uses the [AWS provider](https://www.terraform.io/docs/providers/aws/index.html) to provision virtual machines on AWS to prepare VMs and deploy [IBM Cloud Private](https://www.ibm.com/cloud-computing/products/ibm-cloud-private/) on them.  This Terraform template automates best practices learned from installing ICP on AWS at numerous client sites in production.

This [template](https://github.com/IBM-CAMHub-Open/template_icp_aws/tree/master/templates) provisions a highly-available cluster with ICP 3.1.1 Enterprise Edition. This template can be executed either using [Terraform Automation](https://www.terraform.io/) or using [IBM Cloud Automation Manager](https://www.ibm.com/support/knowledgecenter/en/SS2L37/product_welcome_cloud_automation_manager.html).

* [Infrastructure Architecture](#infrastructure-architecture)
* [Executing the template using Terraform Automation](#executing-the-template-using-terraform-automation)
* [Executing the template using IBM Cloud Automation Manager](#executing-the-template-using-ibm-cloud-automation-manager)
* [Installation Procedure](#installation-procedure)
* [Community Edition](#installation-procedure-community-edition)
* [Cluster access](#cluster-access)
* [AWS Cloud Provider](#aws-cloud-provider)

## Infrastructure Architecture
The following diagram outlines the infrastructure architecture.

  ![Infrastructure Architecture](imgs/icp_ha_aw_overview.png?raw=true)

Within an availability zone, there is a public subnet which is directly connected to the internet, and a private subnet that can reach the internet through the NAT gateway:

  ![Single Availability Zone Infrastructure](imgs/icp_ha_aws_single_az.png?raw=true)

## Executing the template using Terraform Automation

The following sections explains how this terraform template works, the required template input values, how to execute the template using terraform and the objects it creates in Amazon Cloud.

### Prerequisites

1. To use Terraform automation, download the Terraform binaries [here](https://www.terraform.io/).

   On MacOS, you can acquire it using [homebrew](brew.sh) using this command:

   ```bash
   brew install terraform
   ```

1. Create an S3 bucket in the same region that the ICP cluster will be created and upload the ICP binaries.  Make note of the bucket name.  You can use the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-bundle.html) to do this.  

  For ICP 3.1.1-EE, you will need to copy the following:
  - the ICP binary package tarball (`ibm-cloud-private-x86_64-3.1.1.tar.gz`)
  - ICP Docker package (`icp-docker-18.03.1_x86_64`)

   The ICP patched installer image and fixpack script can be acquired from [IBM Fix Central](https://www.ibm.com/support/fixcentral/).  

2. Create a file, `terraform.tfvars` containing the values for the following:

|name | required                        | value        |
|----------------|------------|--------------|
| `aws_region`   | no           | AWS region that the VPC will be created in.  By default, uses `us-east-1`.  Note that for an HA installation, the AWS selected region should have at least 3 availability zones. |
| `azs`          | no           | AWS Availability Zones that the VPC will be created in, e.g. `[ "a", "b", "c"]` to install in three availability zones.  By default, uses `["a", "b", "c"]`.  Note that the AWS selected region should have at least 3 availability zones for high availability.  Setting to a single availability zone will disable high availability and not provision EFS, in this case, reduce the number of master and proxy nodes to 1. |
| `key_name`     | yes          | AWS keypair name to assign to instances     |
| `ami` | no | Base AMI to use for all EC2 instances.  If none provided, will search for latest version of RHEL 7.5 |
| `docker_package_location` | no         | S3 URL of the ICP docker package for RHEL (e.g. `s3://<bucket>/<filename>`). Ubuntu will use `docker-ce` from the [Docker apt repository](https://docs.docker.com/install/linux/docker-ce/ubuntu/).  If Docker is already installed in the base AMI, this step will be skipped. |
| `image_location` | no         | S3 URL of the ICP binary package (e.g. `s3://<bucket>/ibm-cloud-private-x86_64-3.1.1.tar.gz`).  Can also be a local path, e.g. `./icp-install/ibm-cloud-private-x86_64-3.1.1.tar.gz`; in this case the Terraform automation will create an S3 bucket and upload the binary package.  If provided, the automation will download the binaries from S3 and perform a `docker load` on every instance.  Note that it is faster to create an instance, install docker, perform the `docker load`, and convert to an AMI for use as a base instance for all node role types, as loading docker images takes around 20 minutes per EC2 instance. If the installer image is already on the EC2 instance, this step is skipped. |
| `patch_images` | no         | A list of S3 URLs for the images to load to each ICP node before installation.  For example, for ICP 2.1.0.3 fixpack 1, this would be `[ "s3://<bucket>/icp-inception-amd64.2.1.0.3.fp1.tar" ]`.  If provided, the automation will download these additional binaries from S3 and perform a `docker load` on every EC2 instance in the ICP cluster. |
| `patch_scripts` | no         | A list of S3 URLs for the patch scripts to execute after installation completed.  For example, for ICP 2.1.0.3 fixpack 1, this would be `[ "s3://<bucket>/ibm-cloud-private-2.1.0.3-fp1.sh" ]`.  If provided, the automation will download these additional scripts from S3 and execute them in order through the `icp-inception` image as post-install commands. |
| `icp_inception_image` | no | Name of the bootstrap installation image.  By default it uses `ibmcom/icp-inception-amd64:3.1.1-ee` to indicate 3.1.1 EE, but this will vary in each release.|
| `existing_iam_instance_profile_name` | no | If an IAM role is created beforehand, will assign the role with this name to all EC2 instances. See section on IAM roles for more information on the required policies. If blank, will attempt to create an IAM role.|
| `user_provided_cert_dns` | no | The DNS name in a user-provided TLS certificate, if provided |

See [Terraform documentation](https://www.terraform.io/intro/getting-started/variables.html) for the format of this file.

5. If using a user-provided TLS certificate containing a custom DNS name, copy `icp-auth.crt` and `icp-auth.key` to this directory before installation to the `cfc-certs` directory.  See [documentation](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.1.1/installing/create_ca_cert.html) for more details.  The certificate should contain the `user_provided_cert_dns` as a common name, and the DNS entry corresponding should be a CNAME pointing at the created ELB DNS entry for the master console.

6. Provide AWS credentials using environment variables:

   ```bash
   export AWS_ACCESS_KEY_ID=AKIAADGHASKDHGAKSDHGKASDHGK
   export AWS_SECRET_ACCESS_KEY=BAzxcvq^.asdgaljlajdfl235bads
   ```

7. Initialize Terraform using this command.

   ```bash
   terraform init
   ```

### Run the Terraform Automation

Run this command to see what would be created in the AWS account:

```bash
terraform plan
```

To move forward and create the objects, use the following command:

```bash
terraform apply
```

This will kick off all infrastructure objects.  Once the infrastructure is created, the installation runs silently on the boot master (i.e. `icp-master01`) until it completes.  To monitor the installation, you can provision a bastion host which is placed on the public subnet and use it as a jumpbox into the `icp-master01` host by setting the number of bastion nodes in `terraform.tfvars` to 1.  

```
bastion = {
 nodes = "1"
}
```

The installation output will be written to `/var/log/cloud-init-output.log` for RHEL 7.4 systems and `/var/log/messages` on RHEL 7.5+ systems.  Bastion hosts are not required for normal operation of the cluster.

When the installation completes,  the `/opt/ibm/cluster` directory on the boot master (i.e. `icp-master01`) is backed up to S3 in a bucket named `icpbackup-<clusterid>`, which can be used in master recovery in case one of the master nodes fails.  It is recommended after every time `terraform apply` is performed, to commit the `terraform.tfstate` into a backend so that the state is stored in source control.

When installation completes, if a user-provided certificate is used, create a CNAME entry in your DNS provider from the DNS entry to the ELB DNS URL output at the end of the terraform process.

### Terraform objects

The Terraform automation creates the following objects.

#### EC2 Instances

*these are tagged with the cluster id for Kubernetes-AWS integration*

| Node Role | Count | AWS EC2 Instance Type | Subnet | Security Group(s) |
|-----------|-------|-----------------------|--------|-------------------|
| Bastion   |   0   | t2.large              | public | icp-default, icp-bastion |
| Master    |   3   |  m4.xlarge            | private | icp-default, icp-master |
| Management |  3   | m4.xlarge             | private | icp-default |
| VA        | 3     | m4.xlarge             | private | icp-default |
| Proxy     |   3   | m4.large              | private | icp-default, icp-proxy |
| Worker    |  > 3   | m4.xlarge             | private | icp-default |

*(the instance types, base AMIs and counts can be configured in `variables.tf`)*

#### Elastic Network Interfaces

For recovery, master and proxy nodes have Network Interfaces created and attached to them as the first network device.  The private IP address is bound to the network interface, so when the interface is attached to a newly created instance, the IP address is preserved.  This is useful for Master Recovery, which is covered in below.

#### IAM Configuration

An IAM role is created in AWS and attached to each EC2 instance with the following policy:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:AttachVolume",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DetachVolume",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": ["elasticloadbalancing:*"],
      "Resource": ["*"]
    }
  ]
}
```

*(The Kubernetes AWS Cloud Provider needs access to read information from the AWS API about the instance (i.e. which subnet it's in, the private DNS name, whether nodes that have been removed, etc), and to create LoadBalancers and EBS Volumes on demand.)*

Additionally, we add `S3FullAccess` policy so that the IAM role can get installation images out of an S3 bucket and back up the `/opt/ibm/cluster` directory to an S3 bucket after installation.

#### VPC
- VPC with an internet gateway   
- All ICP nodes are placed in private subnets, each with their own NAT Gateway.
  - outbound Internet access from private subnet through NAT Gateway
- Private EC2 and S3 API endpoints are created in the VPC

#### Subnets
- two for each AZ (one public, one private)
  - *(CIDR for VPC and subnets can be configured in `terraform.tfvars`, see `variables.tf for values`)*
  - *(these are tagged with the cluster id for Kubernetes ELB integration)*

#### Security Group
Note that the below are the defaults, and each security group can have its whitelist be configured in `terraform.tfvars`.
- `icp-bastion`
  - allow 22 from 0.0.0.0/0   
- `icp-default`
  - allow ALL traffic from itself *(all nodes are in this security group)*
  - *(this is tagged with the cluster id for Kubernetes ELB integration)*
- `icp-proxy`
  - allow from 0.0.0.0/0 on port 80
  - allow from 0.0.0.0/0 on port 443
- `icp-master`
  - allow from 0.0.0.0/0 on port 8500 (image registry)   
  - allow from 0.0.0.0/0 on port 8600 (image registry)   
  - allow from 0.0.0.0/0 on port 8001 (kube api)   
  - allow from 0.0.0.0/0 on port 8443 (master UI)   
  - allow from internal  on port 9443 (Auth service)   

#### Load Balancer

*Note that in AWS, the Network LoadBalancer type does not have explicit security groups are instead placed on the instances themselves.*

- Network LoadBalancer for ICP console
  - listen on 8443, forward to master nodes port 8443 (ICP Console)
  - listen on 8001, forward to master nodes port 8001 (Kubernetes API)
  - listen on 8500, forward to master nodes port 8500 (Image registry)
  - listen on 8600, forward to master nodes port 8600 (Image registry)
  - listen on 9443, forward to master nodes port 9443 (Auth service)
- Network LoadBalancer for ICP Ingress resources
  - listen on port 80, forward to proxy nodes port 80 (http)
  - listen on port 443, forward to proxy nodes port 443 (https)
- Network LoadBalancer for IBM Multicloud Manager Klusterlet Prometheus Ingress resources. A separate load balancer is required for ssl-passthrough configuration.
  - listen on port 80, forward to proxy nodes port 80 (http)
  - listen on port 443, forward to proxy nodes port 443 (https)
  
#### Route53 DNS Zone

For convenience, a private DNS Zone is created in Route 53.  The domain name can be configured in `variables.tf`; by default it is `<clusterid>.icpcluster.icp`.  The domain search suffixes are added to `resolv.conf`, but due to a bug in cloud-init, `resolv.conf` is overwritten by NetworkManager in RHEL. It should be resolved in a future release of cloud-init.

#### S3 Bucket

1. An S3 Bucket for Configuration is created and the `/opt/ibm/cluster` is uploaded after the cluster is installed.  This is not deleted after an `terraform destroy`.
2. An S3 bucket is created for ICP installation binaries.  This is not deleted after `terraform destroy`.
3. An S3 bucket is created for ICP image registry storage.


## Executing the template using IBM Cloud Automation Manager

The following sections describe how to execute this template using [IBM Cloud Automation Manager](https://www.ibm.com/support/knowledgecenter/en/SS2L37/product_welcome_cloud_automation_manager.html).

In your IBM Cloud Automation Manager navigate to Library > Templates > Starterpack > IBM Cloud Private highly-available cluster in AWS and select Deploy operation. Fill the following input parameters and deploy the template.

For High Available ICP deployment there must be atleast 3 master, 3 proxy, 3 management and 3 worker node. You must use a region with atleast 3 availability zone. You must also specify atleast 3 private and public subnet CIDRs.

### Input Variables

#### Globals

| Parameter | Default Value | Description |
| :-------------- |:--------------| :-----|
| AWS Region | us-east-1 | AWS region to deploy your ICP cluster nodes. For an HA installation, the AWS selected region should have at least 3 availability zones. |
| Availability Zones | ["a","b","c"] | The availability zone letter identifier in the above selected region. For high availability should have at least 3 availability zones. Setting to a single availability zone will disable high availability and not provision EFS, in this case, reduce the number of master and proxy nodes to 1 |
| Key Name |  | Name of the EC2 key pair. |
| Private Key |  | Base64 encoded private key file contents of the EC2 key pair. |
| VPC Name | icp-vpc | AWS VPC Name prefix. This value is used to prefix the VPC created for ICP nodes. |
| Amazon Machine Image (AMI-ID) | ami-0f9cf087c1f27d9b1 | Default Amazon Machine Image ID that will be used if AMI ID for individual node is not provided. |
| Bastion Node | {"nodes":"1","type":"t2.micro","ami":"ami-0f9cf087c1f27d9b1","disk":"10"} | Bastion host that you can use to ssh into ICP cluster nodes. Can be used for debugging purpose. |
| Master Node | {"nodes":"3","type":"m4.2xlarge","ami":"ami-0f9cf087c1f27d9b1","disk":"300","docker_vol":"100","ebs_optimized":true} | Master node details. Each master node will be created in a different AZS. Number of AZS, public subnet and private subnet must match the number of master node. |
| Proxy Node | {"nodes":"3","type":"m4.xlarge","ami":"ami-0f9cf087c1f27d9b1","disk":"150","docker_vol":"100","ebs_optimized":true} | Proxy node details. Each proxy node will be created in a different AZS. Number of AZS, public subnet and private subnet must match the number of proxy node. |
| Management Node | {"nodes":"3","type":"m4.2xlarge","ami":"ami-0f9cf087c1f27d9b1","disk":"300","docker_vol":"100","ebs_optimized":true} | Management node details. Each management node will be created in a different AZS. Number of AZS, public subnet and private subnet must match the number of management node. |
| Worker Node | {"nodes":"3","type":"m4.2xlarge","ami":"ami-0f9cf087c1f27d9b1","disk":"150","docker_vol":"100","ebs_optimized":true} | Worker node details. Each worker node will be created in a different AZS. Number of AZS, public subnet and private subnet must match the number of worker node. |
| Vulnerability Advisor Node | {"nodes":"3","type":"m4.2xlarge","ami":"ami-0f9cf087c1f27d9b1","disk":"300","docker_vol":"100","ebs_optimized":true} | Vulnerability Advisor node details. Each VA node will be created in a different AZS. Number of AZS, public subnet and private subnet must match the number of VA node. |
| Cluster Name | icp | ICP Cluster Name |
| ICP Password |  | ICP user password |
| Docker Package Location |  | Docker package location is required when installing ICP EE on RedHat. Package is expected in AWS s3 bucket. Prefix the location string with protocol s3://. |
| ICP EE Image Location |  | Image location of ICP EE. Package is expected in AWS s3 bucket. Prefix the location string with s3://. |
| ICP Inception Image | ibmcom/icp-inception-amd64:3.1.1-ee | Name of the bootstrap installation image. |

#### Networking

| Parameter | Default Value | Description |
| :-------------- |:--------------| :-----|
| VPC CIDR block | 10.10.0.0/16 | AWS VPC CIDR block. This is the primary CIDR block for your ICP node VPC. |
| Subnet Name | icp-subnet | Subnet name prefix for public and private subnets used by ICP nodes. |
| Private Subnet CIDRs | ["10.10.10.0/24","10.10.11.0/24","10.10.12.0/24"] | List of subnet CIDRs. Total number of CIDR entry must match the number of availability zone provided above. A CIDR value is used in the creation of a private subnet in an availability zone for the worker nodes. |
| Public Subnet CIDRs | ["10.10.20.0/24","10.10.21.0/24","10.10.22.0/24"] | List of subnet CIDRs. Total number of CIDR entry must match the number of availability zone provided above. A CIDR value is used in the creation of a public subnet in an availability zone for the proxy and management nodes. |
| Private Domain | icp-cluster.icp | Private domain name that is used to create route53 name. |

The following output variables are exposed by IBM Cloud Automation Manager, that can be used to access the ICP Console or to log into bastion or boot master node or in service composition like [ICP cluster with klusterlet on Amazon EC2](https://github.com/IBM-CAMHub-Open/servicelibrary/tree/master/Services/ICP/ICP_on_AmazonEC2/ICP_cluster_and_MCM_Klusterlet).

### Output Variables

| Parameter | Description |
| :-------------- | :-----|
| Bastion Host IP | Bastion Host IP address. |
| Cluster CA Domain | Cluster Certification Authority Domain address. |
| Bootmaster Host IP | Bootmaster Host IP address |
| ICP Cloud Connection Name | ICP cloud connection name that can be used in other templates to connect to ICP cluster. |
| ICP Admin Password | ICP Admin Password |
| ICP Admin Username | ICP Admin Username |
| ICP Console ELB DNS ( Internal ) | ICP Console ELB DNS ( Internal ) |
| ICP Proxy Elb DNS ( Internal ) | ICP Proxy Elb DNS ( Internal ) |
| ICP Console URL | ICP Console URL |
| ICP Registry ELB URL | ICP Registry ELB URL |
| Host Name for klusterlet ingress rule | Use this host name as input to the klusterlet Prometheus ingress hostname. |
| ICP Kubernetes API URL | ICP Kubernetes API URL |
| Boot Master Node User Private SSH Key (base64 encoded) | Private SSH key to use while configuring the IBM Cloud Private Boot Node (base64 encoded) |

This template creates the following data objects that can be used in other templates like [IBM Multicloud Manager](https://github.com/IBM-CAMHub-Open/template_mcm_install) or in service composition like [ICP cluster with klusterlet on Amazon EC2](https://github.com/IBM-CAMHub-Open/servicelibrary/tree/master/Services/ICP/ICP_on_AmazonEC2/ICP_cluster_and_MCM_Klusterlet) 

### Data objects created by this template

| Data Object Type | Description |
| :-------------- | :-----|
| com.ibm.cloud.cloudconnections.ICP | ICP cloud connection name that can be used in other templates to connect to the created ICP cluster. |
| bastionhost | Bastion host details that can be used in other templates to connect to boot master using bation host. |

## Installation Procedure

The installer automates the install procedure described [here](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.1.1/installing/installing.html).

### ICP Installation Parameters on AWS

Suggested ICP Installation parameters specific on AWS:

```
---
calico_tunnel_mtu: 8981
cloud_provider: aws
kubelet_nodename: fqdn
```

Because AWS enables Jumbo frames (MTU 9001), the Calico IP-in-IP tunnel is configured to take advantage of the larger MTU.

The `cloud_provider` parameter allows Kubernetes to take advantage of some Kubernetes-AWS integration with dynamic ELB creation and dynamic EBS creation for persistent volumes.  When the AWS `cloud_provider` is used, all node names use the private FQDN retrieved from from the AWS metadata service and nodes are tagged with the correct region and availability zone.  Kubernetes will stripe deployments across availability zones.  See the [below section](#aws-cloud-provider) for more details.

The Terraform automation generates `cluster_CA_domain`, `cluster_lb_address`, and `proxy_lb_address` corresponding to the DNS names for the master and proxy ELB.

Note the other parameters in the `icp-deploy.tf` module.  The config files are stored in `/opt/ibm/cluster/config.yaml` on the boot-master.

### Installing IBM Cloud Private Community Edition 

The following parameters are required settings to install IBM Cloud Private Community Edition.  These values are the preferred values for any conflicting paramters in the `terraform.tfvars` file, as specified above in the [Prerequisites](#prerequisites) section.  These settings have been validated on IBM Cloud Private 3.1.1 Community Edition.

```
image_location = ""
patch_images = []
patch_scripts = []

icp_inception_image = "ibmcom/icp-inception-amd64:3.1.1"

bastion = {
 nodes = "1"
}

master = {
  nodes = "1"          # required to be '1' to install CE
  type = "m4.2xlarge"  # or m4.4xlarge if 'management' nodes=0
  disk = "300"
}

management = {
  nodes = "1"          # or optionally 0 if you want to run all platform services on 'master'
  type = "m4.xlarge"
  disk = "300"
}

va = {
  nodes = "0"
}

proxy = {
  nodes = "1"          # required to be '1' to install CE
  disk = "150"
}

worker = {
  disk = "150"
}
```

## Cluster access

### ICP Console access

The ICP console can be accessed at `https://<cluster_lb_address>:8443`.  See [documentation](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.1/manage_cluster/cfc_gui.html).

### ICP Private Image Registry access

The registry is available at `https://<cluster_lb_address>:8500`.  See [documentation](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.1.1/manage_images/configuring_docker_cli.html) for how to configure Docker to access the registry.

### ICP Kubernetes API access

The Kubernetes API can be reached at `https://<cluster_lb_address>:8001`.  To obtain a token, see the [documentation](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.1.1/manage_cluster/cfc_cli.html) or this [blog post](https://www.ibm.com/developerworks/community/blogs/fe25b4ef-ea6a-4d86-a629-6f87ccf4649e/entry/Configuring_the_Kubernetes_CLI_by_using_service_account_tokens1?lang=en),

### ICP Ingress Controller

[Ingress Resources](https://kubernetes.io/docs/concepts/services-networking/ingress/) can be created and exposed using the proxy node endpoints at `http://<proxy_lb_address>:80` or `https://<proxy_lb_address>:443`

## AWS Cloud Provider

The AWS Cloud provider provides Kubernetes integration with Elastic Load Balancer and Elastic Block Store.  See documentation on [LoadBalancer](https://kubernetes.io/docs/concepts/cluster-administration/cloud-providers/#aws) and [Volume](https://kubernetes.io/docs/concepts/storage/storage-classes/#aws)

### License and Maintainer

Copyright IBM Corp. 2019

Template Version - 3.1.1
