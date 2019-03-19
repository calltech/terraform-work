pipeline {
    // let jenkins assign proper  agent to run the tasks. if agent is none 
    // then we will have to assign angets manually with each step. 
  agent any
    environment {
        // Define var for docker image 
        DOCKER_IMAGE_NAME = "programmer26/demo-app-name-0"
        registryCredential = 'dockerhub'
    }

    // Building the application and saving it as an jenkins artifact in dist folder
    stages {


// Unit Tests ...
    stage('Unit Tests') {
        steps {
            echo 'Unit test begins ..... '
            // unstash 'node_modules'
            // sh 'yarn test:ci'
            // junit 'reports/**/*.xml'
        }
    }

// End to end tests , 
    stage ('End to End test'){
        steps {
            echo 'End to End Tests Start Now!'
            // unstash 'node_modules'
            // sh 'mkdir -p reports'
            // sh 'yarn e2e:pre-ci'
            // sh 'yarn e2e:ci'
            // sh 'yarn e2e:post-ci'
            // junit 'reports/**/*.xml'
        }
    }


// Build the application
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh 'npm install'
                sh 'npm run ng build --prod'
                archiveArtifacts artifacts: 'dist/**' //onlyIfSuccessful: true
            }
        }



// building docker image
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo Hello, World!'
                    }
                }
            }
        }


// pushing docker image to the docker repository
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }

        // Deploying it to productions
        // stage('DeployToProduction') {
        //     when {
        //         branch 'master'
        //     }
        //     steps {
        //         input 'Deploy to Production?'
        //         milestone(1)
        //         kubernetesDeploy(
        //             kubeconfigId: 'kubeconfig',
        //             configs: 'assignment01-full.yml',
        //             enableConfigSubstitution: true
        //         )
        //     }
        // }
    }
}
