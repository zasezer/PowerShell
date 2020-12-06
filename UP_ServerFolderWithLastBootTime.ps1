
<# You should Change theese variables according to your environment #>
$reportsPathScriptBlock =  { (get-ITEM -Path "C:\windows\System32" ).LastWriteTime  } 
$dbPathScriptBlock =  { (get-ITEM -Path "C:\windows\System32\cmd.exe" ).LastWriteTime  }
$inputFilePath = "Q:\gecici\Servers.csv" <# #file path that contains servernames 
Coulmn Name Should be "ComputerName" like below IP and other Columns optional

ComputerName,IP
Server1,192.168.1.1
#>

$outputFilePath = "Q:\gecici\results.csv" <# #file path that results will be recorded. 
You can create daily files that name contains date or append results to same file #>



$servers = Import-Csv -Path $inputFilePath 
$collection = @() #This collection is used to collect results

ForEach( $srv in $servers ) {

    <# ping Computer #>
    try {
        $rslt = Test-NetConnection -ComputerName $srv.ComputerName -ErrorAction SilentlyContinue
    }
    catch {
        $rslt = $false
    }
    
    <#  IF ping succeded then check reports and database change time     #>
    if($rslt.PingSucceeded)
    {
        $reportDate = Invoke-Command -ComputerName $srv.ComputerName -ScriptBlock $reportsPathScriptBlock
        $dbDate = Invoke-Command -ComputerName $srv.ComputerName -ScriptBlock $dbPathScriptBlock
        $lastBootTime = ( Get-CimInstance -ComputerName $srv.ComputerName -Class CIM_OperatingSystem -ErrorAction Stop | Select-Object LastBootUpTime ).LastBootUpTime
        
        $newobject = New-Object PSObject -Property @{
            "ComputerName" =$srv.ComputerName;
            "Status" ="UP";
            "CheckTime" = (Get-Date -Format "yyyy-MM-dd hh:mm:ss");
            "Reports" = ( $reportDate.ToString( "yyyy-MM-dd hh:mm:ss" ));
            "Database" = ( $reportDate.ToString( "yyyy-MM-dd hh:mm:ss" ));
            "LastBootTime" = ( $lastBootTime.ToString( "yyyy-MM-dd hh:mm:ss" ))
        }
            
        $collection += $newobject

    }
    else {

        $newobject = New-Object PSObject -Property @{
            "ComputerName" =$srv.ComputerName;
            "Status" ="DOWN";
            "CheckTime" = (Get-Date -Format "yyyy-MM-dd hh:mm:ss");
            "Reports" = $null;
            "Database" = $null;
            "LastBootTime" = $null
        }
            
        $collection += $newobject        
        
    }
}

#Write to file
$collection | Select-Object -Property  ComputerName,Status,CheckTime,Reports,Database,LastBootTime | Export-Csv $outputFilePath -NoTypeInformation -Append
#Read from file for screen
Import-Csv $outputFilePath | FT ComputerName,Status,CheckTime,Reports,Database,LastBootTime
