
pipeline {
	agent any
    options {
        timeout(time: 1, unit: 'HOURS')
    }
	stages {
        stage('setup') {
            parallel {
                stage ('acquire puppet credentials f') {
                    steps {
                        script {
                            puppet.credentials 'dc0758a9-9f9b-48cd-84ab-e86c6884d93d'
                            echo env.ghprbPullTitle
                            echo env.ghprbSourceBranch
                            echo env.GIT_BRANCH
                        }
                    }
                }
                stage ('setup for pull request') {
                    when {
                        expression { "${env.GIT_BRANCH}" == "origin/pr/*" }
                    }
                    steps {
                        script {
                            currentBuild.description = "Processing pull request ${env.ghprbPullTitle}."
                        }
                    }
                }
                stage ('setup for feature branch') {
                    when {
                        expression { "${env.GIT_BRANCH}" == 'origin/feature_new' }
                    }
                    steps {
                        script {
                            currentBuild.description = "Processing feature branch ${env.GIT_BRANCH}."
                        }
                    }
                }
            }
        }
        stage('test') {
            parallel {
                stage('puppet-parse') {
                    steps {
                        powershell '''
                            .\\pipeline\\Start-PuppetParse.ps1
                        '''
                    }
                }
                stage('puppet-lint') {
                    steps {
                        powershell '''
                            .\\pipeline\\Start-PuppetLint.ps1
                        '''
                    }
                }
                stage('powershell-parse') {
                    steps {
                        powershell '''
                            .\\pipeline\\Start-PowerShellParse.ps1
                        '''
                    }
                }
            }
        }
        stage('deploy feature branch') {
            steps {
                script {
                    // puppet.codeDeploy env.ghprbSourceBranch
                    echo 'hi'
                }
            }
        }
        stage('run feature branch') {
            steps {
                script {
                    // puppet.job "${env.ghprbSourceBranch}", query: 'nodes { catalog_environment = "nonproduction" }'
                    // puppet.job 'nonproduction', query: 'nodes { catalog_environment = "nonproduction" }'
                    // puppet.job env.ghprbSourceBranch, nodes: ['jenkins.ad.piccola.us']
                    echo 'oi'
                }
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}