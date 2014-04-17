[T4Scaffolding.Scaffolder(Description = "Enter a description of ServiceController here")][CmdletBinding()]
param(        
	[parameter(Mandatory=$true, ValueFromPipelineByPropertyName = $true)][System.String]$type,
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false,
	[string]$Name = "-",
	[string]$ToFolder = "Controllers"
)

$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value

try
{
	$class = Get-ProjectType $type 

	if ($Name -eq "-")
	{
		$Name = $type
		
		if ($class.Kind -eq 8)
		{
			$Name = $Name.Substring(1)
		}
	}

	$outputPath = $outputPath = ("$ToFolder\$Name" + "Controller")

	if ($class -eq $null)
	{
		Exit
	}

	Add-ProjectItemViaTemplate $outputPath -Template ServiceControllerTemplate `
		-Model @{ 
			Namespace = $namespace; 
			Name = $Name;
		} `
		-SuccessMessage "Added ServiceController output at {0}" `
		-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force

}
catch [System.Exception]
{
	Write-Error $Error[0];
}