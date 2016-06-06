import com.scms.PropertiesReader
import grails.converters.JSON
import scms.ConfigureService

class BootStrap {

    ConfigureService configureService

    def init = { servletContext ->
        JSON.registerObjectMarshaller(Date) {
            if (!it) return null
            if (it.format("mm:ss").equals("00:00")) {
                return it.format("yyyy-MM-dd")
            }
            return it.format("yyyy-MM-dd'T'HH:mm:ss")
        }

        Boolean initDefaultData = Boolean.parseBoolean(PropertiesReader.getProperty("bootstrap.initDefaultData", PropertiesReader.CONFIG_FILE_DB))
        Boolean initDefaultSchema = Boolean.parseBoolean(PropertiesReader.getProperty("bootstrap.initDefaultSchema", PropertiesReader.CONFIG_FILE_DB))

        if (initDefaultSchema.booleanValue()) {
            configureService.initSchema()
        }
        if (initDefaultData.booleanValue()) {
            configureService.initData()
        }

    }
    def destroy = {
    }
}
