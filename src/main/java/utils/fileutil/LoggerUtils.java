package utils.fileutil;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class LoggerUtils {
    private static Logger logger = null;

    public static Logger getLogger() {
        return logger;
    }

    public static void setLogger(Logger logger) {
        LoggerUtils.logger = logger;
    }
}
