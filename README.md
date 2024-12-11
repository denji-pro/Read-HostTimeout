# Read-HostTimeout

Modification of PowerShell Read-Host that provides a timeout and default value options for user input

## Installation

Install to a local PowerShell modules directory

```pwsh
$env:$PSModulePath
```

## Usage/Examples

```pwsh
Import-Module Read-HostTimeout

$foo = Read-HostTimeout -Prompt 'Ask user for input' -Default 0 -Timeout 10
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
