pipeline{
    agent any
    stages{
        stage('Build'){
            steps{
                sh 'echo "Starting Frontend Pipeline"'
            }
        }
        stage('Upload to S3'){
            steps{
                withAWS(region:'us-east-1', credentials:'gaurav-AWS'){
                    sh 'echo "Uploading the files"'

                    s3Upload(file:'website', bucket:'tf-crc')

                    sh 'echo "Upload is SUCCESS!"'
                }
            }
        }
    }
}
