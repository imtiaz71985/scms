package actions.medicineSellInfo

import grails.transaction.Transactional
import org.codehaus.groovy.grails.plugins.jasper.JasperExportFormat
import org.codehaus.groovy.grails.plugins.jasper.JasperReportDef
import org.codehaus.groovy.grails.plugins.jasper.JasperService
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class DownloadMonthWiseMedicineSellInfoActionService extends BaseService implements ActionServiceIntf {

    JasperService jasperService

    private static final String REPORT_FOLDER = 'medicineSellInfo'
    private static final String JASPER_FILE = 'monthWiseMedicineSellReport'
    private static final String REPORT_TITLE_LBL = 'reportTitle'
    private static final String REPORT_TITLE = 'Medicine Sale Report'
    private static final String OUTPUT_FILE_NAME = "medicine_sale_report"
    private static final String FROM_DATE = "fromDate"
    private static final String TO_DATE = "toDate"
    private static final String MONTH_NAME = "monthName"

    /**
     * Get parameters from UI
     * @param parameters -serialized parameter from UI
     * @param obj -N/A
     * @return -a map containing necessary information for execute
     * map contains isError(true/false) depending on method success
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {

        String dateStr = params.month.toString()
        Calendar c = Calendar.getInstance();
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date date = originalFormat.parse(dateStr);
        c.setTime(date);
        Calendar ce = Calendar.getInstance();
        ce.setTime(date);
        ce.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));

        String start = DateUtility.getDBDateFormatAsString(c.getTime())
        String end = DateUtility.getDBDateFormatAsString(ce.getTime())
        String monthName = new SimpleDateFormat("MMMM yyyy").format(c.getTime());

        params.put(FROM_DATE, start)
        params.put(TO_DATE, end)
        params.put(MONTH_NAME, monthName)

        return params
    }

    /**
     * Generates report
     * @param params -N/A
     * @param obj -a map returned from previous method
     * @return -a map containing all necessary information for downloading report
     */
    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            Map report = getReport(result)
            result.put(REPORT, report)
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * do nothing for post operation
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Wrap sprint details list for grid
     * @param obj -map returned from execute method
     * @return -a map containing all objects necessary for grid view
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * Build failure result in case of any error
     * @param obj -map returned from previous methods, can be null
     * @return -a map containing isError = true & relevant error message
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private Map getReport(Map result) {
        String rootDir = result.reportDirectory + File.separator
        String logoDir = result.logoDirectory + File.separator
        String reportDir = result.reportDirectory + File.separator + REPORT_FOLDER
        String subReportDir = reportDir + File.separator
        String outputFileName = OUTPUT_FILE_NAME + PDF_EXTENSION
        Map reportParams = new LinkedHashMap()
        reportParams.put(ROOT_DIR, rootDir)
        reportParams.put(LOGO_DIR, logoDir)
        reportParams.put(REPORT_DIR, reportDir)
        reportParams.put(SUBREPORT_DIR, subReportDir)
        reportParams.put(REPORT_TITLE_LBL, REPORT_TITLE)
        reportParams.put(FROM_DATE, result.get(FROM_DATE))
        reportParams.put(TO_DATE, result.get(TO_DATE))
        reportParams.put(MONTH_NAME, result.get(MONTH_NAME))
        JasperReportDef reportDef = new JasperReportDef(name: JASPER_FILE, fileFormat: JasperExportFormat.PDF_FORMAT,
                parameters: reportParams, folder: reportDir)
        ByteArrayOutputStream report = jasperService.generateReport(reportDef)
        return [report: report, reportFileName: outputFileName, format: REPORT_FILE_FORMAT]
    }
}
