module "tf_state_backend" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-tfstate-backend?ref=0.0.3"

  providers = {
    aws = aws.ephemeral
  }
  region            = "eu-west-2"
  s3_bucket_name    = "cloud-platform-ephemeral-testbed"
  dynamo_table_name = "cloud-platform-ephemeral-testbed"
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = module.tf_state_backend.s3_bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
