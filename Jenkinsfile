import groovy.json.JsonOutput

// Git settings
env.git_url = 'https://github.com/Meirino/terraform-pipeline-test.git'
env.git_branch = 'master'

// Jenkins settings
env.jenkins_custom_workspace = "/opt/jenkins/terraform_test"

// AWS Credentials
env.access_key = ""
env.secret_key = ""
env.region = ""

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
                git credentialsId: '', url: "$git_url"
            }
        }
        stage('Parallel build example') {
            parallel {
                stage('Stage_1') {
                    steps {
                        sh "echo 'Stage 1'"
                    }
                }
                stage('Stage_2') {
                    steps {
                        sh "echo 'Stage 2'"
                    }
                }
            }
        }
        stage('build packer AMIs') {
            steps {
                sh "packer build -var aws_access_key=$access_key -var aws_secret_key=$secret_key -var region=$region packer/AMI_1.json"
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
                sh "terraform output -json > output.json"
            }
        }
    }
    
    post {
        failure {
            echo "Fallo, eliminando infraestructura"
            sh "terraform destroy -var='aws_access_key=$access_key' -var='aws_secret_key=$secret_key' -var='region=$region' -auto-approve"
        }
        success {
            echo "Fallo, eliminando infraestructura"
            sh "terraform destroy -var='aws_access_key=$access_key' -var='aws_secret_key=$secret_key' -var='region=$region' -auto-approve"
        }
    }
}