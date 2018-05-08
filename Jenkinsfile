node {
   stage ('clone') {
       git branch: 'test', changelog: false, poll: false, url: 'https://github.com/joeypiccola/control-repo.git'
   }
   stage ('puppet parse') {
       powershell '''
        foreach ($pp in (Get-ChildItem -path .\\ -Recurse -Include *.pp))
        {
            & puppet parser validate $pp --environment production
            if ($LASTEXITCODE -ne 0) {exit 1}
        }
        Write-Output 'No parsing errors found'
       '''
   }
   stage ('puppet lint') {
       powershell '''
        $LintResults = @()
        foreach ($pp in (Get-ChildItem -path .\\ -Recurse -Include *.pp))
        {
            $LintResult = & puppet-lint $pp --with-filename --no-140chars-check
            $LintResults += $LintResult
        }
        Write-Output $LintResults
        if ($LintResults | Select-String -Pattern 'error') {exit 1}
       '''
   }
   stage ('powershell parse') {
       powershell '''
        $files = @()
        foreach ($ps1 in (Get-ChildItem -path .\\ -Recurse -Include *.ps1))
        {
            $contents = Get-Content -Path $ps1
            
            if ($null -eq $contents)
            {
                continue
            }
            
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
            
            $file = $null
            $file = New-Object psobject -Property @{
                Path = $ps1
                SyntaxErrorsFound = ($errors.Count -gt 0)
            }
            $files += $file
        }
        Write-Output $files
        if ($files |?{$_.syntaxerrorsfound -eq $true}) {exit 1}
       '''
   }
   stage ('get puppet token') {
     puppet.credentials 'dc0758a9-9f9b-48cd-84ab-e86c6884d93d'
   }
  stage ('deploy to test') {
      lock('puppet-code-test') {
      puppet.codeDeploy 'test'
    }
  }
  stage ('run in test') {
      lock('puppet-code-test') {
      puppet.job 'test', query: 'nodes { catalog_environment = "test" }'
    }
  }  
}