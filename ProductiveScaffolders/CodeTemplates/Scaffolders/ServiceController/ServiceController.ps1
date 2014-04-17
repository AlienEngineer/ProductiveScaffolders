[T4Scaffolding.Scaffolder(Description = "Enter a description of ServiceController here")][CmdletBinding()]
param(        
	[parameter(Mandatory=$true, ValueFromPipelineByPropertyName = $true)][System.String]$type,
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false,
	[System.Management.Automation.SwitchParameter]$HandleExceptions = $true,
	[string]$Name = "-",
	[string]$ExceptionType = "Exception",
	[string]$ToFolder = "Controllers"
)

write-Verbose $HandleExceptions
write-Verbose ([System.Boolean]$HandleExceptions)

$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value + "." + $ToFolder

function Get-Namespace ($type)
{
	return $type.substring(0, $type.LastIndexOf('.'))
}

function Exclude-Namespace ($type)
{
	return $type.substring( $type.LastIndexOf('.')+1)
}

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
			Type = $type;
		} `
		-SuccessMessage "Added ServiceController output at {0}" `
		-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force

	$Members = $class.Members | where { $_.Kind -eq 2 } | foreach { 
		return @{
			Name = $_.Name;
			Type = $_.Type.AsString;
			Parameters = $_.Parameters | foreach {
				return @{
					Type = $_.Type.AsString;
					TypeName = (Get-Namespace $_.Type.AsString);
					Namespace = (Exclude-Namespace $_.Type.AsString);
				}
			};
		}
	}

	$Members | foreach {
		Write-Verbose ("Name: " + $_.Name)
		Write-Verbose ("Type: " + $_.Type)

		Write-Verbose "Parameters: "
		$_.Parameters | foreach {
			Write-Verbose ("Type: " + $_.Type)
			Write-Verbose ("TypeName: " + $_.TypeName	)
			Write-Verbose ("Namespace: " + $_.Namespace	)
		}

		$controller = Get-ProjectType ($Name+ "Controller")

		Add-ClassMemberViaTemplate -CodeClass $controller -Template ServiceToActionTemplate `
			-Model @{ 
				Service = $Name;
				Type = $_.Type; 
				Name = $_.Name; 
				Parameters = $_.Parameters;
				HandleExceptions = [System.Boolean]$HandleExceptions;
				ExceptionType = $ExceptionType;
			} `
			-SuccessMessage ("Added " + $_.Name + " to " + $controller.Name)  `
			-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force
	}

}
catch [System.Exception]
{
	Write-Error $Error[0];
}