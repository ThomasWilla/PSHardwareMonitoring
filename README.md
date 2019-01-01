# PSHardwareMonitoring

This Powershell Class catch the min/max/current value from the CPU and GPU temperature. Load is comming...

## Getting Started
Copy the ps1 and dll to your Computer:

```
|DIR
|class.PSHardwareMonitor.ps1
|-DLL
|--OpenHardwareMonitorLib.dll
```

**Load the class**
```
./class.PSHardwareMonitor.ps1
```

**Build the Class Object**
```
$HARDWAREMONITOR = [HardwareMonitor]::new()
```

**Set required Parameters**
```
$HARDWAREMONITOR.ComputerName = "COMPUTERNAME"
$HARDWAREMONITOR.EnableCPU = $true|$false {default: $True}
$HARDWAREMONITOR.EnableGPU = $true|$false {default: $False}
```

**Get Value from System**
```
$HARDWAREMONITOR.GetHardwareValuesFromReomtePC()
```

**Show Value from System**
```
$HARDWAREMONITOR.Values()
```

**Destroy Session**
```
$HARDWAREMONITOR.DestroyRemoteSession()
```

### Prerequisites

What things you need to install the software and how to install them

**WinRM must be Enable**

```
winrm quickconfig
```

* PowerShell 5 is required
* OpenHardwareMonitor (dll) is required. This will be copied automaticly when it is not present


## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [OpenHardwareMonitor](https://openhardwaremonitor.org/) - Version Alpha 0.8.0.3


## Versioning
01.01.2019: Final Alpha 0.8


## Authors

* **Thomas Willa** - *Initial work* - [ThomasWilla](https://github.com/ThomasWilla)

See also the list of [contributors](https://github.com/ThomasWilla/PSHardwareMonitoring/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details