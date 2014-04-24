# Don't forget to
# netsh advfirewall firewall add rule name="check_MegaRAID" dir=in action=allow protocol=TCP localport=63560

$port = 63560

# Socket IO mostly copied from http://poshcode.org/4601
function listen-port ($port) {
    $endpoint = new-object System.Net.IPEndPoint ([system.net.ipaddress]::any, $port)
    $listener = new-object System.Net.Sockets.TcpListener $endpoint
    $listener.start()

    do {
        # Replace hardcoded path to megacli.exe
        $z = invoke-command -command {c:\megacli\megacli.exe -LDInfo -Lall -aALL}
        $z = [string]::Join([Environment]::NewLine, $z)
        $x = [string]$z

        $client = $listener.AcceptTcpClient() # will block here until connection
        $stream = $client.GetStream();
        $reader = New-Object System.IO.StreamReader $stream
        $writer = New-Object System.IO.StreamWriter $stream

        $line = $reader.ReadLine()
        if ($line -eq [string]"GET") {
            $writer.Write([string]$x)
        }
        $writer.Close()
        $reader.Close()
        $stream.Close()
        $client.Close()
    } while ($line -ne ([char]4))
    $listener.stop()
}

write-host "Listening on port $port."
listen-port $port
