pipeline {
	agent any
    options {
        timeout(time: 1, unit: 'HOURS')
    }
	stages {
        stage('run tests') {
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
        stage('puppet-token') {
            steps {
                script {
                    puppet.credentials 'dc0758a9-9f9b-48cd-84ab-e86c6884d93d'
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    lock('puppet-code-nonproduction') {
                        puppet.codeDeploy 'nonproduction'
                    }
                }
            }
        }
        stage('run') {
            steps {
                script {
                    lock('puppet-code-nonproduction') {
                        puppet.job 'nonproduction', query: 'nodes { catalog_environment = "nonproduction" }'
                    }
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