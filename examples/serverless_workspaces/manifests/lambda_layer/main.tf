data "archive_file" "layer_artifact" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = var.output_path
}

resource "aws_s3_object" "s3_layer_artifact" {
  source = data.archive_file.layer_artifact.output_path
  bucket = var.artifact_bucket_id
  key    = var.artifact_s3_key
  etag   = filemd5(data.archive_file.layer_artifact.output_path)
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = var.layer_name
  skip_destroy        = var.skip_destroy
  s3_bucket           = var.artifact_bucket_id
  s3_key              = aws_s3_object.s3_layer_artifact.id
  compatible_runtimes = var.compatible_runtimes
  source_code_hash    = data.archive_file.layer_artifact.output_base64sha256
}
