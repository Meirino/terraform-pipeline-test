import groovy.json.JsonOutput
env.git_url = 'https://github.com/Meirino/terraform-pipeline-test.git'
env.git_branch = 'master'
env.jenkins_custom_workspace = "/opt/jenkins/terraform_test"
env.access_key = "**********"
env.secret_key = "**********"
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
                git branch: "$git_branch", url: "$git_url"
            }
        }
        stage('build packer AMIs') {
            steps {
                sh "packer build -var aws_access_key=$access_key -var aws_secret_key=$secret_key -var region=$region packer.json"
            }
        }
        stage('terraform init') {
            steps {
                sh "terraform init"
            }
        }
        stage('terraform plan') {
            steps {
                sh "terraform plan -var='aws_access_key=$access_key' -var='aws_secret_key=$secret_key' -var='region=$region' -out=plan.out"
            }
        }
        stage('approve deployment') {
            steps {
                input "¿Aprovar despliegue?"
            }
        }
        stage('aplicar cambios') {
            steps {
                sh "terraform apply plan.out"
            }
        }
    }
    
    post {
        failure {
            echo "Fallo, elimininando eliminando infraestructura"
            sh "terraform destroy -var='aws_access_key=$access_key' -var='aws_secret_key=$secret_key' -var='region=$region' -auto-approve"
        }
    }
}