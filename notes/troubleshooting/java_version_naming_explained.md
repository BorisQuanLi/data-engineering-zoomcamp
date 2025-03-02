# Java Version Naming Explained

## Current System Status
```bash
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64    # Points to Java 8
java -version    # Shows Java 11.0.26           # Actually using Java 11
```

## Version Naming Conventions

1. **Java 8 = JavaSE-1.8**
   - These are the same version:
     - Java 8
     - Java 1.8
     - JavaSE-1.8
   - Directory: `/usr/lib/jvm/java-8-openjdk-amd64`

2. **Java 11**
   - Simple version number (dropped the 1.x naming)
   - Directory: `/usr/lib/jvm/java-11-openjdk-amd64`

## Your Current Setup Explained

You have a mixed configuration:
- `JAVA_HOME` points to Java 8 installation directory
- But `java -version` shows Java 11 because:
  1. Either Java 11 is set as default in alternatives system
  2. Or PATH is picking up Java 11 first

To fix this mismatch, you should:
1. Decide which version you want as default
2. Make both `JAVA_HOME` and alternatives point to the same version
3. Use the version switching function from `java_multiple_versions.md` to manage changes

Check current alternatives setup:
```bash
sudo update-alternatives --config java
```

## Current Alternatives Configuration
```bash
Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0          /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      auto mode
  1          /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      manual mode
  2          /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      manual mode
```

### Understanding Alternatives Output
1. **Current Setting**: Java 11 is active (marked with *)
2. **Priority**:
   - Java 11: 1111 (higher priority)
   - Java 8: 1081 (lower priority)
3. **Modes**:
   - Auto mode: System picks highest priority version
   - Manual mode: User explicitly selected version

This explains why:
- `java -version` shows Java 11 (highest priority in auto mode)
- But `JAVA_HOME` still points to Java 8 (separate environment variable)

To align everything to Java 11:
```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

To switch to Java 8:
```bash
sudo update-alternatives --config java  # Select option 2
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```
