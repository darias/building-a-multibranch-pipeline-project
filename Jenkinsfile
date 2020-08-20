pipeline {
    agent {
        docker {
            image 'node:6-alpine'
            args '-p 3000:3000 -p 5000:5000' 
        }
    }
    parameters {
        string(name: 'PREFIX', defaultValue: 'aarias',
                description: 'Prefix for resource naming')
        string(name: 'REGION', defaultValue: 'us-east-1',
                description: 'Default AWS region')
        string(name: 'PROFILE', defaultValue: 'default',
                description: 'Set the value of the app version')
        string(name: 'ENVTYPE', defaultValue: 'dev',
                description: 'Environment type')
        string(name: 'TEAM', defaultValue: '51',
                description: 'Team code')
        string(name: 'OWNER', defaultValue: 'sre@mobileiron.com',
                description: 'Owner email')
        string(name: 'ECR_IMAGE', defaultValue: "",
                description: 'ECR Image')
        string(name: 'APP_YAML', defaultValue: "k8s/mtd/mtd.yaml",
                description: 'Application yaml file')
        string(name: 'EKS_CLUSTER_NAME', defaultValue: "${env.PREFIX}-ControlPlane-EKSControlPlane",
                description: 'EKS Cluster Name')
    }

    environment {
        CI = 'true'
    }
    stages {
        stage('Build') {
            when {
                branch 'master'
            }
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                withAWS(profile: "default") {
                    sh("aws eks list-clusters")
                }
            }
        }
        stage('Deliver for development') {
            when {
                branch 'development'
            }
            steps {
                sh './jenkins/scripts/deliver-for-development.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
        stage('Deploy for production') {
            when {
                branch 'production'
            }
            steps {
                sh './jenkins/scripts/deploy-for-production.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}
