# Simple HTTP server for 1341 Floral Designs local site
# Run: Right-click this file → "Run with PowerShell"
# OR open PowerShell in this folder and run: .\server.ps1

$port = 8080
$root = $PSScriptRoot
$url = "http://localhost:$port/"

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()

Write-Host ""
Write-Host "  ========================================"  -ForegroundColor Cyan
Write-Host "  1341 Floral Designs - Local Dev Server" -ForegroundColor Cyan
Write-Host "  ========================================"  -ForegroundColor Cyan
Write-Host ""
Write-Host "  Server running at: http://localhost:$port" -ForegroundColor Green
Write-Host ""
Write-Host "  Opening browser..." -ForegroundColor Yellow
Write-Host "  Press Ctrl+C to stop the server."
Write-Host ""

Start-Process "http://localhost:$port"

$mimeTypes = @{
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".woff" = "font/woff"
    ".woff2"= "font/woff2"
    ".ttf"  = "font/ttf"
}

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $req     = $context.Request
    $res     = $context.Response

    $localPath = $req.Url.LocalPath
    if ($localPath -eq "/" -or $localPath -eq "") { $localPath = "/index.html" }

    $filePath = Join-Path $root ($localPath.TrimStart("/").Replace("/", "\"))

    if (Test-Path $filePath -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $res.ContentType = $mime
        $res.ContentLength64 = $content.Length
        $res.OutputStream.Write($content, 0, $content.Length)
        Write-Host "  200 $localPath" -ForegroundColor Green
    } else {
        $res.StatusCode = 404
        $body = [System.Text.Encoding]::UTF8.GetBytes("404 - Not Found: $localPath")
        $res.ContentType = "text/plain"
        $res.ContentLength64 = $body.Length
        $res.OutputStream.Write($body, 0, $body.Length)
        Write-Host "  404 $localPath" -ForegroundColor Red
    }

    $res.OutputStream.Close()
}
