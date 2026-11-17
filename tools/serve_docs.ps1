$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\docs')).Path
$rootPrefix = $root.TrimEnd('\') + '\'
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 8765)
$listener.Start()

while ($listener.Server.IsBound) {
    $client = $listener.AcceptTcpClient()
    try {
        $stream = $client.GetStream()
        $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
        $request = $reader.ReadLine()
        while ($null -ne ($headerLine = $reader.ReadLine()) -and $headerLine.Length -gt 0) { }

        $requestedPath = '/'
        if ($request) {
            $parts = $request.Split(' ')
            if ($parts.Length -gt 1) { $requestedPath = [Uri]::UnescapeDataString($parts[1].Split('?')[0]) }
        }
        if ($requestedPath -eq '/') { $requestedPath = '/index.html' }
        $candidate = [System.IO.Path]::GetFullPath((Join-Path $root $requestedPath.TrimStart('/').Replace('/', '\')))

        if (-not $candidate.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            $status = '404 Not Found'
            $body = [System.Text.Encoding]::UTF8.GetBytes('Not found')
            $contentType = 'text/plain; charset=utf-8'
        } else {
            $status = '200 OK'
            $extension = [System.IO.Path]::GetExtension($candidate).ToLowerInvariant()
            $contentType = switch ($extension) {
                '.html' { 'text/html; charset=utf-8' }
                '.js' { 'application/javascript; charset=utf-8' }
                '.wasm' { 'application/wasm' }
                '.pck' { 'application/octet-stream' }
                '.png' { 'image/png' }
                '.json' { 'application/json; charset=utf-8' }
                default { 'application/octet-stream' }
            }
            $body = [System.IO.File]::ReadAllBytes($candidate)
        }

        $header = "HTTP/1.1 $status`r`nContent-Type: $contentType`r`nContent-Length: $($body.Length)`r`nCache-Control: no-cache`r`nConnection: close`r`n`r`n"
        $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
        $stream.Write($headerBytes, 0, $headerBytes.Length)
        $stream.Write($body, 0, $body.Length)
        $stream.Flush()
    } catch {
        # A browser may close a connection while the page is reloading.
    } finally {
        if ($client) { $client.Close() }
    }
}
