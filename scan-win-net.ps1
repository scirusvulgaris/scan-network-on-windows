# Define the range of IP addresses
$startIP = [System.Net.IPAddress]::Parse("x.x.x.x")
$endIP = [System.Net.IPAddress]::Parse("x.x.x.x")

# Define the list of ports to test
$ports = @(80, 443, 22, 3389)

# Convert IP address to an integer
function Convert-IPToInteger {
    param (
        [System.Net.IPAddress]$ip
    )
    $bytes = $ip.GetAddressBytes()
    [Array]::Reverse($bytes)
    [BitConverter]::ToUInt32($bytes, 0)
}

# Convert integer to IP address
function Convert-IntegerToIP {
    param (
        [UInt32]$int
    )
    $bytes = [BitConverter]::GetBytes($int)
    [Array]::Reverse($bytes)
    [System.Net.IPAddress]::new($bytes)
}

# Get the integer values of the start and end IP addresses
$startIPInt = Convert-IPToInteger -ip $startIP
$endIPInt = Convert-IPToInteger -ip $endIP

# Loop through the range of IP addresses
for ($ipInt = $startIPInt; $ipInt -le $endIPInt; $ipInt++) {
    $ip = Convert-IntegerToIP -int $ipInt
    foreach ($port in $ports) {
        $result = Test-NetConnection -ComputerName $ip -Port $port -InformationLevel Detailed
        if ($result.TcpTestSucceeded) {
            Write-Host "IP: $($ip) Port: $port is open"
        } else {
            Write-Host "IP: $($ip) Port: $port is closed"
        }
    }
}
