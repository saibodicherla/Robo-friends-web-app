pipeline {
  agent any
  environment
  {

      VERSION = "${BUILD_NUMBER}"
      PROJECT = 'robo'
      IMAGE = "$PROJECT:$VERSION"
      ECRURL = 'https://982641132963.dkr.ecr.eu-west-1.amazonaws.com/robo'
      ECRCRED = 'ecr:eu-west-1:capstone-project'
  }
  stages {
    stage('Git checkout') {
        steps {
                checkout scm
            }
        }

    stage('Lint Dockerfile') {
        steps {
            sh "hadolint --ignore DL3006 ./Dockerfile"
            }
        }

    stage('Build Docker Image') {
        steps {
            script{
                docker.build('$IMAGE')
                }
            }
        }
    
    stage('Push Image to ECR') {
        steps {
            script {        
                    docker.withRegistry(ECRURL, ECRCRED) 
                    {
                        docker.image(IMAGE).push()
                    }                  
                }  
            }        
        }
    
    stage('Create a EKS Cluster') {
        steps {
            withAWS(region:'eu-west-1',credentials:'capstone-project') {
              sh "eksctl create cluster --name robo --version 1.17 --region eu-west-1 --nodegroup-name standard-workers --node-type t3.micro --nodes 2 --nodes-min 1 --nodes-max 4 --managed" 
                }
            }
        }

    stage('Deploy Container on EKS Cluster') {
        steps {
            withAWS(region:'eu-west-1',credentials:'capstone-project') {
                sh "aws eks update-kubeconfig --name robo --region eu-west-1"
                sh "kubectl apply -f Infra/appDeployment.yml"
                sh "kubectl get deployments"
                sh "kubectl get pods"
                sh "kubectl get services -o wide"
                }
            }
        }
    }
}