resource "aws_dynamodb_table" "db"{
    name= "tf_db"
    billing_mode= "PAY_PER_REQUEST"
    hash_key= "id" 
    attribute{
        name= "id"
        type= "S"
    }
    tags= {
        project= "crc"
    }
}

resource "aws_dynamodb_table_item" "db_item" {
  table_name= aws_dynamodb_table.db.name
  hash_key= aws_dynamodb_table.db.hash_key

  item= <<ITEM
  {
    "id": {"S": "0"},
    "views": {"N": "0"}
  }
  ITEM
}