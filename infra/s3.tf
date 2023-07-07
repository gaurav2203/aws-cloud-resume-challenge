resource "aws_s3_bucket" "s3"{
    bucket= "tf-crc"
    tags= {
        project= "crc"
    }
    force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "s3_oc"{
    bucket= aws_s3_bucket.s3.id 
    rule{
        object_ownership= "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "s3_acl"{
    depends_on= [aws_s3_bucket_ownership_controls.s3_oc]
    bucket= aws_s3_bucket.s3.id 
    acl= "private"
}

locals{
    s3_origin_id= "myS3Origin"
}

data "aws_iam_policy_document" "cf_allow_access_s3"{
    statement{
        principals {
          type= "Service"
          identifiers = ["cloudfront.amazonaws.com"]
        }
        actions= [
            "s3:GetObject",
            "s3:ListBucket"
        ]
        resources= [
            aws_s3_bucket.s3.arn,
            "${aws_s3_bucket.s3.arn}/*"
        ]
    }
} 

resource "aws_s3_bucket_policy" "s3_policy"{
    bucket= aws_s3_bucket.s3.id
    policy= data.aws_iam_policy_document.cf_allow_access_s3.json
}