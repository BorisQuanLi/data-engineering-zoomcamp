# VS Code Java Version Conflicts

## Current Setup
- System has OpenJDK 11 installed:
  ```bash
  java version "11.0.26" 2025-01-21
  javac 11.0.26
  ```

## Common VS Code Java 8 Notifications

VS Code might show Java 8 related warnings because:
1. Some VS Code Java extensions default to Java 8
2. Project settings might be configured for Java 8
3. Workspace settings might be targeting Java 8

## Solutions

### 1. Update VS Code Java Settings
1. Open Command Palette (Ctrl+Shift+P)
2. Type "Java: Configure Java Runtime"
3. Set JDK to version 11

### 2. Update workspace settings
Create or modify `.vscode/settings.json`:
```json
{
    "java.configuration.runtimes": [
        {
            "name": "JavaSE-11",
            "path": "/usr/lib/jvm/java-11-openjdk-amd64",
            "default": true
        }
    ],
    "java.configuration.updateBuildConfiguration": "automatic"
}
```

### 3. Project-specific settings
If you need Java 8 for specific projects, you can:
1. Install OpenJDK 8 alongside 11:
   ```bash
   sudo apt install openjdk-8-jdk
   ```
2. Configure project-specific settings in that project's `.vscode/settings.json`

### Checking Current Java Home
```bash
echo $JAVA_HOME
update-alternatives --config java
```

## Specific Error: Invalid Runtime Path
If you see this error:
```
Invalid runtime for JavaSE-1.8: The path points to a missing or inaccessible folder 
(C:\Program Files (x86)\Common Files\Oracle\Java\java8path)
```

Quick Fix:
1. Open VS Code Command Palette (Ctrl+Shift+P)
2. Type and select "Java: Configure Java Runtime"
3. Under "Java Version", click the + button to add your Java 11 installation
4. Remove the invalid Java 8 path
5. Set Java 11 as default

Alternative Fix - Edit settings.json:
```json
{
    "java.configuration.runtimes": [
        {
            "name": "JavaSE-11",
            "path": "/usr/lib/jvm/java-11-openjdk-amd64",
            "default": true
        }
    ],
    "java.jdt.ls.java.home": "/usr/lib/jvm/java-11-openjdk-amd64",
    "java.configuration.updateBuildConfiguration": "automatic"
}
```

Note: This error occurs because VS Code is looking for Java 8 in a Windows path that doesn't exist. Since you're using OpenJDK 11 on WSL, you should point VS Code to your WSL Java installation instead.

Note: If you only need Java 11, you can safely ignore Java 8 notifications as long as your code compiles and runs correctly.
