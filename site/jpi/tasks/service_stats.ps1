Param (
    [Parameter(Mandatory = $True)]
    [string]$servicename,
    [Parameter(Mandatory = $True)]
    [ValidateSet('required', 'dependant', 'both')]
    $stats = 'required'
)

# https://dkalemis.wordpress.com/2015/03/02/visualize-the-services-graph-of-your-windows-os/

function List-DependentServices ($inputService, $inputPadding) {
    if ($inputService.DependentServices) {
        $padding = "   " + $inputPadding

        $output = $padding + "The following services depend on " + $inputService.DisplayName
        $output

        $padding = "   " + $padding

        foreach ($ds in $inputService.DependentServices) {
            $output = $padding + $ds.DisplayName
            $output

            List-DependentServices $ds $padding
        }
    }
}

function List-ServicesDependedOn ($inputService, $inputPadding) {
    if ($inputService.ServicesDependedOn) {
        $padding = "   " + $inputPadding

        $output = $padding + "The following services are required by " + $inputService.DisplayName
        $output

        $padding = "   " + $padding

        foreach ($rs in $inputService.ServicesDependedOn) {
            $output = $padding + $rs.DisplayName
            $output

            List-ServicesDependedOn $rs $padding
        }
    }
}

$service = Get-Service -Name $servicename -erroraction stop

$output = $service.DisplayName
$output

switch ($stats) {
    'required' {
        List-ServicesDependedOn $service ""
    }
    'dependant' {
        List-DependentServices $service ""
    }
    'both' {
        List-DependentServices $service ""
        List-ServicesDependedOn $service ""
    }
}
