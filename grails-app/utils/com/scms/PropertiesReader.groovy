package com.scms

/**
 * Created by User on 11/11/15.
 */
class PropertiesReader {

    private static Properties ppt;
    public final static String CONFIG_FILE_DB = "app-config.properties";
    public final static String CONFIG_FILE_XTRA = "xtra-config.properties";

    static getProperty(def name, def propertiesFileName) {
        if (ppt == null) {
            ppt = new Properties();
            try {
                URL url = PropertiesReader.class.getResource("PropertiesReader.class");
                String thisPath = url.getPath();
                thisPath = thisPath.substring(0, thisPath.lastIndexOf("classes")) + propertiesFileName;
                url = new URL("file://" + thisPath);
                InputStream stream = url.openStream();
                ppt.load(stream);
                stream.close();
            } catch (Throwable k) {}
        }
        def result = ppt.getProperty(name);
        return result;
    }
}
