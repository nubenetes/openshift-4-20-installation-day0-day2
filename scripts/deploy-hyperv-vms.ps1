<#
.SYNOPSIS
    Automated Provisioning of OpenShift 4.20 Generation 2 VMs on Microsoft Hyper-V / Azure Stack HCI
.DESCRIPTION
    Creates Generation 2 VMs, disables Dynamic Memory, sets UEFI Secure Boot to MicrosoftUEFICertificateAuthority,
    enables MAC Address Spoofing for Keepalived VIPs, and mounts the Agent-Based Installer ISO.
.PARAMETER ClusterName
    Name prefix for VMs (e.g., ocp420)
.PARAMETER SwitchName
    Name of the Hyper-V Virtual Switch (e.g., ExternalSwitch)
.PARAMETER IsoPath
    Full path to the agent.x86_64.iso file
.PARAMETER VmPath
    Base storage path for Hyper-V VM configuration and VHDX disks
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)][string]$ClusterName = "ocp420",
    [Parameter(Mandatory=$false)][string]$SwitchName = "ExternalSwitch",
    [Parameter(Mandatory=$false)][string]$IsoPath = "C:\ISO\agent.x86_64.iso",
    [Parameter(Mandatory=$false)][string]$VmPath = "C:\Hyper-V\Virtual Machines",
    [Parameter(Mandatory=$false)][int]$MasterCount = 3,
    [Parameter(Mandatory=$false)][int]$WorkerCount = 2,
    [Parameter(Mandatory=$false)][int]$MasterCpu = 8,
    [Parameter(Mandatory=$false)][int64]$MasterRamBytes = 32GB,
    [Parameter(Mandatory=$false)][int64]$MasterDiskBytes = 120GB,
    [Parameter(Mandatory=$false)][int]$WorkerCpu = 8,
    [Parameter(Mandatory=$false)][int64]$WorkerRamBytes = 32GB,
    [Parameter(Mandatory=$false)][int64]$WorkerDiskBytes = 200GB
)

$ErrorActionPreference = "Stop"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host " Provisioning OpenShift 4.20 VMs on Hyper-V (Gen 2 / Agent-Based)      " -ForegroundColor Cyan
Write-Host " Cluster: $ClusterName | ISO: $IsoPath" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan

# Validate ISO
if (-not (Test-Path $IsoPath)) {
    Write-Error "Agent ISO file not found at: $IsoPath"
}

# Function to create and configure a VM
function Provision-OcpVM {
    param(
        [string]$VmName,
        [int]$CpuCount,
        [int64]$RamBytes,
        [int64]$DiskSizeBytes
    )

    $vmDir = Join-Path $VmPath $VmName
    $vhdxPath = Join-Path $vmDir "$VmName-root.vhdx"
    
    if (Get-VM -Name $VmName -ErrorAction SilentlyContinue) {
        Write-Warning "VM $VmName already exists. Skipping creation."
        return
    }

    New-Item -ItemType Directory -Path $vmDir -Force | Out-Null
    
    Write-Host "Creating VHDX disk: $vhdxPath ($($DiskSizeBytes / 1GB) GB)..." -ForegroundColor Yellow
    New-VHD -Path $vhdxPath -SizeBytes $DiskSizeBytes -Dynamic | Out-Null

    Write-Host "Creating Gen 2 VM: $VmName..." -ForegroundColor Green
    New-VM -Name $VmName `
           -Generation 2 `
           -MemoryStartupBytes $RamBytes `
           -VHDPath $vhdxPath `
           -Path $VmPath `
           -SwitchName $SwitchName | Out-Null

    # 1. Disable Dynamic Memory (Mandatory for etcd & kubelet)
    Set-VMMemory -VMName $VmName -DynamicMemoryEnabled $false

    # 2. Configure CPU Cores
    Set-VMProcessor -VMName $VmName -Count $CpuCount

    # 3. Add DVD Drive and Mount Agent ISO
    Add-VMDvdDrive -VMName $VmName -Path $IsoPath | Out-Null
    $dvd = Get-VMDvdDrive -VMName $VmName

    # 4. Configure Firmware: Microsoft UEFI Certificate Authority (or disable SecureBoot)
    Set-VMFirmware -VMName $VmName -EnableSecureBoot $true -SecureBootTemplate "MicrosoftUEFICertificateAuthority" -FirstBootDevice $dvd

    # 5. Enable MAC Address Spoofing (Mandatory for VRRP Keepalived VIPs)
    Set-VMNetworkAdapter -VMName $VmName -MacAddressSpoofing On

    Write-Host "VM $VmName configured successfully." -ForegroundColor Green
}

# Create Masters
for ($i = 0; $i -lt $MasterCount; $i++) {
    $masterName = "$ClusterName-master-$i"
    Provision-OcpVM -VmName $masterName -CpuCount $MasterCpu -RamBytes $MasterRamBytes -DiskSizeBytes $MasterDiskBytes
}

# Create Workers
for ($i = 0; $i -lt $WorkerCount; $i++) {
    $workerName = "$ClusterName-worker-$i"
    Provision-OcpVM -VmName $workerName -CpuCount $WorkerCpu -RamBytes $WorkerRamBytes -DiskSizeBytes $WorkerDiskBytes
}

Write-Host "`nAll VMs created successfully!" -ForegroundColor Cyan
Write-Host "To power on all nodes and start installation, run:" -ForegroundColor White
Write-Host "  Get-VM -Name '$ClusterName-*' | Start-VM" -ForegroundColor White
