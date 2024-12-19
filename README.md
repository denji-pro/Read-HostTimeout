# Read-HostTimeout

Emulate Read-Host with a timeout and default value

## Installation

Install to a local PowerShell modules directory

```pwsh
$ENV:PSModulePath
```

## Usage/Examples

```pwsh
Import-Module Read-HostTimeout

$foo = Read-HostTimeout -Prompt 'Ask user for input' -Default 0 -Timeout 10
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
