# Load Starship Prompt
Invoke-Expression (&starship init powershell)

# Get default host IP
function Get-HostIp {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Wi-Fi', 'Ethernet')]
        [string]
        $InterfaceType = 'Ethernet',

        [Parameter()]
        [ValidateSet('IPv4', 'IPv6')]
        [string]
        $AddressFamily = 'IPv4'
    )

    $defaultRouteNics = Get-NetRoute -DestinationPrefix 0.0.0.0/0 | 
                            Sort-Object -Property RouteMetric | 
                            Select-Object -ExpandProperty ifIndex

    if ($defaultRouteNics.length -eq 0) {
        throw "Failed to identify an interface associated with the default route.  Is your network ok?"
    }

    $targetNicIndex = Get-NetIpInterface -InterfaceIndex $defaultRouteNics -AddressFamily $AddressFamily |
                        Where-Object InterfaceAlias -like "$InterfaceType*" |
                        Select-Object -ExpandProperty InterfaceIndex | Sort-Object -Unique

    if ($targetNicIndex.length -eq 0) {
        throw "Failed to find a default interface of the specified type."
    }

    Get-NetIpAddress -InterfaceIndex $targetNicIndex -AddressFamily $AddressFamily | Select-Object -ExpandProperty IPAddress
}

# Forward a host port to localhost, which magically forwards to WSL
function New-WSLPortForward {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Port,

        [Parameter()]
        [string]
        $WslIp = $(wsl hostname -I).trim()
    )

    netsh interface portproxy add v4tov4 listenport=$Port connectport=$Port connectaddress=$WslIp
}

# Removes port forwarding rules
function Remove-WSLPortForward {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Port
    )
    
    netsh interface portproxy delete v4tov4 listenport=$Port
}

# List port forwarding rules
function Get-WSLPortForward {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $WslIp = $(wsl hostname -I).trim()
    )

    netsh interface portproxy show v4tov4 connectaddress=$WslIp
}

# Canned functions for managing packer port forwarding
function Enable-PackerPortForwarding {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $MinimumPort = 8080,

        [Parameter()]
        [int]
        $MaximumPort = 8100,

        [Parameter()]
        [string]
        $ProvisioningCidr = "10.0.31.0/24"
    )

    $MinimumPort..$MaximumPort | ForEach-Object {
        New-WSLPortForward -Port $PSItem | Out-Null
    }

    $firewallRule = @{
        Name = "Allow Packer Provisioning"
        DisplayName = "Allow Packer Provisioning"
        Description = "Allow Packer Provisioning Inbound HTTP Traffic"
        Direction = "Inbound"
        Action = "Allow"
        Protocol = "TCP"
        LocalPort = "$MinimumPort-$MaximumPort"
        RemoteAddress = $ProvisioningCidr
    }

    New-NetFirewallRule @firewallRule | Out-Null
}

function Disable-PackerPortForwarding {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $MinimumPort = 8080,

        [Parameter()]
        [int]
        $MaximumPort = 8100
    )

    $MinimumPort..$MaximumPort | ForEach-Object {
        Remove-WSLPortForward -Port $PSItem | Out-Null
    }

    Remove-NetFirewallRule -Name "Allow Packer Provisioning"
}
