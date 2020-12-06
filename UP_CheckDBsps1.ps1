
$inputFilePath = "c:\temp\Servers.csv" <# #file path that contains instances 
Coulmn Name/header Should be "InstanceName" like below IP and other Columns optional

InstanceName,IP
Server1,192.168.1.1
#>



$instances = Import-Csv -Path $inputFilePath 


ForEach( $ins in $instances ) {

    $DBs = Invoke-Sqlcmd -Query "SELECT Name FROM master.sys.databases" -ServerInstance $ins.InstanceName
    
    foreach($db in $DBs){
        
        $rslt = Invoke-Sqlcmd -Query ("DBCC CHECKDB " + $db.Name) -ServerInstance $ins

        $rslt | out-file ( $ins.InstanceName.Replace("\","-") + "-" + $db.Name + "-" + (Get-Date -Format "yyyy-MM-dd_hhmmss") + ".txt" ) #Saving results to file.

        <#
            For the composed reasult some codes should be added to here
        #>
    
    }


}