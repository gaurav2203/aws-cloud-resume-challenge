data "aws_iam_policy_document" "assume_role"{
    statement{
        effect= "Allow"
        principals{
            type= "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
        actions= ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "iam_lambda"{
    name= "iam_for_lambda"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json 
}

data "archive_file" "code"{
    type= "zip"
    source_file= "lambda.py"
    output_path= "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_func"{
    filename= "lambda_function_payload.zip"
    function_name = "lambda_handler"
    handler= "lambda.py"
    role= aws_iam_role.iam_lambda.arn
    runtime= "python3.8"
    tags= {
        project= "crc"
    }
}

resource "aws_lambda_function_url" "lambda_func_url"{
    function_name= aws_lambda_function.lambda_func.function_name
    authorization_type = "NONE"
}

output "lambda_func_url"{
    value= aws_lambda_function_url.lambda_func_url.function_url
}

# module "api-gateway-enable-cors" {
# source  = "squidfunk/api-gateway-enable-cors/aws"
# version = "0.3.3"
# api_id          = "<your_api_id>"
# api_resource_id = "<your_api_resource_id>"
# }