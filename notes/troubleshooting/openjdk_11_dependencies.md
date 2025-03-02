# Java Dependencies Troubleshooting

## OpenJDK 11 Installation Issues

If you encounter dependency problems with OpenJDK 11 (such as while running `sudo apt-get install docker-compose-plugin`), run these commands in order:

```bash
# 1. Update package list
sudo apt update

# 2. Fix broken packages
sudo apt --fix-broken install

# 3. Remove problematic OpenJDK packages
sudo apt remove openjdk-11-jdk
sudo apt remove openjdk-11-jre

# 4. Clean up package cache
sudo apt clean
sudo apt autoremove

# 5. Reinstall OpenJDK 11
sudo apt install openjdk-11-jdk

# 6. Verify installation
java -version
javac -version
```

If you still see dependency errors, try forcing the configuration:

```bash
sudo dpkg --force-all --configure -a
```

Note: The `dpkg` command is the low-level package manager used by higher-level tools like `apt`. While `apt` is the recommended tool for installing packages, `dpkg` is useful for fixing package system issues.
