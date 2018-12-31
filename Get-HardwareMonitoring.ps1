#Hardware Monitoring

class HardwareMonitor {

    #Proberties
    [String] $Computername
    [Bool] $OnlineState
    [Bool] $OpenHardwareMonitorDLL
    [Bool] $EnableCPU = $true
    [Bool] $EnableGPU = $false
    [System.Management.Automation.Runspaces.PSSession] $RemoteSession
    
    [String] $LastInfoMessage
    [String] $LastErrorMessage



    #Constructor
    HardwareMonitor(){
    }

    #Test OnlineState
    [void] TestOnlineState (){
        $this.OnlineState = (Test-NetConnection -ComputerName $this.Computername).PingSucceeded
        } 
    
    #Build Remote PS Session
    [void] BuildRemoteSession (){

        $this.TestOnlineState()
        If ($this.OnlineState -eq $true){
        $this.RemoteSession = New-PsRemoteSession -ComputerName $this.Computername
        }
        else{
        $this.LastErrorMessage = "no conection established"
        }
    }        
    #Test HardwareMonitorDLL
    [void] TestHardwareMonitorDLL (){
        $DLLPath = (Get-Item -Path ".\").FullName + "\DLL\OpenHardwareMonitorLib.dll"
        $Command = {Test-Path -Path "C:\Script\PSHardwareMonitor"}

        if (Invoke-Command -Session $this.RemoteSession -ScriptBlock $Command){
            $this.OpenHardwareMonitorDLL = $true
        }
        else{
            $Command = {new-item -type directory -force "c:\Script\PSHardwareMonitor\"}
            Invoke-Command -Session $this.RemoteSession -ScriptBlock $Command      
            Copy-Item $DLLPath -ToSession $this.RemoteSession -Destination "C:\Script\PSHardwareMonitor\" -Recurse -Force
            #Remove Security Trust download from Internet
            $command = {Unblock-File -Path "C:\Script\PSHardwareMonitor\OpenHardwareMonitorLib.dll"}
            Invoke-Command -Session $this.RemoteSession -ScriptBlock $Command 
            $this.LastInfoMessage = "Open Hardware Monitoring DLL not exsist -> copied"
            $this.TestHardwareMonitorDLL()
        } 
    }    

    #Build OpenDLL Object
    [void] BuilsOpenDLLObject(){

        #Parameter Bindings
        $CPUEnable=$this.EnableCPU
        $GPUEnable=$this.EnableGPU
      
        $command = {
        param($CPUEnable, $argument2)
        [System.Reflection.Assembly]::LoadFile("C:\Script\PSHardwareMonitor\OpenHardwareMonitorLib.dll") | Out-Null
        $PCHARDWARE = New-Object OpenHardwareMonitor.Hardware.Computer
        $PCHARDWARE.CPUEnabled = $CPUEnable
        $PCHARDWARE.GPUEnabled = $GPUEnable
        $PCHARDWARE.Open()
        }   
        Invoke-Command -Session $this.RemoteSession -ScriptBlock $Command -ArgumentList ($CPUEnable, $GPUEnable) 
    }
    
}
