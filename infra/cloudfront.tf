resource "aws_cloudfront_origin_access_control" "cf_oac"{
    name= "cf_oac"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol= "sigv4"
}

resource "aws_cloudfront_distribution" "cf" {
  origin{
    domain_name= aws_s3_bucket.s3.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_oac.id 
    origin_id= local.s3_origin_id
  }
  enabled= true
  comment= "tf_cf"
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods= ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string= false 
      cookies{
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
  }
  price_class= "PriceClass_All"
  tags={
    project= "crc"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true 
  }
}

data "aws_cloudfront_distribution" "my_distribution" {
  id = aws_cloudfront_distribution.cf.id
}

output "cloudfront_domain_name" {
  value = data.aws_cloudfront_distribution.my_distribution.domain_name
}
