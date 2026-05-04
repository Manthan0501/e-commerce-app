@Library('shared library') _

pipeline {
    agent any
    
    environment {
        // Update the main app image name to match the deployment file
        DOCKER_IMAGE_NAME = 'manthan0501/easyshop-app'
        DOCKER_MIGRATION_IMAGE_NAME = 'manthan0501/easyshop-migration'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GITHUB_CREDENTIALS = credentials('git_creds')
        GIT_BRANCH = "dev"
        GIT_REPO = "https://github.com/Manthan0501/e-commerce-app.git"
    }
    
    options {
        buildDiscarder(logRotator(
            numToKeepStr: '5',        // keep last 5 builds
            daysToKeepStr: '7',       // OR keep builds for 7 days
            artifactNumToKeepStr: '3' // keep only 3 artifacts
        ))
    }
    
    stages {
       
        stage('Cleanup Workspace') {
            steps {
                script {
                    clean_ws()
                }
            }
        }
        
        stage('Clone Repository') {
            steps {
                script {
                    clone(env.GIT_REPO,env.GIT_BRANCH)
                }
            }
        }
        
        
        stage('Build Docker Images') {
            parallel {
                stage('Build Main App Image') {
                    steps {
                        script {
                            docker_build(
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                dockerfile: 'Dockerfile',
                                context: '.'
                            )
                        }
                    }
                }
                
                stage('Build Migration Image') {
                    steps {
                        script {
                            docker_build(
                                imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                dockerfile: 'scripts/Dockerfile.migration',
                                context: '.'
                            )
                        }
                    }
                }
            }
        }
        
        stage('Run Unit Test') {
            steps {
                sh 'npm ci'
                sh 'npm run lint'
            }
        }
        
        stage('Security Scan with Trivy') {
            steps {
                script {
                    // Create directory for results
                  
                    trivy_scan()
                    
                }
            }
        }
        
        stage('Push Docker Images') {
            parallel {
                stage('Push Main App Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'docker_hub'
                            )
                        }
                    }
                }
                
                stage('Push Migration Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'docker_creds'
                            )
                        }
                    }
                }
            }
        }
        
        stage('Cleanup Docker') {
    steps {
        sh '''
        # Keep latest images, delete rest
        docker images manthan0501/easyshop-app --format "{{.ID}}" | tail -n +2 | xargs -r docker rmi -f

        docker images manthan0501/easyshop-migration --format "{{.ID}}" | tail -n +2 | xargs -r docker rmi -f

        # Clean dangling images (important)
        docker image prune -f
        '''
    }
}
        
        // Add this new stage
        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    update_k8s_manifests(
                        imageTag: env.DOCKER_IMAGE_TAG,
                        manifestsPath: 'kubernetes',
                        gitCredentials: 'git_creds',
                        gitUserName: 'Jenkins CI',
                        gitUserEmail: 'manthantiwari2697@gmail.com'
                    )
                }
            }
        }
    }
}
