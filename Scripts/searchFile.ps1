$ComputersPath = "c:\temp\computernames.txt"
$LogPath = "c:\temp"

$Log = @()
ForEach ($Computer in (Get-Content $ComputersPath))
{   ForEach ($Drive in "D")
    {   If (Test-Path "$($Drive):\")
        {   $Log += ForEach ($PST in ($PSTS = Get-ChildItem "$($Drive):\" -Include *.pst -Recurse -Force))
            {   New-Object PSObject -Property @{
                    ComputerName = $Computer
                    Path = $PST.DirectoryName
                    FileName = $PST.BaseName
                    Size = "{0:N2} MB" -f ($PST.Length / 1mb)
                    LastAlter = $PST.LastWriteTime
                    LastRead = $PST.LastAccessTime
                }
            }
        }
    }
}

$Log | Export-Csv $LogPath\PSTLog.csv -NoTypeInformation