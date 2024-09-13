module log4d.logger;

import std.string;

final class Logger
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

    static string logFile;
    static string debugFile;

    this(string name, bool includeDebug)
    {
        this.logName = name;
        this.includeDebug = includeDebug;

        if (!exists("./log/") || !isDir("./log/"))
        {
            mkdir("./log/");
        }

        createFile();
    }

    void writeTo(Level level = Level.INFO, string msg)
    {
        import std.stdio : writefln;

        if (level == Level.DEBUG && !this.includeDebug)
        {
            return;
        }

        string info = this.getHead() ~ level ~ this.getName();
        info ~= msg;

        int color = 0;
        final switch(level)
        {
            case Level.INFO:
                color = 32;
                break;
            case Level.WARN:
                color = 33;
                break;
            case Level.DEBUG:
                color = 36;
                break;
            case Level.ERROR:
                color = 31;
                break;
        }

        writefln("\033[0m\033[%dm%s\033[0m", color, info);

        info ~= "\r\n";
        append(this.logFile, info);
        if (this.includeDebug)
        {
            append(this.debugFile, info);
        }
    }

    void createFile()
    {
        import log4d.dateutil : getDate;

        void cheackAndCreate(string file)
        {
            if (!exists(file) || !isFile(file))
            {
                write(file, "");
            }
        }

        if (logFile is null)
        {
            logFile = "./log/" ~  getDate() ~ "_" ~ getTime()
                .replace(":", "-") ~ ".log";
        }

        if (debugFile is null)
        {
            debugFile = "./log/" ~ getDate() ~ "_" ~ getTime()
                .replace(":", "-") ~ "_debug.log";
        }

        cheackAndCreate(logFile);
        if (this.includeDebug)
        {
            cheackAndCreate(debugFile);
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
