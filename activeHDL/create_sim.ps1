param ([string]$name = "template", [bool]$verbose = $true)

if ($name -eq "template") {
    write-output "Usage: .\create_sim.ps1 -name module_name"
    exit
}

$dirname = "" + $pwd + "\" + $name
if (Test-Path $dirname) {
    write-output "Path already exists. Choose another name."
    exit
}

if ($verbose) {
    write-output "Creating directory: " + $dirname
}
New-Item $dirname -type directory

if ($verbose) {
    write-output "Copying files from template to $name..."
}
$srcdir = "" + $pwd + "\template\*"
$destdir = $dirname
write-output $srcdir
write-output $destdir
Copy-Item $srcdir $destdir

# Alter files
$destfile = $destdir + "\my_module.sv"
(Get-Content $destfile) -replace 'my_module', $name | Set-Content $destfile

$destfile = $destdir + "\tb_my_module.sv"
(Get-Content $destfile) -replace 'my_module', $name | Set-Content $destfile

$destfile = $destdir + "\dosim.do"
(Get-Content $destfile) -replace 'my_module', $name | Set-Content $destfile

$destfile = $destdir + "\go.ps1"
(Get-Content $destfile) -replace 'my_module', $name | Set-Content $destfile

# Rename files
$srcfile = $destdir + "\my_module.sv"
$destfile = $destdir + "\" + $name + ".sv"
Move-Item -path $srcfile -destination $destfile

$srcfile = $destdir + "\tb_my_module.sv"
$destfile = $destdir + "\tb_" + $name + ".sv"
Move-Item -path $srcfile -destination $destfile
