# Access FTP
$ftp = "ftp://ftp.server.com.br/" 
$user = "user" 
$pass = "pass"  

$Dir="\\server\sendingFolder\"    
$archives = (get-date).AddDays(-1).ToString("'*M'MM'.D'dd'.zip'")
$log = 'C:\LOG\FTP-LOG.txt'
$logOld = 'C:\LOG\FTP-LOGOLD.txt'

if ( Test-Path $log ){
	Get-Content($log) | Out-File $logOld
	$log | del
}

echo "#" | Out-File $logOld -append
echo "# Send files by FTP" | Out-File $logOld -append

$webclient = New-Object System.Net.WebClient 
$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)  

foreach($item in (dir $Dir$archives)){ 
    echo "# Uploading $item" | Out-File $logOld -append
    try{
        $uri = New-Object System.Uri($ftp+$item.Name) 
        $webclient.UploadFile($uri, $item.FullName)
    }
    catch{
        $err=$_
        Write-Host $error.exception.message
    continue
    } 
} 
if ( Test-Path $logOld ){
	$content = Get-Content($logOld)
	$content = $content |? {$_.trim() -ne "" }
	$content | Out-File $log
}
if ( Test-Path $logOld ){
	$logOld | del
}
