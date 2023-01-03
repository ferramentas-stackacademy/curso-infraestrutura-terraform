resource "aws_s3_object" "jars" {
  bucket = "${var.project_name}-scripts-${var.environment}"
  key    = "./jars/delta-core_2.12-1.0.0.jar"
  source = "./jars/delta-core_2.12-1.0.0.jar"
  etag   = filemd5("jars/delta-core_2.12-1.0.0.jar")
  depends_on = [aws_s3_bucket.buckets-stack]
}

resource "aws_s3_object" "jobGlue" {
  bucket = "${var.project_name}-scripts-${var.environment}"
  key    = "job/jobGlue.py"
  source = "job/jobGlue.py"
  etag   = filemd5("job/jobGlue.py")
    depends_on = [aws_s3_bucket.buckets-stack]
}