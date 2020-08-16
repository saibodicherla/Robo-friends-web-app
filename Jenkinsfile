pipeline {
  agent any
  stages {
    stage('Git checkout') {
        steps {
                checkout scm
            }
        }

    stage('Lint JavaScript') {
        steps {
            sh '''
                cd app
                npm install
                npm run lint
                '''
             }
        }

    stage('Lint Dockerfile') {
        steps {
            sh "hadolint --ignore DL3006 ..Docker/Dockerfile"
            }
        }

    stage('Build Docker Image') {
        steps {
                sh "docker build -t robo ."
            }
        }
    
    stage('Push Image to AWS ECR') {
        steps {
            script{
                docker. withRegistry ('https: //982641132963.dkr.ecr.eu-west-1.amazonaws.com', 'ecr:eu-west-1:982641132963' ) {
                    sh "docker tag robo:latest 982641132963.dkr.ecr.eu-west-1.amazonaws.com/robo:latest"
                    sh "docker push 982641132963.dkr.ecr.eu-west-1.amazonaws.com/robo:latest"
                    }
                }        
            }
        }
    
    stage('Create Kubernetes Cluster') {
        steps {
            withAWS(region:'eu-west-1',credentials:'capstone-project') {
              sh "eksctl create cluster --name prod --version 1.17 --region eu-west-1 --nodegroup-name standard-workers --node-type t3.micro --nodes 2 --nodes-min 1 --nodes-max 4 --managed" 
                }
            }
        }

    stage('Deploy Container on EKS Cluster') {
        steps {
            withAWS(region:'eu-west-1',credentials:'capstone-project') {
                sh "aws eks update-kubeconfig --name prod --region eu-west-1"
                sh "kubectl apply -f Infra/app-deployment.yml"
                sh "kubectl get deployments"
                sh "kubectl get pods"
                sh "kubectl get services -o wide"
                }
            }
        }
    }
}