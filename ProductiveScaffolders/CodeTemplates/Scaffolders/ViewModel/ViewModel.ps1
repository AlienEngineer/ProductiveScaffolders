[T4Scaffolding.Scaffolder(Description = "Enter a description of ViewModel here")][CmdletBinding()]
param(        
	[parameter(Mandatory=$true, ValueFromPipelineByPropertyName = $true)][System.String]$type,
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false,
	[string]$Name = $type,
	[string]$ToFolder = "Models"
)

$outputPath = ("$ToFolder\$Name" + "Model")  # The filename extension will be added based on the template's <#@ Output Extension="..." #> directive
$namespace = ((Get-Project $Project).Properties.Item("DefaultNamespace").Value + "." + $ToFolder)

try
{

	$class = Get-ProjectType $type 

	if ($class -eq $null)
	{
		Exit
	}

	$Members = $class.Members | where { $_.Kind -eq 4 } | foreach { 
		return @{
			Name = $_.Name;
			Type = $_.Type.AsString;
		}
	}



	

	Add-ProjectItemViaTemplate $outputPath -Template ViewModelTemplate `
		-Model @{ 
			Namespace = $namespace; 
			Type = $type;
			Name = $Name;
			Members = $Members;
		} `
		-SuccessMessage "Added ViewModel output at {0}" `
		-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force

}
catch [System.Exception]
{
	Write-Error $Error[0];
}