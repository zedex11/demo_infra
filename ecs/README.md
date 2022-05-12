# bcd-ecs-infra mongo-backup-toolkit

## Terraform local setup

*Terraform version = 0.15.4*

>terraform init \
    -backend-config "bucket=ops01-infra" \
    -backend-config "region=us-east-1" \
    -backend-config "key=tfstate/ecs/mongo-backup-toolkit/ops01/terraform.tfstate" 

>terraform plan \
    -var "env_name=ops01" \
    -var "region=us-east-1" \
    -var-file="profiles/ops01-config.tfvars"

>terraform apply \
    -var "env_name=ops01" \
    -var "region=us-east-1" \
    -var-file="profiles/ops01-config.tfvars" -auto-approve
