def ghprbSourceBranch = env.ghprbSourceBranch

pipeline {
	agent any
    options {
        timeout(time: 1, unit: 'HOURS')
    }
	stages {
        stage('setup') {
            steps {
                script {
                    puppet.credentials 'dc0758a9-9f9b-48cd-84ab-e86c6884d93d'
                    currentBuild.description = "Processing pull request ${env.ghprbPullTitle}."
                    echo ghprbSourceBranch
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
        stage('deploy') {
            steps {
                script {
                    puppet.codeDeploy ghprbSourceBranch
                }
            }
        }
        stage('run') {
            steps {
                script {
                    // puppet.job "${env.ghprbSourceBranch}", query: 'nodes { catalog_environment = "nonproduction" }'
                    // puppet.job 'nonproduction', query: 'nodes { catalog_environment = "nonproduction" }'
                    puppet.job ghprbSourceBranch, nodes: ['jenkins.ad.piccola.us']
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