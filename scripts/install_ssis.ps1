#Get config file for deployment
$MyDir = Split-Path -Parent $MyInvocation.MyCommand.Path

[xml]$ConfigFile = Get-Content "$MyDir\settings.xml"

#region script configuration
Try
{
If (("deeperview_stage_DG").Equals($env:DEPLOYMENT_GROUP_NAME)) {
        Write-Host "Dev config picked up for deployment"
        $Settings = $ConfigFile.settings.dev
}
Else{
        Write-Host "Prod config picked up for deployment"
        $Settings = $ConfigFile.settings.prod
}

##Set Variables

$SsisServer = $Settings.DestinationServer
$ProjectFileName = $Settings.ProjectFileName
$FolderName = $Settings.FolderName
$ProjectName = $Settings.ProjectName

$ISDeploymentWizard = "C:\Program Files (x86)\Microsoft SQL Server\130\DTS\Binn\ISDeploymentWizard.exe"


#region project deployment

# Create command line arguments
$DestinationPath = "/SSISDB/" + $FolderName + "/" + $ProjectName
$ProjectFilePath = $PSScriptRoot + "\..\process_weekly_partitions/bin/Development" + $ProjectFileName

$cmd = $ISDeploymentWizard
$arg1 = "/Silent"
$arg2 = "/SourcePath:""$ProjectFilePath"""
$arg3 = "/DestinationServer:""$SsisServer"""
$arg4 = "/DestinationPath:""$DestinationPath"""
#$arg5 = "/ProjectPassword:""$ProjectFilePassword"""

#Write-Host $cmd $arg1 $arg2 $arg3 $arg4

& $cmd $arg1 $arg2 $arg3 $arg4
}Catch [Exception]{
Write-Host $_.Exception|format-list -force
exit 255
}

#endregion
