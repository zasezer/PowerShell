$htmm = Invoke-WebRequest https://covid19.saglik.gov.tr/ 

$htmm.Content > C:\Temp\covid.txt

$sonDrum = gc C:\Temp\covid.txt | Where-Object{ $_ -match "var sondurum"}

$sonDrum = $sonDrum.Substring( $sonDrum.IndexOf("{")  , $sonDrum.IndexOf("}") - $sonDrum.IndexOf("{") + 1 )

ConvertFrom-Json( $sonDrum)

