#requires -version 5.1
#requires -module VMware.VimAutomation.Core
Function Get-VMwareToolsReport {

  <#
      .DESCRIPTION
        Returns a VMware Tools report for one or more VMware virtual machines.
        You should already be conencted to vCenter before running this.
        Only returns information for powered on VMs.
        Supports all Get-VM input parameters.

      .Notes
        Script:     Get-VMwareToolsReport.ps1
        Author:     Mike Nisk
        Prior Art:  Based on Get-VM by VMware, Inc.
  #>

  [CmdletBinding(DefaultParameterSetName='Default')]
  Param(

    [Parameter(ParameterSetName='Default', Position=0)]
    [Parameter(ParameterSetName='DistributedSwitch', Position=0)]
    [ValidateNotNullOrEmpty()]
    [string[]]$Name,

    [Parameter(ParameterSetName='Default')]
    [Parameter(ParameterSetName='DistributedSwitch')]
    [Parameter(ParameterSetName='ById')]
    [VMware.VimAutomation.ViCore.Types.V1.VIServer[]]$Server,

    [Parameter(ParameterSetName='Default', ValueFromPipeline=$true)]
    [ValidateNotNullOrEmpty()]
    [VMware.VimAutomation.ViCore.Types.V1.DatastoreManagement.StorageResource[]]$Datastore,

    [Parameter(ParameterSetName='DistributedSwitch', ValueFromPipeline=$true)]
    [Alias('DistributedSwitch')]
    [ValidateNotNullOrEmpty()]
    [VMware.VimAutomation.ViCore.Types.V1.Host.Networking.VirtualSwitchBase[]]$VirtualSwitch,

    [Parameter(ParameterSetName='Default', ValueFromPipeline=$true)]
    [VMware.VimAutomation.ViCore.Types.V1.Inventory.VIContainer[]]$Location,

    [Parameter(ParameterSetName='RelatedObject', Mandatory=$true, ValueFromPipeline=$true)]
    [VMware.VimAutomation.ViCore.Types.V1.RelatedObject.VmRelatedObjectBase[]]$RelatedObject,

    [Parameter(ParameterSetName='Default')]
    [Parameter(ParameterSetName='DistributedSwitch')]
    [VMware.VimAutomation.ViCore.Types.V1.Tagging.Tag[]]$Tag,

    [Parameter(ParameterSetName='ById')]
    [ValidateNotNullOrEmpty()]
    [string[]]$Id,

    [Parameter(ParameterSetName='Default')]
    [switch]$NoRecursion

  )

  Process {
  
    ## Get virtual machines
    $VMs = Get-VM @PSBoundParameters | Where-Object {$_.PowerState -eq 'PoweredOn'}
  
    ## VMware Tools Report
    $result = $VMs | Select-Object name,@{'n'='ToolsRunningStatus';e={$_.ExtensionData.Guest.ToolsRunningStatus}},`
    @{'n'='ToolsStatus';e={$_.ExtensionData.Guest.ToolsStatus}},`
    @{'n'='ToolsVersion';e={$_.ExtensionData.Guest.ToolsVersion}},`
    @{'n'='Operating System';e={$_.ExtensionData.Guest.GuestFullName}}
    
  } #End Process

  End {
    If($result){
      return $result
    }
  } #End End
} #End Function