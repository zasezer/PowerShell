[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$URLS = ("https://wsmob.thy.com/cargoportalmw/api/user/getProfileByUsername/CISTPTEST5", "https://www.anadolujet.com")

$rslt = New-Object

foreach($URL in $URLS){

 $rslt = Invoke-WebRequest  $URL |Out-Null


        

        IF($rslt.StatusCode -eq 200){
            Write-Host "Result is OK for $URL" -ForegroundColor Green
        }
        else {

             Write-Host "Result is NOK for $URL" -ForegroundColor Red

        }


}