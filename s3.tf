module "s3_bucket" {
  source = "./modules/s3-bucket"
  bucket_name = "ajinkya-cicd-proj"
  tags = {
    Name = "statefile-bucket"
  }
}