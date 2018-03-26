#Get config file for deployment
$MyDir = Split-Path -Parent $MyInvocation.MyCommand.Path

[xml]$ConfigFile = Get-Content "$MyDir\settings.xml"

#region script configuration

If ($env:DEPLOYMENT_GROUP_NAME.Equals("prod")) {
        $Settings = $ConfigFile.settings.prod
}
Else{
        $Settings = $ConfigFile.settings.dev
}

##Set Variables

$SsisServer = $Settings.DestinationServer
$ProjectFileName = $Settings.ProjectFileName
$FolderName = $Settings.FolderName
$ProjectName = $Settings.ProjectName

$ISDeploymentWizard = "C:\Program Files (x86)\Microsoft SQL Server\120\DTS\Binn\ISDeploymentWizard.exe"


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
Try
{
  #Write-Host $cmd $arg1 $arg2 $arg3 $arg4
  & $cmd $arg1 $arg2 $arg3 $arg4
}Catch{
exit 255
}

#endregion
