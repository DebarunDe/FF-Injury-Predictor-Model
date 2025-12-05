<#
.\scripts\dev.ps1 <target>

PowerShell wrapper for Makefile targets for Windows users who don't have `make`.
Supported targets: install, run, test, lint, format, clean, help

Examples:
  .\scripts\dev.ps1 run
  .\scripts\dev.ps1 lint
#>

param(
    [string]$Target = 'help'
)

function Show-Help {
    @"
Usage: .\scripts\dev.ps1 <target>

Targets:
  install  - install runtime + dev dependencies from requirements.txt
  run      - run the dev server (python -m src.serve.app)
  test     - run pytest
  lint     - run ruff/black/mypy checks
  format   - autoformat with ruff/black
  clean    - remove build/test caches
  help     - show this help
"@
}

function Run-Install {
    Write-Host "Installing runtime + dev dependencies from requirements.txt"
    python -m pip install -r requirements.txt
}

function Run-Server {
    Write-Host "Running dev server (python -m src.serve.app)"
    python -m src.serve.app
}

function Run-Tests {
    Write-Host "Running tests (pytest)"
    python -m pytest -q
}

function Run-Lint {
    Write-Host "Running lints/checks: ruff, black, mypy"
    python -m ruff check .
    if ($LASTEXITCODE -ne 0) { Write-Host "ruff reported issues" }
    python -m black --check .
    if ($LASTEXITCODE -ne 0) { Write-Host "black reported formatting issues" }
    python -m mypy src
    if ($LASTEXITCODE -ne 0) { Write-Host "mypy reported type issues" }
}

function Run-Format {
    Write-Host "Formatting: ruff format, black"
    python -m ruff format .
    python -m black .
}

function Run-Clean {
    Write-Host "Cleaning build artifacts and caches"
    $paths = @('build','dist','*.egg-info','.pytest_cache','__pycache__')
    foreach ($p in $paths) {
        Get-ChildItem -Path $p -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
}

switch ($Target.ToLower()) {
    'install' { Run-Install }
    'run'     { Run-Server }
    'test'    { Run-Tests }
    'lint'    { Run-Lint }
    'format'  { Run-Format }
    'clean'   { Run-Clean }
    'help'    { Show-Help }
    default   { Write-Host "Unknown target: $Target`n"; Show-Help }
}
