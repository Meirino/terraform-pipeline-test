import groovy.json.JsonOutput

// Git settings
env.git_url = 'https://github.com/Meirino/terraform-pipeline-test.git'
env.git_branch = 'master'

// Jenkins settings
env.jenkins_custom_workspace = "/opt/pipelines/terraform_example"

// AWS Region
env.region = "us-east-1"

pipeline  {
    agent {
        node {
            customWorkspace "$jenkins_custom_workspace"
            label "master"
        }
    }

    stages {
        stage('fech code') {
            steps {
                git credentialsId: 'Test_Github_Example', url: "$git_url"
            }
        }
        stage('build packer AMIs') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: '439cfd2f-c83d-439d-9c8f-48e014ec58d2', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "packer build -var aws_access_key=$AWS_ACCESS_KEY_ID -var aws_secret_key=$AWS_SECRET_ACCESS_KEY -var region=$region packer/AMI_1.json"
                }
            }
        }
        stage('terraform init') {
            steps {
                sh "terraform init"
                sh "terraform get"
            }
        }
        stage('terraform plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: '439cfd2f-c83d-439d-9c8f-48e014ec58d2', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "terraform plan -var='aws_access_key=$AWS_ACCESS_KEY_ID' -var='aws_secret_key=$AWS_SECRET_ACCESS_KEY' -var='region=$region' -out=plan.out"
                }
            }
        }
        stage('approve deployment') {
            steps {
                input "¿Aprobar despliegue?"
            }
        }
        stage('aplicar cambios') {
            steps {
                sh "terraform apply plan.out"
                sh "terraform output -json > output.json"
                sh "cat output.json"
            }
        }
    }
    
    post {
        failure {
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: '439cfd2f-c83d-439d-9c8f-48e014ec58d2', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                echo "Fallo, eliminando infraestructura"
                sh "terraform destroy -var='aws_access_key=$AWS_ACCESS_KEY_ID' -var='aws_secret_key=$AWS_SECRET_ACCESS_KEY' -var='region=$region' -auto-approve"
            }
        }
        success {
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: '439cfd2f-c83d-439d-9c8f-48e014ec58d2', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                echo "Funcionamiento correcto, eliminando infraestructura"
                sh "terraform destroy -var='aws_access_key=$AWS_ACCESS_KEY_ID' -var='aws_secret_key=$AWS_SECRET_ACCESS_KEY' -var='region=$region' -auto-approve"
            }
        }
    }
}