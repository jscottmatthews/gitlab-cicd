resource "aws_s3_bucket" "obj_storage_bucket" {
  bucket = "gitlabcicd-object-storage-bucket"
}

resource "aws_s3_object" "artifacts_folder" {
  bucket                 = aws_s3_bucket.obj_storage_bucket.id
  acl                    = "private"
  key                    = "artifacts/"
  source                 = "/dev/null"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "lfs_folder" {
  bucket                 = aws_s3_bucket.obj_storage_bucket.id
  acl                    = "private"
  key                    = "lfs/"
  source                 = "/dev/null"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "external_diffs_folder" {
  bucket                 = aws_s3_bucket.obj_storage_bucket.id
  acl                    = "private"
  key                    = "external_diffs/"
  source                 = "/dev/null"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "uploads_folder" {
  bucket                 = aws_s3_bucket.obj_storage_bucket.id
  acl                    = "private"
  key                    = "uploads/"
  source                 = "/dev/null"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "backups_folder" {
  bucket                 = aws_s3_bucket.obj_storage_bucket.id
  acl                    = "private"
  key                    = "backups/"
  source                 = "/dev/null"
  server_side_encryption = "AES256"
}