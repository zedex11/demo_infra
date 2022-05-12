# bcd-ecs-infra 

## Terraform local setup


>terraform init \
    -backend-config "bucket=dev-infra-test-1" \
    -backend-config "region=us-east-1" \
    -backend-config "key=tfstate/ecs/cluster/dev/terraform.tfstate" 

>terraform plan 

>terraform apply 
