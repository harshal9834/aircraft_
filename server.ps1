# Tactical Air Operations Console - Local HTTP Development Server (TcpListener)
$port = 3000
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $port)

try {
    $listener.Start()
} catch {
    $port = 8080
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $port)
    $listener.Start()
}

Write-Host "=========================================================="
Write-Host " Tactical Air Operations Console - Local Server Active"
Write-Host " Local URL: http://localhost:$port/"
Write-Host " Serving directory: $(Get-Location)"
Write-Host " Press Ctrl+C to stop the server."
Write-Host "=========================================================="

while ($true) {
    try {
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        $stream.ReadTimeout = 5000
        $stream.WriteTimeout = 5000

        $buffer = New-Object byte[] 4096
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        if ($bytesRead -le 0) {
            $client.Close()
            continue
        }

        $requestStr = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead)
        $requestLine = ($requestStr -split "`r?`n")[0]

        if ([string]::IsNullOrWhiteSpace($requestLine)) {
            $client.Close()
            continue
        }

        # Parse GET /path HTTP/1.1
        $parts = $requestLine.Split(" ")
        $urlPath = if ($parts.Length -ge 2) { $parts[1] } else { "/" }
        $cleanPath = $urlPath.Split("?")[0]
        if ($cleanPath -eq "/" -or $cleanPath -eq "") {
            $cleanPath = "/index.html"
        }

        $localPath = Join-Path (Get-Location) $cleanPath.TrimStart('/').Replace('/', '\')

        if (Test-Path $localPath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($localPath).ToLower()
            $mime = switch ($ext) {
                ".html" { "text/html; charset=utf-8" }
                ".css"  { "text/css; charset=utf-8" }
                ".js"   { "application/javascript; charset=utf-8" }
                ".json" { "application/json; charset=utf-8" }
                ".png"  { "image/png" }
                ".jpg"  { "image/jpeg" }
                ".svg"  { "image/svg+xml" }
                default { "application/octet-stream" }
            }

            $bytes = [System.IO.File]::ReadAllBytes($localPath)
            $header = "HTTP/1.1 200 OK`r`nContent-Type: $mime`r`nContent-Length: $($bytes.Length)`r`nConnection: close`r`nAccess-Control-Allow-Origin: *`r`n`r`n"
            $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)

            $stream.Write($headerBytes, 0, $headerBytes.Length)
            $stream.Write($bytes, 0, $bytes.Length)
        } else {
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $cleanPath")
            $header = "HTTP/1.1 404 Not Found`r`nContent-Type: text/plain; charset=utf-8`r`nContent-Length: $($msg.Length)`r`nConnection: close`r`n`r`n"
            $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)

            $stream.Write($headerBytes, 0, $headerBytes.Length)
            $stream.Write($msg, 0, $msg.Length)
        }

        $stream.Flush()
        $client.Close()
    } catch {
        # ignore transient socket issues
    }
}
