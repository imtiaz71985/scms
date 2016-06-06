package scms.utility

class Tools {
    public static final int PLEASE_SELECT_VALUE = -1
    public static final String PLZ_SELECT_VALUE = '-1'
    public static final String PLEASE_SELECT_LEVEL = 'Please Select...'
    public static final String DASH = "_"
    public static final String dd_MM_yyyy_SLASH = "dd/MM/yyyy"

    public static final String PAGE = "page"
    public static final String TOTAL = "total"
    public static final String ROWS = "rows"
    public static final String ID = "id"
    public static final String COUNT = "count"
    public static final String LIST = "list"
    public static final String FROM = "From "
    public static final String TO = " To "
    public static final String IN = "IN"
    public static final String PER = " per "
    public static final String PNG_EXTENSION = ".png"
    public static final def EMAIL_PATTERN = /[-0-9a-zA-Z.+_]+@[-0-9a-zA-Z.+_]+\.[a-zA-Z]{2,4}/
    public static final String PLUS = "+"
    public static final String MINUS = "-"
    public static final String PERCENTAGE = "%"
    public static final String PIPE = "|"
    public static final String COMA = ","
    public static final String SINGLE_QUOTE = "'"
    public static final String GRATER_SIGN = ">"
    public static final String EMPTY_SPACE_COMA = " , "
    public static final String EMPTY_SPACE = ''
    public static final String SINGLE_SPACE = ' '
    public static final String PARENTHESIS_START = " ( "
    public static final String PARENTHESIS_END = " ) "
    public static final String THIRD_BRACKET_START = "["
    public static final String THIRD_BRACKET_END = "]"
    public static final String SEMICOLON = ";"
    public static final String COLON = ":"
    public static final String SINGLE_DOT = "."
    public static final String THREE_DOTS = "..."
    public static final String QUESTION_SIGN = "?"
    public static final String BR = "<br>"
    public static final String UNDERSCORE = "_"
    public static final String HYPHEN = "-"
    public static final String SLASH = "/"
    public static final String STR_ZERO = "0"
    public static final String STR_ZERO_DECIMAL = "0.00"
    public static final String NOT_APPLICABLE = "N/A"
    public static final String NOT_GIVEN = "Not Given"
    public static final String NONE = "None"
    public static final String LABEL_NEW = "New"    // used in place of grid object id
    public static final String HAS_ACCESS = "hasAccess"
    public static final String IS_VALID = "isValid"
    public static final String IS_ERROR = 'isError'
    public static final String IS_APP_EXCEPTION = 'isAppException'
    public static final String MESSAGE = 'message'
    public static final String DELETED = "deleted"
    public static final String MAIL_SENDING_ERR_MSG = 'mailSendingErrMsg'
    public static final String ENTITY = 'entity'
    public static final String GRID_ENTITY = 'gridEntity'
    public static final String VERSION = 'version'
    public static final String HAS_ASSOCIATION = "hasAssociation"
    public static final String COMPANY_LOGO = "companyLogo"
    public static final String YES = "YES"
    public static final String TRUE = 'true'
    public static final String FALSE = 'false'
    public static final String NO = "NO"
    public static final String ALL = "ALL"
    public static final String INVALID_INPUT_MSG = "Error for invalid input"

    public static final String REPORT = "report"
    public static final String REPORT_NAME_FIELD = 'REPORT_NAME'
    public static final String ROOT_DIR = 'ROOT_DIR'
    public static final String LOGO_DIR = 'LOGO_DIR'
    public static final String REPORT_DIR = 'REPORT_DIR'
    public static final String SUBREPORT_DIR = 'SUBREPORT_DIR'
    public static final String COMMON_HEADER_DIR = 'COMMON_HEADER_DIR'
    public static final String COMMON_FOOTER_DIR = 'COMMON_FOOTER_DIR'
    public static final String REPORT_TITLE = 'reportTitle'
    public static final String REPORT_FILE_FORMAT = 'pdf'
    public static final String PDF_EXTENSION = ".pdf"




    public static final String buildCommaSeparatedStringOfIds(List ids) {
        String strIds = EMPTY_SPACE
        for (int i = 0; i < ids.size(); i++) {
            strIds = strIds + ids[i]
            if ((i + 1) < ids.size()) strIds = strIds + COMA
        }
        return strIds
    }

    public static final List<Long> getIds(List lstObjects) {
        List<Long> lstIds = []
        if ((lstObjects == null) || (lstObjects.size() <= 0))
            return lstIds
        for (int i = 0; i < lstObjects.size(); i++) {
            lstIds << (Long) lstObjects[i].id
        }
        return lstIds
    }
}


