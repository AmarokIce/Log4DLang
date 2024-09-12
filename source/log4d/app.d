module log4d.app;

void main()
{
    import log4d.logger;

    Logger log = new Logger("test");
    try
    {
        throw new Exception("In step error!");
    }
    catch(Exception e)
    {
        log.error(e);
    }

    log.info("Success!");
}