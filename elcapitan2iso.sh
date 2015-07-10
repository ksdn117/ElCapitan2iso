# Mount the installer image
hdiutil attach /Applications/Install\ OS\ X\ El\ Capitan.app/Contents/SharedSupport/InstallESD.dmg -noverify -nobrowse -mountpoint /Volumes/install_app

# Convert the boot image to a sparse bundle
hdiutil convert /Volumes/install_app/BaseSystem.dmg -format UDSP -o /tmp/ElCapitan

# Increase the sparse bundle capacity to accommodate the packages
hdiutil resize -size 8g /tmp/ElCapitan.sparseimage

# Mount the sparse bundle for package addition
hdiutil attach /tmp/ElCapitan.sparseimage -noverify -nobrowse -mountpoint /Volumes/install_build

# Remove Package link and replace with actual files
rm /Volumes/install_build/System/Installation/Packages
cp -rp /Volumes/install_app/Packages /Volumes/install_build/System/Installation/

# Copy BaseSystem.dmg and Basesystem.chunklist

cp /Volumes/install_app/BaseSystem.dmg /Volumes/install_build/
cp /Volumes/install_app/Basesystem.chunklist /Volumes/install_build/

# Unmount the installer image
hdiutil detach /Volumes/install_app

# Unmount the sparse bundle
hdiutil detach /Volumes/install_build

# Resize the partition in the sparse bundle to remove any free space
hdiutil resize -size `hdiutil resize -limits /tmp/ElCapitan.sparseimage | tail -n 1 | awk '{ print $1 }'`b /tmp/ElCapitan.sparseimage

# Convert the sparse bundle to ISO/CD master
hdiutil convert /tmp/ElCapitan.sparseimage -format UDTO -o /tmp/ElCapitan

# Remove the sparse bundle
rm /tmp/ElCapitan.sparseimage

# Rename the ISO and move it to the desktop
mv /tmp/ElCapitan.cdr ~/Desktop/ElCapitan.iso
