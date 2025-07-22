pipeline {
    agent any

    tools {
        
        // Install the Maven version configured as "M3" and add it to the path.
        maven "Maven3"
    }
    stages {
        stage('Checkout external proj') {
        steps {
            git branch: 'master',
                credentialsId: 'Gitlab-cred',
                url: 'https://git.nagarro.com/freshertraining2022/mohdsalim.git'

            sh "ls -lat"
        }
    }
        stage('clean') {
            steps {
                sh "mvn clean"
            }
        }
        
        stage('Build') {
            steps {
                sh "mvn clean package"
            }
            
            
        }
        
        stage ('sonar QA') {
            steps {
                withMaven(jdk:'java', maven:'Maven3'){
                    withSonarQubeEnv(installationName: 'sonarqube-8.9.10', credentialsId: 'sonarqube-token') {
                        sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }
        
        stage('Server'){
             steps{
                 rtServer(
                     id: "Artifactory-server",
                     url: "http://192.168.56.9:8081/artifactory",
                     username: 'admin',
                     password: 'password',
                     bypassProxy: true,
                     timeout: 300
                 )
             }
        }
        stage('Artifactory Upload'){
            steps{
                rtUpload(
                    serverId: "Artifactory-server",
                    spec:'''{
                        "files":[
                            {
                                "pattern": "*.war",
                                "target": "example-repo-local"
                            }
                        ]
                    }''',
                )
                rtPublishBuildInfo(
                    serverId: "Artifactory-server"    
                )
            }

        }
        stage('Publish Build Info'){
            steps{
                 rtPublishBuildInfo(
                     serverId: "Artifactory-server"    
                 )
             }
        }
        
        stage('Docker Build') {
           steps {

                sh 'docker build -t samplewebapp:latest .' 
                

          }
        }
        stage('Docker deployment locally') {
            steps {
                sh "docker run -d -p 8064:8080 samplewebapp:latest"
                
            }
        }
        stage('Push to ECR'){
          steps {
            script {
              docker.withRegistry(
              'https://876724398547.dkr.ecr.us-west-2.amazonaws.com',
              'ecr:us-west-2:AWS-cred') {
              def myImage = docker.build('salim-assignment9')
               myImage.push('latest')
            }
        }
        
       }
       
     }
    
    }
}