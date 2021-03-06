[T4Scaffolding.Scaffolder(Description = "Enter a description of ServiceToAction here")][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

$outputPath = "ExampleOutput"  # The filename extension will be added based on the template's <#@ Output Extension="..." #> directive
$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value

Add-ClassMemberViaTemplate -Template ServiceToActionTemplate `
	-Model @{ Namespace = $namespace; ExampleValue = "Hello, world!" } `
	-SuccessMessage "Added ServiceToAction output at {0}" `
	-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force