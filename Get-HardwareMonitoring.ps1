#Hardware Monitoring

class HardwareMonitor {

    #properties
    [String] $Computername
    [Bool] $OnlineState
    [Bool] $OpenHardwareMonitorDLL
    [Bool] $EnableCPU = $true
    [Bool] $EnableGPU = $false
    [System.Management.Automation.Runspaces.PSSession] $RemoteSession
    [System.Object]$Values
    [datetime]$TimeStamp
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
    
    #Destroy Remote Sessin
    [void] DestroyRemoteSession (){
        Remove-PSSession $this.RemoteSession
        $this.RemoteSession = $null
        $this.OpenHardwareMonitorDLL = $false
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
    [void] BuildOpenDLLObject(){

        #Parameter Bindings
        $CPUEnable=$this.EnableCPU
        $GPUEnable=$this.EnableGPU
      
        $command = {
        param($CPUEnable, $GPUEnable)
        [System.Reflection.Assembly]::LoadFile("C:\Script\PSHardwareMonitor\OpenHardwareMonitorLib.dll") | Out-Null
        $PCHARDWARE = New-Object OpenHardwareMonitor.Hardware.Computer
        $PCHARDWARE.CPUEnabled = $CPUEnable
        $PCHARDWARE.GPUEnabled = $GPUEnable
        $PCHARDWARE.Open()
        }   
        Invoke-Command -Session $this.RemoteSession -ScriptBlock $Command -ArgumentList ($CPUEnable, $GPUEnable) 
    }
    
    # GetHardwareValues from Session
    [void] GetHardwareValuesFromSession (){

        #Get CPU Value

        $command = {
            $PCHARDWARE.Hardware.Update()
            $PCHARDWARE.Hardware.Sensors | Select-Object SensorType,Name,Index,Min,Max,Value | Where-Object {$_.SensorType -eq "Temperature"} | Format-Table
        }
        $this.Values = Invoke-Command -Session $this.RemoteSession -ScriptBlock $command
        

        $this.TimeStamp = get-date -Format "dd/MM/yyyy HH:mm:ss"
    }

    # GetHardwareValuesFromRemotePC
    [void] GetHardwareValuesFromReomtePC (){
        $this.TestOnlineState()
        
        if ($this.OnlineState -eq $true){

              #Test If Remotesession is Open
              if ($this.RemoteSession -eq $null){
                $this.BuildRemoteSession()
            }

            #Test If DLL exsist
            If ($this.OpenHardwareMonitorDLL -eq $false){
                $this.TestHardwareMonitorDLL()
                $this.BuildOpenDLLObject()
            }
          
                       
            $this.GetHardwareValuesFromSession()
        }
    }






} #Class End
