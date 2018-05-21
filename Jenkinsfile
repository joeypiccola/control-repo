pipeline {
	agent any
    options {
        timeout(time: 1, unit: 'HOURS')
    }
	stages {
        stage('puppet-parse') {
            steps {
                powershell '''
                    .\\Start-PuppetParse.ps1
                '''
            }
        }
        stage('puppet-lint') {
            steps {
                powershell '''
                    .\\Start-PuppetLint.ps1
                '''
            }
        }
        stage('powershell-parse') {
            steps {
                powershell '''
                    .\\Start-PowerShellParse.ps1
                '''
            }
        }
        stage('puppet-token') {
            puppet.credentials 'dc0758a9-9f9b-48cd-84ab-e86c6884d93d'
        }
        stage('deploy') {
            steps {
                lock('puppet-code-nonproduction') {
                    puppet.codeDeploy 'nonproduction'
                }
            }
        }
        stage('run') {
            steps {
                lock('puppet-code-nonproduction') {
                    puppet.job 'nonproduction', query: 'nodes { catalog_environment = "nonproduction" }'
                }
            }
        }
    }
}