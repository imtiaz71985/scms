package com.model

class ListThemeActionServiceModel {

    public static final String MODEL_NAME = 'list_theme_action_service_model'
    public static final String SQL_LIST_THEME_MODEL = """
        CREATE OR REPLACE VIEW list_theme_action_service_model AS
        SELECT thm.id, thm.version, thm.name, thm.value, thm.module_id AS module_id
                 FROM theme thm;
    """

    long id
    long version
    String name
    String value
    long moduleId

    static constraints = {
    }
}
