<div align=center>

![](./img/Log4D.png)

</div>

# Log4D

A simple logger for DLang.

## Start

**Create a logger:**
```d
import log4d : Logger;

// Create a logger.
auto LOGGER;

// Create a logger without debug.
auto LOGGER_WITHOUT_DEBUG;

void main(string[] args)
{
    LOGGER = new Logger("MyLogger");
    LOGGER_WITHOUT_DEBUG = new Logger("MyLoggerOutDebug", false);
}
```


**record:**
```d
auto log = new Logger("MyLogger");

log.info("My Info");
log.info("Auto %s", "format");

log.warn("A warn");
log.error("An error");

log.debugInfo("A debug info"); // Debug only.

try
{
    throw new Exception("Some reason...");
}
catch(Exception e)
{
    log.error(e); // Record an exception.
}
```

