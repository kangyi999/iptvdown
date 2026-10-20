# commit_push.ps1
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"

if(Test-Path "output"){
    Write-Host "output folder exists"
    $files = Get-ChildItem "output" -File
    if ($files.Count -gt 0) {
        Write-Host "Found $($files.Count) files, add to git"
        git add output/
    } else {
        Write-Host "output folder empty, skip git add"
        exit 0
    }
}else{
    Write-Host "output folder not found, skip git add"
    exit 0
}

$dt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Auto update source files $dt"
$commitExitCode = $LASTEXITCODE

if ($commitExitCode -eq 0) {
    git push
    Write-Host "commit and push success"
}
elseif ($commitExitCode -eq 1) {
    # exit code=1 代表没有改动，属于正常情况，直接退出不报错
    Write-Host "no file changes, skip commit, normal exit"
    exit 0
}
else {
    Write-Host "git commit error"
    exit $commitExitCode
}
