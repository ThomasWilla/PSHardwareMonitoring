# PSHardwareMonitoring

This Powershell Module catch the min/max/current value from the CPU and GPU temperature. This Module is based on the OpenHardwaremonitoring Project and will not use the default Windows CIM Class. Thereby all CPUs and GPUs are supported. For more Information see https://openhardwaremonitor.org/

## Getting Started

Install-Module -Name PSHardwareMonitor

**Commands:**
```
Get-HWMeasurement | Reports all Measurement Values
Set-HWMeasuremet | Enable CPU/GPU
Get-HWInformationLog | Show the Logging
Get-HWObject | Show the Object Detailinformation
New-HWCustomObject | Create a Custom Object fromt Type HardwareMonitor. Class Description see below
```

## Class Description Type HardwareMonitoring


**Build the Custom Class Object**
```
New-HWCustomObject -CustomObjectName "HARDWAREMONITOR"
```

**Set required Parameters**
```
$HARDWAREMONITOR.EnableCPU = $true|$false {default: $True}
$HARDWAREMONITOR.EnableGPU = $true|$false {default: $False}
```

**Get Value from System**
```
$HARDWAREMONITOR.GetMeasurementValues()
```

**Show Value from System**
```
$HARDWAREMONITOR.Temperatures()
```

**Show Logging
```
$HARDWAREMONITOR.HardwareMonitorLog
```

**Show Last Error
```
$HARDWAREMONITOR.LastErrorMessage
```


### Prerequisites

What things you need to install the software and how to install them

* PowerShell 5 is required
* OpenHardwareMonitor (dll) is required (Included in Project)


## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [LibreHardwareMonitor](https://github.com/LibreHardwareMonitor/LibreHardwareMonitor?tab=readme-ov-file)


## Versioning
22.02.2025: Change to LibreHardwareMonitoring
01.05.2020: Extend as Module
01.04:2020 : Final Class
01.01.2019: Final Alpha 0.8


## Authors

* **Thomas Willa** - *Initial work* - [ThomasWilla](https://github.com/ThomasWilla)

See also the list of [contributors](https://github.com/ThomasWilla/PSHardwareMonitoring/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
