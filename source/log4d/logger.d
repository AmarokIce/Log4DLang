module log4d.logger;

import std.string;

class Logger
{
    private const string logName;
    private const bool includeDebug;
    private LogWriter writer;

    this(string name)
    {
        this.logName = name;
        this.includeDebug = true;

        this.writer = new LogWriter(logName, includeDebug);
    }

    this(string name, bool includeDebug)
    {
        this.logName = name;
        this.includeDebug = includeDebug;

        this.writer = new LogWriter(logName, includeDebug);
    }

    public void log(string message, Level level)
    {
        this.writer.writeTo(level, message);
    }

    public void info(string, ARGS...)(string message, ARGS args)
    {
        message = format(message, args);
        this.writer.writeTo(Level.INFO, message);
    }

    public void warn(string, ARGS...)(string message, ARGS args)
    {
        message = format(message, args);
        this.writer.writeTo(Level.WARN, message);
    }

    public void error(string, ARGS...)(string message, ARGS args)
    {
        message = format(message, args);
        this.writer.writeTo(Level.ERROR, message);
    }

    public void error(Throwable err)
    {
        this.writer.writeTo(Level.ERROR, err.toString());
    }

    public void debugInfo(string, ARGS...)(string message, ARGS args)
    {
        message = format(message, args);
        this.writer.writeTo(Level.DEBUG, message);
    }

}

private class LogWriter
{
    import std.datetime.systime;
    import std.datetime.date;

    import std.file;

    import log4d.dateutil : getTime;

private:

    const string logName;
    const bool includeDebug;

    const string logFile;
    const string debugFile;

    this(string name, bool includeDebug)
    {
        import log4d.dateutil : getDate;

        this.logName = name;
        this.includeDebug = includeDebug;

        this.logFile = "./log/" ~ logName ~ "_" ~ getDate() ~ "_" ~ getTime()
            .replace(":", "-") ~ ".log";
        this.debugFile = "./log/" ~ logName ~ "_" ~ getDate() ~ "_" ~ getTime()
            .replace(":", "-") ~ "_debug.log";

        if (!exists("./log/") || !isDir("./log/"))
        {
            mkdir("./log/");
        }

        write(logFile, "");
        if (includeDebug)
        {
            write(debugFile, "");
        }
    }

    void writeTo(Level level = Level.INFO, string msg)
    {
        import std.stdio : writeln;

        if (level == Level.DEBUG && !this.includeDebug)
        {
            return;
        }

        string info = level ~ this.getHead() ~ this.getName();
        info ~= msg;

        writeln(info);

        info ~= "\r\n";
        append(this.logFile, info);
        if (this.includeDebug)
        {
            append(this.debugFile, info);
        }
    }

    string getName() => "[" ~ this.logName ~ "]";
    string getHead() => "[" ~ getTime() ~ "]";
}

enum Level
{
    INFO = "[info]",
    DEBUG = "[debug]",
    WARN = "[warn]",
    ERROR = "[error]"
}
