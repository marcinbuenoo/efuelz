Add-Type -AssemblyName System.Drawing

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$assetDir = Join-Path $projectRoot 'assets\branding'
New-Item -ItemType Directory -Force -Path $assetDir | Out-Null

$size = 1024
$base = [System.Drawing.Bitmap]::new(
  $size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($base)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

$bounds = [System.Drawing.Rectangle]::new(0, 0, $size, $size)
$background = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
  $bounds,
  [System.Drawing.Color]::FromArgb(255, 38, 18, 55),
  [System.Drawing.Color]::FromArgb(255, 97, 49, 141),
  45.0)
$graphics.FillRectangle($background, $bounds)

$drop = [System.Drawing.Drawing2D.GraphicsPath]::new()
$drop.AddBezier(512, 190, 451, 285, 310, 420, 310, 531)
$drop.AddBezier(310, 531, 310, 656, 397, 752, 512, 752)
$drop.AddBezier(512, 752, 627, 752, 714, 656, 714, 531)
$drop.AddBezier(714, 531, 714, 420, 573, 285, 512, 190)
$drop.CloseFigure()
$dropBrush = [System.Drawing.SolidBrush]::new(
  [System.Drawing.Color]::FromArgb(255, 247, 240, 255))
$graphics.FillPath($dropBrush, $drop)

$route = [System.Drawing.Drawing2D.GraphicsPath]::new()
$route.AddBezier(445, 635, 560, 600, 430, 525, 558, 469)
$route.AddBezier(558, 469, 660, 421, 540, 381, 515, 338)
$roadPen = [System.Drawing.Pen]::new(
  [System.Drawing.Color]::FromArgb(255, 53, 32, 71), 72)
$roadPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$roadPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$roadPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$graphics.DrawPath($roadPen, $route)

$centerPen = [System.Drawing.Pen]::new(
  [System.Drawing.Color]::FromArgb(255, 201, 155, 234), 12)
$centerPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$centerPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$centerPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$graphics.DrawPath($centerPen, $route)

$masterPath = Join-Path $assetDir 'efuelz-icon.png'
$base.Save($masterPath, [System.Drawing.Imaging.ImageFormat]::Png)

function Save-IconPng([string]$Path, [int]$TargetSize) {
  $image = [System.Drawing.Bitmap]::new(
    $TargetSize, $TargetSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($image)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.DrawImage($base, 0, 0, $TargetSize, $TargetSize)
  $image.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $image.Dispose()
}

$androidSizes = @{ mdpi = 48; hdpi = 72; xhdpi = 96; xxhdpi = 144; xxxhdpi = 192 }
foreach ($density in $androidSizes.Keys) {
  $directory = Join-Path $projectRoot "android\app\src\main\res\mipmap-$density"
  New-Item -ItemType Directory -Force -Path $directory | Out-Null
  Save-IconPng (Join-Path $directory 'ic_launcher.png') $androidSizes[$density]
}

$ios = Join-Path $projectRoot 'ios\Runner\Assets.xcassets\AppIcon.appiconset'
$iosFiles = @{
  'Icon-App-20x20@1x.png' = 20; 'Icon-App-20x20@2x.png' = 40; 'Icon-App-20x20@3x.png' = 60
  'Icon-App-29x29@1x.png' = 29; 'Icon-App-29x29@2x.png' = 58; 'Icon-App-29x29@3x.png' = 87
  'Icon-App-40x40@1x.png' = 40; 'Icon-App-40x40@2x.png' = 80; 'Icon-App-40x40@3x.png' = 120
  'Icon-App-60x60@2x.png' = 120; 'Icon-App-60x60@3x.png' = 180
  'Icon-App-76x76@1x.png' = 76; 'Icon-App-76x76@2x.png' = 152
  'Icon-App-83.5x83.5@2x.png' = 167; 'Icon-App-1024x1024@1x.png' = 1024
}
foreach ($file in $iosFiles.Keys) { Save-IconPng (Join-Path $ios $file) $iosFiles[$file] }

$web = Join-Path $projectRoot 'web\icons'
Save-IconPng (Join-Path $web 'Icon-192.png') 192
Save-IconPng (Join-Path $web 'Icon-512.png') 512
Save-IconPng (Join-Path $web 'Icon-maskable-192.png') 192
Save-IconPng (Join-Path $web 'Icon-maskable-512.png') 512

$mac = Join-Path $projectRoot 'macos\Runner\Assets.xcassets\AppIcon.appiconset'
foreach ($iconSize in @(16, 32, 64, 128, 256, 512, 1024)) {
  Save-IconPng (Join-Path $mac "app_icon_$iconSize.png") $iconSize
}

$icoSizes = @(16, 32, 48, 64, 128, 256)
$icoImages = [System.Collections.Generic.List[byte[]]]::new()
foreach ($iconSize in $icoSizes) {
  $image = [System.Drawing.Bitmap]::new($iconSize, $iconSize)
  $g = [System.Drawing.Graphics]::FromImage($image)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.DrawImage($base, 0, 0, $iconSize, $iconSize)
  $memory = [System.IO.MemoryStream]::new()
  $image.Save($memory, [System.Drawing.Imaging.ImageFormat]::Png)
  $icoImages.Add($memory.ToArray())
  $memory.Dispose(); $g.Dispose(); $image.Dispose()
}
$icoStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.BinaryWriter]::new($icoStream)
$writer.Write([UInt16]0); $writer.Write([UInt16]1); $writer.Write([UInt16]$icoSizes.Count)
$offset = 6 + 16 * $icoSizes.Count
for ($i = 0; $i -lt $icoSizes.Count; $i++) {
  $iconSize = $icoSizes[$i]
  $dimension = if ($iconSize -eq 256) { 0 } else { [byte]$iconSize }
  $writer.Write([byte]$dimension); $writer.Write([byte]$dimension)
  $writer.Write([byte]0); $writer.Write([byte]0)
  $writer.Write([UInt16]1); $writer.Write([UInt16]32)
  $writer.Write([UInt32]$icoImages[$i].Length); $writer.Write([UInt32]$offset)
  $offset += $icoImages[$i].Length
}
foreach ($bytes in $icoImages) { $writer.Write($bytes) }
$windowsIcon = Join-Path $projectRoot 'windows\runner\resources\app_icon.ico'
[System.IO.File]::WriteAllBytes($windowsIcon, $icoStream.ToArray())

$centerPen.Dispose(); $roadPen.Dispose(); $dropBrush.Dispose()
$route.Dispose(); $drop.Dispose(); $background.Dispose()
$graphics.Dispose(); $base.Dispose(); $writer.Dispose(); $icoStream.Dispose()
Write-Output "Generated e-Fuelz icon assets from $masterPath"
