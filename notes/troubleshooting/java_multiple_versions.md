# Managing Multiple Java Versions

## Current Status
```bash
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
java version "11.0.26" (System)
```

## Setting Up Multiple Java Versions

1. Install both versions:
```bash
# Install Java 8
sudo apt install openjdk-8-jdk

# Install Java 11 (already done)
sudo apt install openjdk-11-jdk
```

2. Configure alternatives:
```bash
# List all Java installations
sudo update-alternatives --config java
sudo update-alternatives --config javac

# Or configure specific versions
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
```

3. Set JAVA_HOME dynamically:
Add to your ~/.bashrc:
```bash
# Function to switch Java versions
switch_java() {
    version=$1
    case $version in
        "8")
            export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
            ;;
        "11")
            export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
            ;;
        *)
            echo "Usage: switch_java [8|11]"
            return 1
            ;;
    esac
    export PATH=$JAVA_HOME/bin:$PATH
    echo "Switched to Java $version: $(java -version 2>&1 | head -n 1)"
}

# Optional: Set default Java version
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64  # For Java 8 compatibility
```

## VS Code Configuration
Create project-specific `.vscode/settings.json`:
```json
{
    "java.configuration.runtimes": [
        {
            "name": "JavaSE-1.8",
            "path": "/usr/lib/jvm/java-8-openjdk-amd64",
            "default": true  // Set to true for Java 8 projects
        },
        {
            "name": "JavaSE-11",
            "path": "/usr/lib/jvm/java-11-openjdk-amd64"
            // Set "default": true for Java 11 projects
        }
    ],
    "java.jdt.ls.java.home": "/usr/lib/jvm/java-8-openjdk-amd64"  // Match project's Java version
}
```

## Usage
```bash
# Switch to Java 8
switch_java 8

# Switch to Java 11
switch_java 11

# Verify current version
echo $JAVA_HOME
java -version
```

Note: Having both versions installed allows you to switch between them based on project requirements while keeping Java 8 as the default for compatibility with older projects.
